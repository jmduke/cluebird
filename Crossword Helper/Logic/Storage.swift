//
//  Storage.swift
//  Crossword Helper
//
//  Created by Justin Duke on 10/11/16.
//  Copyright © 2016 Pug and Chalice, LLC. All rights reserved.
//

import Foundation
import SQLite
import Zip

func sqliteStorage() -> Connection {
    // TODO: Figure out a way to create this easier for when I need to reconstitute the DB.
    let zipPath = Bundle.main.url(forResource: "clues.sqlite3", withExtension: "zip")!
    let unzipDirectory = try! Zip.quickUnzipFile(zipPath)
    let unzipFile = unzipDirectory.appendingPathComponent("clues.sqlite3").path
    /*let path = NSSearchPathForDirectoriesInDomains(
    .documentDirectory, .userDomainMask, true
    ).first!
    */
    return try! Connection(unzipFile, readonly: true)
 /*
    let path = Bundle.main.path(forResource: "clues", ofType: "sqlite3")!
    return try! Connection(path, readonly: true)*/
}
var db = sqliteStorage()
