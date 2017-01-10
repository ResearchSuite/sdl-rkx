//
//  MEDLFullAssessmentStepViewController.swift
//  sdlrkx
//
//  Created by James Kizer on 5/6/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

class MEDLFullAssessmentCategoryStepViewController: RKXMultipleImageSelectionSurveyViewController {
    
    override var additionalTextViewText: String? {
        return (self.step as? MEDLFullAssessmentCategoryStep)?.category
    }
    
    override var additionalTextViewHeight: CGFloat {
        return 32.0
    }
    
    override var cellTextStackViewHeight: CGFloat {
        return 40.0
    }
    
    override func configureCellForImageChoice(_ missCell: RKXMultipleImageSelectionSurveyCollectionViewCell, imageChoice: ORKImageChoice) -> RKXMultipleImageSelectionSurveyCollectionViewCell {
        
        let missCell = super.configureCellForImageChoice(missCell, imageChoice: imageChoice)
        
        if let additionalTextImageChoice = imageChoice as? RKXImageChoiceWithAdditionalText {
            if let _ = additionalTextImageChoice.text {
                missCell.primaryText = additionalTextImageChoice.text
                missCell.secondaryText = additionalTextImageChoice.additionalText
            }
            else {
                missCell.primaryText = additionalTextImageChoice.additionalText
            }
        }
        
        return missCell
    }
    
    // MARK: - Required by superclass
    override var supportsMultipleSelection: Bool {
        return true
    }
    
    override var transitionOnSelection: Bool {
        return false
    }
    
    override var somethingSelectedButtonText: String {
        return "Next"
    }
    
    override var nothingSelectedButtonText: String {
        return "Next"
    }
    
    @IBAction override func somethingSelectedButtonPressed(_ sender: AnyObject) {
        self.notifyDelegateAndMoveForward()
    }
    
    @IBAction override func nothingSelectedButtonPressed(_ sender: AnyObject) {
        self.notifyDelegateAndMoveForward()
    }
}
