//
//  AnswerResultSortingMethod.swift
//  Crossword Helper
//
//  Created by Justin Duke on 10/3/16.
//  Copyright © 2016 Pug and Chalice, LLC. All rights reserved.
//

import Foundation

enum AnswerResultSortingMethod: String {
    case byAlphabet = "A to Z"
    case byPopularity = "Most popular"
    
    func sortingFunction() -> (AnswerResult, AnswerResult) -> Bool {
        switch self {
        case .byAlphabet:
            return {
                $0.0.answer.localizedCompare($0.1.answer) == .orderedAscending
            }
        case .byPopularity:
            return {
                $0.0.clues.count > $0.1.clues.count
            }
        }
    }
    
    func groupingFunction() -> ([AnswerResult]) -> [[AnswerResult]] {
        switch self {
        case .byAlphabet:
            return {
                $0
                    .categorise({ $0.answer[0] })
                    .sorted(by: {$0.0.0 < $0.1.0 })
                    .map({ $0.1 })
            }
        case .byPopularity:
            return {[$0]}
        }
    }
    
    static let values = [byAlphabet, byPopularity]
}
