//
//  RKXAssessmentDescriptor.swift
//  sdlrkx
//
//  Created by James Kizer on 5/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import Gloss

let kPromptTag = "prompt"
let kIdentifierTag = "identifier"

let kSummaryTag = "summary"
let kSummaryNoItemsTag = "noItemsSummary"
let kSummaryTitleTag = "title"
let kSummaryTextTag = "text"

let kOptionsTag = "options"

let kChoicesTag = "choices"
let kChoiceTextTag = "text"
let kChoiceValueTag = "value"
let kChoiceColorTag = "color"

let kOptionsSomethingSelectedButtonColorTag = "somethingSelectedButtonColor"
let kOptionsNothingSelectedButtonColorTag = "nothingSelectedButtonColor"
let kOptionsItemCellSelectedColorTag = "itemCellSelectedColor"
let kOptionsItemCellTextBackgroundColorTag = "itemCellTextBackgroundColor"
let kOptionsItemCollectionViewBackgroundColorTag = "itemCollectionViewBackgroundColor"
let kOptionsItemCellSelectedOverlayImageTitleTag = "itemCellSelectedOverlayImageTitle"
let kOptionsItemsPerRowTag = "itemsPerRow"
let kOptionsItemMinSpacingTag = "itemMinSpacing"
let kOptionsMaximumSelectedNumberOfItems = "maximumSelectedNumberOfItems"
let kOptionsOptional = "optional"

func getStringForKeyStrings(_ keys: [String], optionsDictionary: [String: AnyObject]) -> String? {
    return keys.map { key in
        return optionsDictionary[key] as? String
    }.flatMap { $0 }.first
}

func colorForOptionsAndKey(_ options: [String: AnyObject], key: String) -> UIColor? {
    if let colorString = options[key] as? String {
        return UIColor(hexString: colorString)
    }
    else { return nil }
}

open class RKXMultipleImageSelectionSurveyOptions: NSObject, Decodable {
    public var somethingSelectedButtonColor: UIColor?
    public var nothingSelectedButtonColor: UIColor?
    public var itemCellSelectedColor:UIColor?
    public var itemCellSelectedOverlayImage: UIImage?
    public var itemCellTextBackgroundColor: UIColor?
    public var itemCollectionViewBackgroundColor: UIColor?
    public var itemsPerRow: Int?
    public var itemMinSpacing: CGFloat?
    public var maximumSelectedNumberOfItems: Int?
    
    public init(optionsDictionary: [String: AnyObject]?) {
        guard let optionsDictionary = optionsDictionary
            else {
                return
        }
        self.somethingSelectedButtonColor = colorForOptionsAndKey(optionsDictionary, key: kOptionsSomethingSelectedButtonColorTag)
        self.nothingSelectedButtonColor = colorForOptionsAndKey(optionsDictionary, key: kOptionsNothingSelectedButtonColorTag)
        self.itemCellSelectedColor = colorForOptionsAndKey(optionsDictionary, key: kOptionsItemCellSelectedColorTag)
        self.itemCollectionViewBackgroundColor = colorForOptionsAndKey(optionsDictionary, key: kOptionsItemCollectionViewBackgroundColorTag)
        self.itemCellTextBackgroundColor = colorForOptionsAndKey(optionsDictionary, key: kOptionsItemCellTextBackgroundColorTag)
        self.itemCellSelectedOverlayImage = {
            if let imageString = optionsDictionary[kOptionsItemCellSelectedOverlayImageTitleTag] as? String {
                return UIImage(named: imageString)
            }
            else { return nil }
            }()
        self.itemsPerRow = optionsDictionary[kOptionsItemsPerRowTag] as? Int
        self.itemMinSpacing = optionsDictionary[kOptionsItemMinSpacingTag] as? CGFloat
        self.maximumSelectedNumberOfItems = optionsDictionary[kOptionsMaximumSelectedNumberOfItems] as? Int
    }
    
    override public init() {
        super.init()
    }
    
