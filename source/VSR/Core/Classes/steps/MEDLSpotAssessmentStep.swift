//
//  MEDLSpotAssessmentStep.swift
//  sdlrkx
//
//  Created by James Kizer on 5/6/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import ResearchKit

open class MEDLSpotAssessmentStep: RKXMultipleImageSelectionSurveyStep {

    override open func stepViewControllerClass() -> AnyClass {
        return MEDLSpotAssessmentStepViewController.self
    }
    
    public static func create(identifier: String, propertiesFileName: String, itemIdentifiers: [String]? = nil) throws -> MEDLSpotAssessmentStep? {
        guard let filePath = Bundle.main.path(forResource: propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to locate file \(propertiesFileName)")
        }
        
        guard let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else {
                fatalError("Unable to create NSData with file content (YADL Spot Assessment data)")
        }
        
        let json = try JSONSerialization.jsonObject(with: fileContent, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        return MEDLSpotAssessmentStep.create(identifier: identifier, json: json as AnyObject, itemIdentifiers: itemIdentifiers)
    }
    
    public static func create(identifier: String, json: AnyObject, itemIdentifiers: [String]? = nil) -> MEDLSpotAssessmentStep? {
        
        guard let completeJSON = json as? [String: AnyObject],
            let typeJSON = completeJSON["MEDL"] as? [String: AnyObject],
            let assessmentJSON = typeJSON["spot"] as? [String: AnyObject],
            let itemJSONArray = typeJSON["medications"] as? [AnyObject]
            else {
                assertionFailure("JSON Parse Error")
                return nil
        }
        
        let items:[RKXCopingMechanismDescriptor] = itemJSONArray.map { (itemJSON: AnyObject) in
            guard let itemDictionary = itemJSON as? [String: AnyObject]
                else
            {
                return nil
            }
            return RKXCopingMechanismDescriptor(itemDictionary: itemDictionary)
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
        
        guard imageChoices.count > 0 else { return nil }
        
        let assessment = RKXMultipleImageSelectionSurveyDescriptor(assessmentDictionary: assessmentJSON)
        
        let options = assessment.options
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
        
        return MEDLSpotAssessmentStep(identifier: identifier, title: assessment.prompt, answerFormat: answerFormat, options: options)
    }
    
    
    
}
