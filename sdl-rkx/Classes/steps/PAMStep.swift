//
//  PAMStep.swift
//  sdl-rkx
//
//  Created by James Kizer on 5/3/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit

class PAMStep: RKXMultipleImageSelectionSurveyStep {

    override func stepViewControllerClass() -> AnyClass {
        return PAMStepViewController.self
    }
    
}
