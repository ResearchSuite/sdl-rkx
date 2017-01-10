//
//  MEDLFullAssessmentTask.swift
//  sdlrkx
//
//  Created by James Kizer on 5/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

open class MEDLFullAssessmentTask: RKXMultipleImageSelectionSurveyTask {

    open class func fullAssessmentResults(_ taskResult: ORKTaskResult) -> [ORKChoiceQuestionResult]? {
        if let stepResults = taskResult.results as? [ORKStepResult]
        {
            print(stepResults)
            stepResults.forEach { print($0) }
            return stepResults.map { stepResult in
                return stepResult.firstResult as? ORKChoiceQuestionResult
                }
                .flatMap{ $0 }
        }
        else { return nil }
    }
    
    class func defaultOptions() -> RKXMultipleImageSelectionSurveyOptions {
        let options = RKXMultipleImageSelectionSurveyOptions()
        options.somethingSelectedButtonColor = UIColor.blue
        options.nothingSelectedButtonColor = UIColor.blue
        options.itemsPerRow = 4
        options.itemMinSpacing = 4
        return options
    }
    
    convenience public init(identifier: String, propertiesFileName: String) {
        
        guard let filePath = Bundle.main.path(forResource: propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to locate file \(propertiesFileName)")
        }
        
        guard let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else {
                fatalError("Unable to create NSData with file content (YADL Spot Assessment data)")
        }
        
        let json = try! JSONSerialization.jsonObject(with: fileContent, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        self.init(identifier: identifier, json: json as AnyObject)
    }
    
    convenience public init(identifier: String, json: AnyObject) {
        
        guard let completeJSON = json as? [String: AnyObject],
            let typeJSON = completeJSON["MEDL"] as? [String: AnyObject],
            let assessmentJSON = typeJSON["full"] as? [String: AnyObject],
            let itemJSONArray = typeJSON["medications"] as? [AnyObject]
            else {
                fatalError("JSON Parse Error")
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
        let steps: [ORKStep] = {
            if (categories.count == 0) {
                guard let noActivitiesSummary = assessment.noItemsSummary
                    else {
                        fatalError("No summary")
                }
                let summaryStep = ORKInstructionStep(identifier: noActivitiesSummary.identifier)
                summaryStep.title = noActivitiesSummary.title
                summaryStep.text = noActivitiesSummary.text
                return [summaryStep]
            }
            else {

                var steps: [ORKStep] = categories.map { category in
                    let items:[RKXCopingMechanismDescriptor] = categoryGroups[category]!
                    let imageChoices: [ORKImageChoice] = items
                        .map(RKXImageDescriptor.imageChoiceForDescriptor())
                        //dont forget to unwrap optionals!!
                        .flatMap { $0 }
                    
                    let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
                    
                    let assessmentStep = MEDLFullAssessmentCategoryStep(identifier: category, title: assessment.prompt, category: category, answerFormat: answerFormat, options: options)
                    
                    return assessmentStep
                }
                
                if let summary = assessment.summary {
                    let summaryStep = ORKInstructionStep(identifier: summary.identifier)
                    summaryStep.title = summary.title
                    summaryStep.text = summary.text
                    steps.append(summaryStep)
                }
                
                return steps
            }
        }()
        
        self.init(identifier: identifier, steps: steps)
        
    }
    
    override init(identifier: String, steps: [ORKStep]?) {
        super.init(identifier: identifier, steps: steps)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
