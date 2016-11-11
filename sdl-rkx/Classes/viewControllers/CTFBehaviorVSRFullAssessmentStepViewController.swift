//
//  CTFBehaviorVSRFullAssessmentStepViewController.swift
//  SDLRKX
//
//  Created by James Kizer on 11/10/16.
//  Copyright © 2016 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit

open class CTFBehaviorVSRFullAssessmentStepViewController: RKXMultipleImageSelectionSurveyViewController {
    // MARK: - Required by superclass
    override var supportsMultipleSelection: Bool {
        return true
    }
    
    override var transitionOnSelection: Bool {
        return false
    }
    
    override var somethingSelectedButtonText: String {
        if let selectedAnswers = self.selectedAnswers() {
            return "Submit (\(selectedAnswers.count))"
        }
        else {
            return "Submit (0)"
        }
    }
    
    override var nothingSelectedButtonText: String {
        return "Submit (0)"
    }
    
    @IBAction override func somethingSelectedButtonPressed(_ sender: AnyObject) {
        self.notifyDelegateAndMoveForward()
    }
    
    @IBAction override func nothingSelectedButtonPressed(_ sender: AnyObject) {
        self.notifyDelegateAndMoveForward()
    }
}
