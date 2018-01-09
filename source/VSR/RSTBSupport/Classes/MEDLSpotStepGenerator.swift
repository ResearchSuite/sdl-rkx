//
//  MEDLSpotStepGenerator.swift
//  PAM-Reference-App
//
//  Created by Christina Tsangouri on 1/3/18.
//  Copyright © 2018 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss
import ResearchSuiteExtensions
import sdlrkx

open class MEDLSpotStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "MEDLSpotAssessment"
    ]
    
    open var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func excludedIdentifiers(items: [MEDLItem], jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> [String] {
        
        guard let medlSpotDescriptor = MEDLSpotDescriptor(json: jsonObject),
            let filterKey = medlSpotDescriptor.filterKey,
            let stateHelper = helper.stateHelper,
            let includedValues = stateHelper.valueInState(forKey: filterKey) as? [String] else {
                return []
        }
        
        if includedValues.count == 0 {
            return items.map{$0.identifier}
        }
        else {
            
            return items.map({$0.identifier}).filter({ identifier in
                return !includedValues.contains(where: { (includedValue) -> Bool in
                    return includedValue == identifier
                })
            })
            
        }
    }
    
    open func imageChoice(_ item: MEDLItem) -> RKXImageChoiceWithAdditionalText? {
        guard let image = UIImage(named: item.imageTitle)
            else {
                assertionFailure("Cannot find image named \(item.imageTitle))")
                return nil
        }
        return RKXImageChoiceWithAdditionalText.init(image: image, text: item.specificDescription, additionalText: item.generalDescription, value: item.identifier as NSCoding & NSCopying & NSObjectProtocol)
    }
    
    open func generateChoices(items: [MEDLItem], shouldShuffle: Bool = false) -> [RKXImageChoiceWithAdditionalText] {
        
        if shouldShuffle {
            return items.shuffled().flatMap({self.imageChoice($0)})
        }
        else {
            return items.flatMap({self.imageChoice($0)})
        }
    }
    
    open func generateSteps(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> [ORKStep]? {
        
        guard let medlSpotDescriptor = MEDLSpotDescriptor(json: jsonObject) else {
            return nil
        }
        
        let imageChoices = self.generateChoices(items: medlSpotDescriptor.items)
        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
        
        let excludedIdentifiers = self.excludedIdentifiers(items: medlSpotDescriptor.items, jsonObject: jsonObject, helper: helper)
        let options = RKXMultipleImageSelectionSurveyOptions(json: jsonObject)
        let spotAssessmentStep = MEDLSpotAssessmentStep(
            identifier: medlSpotDescriptor.identifier,
            title: medlSpotDescriptor.title,
            answerFormat: answerFormat,
            options: options,
            excludedIdentifiers: excludedIdentifiers
        )
        
        spotAssessmentStep.isOptional = medlSpotDescriptor.optional
        
        return [spotAssessmentStep]
        
        
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    
}
