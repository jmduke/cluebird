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
        let zipPath = Bundle.main.url(forResource: "clues.csv", withExtension: "zip")!
        let unzipDirectory = try! Zip.quickUnzipFile(zipPath)
        let unzipFile = unzipDirectory.appendingPathComponent("clues.csv")
        let resourceString = try! String(contentsOf: unzipFile)
        let mapper: (String) -> [String:Any] = {[
            "clue": $0.components(separatedBy: ",")[1],
            "answer": $0.components(separatedBy: ",")[2],
            "answerLength": $0.components(separatedBy: ",")[2].lengthOfBytes(using: .utf8)
        ]}
        let strings = resourceString
            .components(separatedBy: "\n")
            .filter({ $0.components(separatedBy: ",").count == 3 })
            .map(mapper)
        
        let users = Table("clues")
        let clueColumn = Expression<String>("clue")
        let answerColumn = Expression<String>("answer")
        let answerLengthColumn = Expression<Int>("answerLength")
        
        try! db.run(users.create { t in
            t.column(answerColumn)
            t.column(clueColumn)
            t.column(answerLengthColumn)
        })
        
        let stmt = try! db.prepare("INSERT INTO clues (answer, clue, answerLength) VALUES (?, ?, ?)")
        
        let chunkSize = 500
        let chunks = stride(from: 0, to: strings.count, by: chunkSize).map {
            Array(strings[$0..<min($0 + chunkSize, strings.count)])
        }

        chunks.forEach { chunk in
            try! db.transaction {
                chunk.forEach {
                    let clue = $0["clue"] as! String
                    let answer = $0["answer"] as! String
                    let length = $0["answerLength"] as! Int
                    try! stmt.run(answer, clue, length)
                }
        }
        
    }
    
    func needsBootstrap() -> Bool {
        return false
        //return try! db.fetch(FetchRequest<ClueAnswerPair>()).isEmpty
    }
}

