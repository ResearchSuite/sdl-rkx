//
//  RKXItemDescriptor.swift
//  Pods
//
//  Created by James Kizer on 5/5/16.
//
//

import UIKit
import ResearchKit



public class RKXItemDescriptor: NSObject {
    var identifier: String!
    
    init(itemDictionary: [String: AnyObject]) {
        super.init()
        self.identifier = itemDictionary["identifier"] as? String
    }
}

public class RKXImageDescriptor: RKXItemDescriptor {
    
    class func imageChoiceForDescriptor(bundle: NSBundle = NSBundle.mainBundle()) -> ((RKXImageDescriptor) -> (ORKImageChoice?)) {
        return { imageDescriptor in
            return imageDescriptor.imageChoice(bundle)
        }
    }
    
    func imageChoice(bundle: NSBundle = NSBundle.mainBundle()) -> ORKImageChoice? {
        fatalError("Not Implemented")
    }
}

public class RKXCopingMechanismDescriptor: RKXImageDescriptor {
    var generalDescription: String?
    var specificDescription: String?
    var imageTitle: String!
    var category: String!
    
    override func imageChoice(bundle: NSBundle = NSBundle.mainBundle()) -> ORKImageChoice? {
        guard let image = UIImage(named: self.imageTitle)
            else {
                fatalError("Cannot find image named \(imageTitle) in \(bundle)")
                return nil
        }
        return RKXImageChoiceWithAdditionalText(image: image, text: self.specificDescription, additionalText: self.generalDescription, value: self.identifier)
    }
    
    override init(itemDictionary: [String: AnyObject]) {
        super.init(itemDictionary: itemDictionary)
        self.generalDescription = itemDictionary["generalDescription"] as? String
        self.specificDescription = itemDictionary["specificDescription"] as? String
        self.imageTitle = itemDictionary["imageTitle"] as? String
        self.category = itemDictionary["category"] as? String
    }
}

public class RKXActivityDescriptor: RKXImageDescriptor {
    var activityDescription: String?
    var imageTitle: String!
    
    override func imageChoice(bundle: NSBundle = NSBundle.mainBundle()) -> ORKImageChoice? {
        guard let image = UIImage(named: self.imageTitle)
            else {
                fatalError("Cannot find image named \(imageTitle) in \(bundle)")
                return nil
        }
        return ORKImageChoice(normalImage: image, selectedImage: nil, text: self.activityDescription, value: self.identifier)
    }
    
    override init(itemDictionary: [String: AnyObject]) {
        super.init(itemDictionary: itemDictionary)
        self.activityDescription = itemDictionary["activityDescription"] as? String
        self.imageTitle = itemDictionary["imageTitle"] as? String
    }
}

public class RKXAffectDescriptor: RKXImageDescriptor {
    var imageTitles: [String]!
    var value: [String: AnyObject]!
    
    override func imageChoice(bundle: NSBundle = NSBundle.mainBundle()) -> ORKImageChoice? {
        let images: [UIImage] = self.imageTitles.map { imageTitle in
            guard let image = UIImage(named: imageTitle, inBundle: bundle, compatibleWithTraitCollection: nil)
            else{
               fatalError("Cannot find image named \(imageTitle) in \(bundle)")
                return nil
            }
            return image
        }
        .flatMap { $0 }
        return PAMImageChoice(images: images, value: self.value)
    }
    
    override init(itemDictionary: [String: AnyObject]) {
        super.init(itemDictionary: itemDictionary)
        self.value = itemDictionary["value"] as? [String: AnyObject]
        self.imageTitles = itemDictionary["imageTitles"] as? [String]
    }
}
