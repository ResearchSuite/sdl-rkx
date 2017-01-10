//
//  PAMMultipleSelectionStep.swift
//  SDLRKX
//
//  Created by James Kizer on 10/10/16.
//  Copyright © 2016 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit
import ResearchKit

public class PAMMultipleSelectionStep: RKXMultipleImageSelectionSurveyStep {
    override public func stepViewControllerClass() -> AnyClass {
        return PAMMultipleSelectionStepViewController.self
    }
    
    public static func create(identifier: String, propertiesFileName: String, bundle: Bundle = Bundle.main) -> PAMMultipleSelectionStep? {
        
        guard let filePath = bundle.path(forResource: propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to locate file PAM.json")
        }
        
        guard let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else {
                fatalError("Unable to create NSData with file content (PAM data)")
        }
        
        if let spotAssessmentParameters = try! JSONSerialization.jsonObject(with: fileContent, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
            return PAMMultipleSelectionStep.create(identifier: identifier, parameters: spotAssessmentParameters, bundle: bundle)
        }
        else {
            return nil
        }
    }
    
    public static func create(identifier: String, parameters: [String: Any], bundle: Bundle = Bundle.main) -> PAMMultipleSelectionStep? {
        
        let completeJSON = parameters
        
        guard let typeJSON = completeJSON["PAM"] as? [String: AnyObject],
            let itemJSONArray = typeJSON["affects"] as? [AnyObject]
            else {
                assertionFailure("JSON Parse Error")
                return nil
        }
        
        let assessmentJSON = typeJSON
        let items:[RKXSingleImageAffectDescriptor] = itemJSONArray.map { (itemJSON: AnyObject) in
            guard let itemDictionary = itemJSON as? [String: AnyObject]
                else
            {
                return nil
            }
            return RKXSingleImageAffectDescriptor(itemDictionary: itemDictionary)
            }.flatMap { $0 }
        
        let imageChoices: [ORKImageChoice] = items
            .map(RKXImageDescriptor.imageChoiceForDescriptor(bundle))
            //dont forget to unwrap optionals!!
            .flatMap { $0 }
        
        let assessment = RKXMultipleImageSelectionSurveyDescriptor(assessmentDictionary: assessmentJSON)
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
        
        let pamStep = PAMMultipleSelectionStep(identifier: identifier, title: assessment.prompt, answerFormat: answerFormat, options: PAMMultipleSelectionTask.defaultOptions())
        
        return pamStep
    }
}
