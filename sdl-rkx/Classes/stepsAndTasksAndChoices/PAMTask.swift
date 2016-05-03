//
//  PAMTask.swift
//  Pods
//
//  Created by James Kizer on 5/2/16.
//
//

import UIKit
import ResearchKit

class PAMTask: ORKOrderedTask {
    
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
