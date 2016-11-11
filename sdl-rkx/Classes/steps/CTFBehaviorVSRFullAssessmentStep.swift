//
//  CTFBehaviorVSRFullAssessmentStep.swift
//  Impulse
//
//  Created by James Kizer on 11/10/16.
//  Copyright © 2016 James Kizer. All rights reserved.
//

import UIKit
import SDLRKX

open class CTFBehaviorVSRFullAssessmentStep: RKXMultipleImageSelectionSurveyStep {

    
    override open func stepViewControllerClass() -> AnyClass {
        return CTFBehaviorVSRFullAssessmentStepViewController.self
    }
    
}
