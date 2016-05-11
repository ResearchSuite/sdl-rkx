//
//  PAMStepViewController.swift
//  Pods
//
//  Created by James Kizer on 5/3/16.
//
//

import UIKit
class PAMStepViewController: RKXMultipleImageSelectionSurveyViewController {

    // MARK: - Required by superclass
    override var supportsMultipleSelection: Bool {
        return false
    }
    
    override var transitionOnSelection: Bool {
        return true
    }
    
    override var somethingSelectedButtonText: String {
        return ""
    }
    
    override var nothingSelectedButtonText: String {
        return "Reload Images"
    }
    
    @IBAction override func somethingSelectedButtonPressed(sender: AnyObject) {
        fatalError("Unimplemented")
    }
    
    @IBAction override func nothingSelectedButtonPressed(sender: AnyObject) {
        //reloading the UI should cause the cells to be reloaded,
        //which means images will be chosen at random
        self.updateUI()
    }

}
