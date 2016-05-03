//
//  YADLSpotAssessmentTask.swift
//  YADL
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

public class YADLSpotAssessmentTask: ORKOrderedTask {
    
//    public class func spotAssessmentResults(taskResult: ORKTaskResult) -> [ORKChoiceQuestionResult]? {
//        if let stepResults = taskResult.results as? [ORKStepResult]
//        {
//            return stepResults.map { stepResult in
//                return stepResult.firstResult as? ORKChoiceQuestionResult
//                }
//                .flatMap{ $0 }
//        }
//        else { return nil }
//    }
    
    //note that this is a Class method, the steps array needs to be passed to the init function
    class func loadStepsFromJSON(jsonParser: RKXJSONParser, activityIdentifiers: [String]?) -> [ORKStep]? {
        
        
        guard let prompt = jsonParser.YADLSpotAssessmentPrompt
            else {
                fatalError("Missing or Malformed Prompt")
        }
        
        guard let identifier = jsonParser.YADLSpotAssessmentIdentifier
            else {
                fatalError("Missing or Malformed Identifier")
        }
        
        guard let activities = jsonParser.activities
            else {
                fatalError("Missing or Malformed Activities")
        }
        
        guard let summary = jsonParser.YADLSpotAssessmentSummary
            else {
                fatalError("Missing or Malformed Summary")
        }
        
        guard let noActivitiesSummary = jsonParser.YADLSpotAssessmentNoActivitiesSummary
            else {
                fatalError("Missing or Malformed No Activities Summary")
        }
        
        let imageChoices = activities
        .filter { activity in
            if let identifiers = activityIdentifiers {
                return identifiers.contains(activity.identifier)
            }
            else {
                return true
            }
        }
        .map { activity in
            
            return ORKImageChoice(normalImage: activity.image, selectedImage: nil, text: activity.description, value: activity.identifier)
            
        }
        
        if (imageChoices.count == 0) {
            let summaryStep = ORKInstructionStep(identifier: kYADLSpotAssessmentSummaryID)
            summaryStep.title = noActivitiesSummary.title
            summaryStep.text = noActivitiesSummary.text
            return [summaryStep]
        }
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormatWithImageChoices(imageChoices)
        
        let spotAssessmentStep = YADLSpotAssessmentStep(identifier: identifier, title: prompt, answerFormat: answerFormat)
  
        let summaryStep = ORKInstructionStep(identifier: kYADLSpotAssessmentSummaryID)
        summaryStep.title = summary.title
        summaryStep.text = summary.text
        
        return [
            spotAssessmentStep,
            summaryStep
        ]
    }
    
    var submitButtonColor: UIColor?
    var nothingToReportButtonColor: UIColor?
    var activityCellSelectedColor:UIColor?
    var activityCellSelectedOverlayImage: UIImage?
    var activityCollectionViewBackgroundColor: UIColor?
    var activitiesPerRow: Int?
    var activityMinSpacing: CGFloat?
    
    func configureOptions(jsonParser: RKXJSONParser) {
        self.submitButtonColor = jsonParser.YADLSpotAssessmentSubmitButtonColor
        self.nothingToReportButtonColor = jsonParser.YADLSpotAssessmentNothingToReportButtonColor
        self.activityCellSelectedColor = jsonParser.YADLSpotAssessmentActivityCellSelectedColor
        self.activityCellSelectedOverlayImage = jsonParser.YADLSpotAssessmentActivityCellSelectedOverlayImage
        self.activityCollectionViewBackgroundColor = jsonParser.YADLSpotAssessmentActivityCollectionViewBackgroundColor
        self.activitiesPerRow = jsonParser.YADLSpotAssessmentActivitiesPerRow
        self.activityMinSpacing = jsonParser.YADLSpotAssessmentActivityMinSpacing
    }
    
    convenience public init(identifier: String, propertiesFileName: String, activityIdentifiers: [String]? = nil) {

        guard let filePath = NSBundle.mainBundle().pathForResource(propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to location file with YADL Spot Assessment Section in main bundle")
        }
        
        guard let fileContent = NSData(contentsOfFile: filePath)
            else {
                fatalError("Unable to create NSData with file content (YADL Spot Assessment data)")
        }
        
        let spotAssessmentParameters = try! NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
        
        self.init(identifier: identifier, json: spotAssessmentParameters, activityIdentifiers: activityIdentifiers)
    }
    
    convenience public init(identifier: String, json: AnyObject, activityIdentifiers: [String]? = nil) {
        
        let jsonParser = RKXJSONParser(json: json)
        let steps = YADLSpotAssessmentTask.loadStepsFromJSON(jsonParser, activityIdentifiers: activityIdentifiers)
        
        self.init(identifier: identifier, steps: steps)
        self.configureOptions(jsonParser)
    }
    
    override init(identifier: String, steps: [ORKStep]?) {
        super.init(identifier: identifier, steps: steps)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
