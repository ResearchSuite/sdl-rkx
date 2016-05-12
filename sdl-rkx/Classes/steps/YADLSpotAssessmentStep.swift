//
//  YADLSpotAssessmentStep.swift
//  sdl-rkx
//
//  Created by James Kizer on 5/2/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit

class YADLSpotAssessmentStep: RKXMultipleImageSelectionSurveyStep {

    override func stepViewControllerClass() -> AnyClass {
        return YADLSpotAssessmentStepViewController.self
    }
    
}
