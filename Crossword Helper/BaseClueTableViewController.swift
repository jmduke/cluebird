//
//  BaseClueTableViewController.swift
//  Crossword Helper
//
//  Created by Justin Duke on 10/6/16.
//  Copyright © 2016 Pug and Chalice, LLC. All rights reserved.
//

import Async
import DZNEmptyDataSet
import Firebase
import Foundation
import MBProgressHUD
import Popover
import UIKit


class BaseClueTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // State.
    var matchingAnswers: [[AnswerResult]] = []
    var sortingMethod: AnswerResultSortingMethod = .byPopularity {
        didSet {
            updateSearchResults(for: searchController)
        }
    }
    var searchQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    // Views.
    var bannerView: GADBannerView = {
        let adSize = UIDevice.current.orientation == .portrait ? kGADAdSizeSmartBannerPortrait : kGADAdSizeSmartBannerLandscape
        let view = GADBannerView(adSize: adSize)
        view.adUnitID = Constants.adMobAdUnitId
        return view
    }()
    
    // Objects.
    var clueSearcher = ClueSearcher()
    var searchController: UISearchController!
    
    
    // Should be implemented by subclass.
    func getEmptyStateText() -> String {
        fatalError("tfw the language makes a lot of nice choices but decides that abstract classes are an unnecessary luxury")
    }
    func findMatchingAnswers(searchText: String) -> [[AnswerResult]] {
        fatalError("tfw the language makes a lot of nice choices but decides that abstract classes are an unnecessary luxury")
    }
    
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard let searchText = searchBar.text else {
            matchingAnswers = []
            self.tableView.reloadData()
            return
        }
        
        searchQueue.cancelAllOperations()
        searchQueue.addOperation {
            Async.main {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.label.text = "Searching"
                UIApplication.shared.beginIgnoringInteractionEvents()
                }.background {_ in
                    self.matchingAnswers = self.findMatchingAnswers(searchText: searchText)
                }.main {
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    UIApplication.shared.endIgnoringInteractionEvents()
                    // Update display.
                    guard searchController.searchBar.text == searchText else { return }
                    self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section > 0 else {
            let cell = UITableViewCell()
            cell.contentView.addSubview(bannerView)
            return cell
        }
        
        let answer = matchingAnswers[indexPath.section - 1][indexPath.row]
        let cell = AnswerResultCell(answer: answer)
        return cell
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.lightGray,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        return NSAttributedString(string: getEmptyStateText(), attributes: attributes)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : matchingAnswers[section - 1].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return matchingAnswers.isEmpty || matchingAnswers[0].isEmpty ? 0 : matchingAnswers.count + 1
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard sortingMethod == .byAlphabet else { return nil }
        return [""] + matchingAnswers
            .map { String($0[0].answer[0]) }
    }
    
    override func viewDidLoad() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        // Removes cell separators.
        self.tableView.tableFooterView = UIView()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort by", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ClueSearchTableViewController.showSortingPopover))
    }
    
    func changeSortingMethod(sender: UIButton) {
        sortingMethod = AnswerResultSortingMethod(rawValue: sender.currentTitle!)!
    }
    
    func showSortingPopover() {
        let width = self.view.frame.width / 2
        let view = SortingMethodPopoverView(frame: CGRect(x: 0, y: 0, width: width, height: width / 2))
        view.buttons.forEach {
            $0.addTarget(self, action: #selector(ClueSearchTableViewController.changeSortingMethod(sender:)), for: UIControlEvents.touchDown)
        }
        let popover = Popover(options: nil, showHandler: nil, dismissHandler: nil)
        let startPoint = CGPoint(x: 55, y: 55)
        popover.show(view, point: startPoint)
    }
}
