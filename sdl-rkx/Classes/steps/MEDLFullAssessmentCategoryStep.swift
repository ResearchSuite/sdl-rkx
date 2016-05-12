//
//  MEDLFullAssessmentCategoryStep.swift
//  sdl-rkx
//
//  Created by James Kizer on 5/6/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

class MEDLFullAssessmentCategoryStep: RKXMultipleImageSelectionSurveyStep {

    var category: String?
    
    override func stepViewControllerClass() -> AnyClass {
        return MEDLFullAssessmentCategoryStepViewController.self
    }
    
    init(identifier: String,
         title: String?,
         category: String?,
         answerFormat: ORKImageChoiceAnswerFormat? ) {
        
        super.init(identifier: identifier, title: title, answerFormat: answerFormat)
        self.category = category
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
