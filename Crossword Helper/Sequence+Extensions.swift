//
//  SequenceExtensions.swift
//  Crossword Helper
//
//  Created by Justin Duke on 10/3/16.
//  Copyright © 2016 Pug and Chalice, LLC. All rights reserved.
//

import Foundation

public extension Sequence {
    func categorise<U : Hashable>(_ key: (Iterator.Element) -> U) -> [(U,[Iterator.Element])] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = key(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        var arr: [(U, [Iterator.Element])] = []
        for (k, v) in dict {
            arr.append((k, v))
        }
        return arr
    }
}
