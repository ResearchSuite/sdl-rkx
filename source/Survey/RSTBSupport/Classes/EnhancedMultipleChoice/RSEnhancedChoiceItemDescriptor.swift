//
//  RSEnhancedChoiceItemDescriptor.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss

open class RSEnhancedChoiceItemDescriptor: RSTBChoiceItemDescriptor {
    
    public let auxiliaryItem: JSON?
    
    public required init?(json: JSON) {
        
        self.auxiliaryItem = "auxiliaryItem" <~~ json
        super.init(json: json)
        
    }

}
