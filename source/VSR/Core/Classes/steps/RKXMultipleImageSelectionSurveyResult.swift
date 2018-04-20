//
//  RKXMultipleImageSelectionSurveyStepResult.swift
//  Pods
//
//  Created by James Kizer on 4/2/17.
//
//

import UIKit
import ResearchKit

open class RKXMultipleImageSelectionSurveyResult: ORKChoiceQuestionResult {
    
    open var selectedIdentifiers: [String]?
    open var notSelectedIdentifiers: [String]?
    open var excludedIdentifiers: [String]?
    
    override open var description: String {
        return super.description +
            (self.selectedIdentifiers != nil ? "\nselectedIdentifiers: \(self.selectedIdentifiers!)" : "") +
        (self.notSelectedIdentifiers != nil ? "\nnotSelectedIdentifiers: \(self.notSelectedIdentifiers!)" : "") +
        (self.excludedIdentifiers != nil ? "\nexcludedIdentifiers: \(self.excludedIdentifiers!)" : "")
    }
    
    override open func copy(with zone: NSZone? = nil) -> Any {
        let theCopy = super.copy(with: zone) as! RKXMultipleImageSelectionSurveyResult
        theCopy.selectedIdentifiers = self.selectedIdentifiers
        theCopy.notSelectedIdentifiers = self.notSelectedIdentifiers
        theCopy.excludedIdentifiers = self.excludedIdentifiers
        return theCopy
    }

}
