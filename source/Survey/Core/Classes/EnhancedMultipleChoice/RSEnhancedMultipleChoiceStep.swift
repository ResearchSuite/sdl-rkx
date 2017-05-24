//
//  RSEnhancedMultipleChoiceStep.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import UIKit
import ResearchKit

open class RSEnhancedMultipleChoiceStep: ORKStep {
    
    open var answerFormat: ORKTextChoiceAnswerFormat?
    
    public init(identifier: String, title: String?, text: String?, answer answerFormat: ORKTextChoiceAnswerFormat?) {
        self.answerFormat = answerFormat
        super.init(identifier: identifier)
        self.title = title
        self.text = text
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func stepViewControllerClass() -> AnyClass {
        return RSEnhancedMultipleChoiceStepViewController.self
    }

}
