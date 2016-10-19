//
//  SortingMethodPopoverView.swift
//  Crossword Helper
//
//  Created by Justin Duke on 10/3/16.
//  Copyright © 2016 Pug and Chalice, LLC. All rights reserved.
//

import Foundation
import UIKit

class FilteringMethodPopoverView: UIStackView {
    
    var buttons: [UIButton] = []
    
    init(frame: CGRect, filters: [AnswerResultFilteringMethod]) {
        super.init(frame: frame)
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        
        filters.forEach {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: 0, y: 0, width: frame.width, height: 20)
            button.setTitle($0.title.localized(), for: .normal)
            addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
