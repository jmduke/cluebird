//
//  ClueSearchTableViewController.swift
//  Crossword Helper
//
//  Created by Justin Duke on 9/28/16.
//  Copyright © 2016 Pug and Chalice, LLC. All rights reserved.
//
import Async
import DZNEmptyDataSet
import Foundation
import MBProgressHUD
import Popover
import UIKit


class ClueSearchTableViewController: BaseClueTableViewController {
    
    // State.
    var filteringMethod: AnswerResultFilteringMethod = .all {
        didSet {
            updateSearchResults(for: searchController)
        }
    }
    var possibleFilters: [AnswerResultFilteringMethod] = [] {
        didSet {
            filterButton.isEnabled = possibleFilters.count > 1
            self.navigationItem.setRightBarButton(filterButton, animated: true)
        }
    }
    var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Number of Letters".localized(),
            style: .plain,
            target: nil,
            action: #selector(ClueSearchTableViewController.showFilteringPopover)
        )
        return button
    }()
    
    override func getEmptyStateText() -> String {
        return (searchController.searchBar.text ?? "").lengthOfBytes(using: .utf8) > clueSearcher.MINIMUM_SEARCH_LENGTH ? "No results found for '\(searchController.searchBar.text!)'.".localized() : "Type a clue in the search box (e.g. '60 minuti')".localized()
    }
    override func findMatchingAnswers(searchText: String) -> [[AnswerResult]] {
        // Grab matching clues.
        let ununiqueMatchingClues = clueSearcher.search(substring: searchText)
        
        // From those matching clues, find each unique word length and update the scope.
        let uniqueLengths = Array(Set(ununiqueMatchingClues.map({ $0.answer.lengthOfBytes(using: .utf8) }))).sorted()
        self.possibleFilters = [.all] + uniqueLengths.map { AnswerResultFilteringMethod(rawValue: $0.description) }
        
        
        let ungroupedMatchingAnswers = ununiqueMatchingClues
            .filter(self.filteringMethod.filter())
            .categorise({ $0.answer })
            .map({ AnswerResult(answer: $0.0, clues: $0.1.map({ $0.clue })) })
            .sorted(by: self.sortingMethod.sortingFunction())
        
        return sortingMethod.groupingFunction()(ungroupedMatchingAnswers)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterButton.target = self
        navigationItem.rightBarButtonItem = filterButton
        
        let bootstrapper = ClueBootstrapper()
        if bootstrapper.needsBootstrap() {
            Async.main {
                UIApplication.shared.beginIgnoringInteractionEvents()
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.label.text = "Loading data"
                hud.isUserInteractionEnabled = false
                hud.detailsLabel.text = "This takes a while, but only needs to happen once.".localized()
                }.background {_ in
                    bootstrapper.bootstrap()
                }.main {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    func changeFilteringMethod(sender: UIButton) {
        filteringMethod = AnswerResultFilteringMethod(rawValue: sender.currentTitle!)
    }
    
    func showFilteringPopover() {
        let width = self.view.frame.width / 4
        let view = FilteringMethodPopoverView(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat(30 * possibleFilters.count)), filters: possibleFilters)
        view.buttons.forEach {
            $0.addTarget(self, action: #selector(ClueSearchTableViewController.changeFilteringMethod(sender:)), for: UIControlEvents.touchDown)
        }
        let popover = Popover(options: nil, showHandler: nil, dismissHandler: nil)
        let startPoint = CGPoint(x: self.view.frame.width - 55, y: 55)
        popover.show(view, point: startPoint)
    }
}
