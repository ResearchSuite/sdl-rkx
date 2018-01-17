//
//  MEDLFullStepGenerator.swift
//  PAM-Reference-App
//
//  Created by Christina Tsangouri on 12/22/17.
//  Copyright © 2017 Christina Tsangouri. All rights reserved.
//

//
//  YADLFullStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 4/2/17.
//
//

import UIKit
import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss
import sdlrkx

open class MEDLFullStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "MEDLFullAssessment"
    ]
    
    open var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func imageChoice(_ item: MEDLItem) -> RKXImageChoiceWithAdditionalText? {
        guard let image = UIImage(named: item.imageTitle)
            else {
                assertionFailure("Cannot find image named \(item.imageTitle))")
                return nil
        }
        return RKXImageChoiceWithAdditionalText.init(image: image, text: item.specificDescription, additionalText: item.generalDescription, value: item.identifier as NSCoding & NSCopying & NSObjectProtocol)
    }
    
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
            }
            else {
                encountered.insert(value)
                result.append(value)
            }
        }
        return result
    }
    
    open func generateChoices(items: [MEDLItem], shouldShuffle: Bool = false) -> [RKXImageChoiceWithAdditionalText] {
        
        if shouldShuffle {
            return items.shuffled().flatMap({self.imageChoice($0)})
        }
        else {
            return items.flatMap({self.imageChoice($0)})
        }
    }
    
    open func getAllIdentifiers(items: [MEDLItem]) -> [String]{
        
        var allIdentifiers : [String] = []
        
        for item in items {
           allIdentifiers.append(item.identifier)
        }
        
        return ["identifiers"]
    }
    
    open func getCategories(items: [MEDLItem]) -> [String] {
        
        var categories : [String] = []
        
        for each in items {
            categories.append(each.category)
        }
        
        let noDupCategories = removeDuplicates(array: categories)
        
        return noDupCategories
    }
    
    open func generateSteps(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> [ORKStep]? {
        
        var medlSteps : [MEDLFullAssessmentCategoryStep] = []
        
        guard let medlFullDescriptor = MEDLFullStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let categories = self.getCategories(items: medlFullDescriptor.items)
        
        for category in categories {
            
            var currentItems : [MEDLItem] = []
            
            for item in medlFullDescriptor.items {
                if item.category == category {
                    currentItems.append(item)
                }
            }
            
            let imageChoices = self.generateChoices(items: currentItems)
            let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
            let options = RKXMultipleImageSelectionSurveyOptions(json: jsonObject)
            let identifier = "medl_full." + category
            let currentIdentifiers = self.getAllIdentifiers(items: currentItems)
            
            let medlFullAssessmentStep = MEDLFullAssessmentCategoryStep(
                identifier: identifier,
                title: "",
                category: category,
                answerFormat: answerFormat,
                options: options
               
                
            )
            
            medlFullAssessmentStep.isOptional = medlFullDescriptor.optional
            
            
            medlSteps.append(medlFullAssessmentStep)
            
        }
        
        
        
        return medlSteps
        
        
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
}
