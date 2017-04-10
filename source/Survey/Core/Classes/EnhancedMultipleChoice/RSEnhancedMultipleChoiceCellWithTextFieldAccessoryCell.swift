//
//  RSEnhancedMultipleChoiceCellWithTextFieldAccessoryTableViewCell.swift
//  Pods
//
//  Created by James Kizer on 4/10/17.
//
//

import UIKit
import ResearchKit

protocol RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCellDelegate {
    func cellAuxiliaryAnswerChanged(_ cell: RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCell, answer: Any)
}

class RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var auxContainer: UIView!
    @IBOutlet weak var choiceContainer: UIView!
    
    var titleHeight: NSLayoutConstraint?
    var choiceContainerHeight: NSLayoutConstraint?
    
    var auxFormItem: ORKFormItem?
    var auxFormAnswer: Any? = nil
    
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
            
        }
        else {
            self.titleLabel.textColor = UIColor.black
            self.checkImageView.isHidden = true
        }
        
//        self.updateAuxView(selected: selected, animated: animated)
    }
    
    public func accessoryViewAnswerChanged(accessoryView: RSEnhancedMultipleChoiceAccessoryView, answer: Any?) {
        self.auxFormAnswer = answer
    }
    public func accessoryViewDidBecomeFirstResponder(accessoryView: RSEnhancedMultipleChoiceAccessoryView) {
        
    }
    public func accessoryViewDidResignFirstResponder(accessoryView: RSEnhancedMultipleChoiceAccessoryView) {
        
    }

}
