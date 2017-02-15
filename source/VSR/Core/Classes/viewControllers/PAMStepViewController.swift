//
//  PAMStepViewController.swift
//  sdlrkx
//
//  Created by James Kizer on 5/3/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

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
    
    override open func valueForImageChoice(_ imageChoice: ORKImageChoice) -> NSCoding & NSCopying & NSObjectProtocol {
        
        guard let pamImageChoice = imageChoice as? PAMImageChoice,
            let value = pamImageChoice.value as? NSDictionary else {
                return imageChoice.value
        }
        
        let valueDictionary = NSMutableDictionary(dictionary: value)
        valueDictionary["image"] = pamImageChoice.currentImageName
        return valueDictionary
        
    }
    
    @IBAction override func somethingSelectedButtonPressed(_ sender: AnyObject) {
        fatalError("Unimplemented")
    }
    
    @IBAction override func nothingSelectedButtonPressed(_ sender: AnyObject) {
        //reloading the UI should cause the cells to be reloaded,
        //which means images will be chosen at random
        self.updateUI()
    }
    
    

}
