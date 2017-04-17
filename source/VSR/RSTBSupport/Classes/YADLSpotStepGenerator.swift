//
//  YADLSpotStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 4/2/17.
//
//

import UIKit
import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss

open class YADLSpotStepGenerator: RSTBBaseStepGenerator {

    public init(){}
    
    let _supportedTypes = [
        "YADLSpotAssessment"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
//    public typealias YADLItemFilter = ((NSCoding & NSCopying & NSObjectProtocol) -> Bool)
//    
//    open func generateFilter(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> YADLItemFilter? {
//        
//        guard let yadlSpotDescriptor = YADLSpotDescriptor(json: jsonObject),
//            let filterKey = yadlSpotDescriptor.filterKey,
//            let stateHelper = helper.stateHelper,
//            let includedValues = stateHelper.valueInState(forKey: filterKey) as? [String],
//            includedValues.count > 0 else {
//            return nil
//        }
//        
//        return { item in
//            if let value = item as? String {
//                return includedValues.contains(where: { (includedValue) -> Bool in
//                    return includedValue == value
//                })
//            }
//            else {
//                return false
//            }
//        }
//    }

    open func excludedIdentifiers(items: [YADLItem], jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> [String] {
        
        guard let yadlSpotDescriptor = YADLSpotDescriptor(json: jsonObject),
            let filterKey = yadlSpotDescriptor.filterKey,
            let stateHelper = helper.stateHelper,
            let includedValues = stateHelper.valueInState(forKey: filterKey) as? [String],
            includedValues.count > 0 else {
                return []
        }
        
        return items.map({$0.identifier}).filter({ identifier in
            return !includedValues.contains(where: { (includedValue) -> Bool in
                return includedValue == identifier
            })
        })
    }
    
    open func imageChoice(_ item: YADLItem) -> ORKImageChoice? {
        guard let image = UIImage(named: item.imageTitle)
            else {
                assertionFailure("Cannot find image named \(item.imageTitle))")
                return nil
        }
        return ORKImageChoice(normalImage: image, selectedImage: nil, text: item.description, value: item.identifier as NSCoding & NSCopying & NSObjectProtocol)
    }
    
    open func generateChoices(items: [YADLItem], shouldShuffle: Bool = false) -> [ORKImageChoice] {
        
        if shouldShuffle {
            return items.shuffled().flatMap({self.imageChoice($0)})
        }
        else {
            return items.flatMap({self.imageChoice($0)})
        }
    }
    
    
    
    open func generateSteps(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> [ORKStep]? {
        
        guard let yadlSpotDescriptor = YADLSpotDescriptor(json: jsonObject) else {
            return nil
        }
        
        let imageChoices = self.generateChoices(items: yadlSpotDescriptor.items)
        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)

        let excludedIdentifiers = self.excludedIdentifiers(items: yadlSpotDescriptor.items, jsonObject: jsonObject, helper: helper)
        let options = RKXMultipleImageSelectionSurveyOptions(json: jsonObject)
        
        let spotAssessmentStep = YADLSpotAssessmentStep(
            identifier: yadlSpotDescriptor.identifier,
            title: yadlSpotDescriptor.title,
            answerFormat: answerFormat,
            options: options,
            excludedIdentifiers: excludedIdentifiers
        )
        
        spotAssessmentStep.isOptional = yadlSpotDescriptor.optional
        return [spotAssessmentStep]
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
}
