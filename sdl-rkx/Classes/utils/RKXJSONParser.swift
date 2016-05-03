//
//  RKXJSONParser.swift
//  SDK-RKX
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import Foundation
import UIKit

let kDefaultChoiceColor: UIColor = UIColor.blueColor()

let kYADLFullAssessmentTag = "YADLFull"
let kYADLSpotAssessmentTag = "YADLSpot"

let kPromptTag = "prompt"
let kIdentifierTag = "identifier"

let kChoicesTag = "choices"
let kChoiceTextTag = "text"
let kChoiceValueTag = "value"
let kChoiceColorTag = "color"

let kActivitiesTag = "activities"
let kActivityImageTitleTag = "imageTitle"
let kActivityDescriptionTag = "description"
let kActivityIdentifierTag = "identifier"

let kSummaryTag = "summary"
let kSummaryNoActivitiesTag = "noActivitiesSummary"
let kSummaryTitleTag = "title"
let kSummaryTextTag = "text"

let kOptionsTag = "options"
let kOptionsSubmitButtonColorTag = "submitButtonColor"
let kOptionsNothingToReportButtonColorTag = "nothingToReportButtonColor"
let kOptionsActivityCellSelectedColorTag = "activityCellSelectedColor"
let kOptionsActivityCollectionViewBackgroundColorTag = "activityCollectionViewBackgroundColor"
let kOptionsActivityCellSelectedOverlayImageTitleTag = "activityCellSelectedOverlayImageTitle"
let kOptionsActivitiesPerRowTag = "activitiesPerRow"
let kOptionsActivityMinSpacingTag = "activityMinSpacing"

let kYADLFullAssessmentSummaryID = "YADLFullSummaryStep"
let kYADLSpotAssessmentSummaryID = "YADLSpotSummaryStep"

public struct ItemStruct {
    var image: UIImage
    var description: String
    var identifier: String
}

public struct ChoiceStruct {
    var text: String
    var value: protocol<NSCoding, NSCopying, NSObjectProtocol>
    var color: UIColor?
}

public struct SummaryStruct {
    var identifier: String
    var title: String
    var text: String
}

class RKXJSONParser: NSObject {
    class func loadChoicesFromJSON(choicesParameters: [AnyObject]) -> [ChoiceStruct]? {
        
        return choicesParameters.map { choiceParameter in
            guard let choiceDict = choiceParameter as? [String: AnyObject],
                let text = choiceDict[kChoiceTextTag] as? String,
                let value = choiceDict[kChoiceValueTag] as? protocol<NSCoding, NSCopying, NSObjectProtocol>
                else {
                    fatalError("Malformed Choice: \(choiceParameter)")
            }
            let color: UIColor? = {
                if let colorString = choiceDict[kChoiceColorTag] as? String {
                    return UIColor(hexString: colorString)
                }
                else {
                    return nil
                }
            }()
            return ChoiceStruct(text: text, value: value, color: color)
        }
    }
    
    class func loadActivitiesFromJSON(activitiesParameters: [AnyObject]) -> [ItemStruct]? {
        return activitiesParameters.map { activityParameter in
            
            guard let activityDict = activityParameter as? [String: AnyObject],
                let imageTitle = activityDict[kActivityImageTitleTag] as? String,
                let image = UIImage(named: imageTitle),
                let description = activityDict[kActivityDescriptionTag] as? String,
                let identifier = activityDict[kActivityIdentifierTag] as? String
                else {
                    fatalError("Malformed Activity: \(activityParameter)")
            }
            return ItemStruct(image: image, description: description, identifier: identifier)
        }
    }
    
    class func loadSummaryFromJSON(summaryParameters: AnyObject) -> SummaryStruct? {
        
        guard let summaryDict = summaryParameters as? [String: AnyObject],
            let title = summaryDict[kSummaryTitleTag] as? String,
            let text = summaryDict[kSummaryTextTag] as? String,
            let identifier = summaryDict[kSummaryTextTag] as? String
            else {
                fatalError("Malformed Summary: \(summaryParameters)")
        }
        
        return SummaryStruct(identifier: identifier, title: title, text: text)
    }
    
    var YADLFullAssessment: [String: AnyObject]? {
        return self.json.objectForKey(kYADLFullAssessmentTag) as? [String: AnyObject]
    }
    
    var YADLFullAssessmentPrompt: String? {
        return self.YADLFullAssessment?[kPromptTag] as? String
    }
    
