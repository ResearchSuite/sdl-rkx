//
//  MEDLSpotAssessmentStep.swift
//  sdlrkx
//
//  Created by James Kizer on 5/6/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit

class MEDLSpotAssessmentStep: RKXMultipleImageSelectionSurveyStep {

    override func stepViewControllerClass() -> AnyClass {
        return MEDLSpotAssessmentStepViewController.self
    }
    
}
