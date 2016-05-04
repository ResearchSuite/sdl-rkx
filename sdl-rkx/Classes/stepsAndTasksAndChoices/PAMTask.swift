//
//  PAMTask.swift
//  Pods
//
//  Created by James Kizer on 5/3/16.
//
//

import UIKit
import ResearchKit

public class PAMTask: RXMultipleImageSelectionSurveyTask {

    class func loadStepsFromJSON(jsonParser: RKXJSONParser) -> [ORKStep]? {
        
        
        guard let prompt = jsonParser.PAMPrompt
            else {
                fatalError("Missing or Malformed Prompt")
        }
        
        guard let identifier = jsonParser.PAMIdentifier
            else {
                fatalError("Missing or Malformed Identifier")
        }
        
        guard let items = jsonParser.PAMItems
            else {
                fatalError("Missing or Malformed Items")
        }
        
        guard let summary = jsonParser.PAMSummary
            else {
                fatalError("Missing or Malformed Summary")
        }
        
        guard let noActivitiesSummary = jsonParser.PAMNoActivitiesSummary
            else {
                fatalError("Missing or Malformed No Activities Summary")
        }
        
        let imageChoices = items.map { item in
                
                return PAMImageChoice(images: item.images, value: item.value)
                
        }
        
        if (imageChoices.count == 0) {
            let summaryStep = ORKInstructionStep(identifier: kYADLSpotAssessmentSummaryID)
            summaryStep.title = noActivitiesSummary.title
            summaryStep.text = noActivitiesSummary.text
            return [summaryStep]
        }
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormatWithImageChoices(imageChoices)
        
        let spotAssessmentStep = PAMStep(identifier: identifier, title: prompt, answerFormat: answerFormat)
        
        let summaryStep = ORKInstructionStep(identifier: kYADLSpotAssessmentSummaryID)
        summaryStep.title = summary.title
        summaryStep.text = summary.text
        
        return [
            spotAssessmentStep,
            summaryStep
        ]
    }

    func configureOptions(jsonParser: RKXJSONParser) {
        self.somethingSelectedButtonColor = UIColor.blueColor()
        self.nothingSelectedButtonColor = UIColor.blueColor()
        self.itemCellSelectedColor = UIColor.clearColor()
        self.itemsPerRow = 4
        self.itemMinSpacing = 4
//        self.somethingSelectedButtonColor = jsonParser.YADLSpotAssessmentSubmitButtonColor
//        self.nothingSelectedButtonColor = jsonParser.YADLSpotAssessmentNothingToReportButtonColor
//        self.itemCellSelectedColor = jsonParser.YADLSpotAssessmentActivityCellSelectedColor
//        self.itemCellSelectedOverlayImage = jsonParser.YADLSpotAssessmentActivityCellSelectedOverlayImage
//        self.itemCollectionViewBackgroundColor = jsonParser.YADLSpotAssessmentActivityCollectionViewBackgroundColor
//        self.itemsPerRow = jsonParser.YADLSpotAssessmentActivitiesPerRow
//        self.itemMinSpacing = jsonParser.YADLSpotAssessmentActivityMinSpacing
    }
    
    convenience public init(identifier: String, propertiesFileName: String) {
        
        guard let filePath = NSBundle.mainBundle().pathForResource(propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to location file with YADL Spot Assessment Section in main bundle")
        }
        
        guard let fileContent = NSData(contentsOfFile: filePath)
            else {
                fatalError("Unable to create NSData with file content (YADL Spot Assessment data)")
        }
        
        let spotAssessmentParameters = try! NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
        
        self.init(identifier: identifier, json: spotAssessmentParameters)
    }
    
    convenience public init(identifier: String, json: AnyObject) {
        
        let jsonParser = RKXJSONParser(json: json)
        let steps = PAMTask.loadStepsFromJSON(jsonParser)
        
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
