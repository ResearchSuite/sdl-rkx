//
//  RKXItemDescriptor.swift
//  sdlrkx
//
//  Created by James Kizer on 5/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit



open class RKXItemDescriptor: NSObject {
    var identifier: String!
    
    init(itemDictionary: [String: AnyObject]) {
        super.init()
        self.identifier = itemDictionary["identifier"] as? String
    }
}

open class RKXImageDescriptor: RKXItemDescriptor {
    
    class func imageChoiceForDescriptor(_ bundle: Bundle = Bundle.main) -> ((RKXImageDescriptor) -> (ORKImageChoice?)) {
        return { imageDescriptor in
            return imageDescriptor.imageChoice(bundle)
        }
    }
    
    func imageChoice(_ bundle: Bundle = Bundle.main) -> ORKImageChoice? {
        fatalError("Not Implemented")
    }
}

open class RKXCopingMechanismDescriptor: RKXImageDescriptor {
    var generalDescription: String?
    var specificDescription: String?
    var imageTitle: String!
    var category: String!
    
    override func imageChoice(_ bundle: Bundle = Bundle.main) -> ORKImageChoice? {
        guard let image = UIImage(named: self.imageTitle)
            else {
                fatalError("Cannot find image named \(imageTitle) in \(bundle)")
        }
        return RKXImageChoiceWithAdditionalText(image: image, text: self.specificDescription, additionalText: self.generalDescription, value: self.identifier as NSCoding & NSCopying & NSObjectProtocol)
    }
    
    override init(itemDictionary: [String: AnyObject]) {
        super.init(itemDictionary: itemDictionary)
        self.generalDescription = itemDictionary["generalDescription"] as? String
        self.specificDescription = itemDictionary["specificDescription"] as? String
        self.imageTitle = itemDictionary["imageTitle"] as? String
        self.category = itemDictionary["category"] as? String
    }
}

open class RKXActivityDescriptor: RKXImageDescriptor {
    var activityDescription: String?
    var imageTitle: String!
    
    override func imageChoice(_ bundle: Bundle = Bundle.main) -> ORKImageChoice? {
        guard let image = UIImage(named: self.imageTitle)
            else {
                fatalError("Cannot find image named \(imageTitle) in \(bundle)")
        }
        return ORKImageChoice(normalImage: image, selectedImage: nil, text: self.activityDescription, value: self.identifier as NSCoding & NSCopying & NSObjectProtocol)
    }
    
    override init(itemDictionary: [String: AnyObject]) {
        super.init(itemDictionary: itemDictionary)
        self.activityDescription = itemDictionary["description"] as? String
        self.imageTitle = itemDictionary["imageTitle"] as? String
    }
}

open class RKXAffectDescriptor: RKXImageDescriptor {
    var imageTitles: [String]!
    var value: [String: AnyObject]!
    
    override func imageChoice(_ bundle: Bundle = Bundle.main) -> ORKImageChoice? {
        let images: [(String, UIImage)] = self.imageTitles.map { imageTitle in
            guard let image = UIImage(named: imageTitle, in: bundle, compatibleWith: nil)
            else{
               fatalError("Cannot find image named \(imageTitle) in \(bundle)")
            }
            return (imageTitle, image)
        }
        .flatMap { $0 }
        return PAMImageChoice(images: images, value: self.value as NSCoding & NSCopying & NSObjectProtocol)
    }
    
    override init(itemDictionary: [String: AnyObject]) {
        super.init(itemDictionary: itemDictionary)
        self.value = itemDictionary["value"] as? [String: AnyObject]
        self.imageTitles = itemDictionary["imageTitles"] as? [String]
    }
}

open class RKXSingleImageAffectDescriptor: RKXImageDescriptor {
    var imageTitles: [String]!
    var value: [String: AnyObject]!
    
    override func imageChoice(_ bundle: Bundle = Bundle.main) -> ORKImageChoice? {
        let imageTitle = self.imageTitles[0]
            guard let image = UIImage(named: imageTitle, in: bundle, compatibleWith: nil)
            else {
                fatalError("Cannot find image named \(imageTitle) in \(bundle)")
        }
        return ORKImageChoice(normalImage: image, selectedImage: nil, text: nil, value: self.value as NSCoding & NSCopying & NSObjectProtocol)
    }
    
    override init(itemDictionary: [String: AnyObject]) {
        super.init(itemDictionary: itemDictionary)
        self.value = itemDictionary["value"] as? [String: AnyObject]
        self.imageTitles = itemDictionary["imageTitles"] as? [String]
    }
}
