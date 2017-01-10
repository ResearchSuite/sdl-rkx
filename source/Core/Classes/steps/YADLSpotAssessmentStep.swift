//
//  YADLSpotAssessmentStep.swift
//  sdlrkx
//
//  Created by James Kizer on 5/2/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import ResearchKit

open class YADLSpotAssessmentStep: RKXMultipleImageSelectionSurveyStep {

    override open func stepViewControllerClass() -> AnyClass {
        return YADLSpotAssessmentStepViewController.self
    }
    
    public static func create(identifier: String, propertiesFileName: String, itemIdentifiers: [String]? = nil) throws -> YADLSpotAssessmentStep? {
        guard let filePath = Bundle.main.path(forResource: propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to locate file \(propertiesFileName)")
        }
        
        guard let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else {
                fatalError("Unable to create NSData with file content (YADL Spot Assessment data)")
        }
        
        let json = try JSONSerialization.jsonObject(with: fileContent, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        return YADLSpotAssessmentStep.create(identifier: identifier, json: json as AnyObject, itemIdentifiers: itemIdentifiers)
    }
    
    public static func create(identifier: String, json: AnyObject, itemIdentifiers: [String]? = nil) -> YADLSpotAssessmentStep? {
        
        guard let completeJSON = json as? [String: AnyObject],
            let typeJSON = completeJSON["YADL"] as? [String: AnyObject],
            let assessmentJSON = typeJSON["spot"] as? [String: AnyObject],
            let itemJSONArray = typeJSON["activities"] as? [AnyObject]
            else {
                assertionFailure("JSON Parse Error")
                return nil
        }
        
        let items:[RKXActivityDescriptor] = itemJSONArray.map { (itemJSON: AnyObject) in
            guard let itemDictionary = itemJSON as? [String: AnyObject]
                else
            {
                return nil
            }
            return RKXActivityDescriptor(itemDictionary: itemDictionary)
            }.flatMap { $0 }
        
        let imageChoices: [ORKImageChoice] = items
            .filter { activity in
                if let identifiers = itemIdentifiers {
                    return identifiers.contains(activity.identifier)
                }
                else {
                    return true
                }
            }
            .flatMap(RKXImageDescriptor.imageChoiceForDescriptor())
        
        let assessment = RKXMultipleImageSelectionSurveyDescriptor(assessmentDictionary: assessmentJSON)
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
        
        return YADLSpotAssessmentStep(identifier: identifier, title: assessment.prompt, answerFormat: answerFormat, options: assessment.options)
        
    }
    
    
}
