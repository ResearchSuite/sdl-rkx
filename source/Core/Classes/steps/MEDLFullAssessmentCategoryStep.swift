 //
//  MEDLFullAssessmentCategoryStep.swift
//  sdlrkx
//
//  Created by James Kizer on 5/6/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

open class MEDLFullAssessmentCategoryStep: RKXMultipleImageSelectionSurveyStep {

    var category: String?
    
    override open func stepViewControllerClass() -> AnyClass {
        return MEDLFullAssessmentCategoryStepViewController.self
    }
    
    init(identifier: String,
         title: String?,
         category: String?,
         answerFormat: ORKImageChoiceAnswerFormat?,
         options: RKXMultipleImageSelectionSurveyOptions?) {
        
        super.init(identifier: identifier, title: title, answerFormat: answerFormat, options: options)
        self.category = category
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func create(identifier: String, propertiesFileName: String) throws -> [MEDLFullAssessmentCategoryStep]? {
        guard let filePath = Bundle.main.path(forResource: propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to locate file \(propertiesFileName)")
        }
        
        guard let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else {
                fatalError("Unable to create NSData with file content (YADL Spot Assessment data)")
        }

        let json = try JSONSerialization.jsonObject(with: fileContent, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        return MEDLFullAssessmentCategoryStep.create(identifier: identifier, json: json as AnyObject)
    }
    
    public static func create(identifier: String, json: AnyObject) -> [MEDLFullAssessmentCategoryStep]? {
        
        guard let completeJSON = json as? [String: AnyObject],
            let typeJSON = completeJSON["MEDL"] as? [String: AnyObject],
            let assessmentJSON = typeJSON["full"] as? [String: AnyObject],
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
        
        let categories = items.reduce([String](), { (acc, item) -> [String] in
            if acc.contains(item.category) {
                return acc
            }
            else {
                return acc + [item.category]
            }
        })
        
        let categoryGroups :[String: [RKXCopingMechanismDescriptor]] = {
            var dictionary: [String: [RKXCopingMechanismDescriptor]] = [:]
            categories.forEach { category in
                dictionary[category] = items.filter { $0.category == category }
            }
            
            return dictionary
        }()
        
        let assessment = RKXMultipleImageSelectionSurveyDescriptor(assessmentDictionary: assessmentJSON)
        
        let options = assessment.options ?? MEDLFullAssessmentTask.defaultOptions();
        
        guard categories.count > 0 else { return nil }
        
        let steps: [MEDLFullAssessmentCategoryStep] = categories.flatMap { category in
            let items:[RKXCopingMechanismDescriptor] = categoryGroups[category]!
            let imageChoices: [ORKImageChoice] = items
                .flatMap(RKXImageDescriptor.imageChoiceForDescriptor())
            
            guard imageChoices.count > 0 else { return nil }
            
            let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
            
            let assessmentStep = MEDLFullAssessmentCategoryStep(identifier: identifier.appending(".\(category)"), title: assessment.prompt, category: category, answerFormat: answerFormat, options: options)
            
            return assessmentStep
        }
        
        return steps.count > 0 ? steps : nil
        
    }
}
