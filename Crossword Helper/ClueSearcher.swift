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
        
        // TODO: Abstract this the hell out, too.
        let clues = Table("clues")
        let clueColumn = Expression<String>("clue")
        let answerColumn = Expression<String>("answer")
        let answerLengthColumn = Expression<Int>("answerLength")
        return try! db.prepare(clues.filter(clueColumn.like("%" + substring + "%"))).map {
            ClueAnswerPair(answer: $0[answerColumn], clue: $0[clueColumn], answerLength: $0[answerLengthColumn])
        }
    }
    
    func searchByAnswer(substring: String) -> [ClueAnswerPair] {
        guard substring.lengthOfBytes(using: .utf8) > MINIMUM_SEARCH_LENGTH else {
            return []
        }
        
        // TODO: Abstract this the hell out, too.
        let clues = Table("clues")
        let clueColumn = Expression<String>("clue")
        let answerColumn = Expression<String>("answer")
        let answerLengthColumn = Expression<Int>("answerLength")
        
        let replacedSubstring = substring.replacingOccurrences(of: " ", with: "_")
        return try! db.prepare(clues.filter(answerColumn.like(replacedSubstring))).map {
            ClueAnswerPair(answer: $0[answerColumn], clue: $0[clueColumn], answerLength: $0[answerLengthColumn])
        }
    }
}
