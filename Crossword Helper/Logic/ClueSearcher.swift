//
//  ClueSearcher.swift
//  Crossword Helper
//
//  Created by Justin Duke on 9/29/16.
//  Copyright © 2016 Pug and Chalice, LLC. All rights reserved.
//

import Foundation
import SQLite
import UIKit


class ClueSearcher {
    
    // Constants.
    let MINIMUM_SEARCH_LENGTH = 2
    
    func search(substring: String) -> [ClueAnswerPair] {
        guard substring.lengthOfBytes(using: .utf8) > MINIMUM_SEARCH_LENGTH else {
            return []
        }
        
        return try! db.prepare(
            ClueAnswerPair.table.filter(
                ClueAnswerPair.columns.clue.like("%" + substring + "%")
            )
        ).map(ClueAnswerPair.init)
    }
    
    func searchByAnswer(substring: String) -> [ClueAnswerPair] {
        guard substring.lengthOfBytes(using: .utf8) > MINIMUM_SEARCH_LENGTH else {
            return []
        }
        
        let replacedSubstring = substring.replacingOccurrences(of: " ", with: "_")
        
        return try! db.prepare(
            ClueAnswerPair.table.filter(
                ClueAnswerPair.columns.answer.like(replacedSubstring)
            )
        ).map(ClueAnswerPair.init)
    }
}
