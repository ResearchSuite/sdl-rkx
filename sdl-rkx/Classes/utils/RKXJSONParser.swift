//
//  RKXJSONParser.swift
//  SDK-RKX
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import Foundation
import UIKit

//let kDefaultChoiceColor: UIColor = UIColor.blueColor()
//
//let kYADLFullAssessmentTag = "YADLFull"
//let kYADLSpotAssessmentTag = "YADLSpot"
//
//
//
//let kActivitiesTag = "activities"
//let kActivityImageTitleTag = "imageTitle"
//let kActivityDescriptionTag = "description"
//let kActivityIdentifierTag = "identifier"
//
//
//let kYADLFullAssessmentSummaryID = "YADLFullSummaryStep"
//let kYADLSpotAssessmentSummaryID = "YADLSpotSummaryStep"

//public struct ItemStruct {
//    var image: UIImage
//    var description: String
//    var identifier: String
//}
//
//public struct PAMItemStruct {
//    var images: [UIImage]
//    var value: [String: AnyObject]
//}
//
//



//class RKXJSONParser: NSObject {
////    class func loadChoicesFromJSON(choicesParameters: [AnyObject]) -> [ChoiceStruct]? {
////        
////        return choicesParameters.map { choiceParameter in
////            guard let choiceDict = choiceParameter as? [String: AnyObject],
////                let text = choiceDict[kChoiceTextTag] as? String,
////                let value = choiceDict[kChoiceValueTag] as? protocol<NSCoding, NSCopying, NSObjectProtocol>
////                else {
////                    fatalError("Malformed Choice: \(choiceParameter)")
////            }
////            let color: UIColor? = {
////                if let colorString = choiceDict[kChoiceColorTag] as? String {
////                    return UIColor(hexString: colorString)
////                }
////                else {
////                    return nil
////                }
////            }()
////            return ChoiceStruct(text: text, value: value, color: color)
////        }
////    }
////    
////    class func loadActivitiesFromJSON(activitiesParameters: [AnyObject]) -> [RKXActivityDescriptor]? {
////        return activitiesParameters.map { activityParameter in
////            
////            guard let activityDict = activityParameter as? [String: AnyObject],
////                let imageTitle = activityDict[kActivityImageTitleTag] as? String,
////                let description = activityDict[kActivityDescriptionTag] as? String,
////                let identifier = activityDict[kActivityIdentifierTag] as? String
////                else {
////                    fatalError("Malformed Activity: \(activityParameter)")
////            }
////            var activityDescriptor = RKXActivityDescriptor()
////            activityDescriptor.identifier = identifier
////            activityDescriptor.activityDescription = description
////            activityDescriptor.imageTitle = imageTitle
////            return activityDescriptor
////        }
////    }
////    
////    class func loadPAMItemsFromJSON(itemParameters: [AnyObject]) -> [RKXAffectDescriptor]? {
////        return nil
////    }
////    
////    class func loadPAMItemsFromJSON(itemParameters: [AnyObject]) -> [RKXAffectDescriptor]? {
////        return itemParameters.map { itemParameters in
////            
////            guard let itemDict = itemParameters as? [String: AnyObject],
////                let imageTitles = itemDict["imageTitles"] as? [String],
////                let value = itemDict["value"] as? [String: AnyObject]
////                else {
////                    fatalError("Malformed PAM Item: \(itemParameters)")
////            }
////            let affectDescriptor = RKXAffectDescriptor()
////            affectDescriptor.imageTitles = imageTitles
////            affectDescriptor.value = value
////            return affectDescriptor
////            
//////            let images: [UIImage] = imageTitles.map { imageTitle in
////////                guard let image: UIImage = UIImage(named: imageTitle)
//////                guard let image: UIImage = UIImage(named: imageTitle, inBundle: bundle, compatibleWithTraitCollection: nil)
//////                    else {
//////                        fatalError("Image not found: \(imageTitle)")
//////                }
//////                return image
//////            }
//////            
//////            return PAMItemStruct(images: images, value: value)
////        }
////    }
////    
////    class func loadSummaryFromJSON(summaryParameters: AnyObject) -> SummaryStruct? {
////        return nil
////    }
////
////    class func loadSummaryFromJSON(summaryParameters: AnyObject) -> SummaryStruct? {
////        
////        guard let summaryDict = summaryParameters as? [String: AnyObject],
////            let title = summaryDict[kSummaryTitleTag] as? String,
////            let text = summaryDict[kSummaryTextTag] as? String,
////            let identifier = summaryDict[kSummaryTextTag] as? String
////            else {
////                fatalError("Malformed Summary: \(summaryParameters)")
////        }
////        
////        return SummaryStruct(identifier: identifier, title: title, text: text)
////    }
//    
//    var YADLFullAssessment: [String: AnyObject]? {
//        return self.json.objectForKey(kYADLFullAssessmentTag) as? [String: AnyObject]
//    }
//    
//    var YADLFullAssessmentPrompt: String? {
//        return self.YADLFullAssessment?[kPromptTag] as? String
//    }
//    
//    var YADLFullAssessmentIdentifier: String? {
//        return self.YADLFullAssessment?[kIdentifierTag] as? String
//    }
//    
//    var YADLFullAssessmentSummary: SummaryStruct? {
//        guard let summaryParameters = self.YADLFullAssessment?[kSummaryTag]
//            else {
//                return nil
//        }
//        
//        return RKXJSONParser.loadSummaryFromJSON(summaryParameters)
//    }
//    
//    var YADLFullAssessmentNoActivitiesSummary: SummaryStruct? {
//        guard let summaryParameters = self.YADLFullAssessment?[kSummaryNoActivitiesTag]
//            else {
//                return nil
//        }
//        
//        return RKXJSONParser.loadSummaryFromJSON(summaryParameters)
//    }
//    
//    var YADLSpotAssessment: [String: AnyObject]? {
//        return self.json.objectForKey(kYADLSpotAssessmentTag) as? [String: AnyObject]
//    }
//    
//    var YADLSpotAssessmentPrompt: String? {
//        return self.YADLSpotAssessment?[kPromptTag] as? String
//    }
//    
//    var YADLSpotAssessmentIdentifier: String? {
//        return self.YADLSpotAssessment?[kIdentifierTag] as? String
//    }
//    
//    var YADLSpotAssessmentSummary: SummaryStruct? {
//        guard let summaryParameters = self.YADLSpotAssessment?[kSummaryTag]
//            else {
//                return nil
//        }
//        
//        return RKXJSONParser.loadSummaryFromJSON(summaryParameters)
//    }
//    
//    var YADLSpotAssessmentNoActivitiesSummary: SummaryStruct? {
//        guard let summaryParameters = self.YADLSpotAssessment?[kSummaryNoActivitiesTag]
//            else {
//                return nil
//        }
//        
//        return RKXJSONParser.loadSummaryFromJSON(summaryParameters)
//    }
//    
//    var YADLFullAssessmentChoices: [ChoiceStruct]? {
//        guard let choicesParameters = self.YADLFullAssessment?[kChoicesTag] as? [AnyObject]
//            else {
//                return nil
//        }
//        
//        return RKXJSONParser.loadChoicesFromJSON(choicesParameters)
//    }
//    
//    var activities: [RKXActivityDescriptor]? {
//        guard let activitiesParameters = self.json.objectForKey(kActivitiesTag) as? [AnyObject]
//            else {
//                return nil
//        }
//        
//        return RKXJSONParser.loadActivitiesFromJSON(activitiesParameters)
//    }
//    
//    
//    var PAM: [String:AnyObject]? {
//        guard let pam = self.json.objectForKey("PAM") as? [String:AnyObject]
//            else {
//                return nil
//        }
//        return pam
//    }
//    
//    var PAMItems: [RKXAffectDescriptor]? {
//        guard let itemParameters = self.PAM?["items"] as? [AnyObject]
//            else {
//                return nil
//        }
//        
//        return RKXJSONParser.loadPAMItemsFromJSON(itemParameters)
//    }
//    
//    var PAMPrompt: String? {
//        return self.PAM?[kPromptTag] as? String
//    }
//    
//    var PAMIdentifier: String? {
//        return self.PAM?[kIdentifierTag] as? String
//    }
//    
//    var PAMSummary: SummaryStruct? {
//        guard let summaryParameters = self.PAM?[kSummaryTag]
//            else {
//                return nil
//        }
//        
//        return RKXJSONParser.loadSummaryFromJSON(summaryParameters)
//    }
//    
//    var PAMNoActivitiesSummary: SummaryStruct? {
//        guard let summaryParameters = self.PAM?[kSummaryNoActivitiesTag]
//            else {
//                return nil
//        }
//        
//        return RKXJSONParser.loadSummaryFromJSON(summaryParameters)
//    }
//    
//    
//    var YADLSpotAssessmentOptions: [String: AnyObject]? {
//        return self.YADLSpotAssessment?[kOptionsTag] as? [String: AnyObject]
//    }
//    
//    func colorForYADLSpotAssessmentKey(key: String) -> UIColor? {
//        if let colorString = self.YADLSpotAssessmentOptions?[key] as? String {
//            return UIColor(hexString: colorString)
//        }
//        else { return nil }
//    }
//
//    var YADLSpotAssessmentSubmitButtonColor: UIColor? {
//        return self.colorForYADLSpotAssessmentKey(kOptionsSubmitButtonColorTag)
//    }
//    
//    var YADLSpotAssessmentNothingToReportButtonColor: UIColor? {
//        return self.colorForYADLSpotAssessmentKey(kOptionsNothingToReportButtonColorTag)
//    }
//    
//    var YADLSpotAssessmentActivityCellSelectedColor:UIColor? {
//        return self.colorForYADLSpotAssessmentKey(kOptionsActivityCellSelectedColorTag)
//    }
//    
//    var YADLSpotAssessmentActivityCellSelectedOverlayImage: UIImage? {
//        if let imageString = self.YADLSpotAssessmentOptions?[kOptionsActivityCellSelectedOverlayImageTitleTag] as? String {
//            return UIImage(named: imageString)
//        }
//        else { return nil }
//    }
//
//    var YADLSpotAssessmentActivityCollectionViewBackgroundColor: UIColor? {
//        return self.colorForYADLSpotAssessmentKey(kOptionsActivityCollectionViewBackgroundColorTag)
//    }
//    
//    var YADLSpotAssessmentActivitiesPerRow: Int? {
//        return self.YADLSpotAssessmentOptions?[kOptionsActivitiesPerRowTag] as? Int
//    }
//    
//    var YADLSpotAssessmentActivityMinSpacing: CGFloat? {
//        return self.YADLSpotAssessmentOptions?[kOptionsActivityMinSpacingTag] as? CGFloat
//    }
//
//    let json: AnyObject!
//    init(json: AnyObject) {
//        self.json = json
//        super.init()
//        
//    }
//}


