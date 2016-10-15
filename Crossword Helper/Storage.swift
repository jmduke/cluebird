//
//  Storage.swift
//  Crossword Helper
//
//  Created by Justin Duke on 10/11/16.
//  Copyright © 2016 Pug and Chalice, LLC. All rights reserved.
//

import Foundation
import SQLite

func sqliteStorage() -> Connection {
    // TODO: Figure out a way to create this easier for when I need to reconstitute the DB.
    /*
    let path = NSSearchPathForDirectoriesInDomains(
    .documentDirectory, .userDomainMask, true
    ).first!
    return try! Connection("\(path)/db.sqlite3")
 */
    let path = Bundle.main.path(forResource: "clues", ofType: "sqlite3")!
    return try! Connection(path, readonly: true)
}
var db = sqliteStorage()
