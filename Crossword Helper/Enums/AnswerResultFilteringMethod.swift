//
//  AnsweringResultFilteringMethod.swift
//  Crossword Helper
//
//  Created by Justin Duke on 10/4/16.
//  Copyright © 2016 Pug and Chalice, LLC. All rights reserved.
//

import Foundation

enum AnswerResultFilteringMethod {
    case all
    case numberOfLetters(Int)
    
    func filter() -> (ClueAnswerPair) -> Bool {
        switch self {
        case .all:
            return { _ in true }
        case .numberOfLetters(let number):
            return { $0.answer.lengthOfBytes(using: .utf8) == number }
        }
    }
    
    var title: String {
        switch self {
        case .all: return "All".localized()
        case .numberOfLetters(let number): return String(describing: number)
        }
    }
    
    init(rawValue: String) {
        if rawValue == "All".localized() {
            self = .all
        } else {
            self = .numberOfLetters(Int(rawValue)!)
        }
    }
}
