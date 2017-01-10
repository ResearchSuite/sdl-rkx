//
//  YADLSpotAssessmentStepViewController.swift
//  sdlrkx
//
//  Created by James Kizer on 5/3/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit

class YADLSpotAssessmentStepViewController: RKXMultipleImageSelectionSurveyViewController {

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
        return "Nothing To Report"
    }
    
    @IBAction override func somethingSelectedButtonPressed(_ sender: AnyObject) {
        self.notifyDelegateAndMoveForward()
    }
    
    @IBAction override func nothingSelectedButtonPressed(_ sender: AnyObject) {
        self.notifyDelegateAndMoveForward()
    }
}
