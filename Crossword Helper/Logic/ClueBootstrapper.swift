//
//  ClueBootstrapper.swift
//  Crossword Helper
//
//  Created by Justin Duke on 10/3/16.
//  Copyright © 2016 Pug and Chalice, LLC. All rights reserved.
//
import Foundation
import SQLite
import Zip


// TODO: Abstract all of this the hell out.
class ClueBootstrapper {
    func bootstrap() {
        let zipPath = Bundle.main.url(forResource: "culled_clues.csv", withExtension: "zip")!
        let unzipDirectory = try! Zip.quickUnzipFile(zipPath)
        let unzipFile = unzipDirectory.appendingPathComponent("culled_clues.csv")
        let resourceString = try! String(contentsOf: unzipFile)
        let mapper: (String) -> [String:Any] = {[
            ClueAnswerPair.columns.clue.template: $0.components(separatedBy: ",")[0],
            ClueAnswerPair.columns.answer.template: $0.components(separatedBy: ",")[1],
            ClueAnswerPair.columns.answerLength.template: $0.components(separatedBy: ",")[1].lengthOfBytes(using: .utf8)
        ]}
        let strings = resourceString
            .components(separatedBy: "\n")
            .filter({ $0.components(separatedBy: ",").count == 2 })
            .map(mapper)
        
        try! db.run(ClueAnswerPair.table.create { t in
            t.column(ClueAnswerPair.columns.clue)
            t.column(ClueAnswerPair.columns.answer)
            t.column(ClueAnswerPair.columns.answerLength)
        })
        
        let stmt = try! db.prepare("INSERT INTO clues (answer, clue, answerLength) VALUES (?, ?, ?)")
        
        let chunkSize = 500
        let chunks = stride(from: 0, to: strings.count, by: chunkSize).map {
            Array(strings[$0..<min($0 + chunkSize, strings.count)])
        }

        chunks.forEach { chunk in
            try! db.transaction {
                chunk.forEach {
                    let clue = $0[ClueAnswerPair.columns.clue.template] as! String
                    let answer = $0[ClueAnswerPair.columns.answer.template] as! String
                    let length = $0[ClueAnswerPair.columns.answerLength.template] as! Int
                    try! stmt.run(answer, clue, length)
                }
            }
        }
        
    }
    
    func needsBootstrap() -> Bool {
        return false
    }
}
