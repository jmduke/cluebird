//
//  FittingAnswerTableViewController.swift
//  Crossword Helper
//
//  Created by Justin Duke on 10/5/16.
//  Copyright © 2016 Pug and Chalice, LLC. All rights reserved.
//
import Async
import DZNEmptyDataSet
import Foundation
import MBProgressHUD
import Popover
import UIKit

class FittingAnswerTableViewController: BaseClueTableViewController {
    
    override func findMatchingAnswers(searchText: String) -> [[AnswerResult]] {
        // Grab matching clues.
        let ununiqueMatchingClues = self.clueSearcher.searchByAnswer(substring: searchText)
        
        let ungroupedMatchingAnswers = ununiqueMatchingClues
            .categorise({ $0.answer })
            .map({ AnswerResult(answer: $0.0, clues: $0.1.map({ $0.clue })) })
            .sorted(by: self.sortingMethod.sortingFunction())
        
        return sortingMethod.groupingFunction()(ungroupedMatchingAnswers)
    }
    
    override func getEmptyStateText() -> String {
        return (searchController.searchBar.text ?? "").lengthOfBytes(using: .utf8) > clueSearcher.MINIMUM_SEARCH_LENGTH ? "No results found for '\(searchController.searchBar.text!)'.".localized() : "Search by typing in spaces for missing letters, e.g. 'LA__ERS' for 'LADDERS'.".localized()
    }
}
