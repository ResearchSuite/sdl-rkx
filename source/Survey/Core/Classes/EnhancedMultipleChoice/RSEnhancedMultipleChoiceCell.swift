//
//  RSEnhancedMultipleChoiceCell.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import UIKit
import ResearchKit

protocol RSEnhancedMultipleChoiceCellDelegate {
    func cellAuxiliaryAnswerChanged(_ cell: RSEnhancedMultipleChoiceCell, answer: Any)
}

open class RSEnhancedMultipleChoiceCell: UITableViewCell, RSEnhancedMultipleChoiceAccessoryViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
//    @IBOutlet weak var auxContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var auxContainer: UIView!
    var titleHeight: NSLayoutConstraint?
    var choiceContainerHeight: NSLayoutConstraint?
    
    var auxView: UIView?
    
//    var auxViewTopConstraint: NSLayoutConstraint?
//    var auxViewBottomConstraint: NSLayoutConstraint?
    var auxViewConstraints:[NSLayoutConstraint]?
    var auxContainerHeight: NSLayoutConstraint?
    
    var auxFormItem: ORKFormItem?
    
    var auxFormAnswer: Any? = nil
    
    @IBOutlet weak var choiceContainer: UIView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.updateUI(selected: selected, animated: animated)
    }
    
    open func configure(forTextChoice textChoice: RSTextChoiceWithAuxiliaryAnswer) {
        self.separatorInset = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.titleLabel?.text = textChoice.text
//        self.detailTextLabel?.text = textChoice.detailText
        self.selectionStyle = .none
        
        self.checkImageView.image = UIImage(named: "checkmark", in: Bundle(for: ORKStep.self), compatibleWith: nil)
        
        guard let auxItem = textChoice.auxiliaryItem,
            let answerFormat = auxItem.answerFormat else {
            return
        }
        
        self.auxFormItem = auxItem
    }
    
    open func updateAuxView(selected: Bool, animated: Bool) {
        guard let formItem = self.auxFormItem else {
            return
        }
        
        if selected {

            if let heightConstraint = self.auxContainerHeight {
                self.auxContainer?.removeConstraint(heightConstraint)
                self.auxContainerHeight = nil
            }

            guard self.auxViewConstraints == nil,
                let auxView = RSEnhancedMultipleChoiceAccessoryView(
                formItem: formItem,
                answer: self.auxFormAnswer,
                maxLabelWidth: self.bounds.width / 2.0,
                delegate: self
                ) else { return }
            
            if self.auxView == nil,
                let auxView = RSEnhancedMultipleChoiceAccessoryView(
                    formItem: formItem,
                    answer: self.auxFormAnswer,
                    maxLabelWidth: self.bounds.width / 2.0,
                    delegate: self
                ) {
                self.auxView = auxView
                self.auxContainer.addSubview(auxView)
            }
            
            
            print(self.auxContainer)
            print(self.auxView)
            
            let topConstraint = NSLayoutConstraint(item: self.auxContainer, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.auxView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: self.auxContainer, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.auxView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            
            let widthConstraint = NSLayoutConstraint(item: self.auxContainer, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.auxView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
            
            let horizontalCenterConstraint = NSLayoutConstraint(item: self.auxContainer, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.auxView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            
            let constraints = [topConstraint, bottomConstraint, widthConstraint, horizontalCenterConstraint]
            self.auxContainer?.addConstraints(constraints)
            self.auxViewConstraints = constraints
            
        }
        else {
            if let constraints = self.auxViewConstraints { self.auxContainer.removeConstraints(constraints)}
            self.auxViewConstraints = nil
            
//            self.auxView?.removeFromSuperview()
//            self.auxView = nil
            
            let containerHeight = NSLayoutConstraint(item: self.auxContainer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
            //this makes it so the box shrinks from the bottom when unselecting
            containerHeight.priority = 750.0
            
            self.auxContainerHeight = containerHeight
            self.auxContainer.addConstraint(containerHeight)
            
        }
    }
    
    open func updateUI(selected: Bool, animated: Bool) {
        print("updating UI for \(self.textLabel?.text)")
        
        if self.titleHeight == nil {

            let titleHeight = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.titleLabel.bounds.height)
            
            self.titleHeight = titleHeight
            self.titleLabel.addConstraint(titleHeight)
            
            let containerHeight = NSLayoutConstraint(item: self.choiceContainer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.choiceContainer.bounds.height)
            
            self.choiceContainerHeight = containerHeight
            self.choiceContainer.addConstraint(containerHeight)
        }
        
        if selected {
            self.titleLabel.textColor = self.tintColor
            self.checkImageView.isHidden = false
//            self.auxContainerHeight.constant = 32
            
//            //only add subview if not already there
//            if let auxItem = self.auxFormItem,
//                self.auxView == nil {
//                
//                if let heightConstraint = self.auxContainerHeight {
//                    self.auxContainer?.removeConstraint(heightConstraint)
//                    self.auxContainerHeight = nil
//                }
//
//                
//                let auxView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//                self.auxView = auxView
//                self.auxContainer.addSubview(auxView)
//                
//                let topConstraint = NSLayoutConstraint(item: self.auxContainer, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.auxView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
//                
//                self.auxViewTopConstraint = topConstraint
//                
//                let bottomConstraint = NSLayoutConstraint(item: self.auxContainer, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.auxView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
//                
//                self.auxViewBottomConstraint = bottomConstraint
//                
//                self.auxContainer?.addConstraints([topConstraint, bottomConstraint])
//            }
            
        }
        else {
            self.titleLabel.textColor = UIColor.black
            self.checkImageView.isHidden = true
//            self.auxContainerHeight.constant = 0
//            self.auxContainer.removeConstraints([self.auxViewTopConstraint, self.auxViewBottomConstraint].flatMap({$0}))
//            self.auxViewTopConstraint = nil
//            self.auxViewBottomConstraint = nil
//            self.auxView?.removeFromSuperview()
//            self.auxView = nil
//            
//            let containerHeight = NSLayoutConstraint(item: self.auxContainer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
//            //this makes it so the box shrinks from the bottom when unselecting
//            containerHeight.priority = 750.0
//            
//            self.auxContainerHeight = containerHeight
//            self.auxContainer.addConstraint(containerHeight)
        }
        
        self.updateAuxView(selected: selected, animated: animated)
    }
    
    public func accessoryViewAnswerChanged(accessoryView: RSEnhancedMultipleChoiceAccessoryView, answer: Any?) {
        self.auxFormAnswer = answer
    }
    public func accessoryViewDidBecomeFirstResponder(accessoryView: RSEnhancedMultipleChoiceAccessoryView) {
        
    }
    public func accessoryViewDidResignFirstResponder(accessoryView: RSEnhancedMultipleChoiceAccessoryView) {
        
    }
    
    
}