    var YADLFullAssessmentIdentifier: String? {
        return self.YADLFullAssessment?[kIdentifierTag] as? String
    }
    
    var YADLFullAssessmentSummary: SummaryStruct? {
        guard let summaryParameters = self.YADLFullAssessment?[kSummaryTag]
            else {
                return nil
        }
        
        return RKXJSONParser.loadSummaryFromJSON(summaryParameters)
    }
    
    var YADLFullAssessmentNoActivitiesSummary: SummaryStruct? {
        guard let summaryParameters = self.YADLFullAssessment?[kSummaryNoActivitiesTag]
            else {
                return nil
        }
        
        return RKXJSONParser.loadSummaryFromJSON(summaryParameters)
    }
    
    var YADLSpotAssessment: [String: AnyObject]? {
        return self.json.objectForKey(kYADLSpotAssessmentTag) as? [String: AnyObject]
    }
    
    var YADLSpotAssessmentPrompt: String? {
        return self.YADLSpotAssessment?[kPromptTag] as? String
    }
    
    var YADLSpotAssessmentIdentifier: String? {
        return self.YADLSpotAssessment?[kIdentifierTag] as? String
    }
    
    var YADLSpotAssessmentSummary: SummaryStruct? {
        guard let summaryParameters = self.YADLSpotAssessment?[kSummaryTag]
            else {
                return nil
        }
        
        return RKXJSONParser.loadSummaryFromJSON(summaryParameters)
    }
    
    var YADLSpotAssessmentNoActivitiesSummary: SummaryStruct? {
        guard let summaryParameters = self.YADLSpotAssessment?[kSummaryNoActivitiesTag]
            else {
                return nil
        }
        
        return RKXJSONParser.loadSummaryFromJSON(summaryParameters)
    }
    
    var YADLFullAssessmentChoices: [ChoiceStruct]? {
        guard let choicesParameters = self.YADLFullAssessment?[kChoicesTag] as? [AnyObject]
            else {
                return nil
        }
        
        return RKXJSONParser.loadChoicesFromJSON(choicesParameters)
    }
    
    var activities: [ItemStruct]? {
        guard let activitiesParameters = self.json.objectForKey(kActivitiesTag) as? [AnyObject]
            else {
                return nil
        }
        
        return RKXJSONParser.loadActivitiesFromJSON(activitiesParameters)
    }
    
    var YADLSpotAssessmentOptions: [String: AnyObject]? {
        return self.YADLSpotAssessment?[kOptionsTag] as? [String: AnyObject]
    }
    
    func colorForYADLSpotAssessmentKey(key: String) -> UIColor? {
        if let colorString = self.YADLSpotAssessmentOptions?[key] as? String {
            return UIColor(hexString: colorString)
        }
        else { return nil }
    }
    
    var YADLSpotAssessmentSubmitButtonColor: UIColor? {
        return self.colorForYADLSpotAssessmentKey(kOptionsSubmitButtonColorTag)
    }
    
    var YADLSpotAssessmentNothingToReportButtonColor: UIColor? {
        return self.colorForYADLSpotAssessmentKey(kOptionsNothingToReportButtonColorTag)
    }
    
    var YADLSpotAssessmentActivityCellSelectedColor:UIColor? {
        return self.colorForYADLSpotAssessmentKey(kOptionsActivityCellSelectedColorTag)
    }
    
    var YADLSpotAssessmentActivityCellSelectedOverlayImage: UIImage? {
        if let imageString = self.YADLSpotAssessmentOptions?[kOptionsActivityCellSelectedOverlayImageTitleTag] as? String {
            return UIImage(named: imageString)
        }
        else { return nil }
    }
    
    var YADLSpotAssessmentActivityCollectionViewBackgroundColor: UIColor? {
        return self.colorForYADLSpotAssessmentKey(kOptionsActivityCollectionViewBackgroundColorTag)
    }
    
    var YADLSpotAssessmentActivitiesPerRow: Int? {
        return self.YADLSpotAssessmentOptions?[kOptionsActivitiesPerRowTag] as? Int
    }
    
    var YADLSpotAssessmentActivityMinSpacing: CGFloat? {
        return self.YADLSpotAssessmentOptions?[kOptionsActivityMinSpacingTag] as? CGFloat
    }

    let json: AnyObject!
    init(json: AnyObject) {
        self.json = json
        super.init()
        
    }
}


