//
//  PAMMultipleSelectionStep.swift
//  SDLRKX
//
//  Created by James Kizer on 10/10/16.
//  Copyright © 2016 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit

class PAMMultipleSelectionStep: RKXMultipleImageSelectionSurveyStep {
    override func stepViewControllerClass() -> AnyClass {
        return PAMMultipleSelectionStepViewController.self
    }
}
