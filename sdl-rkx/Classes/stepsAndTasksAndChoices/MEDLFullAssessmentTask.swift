//
//  MEDLFullAssessmentTask.swift
//  Pods
//
//  Created by James Kizer on 5/5/16.
//
//

import UIKit
import ResearchKit



class MEDLFullAssessmentTask: RKXMultipleImageSelectionSurveyTask {

    convenience public init(identifier: String, propertiesFileName: String) {
        
        guard let filePath = NSBundle.mainBundle().pathForResource(propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to locate file \(propertiesFileName)")
        }
        
        guard let fileContent = NSData(contentsOfFile: filePath)
            else {
                fatalError("Unable to create NSData with file content (YADL Spot Assessment data)")
        }
        
        let json = try! NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
        
        self.init(identifier: identifier, json: json)
    }
    
    convenience public init(identifier: String, json: AnyObject) {
        
//        let jsonParser = RKXJSONParser(json: json)
//        let steps = YADLSpotAssessmentTask.loadStepsFromJSON(jsonParser)
        let steps: [ORKStep]? = nil
        
        self.init(identifier: identifier, steps: steps)
//        self.configureOptions(jsonParser)
    }
    
    override init(identifier: String, steps: [ORKStep]?) {
        super.init(identifier: identifier, steps: steps)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
