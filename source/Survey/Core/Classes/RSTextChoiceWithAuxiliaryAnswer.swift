//
//  RSTextChoiceWithAuxiliaryAnswer.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import UIKit
import ResearchKit

open class RSTextChoiceWithAuxiliaryAnswer: ORKTextChoice {
    
    public let auxiliaryItem: ORKFormItem?
    
    public init(text: String,
        detailText: String?,
        value: NSCoding & NSCopying & NSObjectProtocol,
        exclusive: Bool,
        auxiliaryItem: ORKFormItem?) {
        
        self.auxiliaryItem = auxiliaryItem
        super.init(text: text, detailText: detailText, value: value, exclusive: exclusive)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
