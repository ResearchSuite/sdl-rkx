//
//  RKXTextChoiceWithColor.swift
//  SDL-RKX
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

class RKXTextChoiceWithColor: ORKTextChoice {
    
    var color: UIColor?
    init(text: String, value: NSCoding & NSCopying & NSObjectProtocol) {
        super.init(text: text, detailText: nil, value: value, exclusive: false)
    }
    
    convenience init(text: String, value: NSCoding & NSCopying & NSObjectProtocol, color: UIColor?) {
        self.init(text: text, value: value)
        self.color = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
