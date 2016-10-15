//
//  String+Extensions.swift
//  Crossword Helper
//
//  Created by Justin Duke on 10/4/16.
//  Copyright © 2016 Pug and Chalice, LLC. All rights reserved.
//

import Foundation
extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (r: Range<Int>) -> String {
        let start = self.index(startIndex, offsetBy: r.lowerBound)
        let end = self.index(start, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}
extension String {
    
    func rangesOfPattern(pattern: String) -> [Range<Index>] {
        var ranges : [Range<Index>] = []
        
        if case let pCount = pattern.characters.count,
            case let strCount = self.characters.count, strCount >= pCount {
            
            for i in 0...(strCount-pCount) {
                let from = self.index(self.startIndex, offsetBy: i)
                let to = self.index(from, offsetBy: pCount, limitedBy: self.endIndex)
                
                if pattern == self[from..<to!] {
                    ranges.append(from..<to!)
                }
            }
        }
        
        return ranges
    }
}
