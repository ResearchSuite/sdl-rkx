//
//  PAMStep.swift
//  Pods
//
//  Created by James Kizer on 5/3/16.
//
//

import UIKit

class PAMStep: RKXMultipleImageSelectionSurveyStep {

    override func stepViewControllerClass() -> AnyClass {
        return PAMStepViewController.self
    }
    
}