    required public init?(json: JSON) {
        
        let hexColorConverter: (String?) -> UIColor? = { hexString in
            
            if let hexString = hexString {
                return UIColor(hexString: hexString)
            }
            else {
                return nil
            }
            
        }
        
        self.somethingSelectedButtonColor = hexColorConverter(kOptionsSomethingSelectedButtonColorTag <~~ json)
        self.nothingSelectedButtonColor = hexColorConverter(kOptionsNothingSelectedButtonColorTag <~~ json)
        self.itemCellSelectedColor = hexColorConverter(kOptionsItemCellSelectedColorTag <~~ json)
        self.itemCollectionViewBackgroundColor = hexColorConverter(kOptionsItemCollectionViewBackgroundColorTag <~~ json)
        self.itemCellTextBackgroundColor = hexColorConverter(kOptionsItemCellTextBackgroundColorTag <~~ json)
        self.itemCellSelectedOverlayImage = {
            if let imageString: String = kOptionsItemCellSelectedOverlayImageTitleTag <~~ json {
                return UIImage(named: imageString)
            }
            else { return nil }
        }()
        self.itemsPerRow = kOptionsItemsPerRowTag <~~ json
        self.itemMinSpacing = kOptionsItemMinSpacingTag <~~ json
        self.maximumSelectedNumberOfItems = kOptionsMaximumSelectedNumberOfItems <~~ json
        
    }
    
    
}

class RKXChoiceDescriptor: NSObject {
    var text: String!
    var value: (NSCoding & NSCopying & NSObjectProtocol)?
    var color: UIColor?
    
    init?(choiceDictionary: [String: AnyObject]?) {
        super.init()
        guard let choiceDictionary = choiceDictionary,
            let text = choiceDictionary[kChoiceTextTag] as? String,
            let value = choiceDictionary[kChoiceValueTag] as? NSCoding & NSCopying & NSObjectProtocol
            else {
                return nil
        }
        if let colorString = choiceDictionary[kChoiceColorTag] as? String {
            self.color = UIColor(hexString: colorString)
        }
        self.text = text
        self.value = value
    }
}

class RKXSummaryDescriptor: NSObject {
    var identifier: String!
    var title: String!
    var text: String!
    
    init?(summaryDictionary: [String: AnyObject]?) {
        super.init()
        guard let summaryDictionary = summaryDictionary,
            let identifier = summaryDictionary[kIdentifierTag] as? String,
            let title = summaryDictionary[kSummaryTitleTag] as? String,
            let text = summaryDictionary[kSummaryTextTag] as? String
            else {
                return nil
        }
        self.identifier = identifier
        self.title = title
        self.text = text
    }
}

class RKXAssessmentDescriptor: NSObject {
    var identifier: String!
    var prompt: String?
    var summary: RKXSummaryDescriptor?
    var noItemsSummary: RKXSummaryDescriptor?
    
    init(assessmentDictionary: [String:AnyObject]) {
        super.init()
        self.identifier = assessmentDictionary[kIdentifierTag] as? String
        self.prompt = assessmentDictionary[kPromptTag] as? String
        self.summary = RKXSummaryDescriptor(summaryDictionary: assessmentDictionary[kSummaryTag] as? [String: AnyObject])
        self.noItemsSummary = RKXSummaryDescriptor(summaryDictionary: assessmentDictionary[kSummaryNoItemsTag] as? [String: AnyObject])
    }
}

class YADLFullAssessmentDescriptor: RKXAssessmentDescriptor {
    var choices: [RKXChoiceDescriptor]?
    
    override init(assessmentDictionary: [String:AnyObject]) {
        super.init(assessmentDictionary: assessmentDictionary)
        if let choiceArray:[[String:AnyObject]] = (assessmentDictionary[kChoicesTag] as? [[String:AnyObject]]) {
            self.choices = choiceArray.map { choiceDictionary in
                return RKXChoiceDescriptor(choiceDictionary: choiceDictionary)
                }.flatMap { $0 }
        }
    }
}

class RKXMultipleImageSelectionSurveyDescriptor: RKXAssessmentDescriptor {
    var options: RKXMultipleImageSelectionSurveyOptions?
    override init(assessmentDictionary: [String:AnyObject]) {
        super.init(assessmentDictionary: assessmentDictionary)
        self.options = RKXMultipleImageSelectionSurveyOptions(optionsDictionary: assessmentDictionary[kOptionsTag] as? [String: AnyObject])
    }
}
