//
//  AnswerResultCell.swift
//  Crossword Helper
//
//  Created by Justin Duke on 10/3/16.
//  Copyright © 2016 Pug and Chalice, LLC. All rights reserved.
//

import Foundation
import UIKit

class AnswerResultCell: UITableViewCell {
    init(answer: AnswerResult) {
        super.init(style: .subtitle, reuseIdentifier: nil)
        textLabel?.text = answer.answer
        
        // Enrich the data.
        detailTextLabel?.text = answer.clues.count > 1 ?
            answer.clues[0] + " +\(answer.clues.count - 1) other answers" :
            answer.clues[0]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
