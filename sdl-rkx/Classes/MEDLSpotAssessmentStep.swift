//
//  MEDLSpotAssessmentStep.swift
//  Pods
//
//  Created by James Kizer on 5/6/16.
//
//

import UIKit

class MEDLSpotAssessmentStep: RKXMultipleImageSelectionSurveyStep {

    override func stepViewControllerClass() -> AnyClass {
        return MEDLSpotAssessmentStepViewController.self
    }
    
}
