//
//  CTFBehaviorVSRFullAssessmentStep.swift
//  Impulse
//
//  Created by James Kizer on 11/10/16.
//  Copyright © 2016 Cornell Tech. All rights reserved.
//

import UIKit

class CTFBehaviorVSRFullAssessmentStep: RKXMultipleImageSelectionSurveyStep {

    
    override open func stepViewControllerClass() -> AnyClass {
        return CTFBehaviorVSRFullAssessmentStepViewController.self
    }
    
}
