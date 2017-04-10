//
//  RSEnhancedMultipleChoiceAccessoryView.swift
//  Pods
//
//  Created by James Kizer on 4/9/17.
//
//

import UIKit
import ResearchKit

public protocol RSEnhancedMultipleChoiceAccessoryViewDelegate: class {
    func accessoryViewAnswerChanged(accessoryView: RSEnhancedMultipleChoiceAccessoryView, answer: Any?)
    func accessoryViewDidBecomeFirstResponder(accessoryView: RSEnhancedMultipleChoiceAccessoryView)
    func accessoryViewDidResignFirstResponder(accessoryView: RSEnhancedMultipleChoiceAccessoryView)
}

open class RSEnhancedMultipleChoiceAccessoryView: UIView {

    
    var textLabel: UILabel
    weak var delegate: RSEnhancedMultipleChoiceAccessoryViewDelegate?
    
    public init?(formItem: ORKFormItem,
         answer: Any?,
         maxLabelWidth:CGFloat,
         delegate: RSEnhancedMultipleChoiceAccessoryViewDelegate) {
        
        
        //add label
        //should be self sizing height
        //set width to max label width
        self.textLabel = UILabel()
        self.textLabel.lineBreakMode = .byWordWrapping
        self.textLabel.numberOfLines = 0
        self.textLabel.text = formItem.text
        
        let size = self.textLabel.sizeThatFits(CGSize(width: maxLabelWidth, height: CGFloat(MAXFLOAT)))
        self.textLabel.frame = CGRect(x: 8, y: 16, width: size.width, height: size.height)
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: size.height + 32) )
        
//        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0) )
        
        self.addSubview(self.textLabel)
        print(self.textLabel)
        
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.textLabel, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 16)
        
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.textLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 16)
        
        let leadingContraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.textLabel, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 8)
        
        let widthConstraint = NSLayoutConstraint(item: self.textLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: maxLabelWidth-8)
        
//        let heightConstraint 
        
        self.addConstraints([topConstraint, bottomConstraint, leadingContraint])
        
        self.textLabel.addConstraint(widthConstraint)
        
        self.setNeedsLayout()
        
        //set delegate
        self.delegate = delegate

    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


open class RSEnhancedMultipleChoiceAccessoryTextBasedView: RSEnhancedMultipleChoiceAccessoryView, UITextFieldDelegate {
    
    
    
}
