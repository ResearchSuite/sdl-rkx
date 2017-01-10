//
//  YADLFullAssessmentStep.swift
//  sdlrkx
//
//  Created by James Kizer on 5/3/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import ResearchKit

open class YADLFullAssessmentStep: RKXSingleImageClassificationSurveyStep {

    public static func create(identifier: String, propertiesFileName: String) throws -> [YADLFullAssessmentStep]? {
        guard let filePath = Bundle.main.path(forResource: propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to locate file \(propertiesFileName)")
        }
        
        guard let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else {
                fatalError("Unable to create NSData with file content (YADL Spot Assessment data)")
        }
        
        let json = try JSONSerialization.jsonObject(with: fileContent, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        return YADLFullAssessmentStep.create(identifier: identifier, json: json as AnyObject)
    }
    
    public static func create(identifier: String, json: AnyObject) -> [YADLFullAssessmentStep]? {
        
        
        guard let completeJSON = json as? [String: AnyObject],
            let typeJSON = completeJSON["YADL"] as? [String: AnyObject],
            let assessmentJSON = typeJSON["full"] as? [String: AnyObject],
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
        
        let assessment = YADLFullAssessmentDescriptor(assessmentDictionary: assessmentJSON)

        let textChoices = assessment.choices!.map { choice in
            return RKXTextChoiceWithColor(text: choice.text, value: (choice.value)!, color: choice.color)
        }
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        let steps: [YADLFullAssessmentStep] = items.flatMap { item in
            guard let image = UIImage(named: item.imageTitle)
                else {
                    fatalError("Cannot find image named \(item.imageTitle)")
                    return nil
            }
            
            return YADLFullAssessmentStep(identifier: identifier.appending(".\(item.identifier)"), title: item.activityDescription, text: assessment.prompt, image: image, answerFormat: answerFormat)
        }
                
        return steps.count > 0 ? steps : nil
        
    }
    
}
