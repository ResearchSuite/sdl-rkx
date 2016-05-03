//
//  RKXMultipleImageSelectionSurveyStep.swift
//  SDL-RKX
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

class RKXMultipleImageSelectionSurveyStep: ORKQuestionStep {

    func stepViewControllerClass() -> AnyClass {
        return RKXMultipleImageSelectionSurveyViewController.self
    }
    
    init(identifier: String,
         title: String,
         answerFormat: ORKImageChoiceAnswerFormat ) {
        
        super.init(identifier: identifier)
        self.title = title
        self.answerFormat = answerFormat
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
