//
//  MEDLFullAssessmentStepViewController.swift
//  Pods
//
//  Created by James Kizer on 5/6/16.
//
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
    
    override func configureCellForImageChoice(missCell: RKXMultipleImageSelectionSurveyCollectionViewCell, imageChoice: ORKImageChoice) -> RKXMultipleImageSelectionSurveyCollectionViewCell {
        
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
    
    @IBAction override func somethingSelectedButtonPressed(sender: AnyObject) {
        self.notifyDelegateAndMoveForward()
    }
    
    @IBAction override func nothingSelectedButtonPressed(sender: AnyObject) {
        self.notifyDelegateAndMoveForward()
    }
}
