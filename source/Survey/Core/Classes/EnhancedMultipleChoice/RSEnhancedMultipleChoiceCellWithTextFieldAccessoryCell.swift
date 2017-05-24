//
//  RSEnhancedMultipleChoiceCellWithTextFieldAccessoryTableViewCell.swift
//  Pods
//
//  Created by James Kizer on 4/10/17.
//
//

import UIKit
import ResearchKit

protocol RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCellDelegate: class {
    func auxiliaryTextField(_ textField: UITextField, forCellId id: Int, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func auxiliaryTextFieldDidEndEditing(_ textField: UITextField, forCellId id: Int)
    func auxiliaryTextFieldShouldClear(_ textField: UITextField, forCellId id: Int) -> Bool
    func setSelected(selected: Bool, forCellId id: Int)
}

open class RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var auxContainer: UIView!
    @IBOutlet weak var choiceContainer: UIView!
    @IBOutlet weak var auxTextLabel: UILabel!
    @IBOutlet weak var auxTextField: UITextField!
    
    var identifier: Int!
    weak var delegate: RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCellDelegate?
    var titleHeight: NSLayoutConstraint?
    var choiceContainerHeight: NSLayoutConstraint?
    var auxFormItem: ORKFormItem?
//    var auxFormAnswer: Any? = nil
    var auxHeight: NSLayoutConstraint?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.clearForReuse()
    }
    
    override open func prepareForReuse() {
        self.clearForReuse()
        super.prepareForReuse()
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.delegate?.setSelected(selected: selected, forCellId: self.identifier)
        // Configure the view for the selected state
        self.updateUI(selected: selected, animated: animated, updateResponder: true)
    }
    
    open func clearForReuse() {
        
        if let auxContainerHeight = self.auxHeight {
            self.auxContainer.removeConstraint(auxContainerHeight)
        }
        
        self.identifier = nil
        self.delegate = nil
        self.titleHeight = nil
        self.choiceContainerHeight = nil
        self.auxFormItem = nil
//        self.auxFormAnswer = nil
        self.auxHeight = nil
        
        let auxContainerHeight = NSLayoutConstraint(item: self.auxContainer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
        auxContainerHeight.priority = 750
        self.auxHeight = auxContainerHeight
        self.auxContainer.addConstraint(auxContainerHeight)
    }
    
    open func configure(forTextChoice textChoice: RSTextChoiceWithAuxiliaryAnswer, withId: Int, initialText: String?) {
        
        self.clearForReuse()
        
        self.identifier = withId
        self.separatorInset = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.titleLabel?.text = textChoice.text
        //        self.detailTextLabel?.text = textChoice.detailText
        self.selectionStyle = .none
        
        self.checkImageView.image = UIImage(named: "checkmark", in: Bundle(for: ORKStep.self), compatibleWith: nil)
        
        self.auxTextField.text = initialText
        self.auxFormItem = textChoice.auxiliaryItem
        
        guard let auxItem = textChoice.auxiliaryItem else {
            return
        }
        
        //configre aux views
        //setup text fields
        //set text field delegate
        //need to add validation stuff too
        switch(auxItem.answerFormat) {
        case let answerFormat as ORKTextAnswerFormat:
            self.auxFormItem = auxItem
            self.auxTextLabel.text = auxItem.text
            self.auxTextField.placeholder = auxItem.placeholder
            self.auxTextField.delegate = self
            
            self.auxTextField.autocapitalizationType = answerFormat.autocapitalizationType
            self.auxTextField.autocorrectionType = answerFormat.autocorrectionType
            self.auxTextField.spellCheckingType = answerFormat.spellCheckingType
            self.auxTextField.keyboardType = answerFormat.keyboardType
            self.auxTextField.isSecureTextEntry = answerFormat.isSecureTextEntry
            break
            
        case _ as ORKEmailAnswerFormat:
            self.auxFormItem = auxItem
            self.auxTextLabel.text = auxItem.text
            self.auxTextField.placeholder = auxItem.placeholder
            self.auxTextField.delegate = self
            
            self.auxTextField.autocapitalizationType = UITextAutocapitalizationType.none
            self.auxTextField.autocorrectionType = UITextAutocorrectionType.default
            self.auxTextField.spellCheckingType = UITextSpellCheckingType.default
            self.auxTextField.keyboardType = UIKeyboardType.emailAddress
            self.auxTextField.isSecureTextEntry = false

            break
        case _ as ORKNumericAnswerFormat:
            self.auxFormItem = auxItem
            self.auxTextLabel.text = auxItem.text
            self.auxTextField.placeholder = auxItem.placeholder
            self.auxTextField.delegate = self
            
            self.auxTextField.autocapitalizationType = UITextAutocapitalizationType.none
            self.auxTextField.autocorrectionType = UITextAutocorrectionType.default
            self.auxTextField.spellCheckingType = UITextSpellCheckingType.default
            self.auxTextField.keyboardType = UIKeyboardType.numberPad
            self.auxTextField.isSecureTextEntry = false

            
            break
        default:
            return
        }
        
    }
    
    open func updateUI(selected: Bool, animated: Bool, updateResponder: Bool) {
        
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
            
            if let _ = self.auxFormItem {
                if let auxHeight = self.auxHeight {
                    self.auxContainer.removeConstraint(auxHeight)
                    self.auxHeight = nil
                    if updateResponder { self.auxTextField.becomeFirstResponder() }
                }
            }
            
        }
        else {
            self.titleLabel.textColor = UIColor.black
            self.checkImageView.isHidden = true
            
            if self.auxHeight == nil {
                let auxContainerHeight = NSLayoutConstraint(item: self.auxContainer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
                auxContainerHeight.priority = 750
                self.auxHeight = auxContainerHeight
                self.auxContainer.addConstraint(auxContainerHeight)
            }
            
//            if updateResponder { self.auxTextField.resignFirstResponder() }
            
            self.endEditing(true)
            
        }
        
    }
    
    
    //delegate
    open func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.auxiliaryTextFieldDidEndEditing(textField, forCellId: self.identifier)
    }
    //delegate
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return self.delegate?.auxiliaryTextField(textField, forCellId: self.identifier, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.delegate?.auxiliaryTextFieldShouldClear(textField, forCellId: self.identifier) ?? true
    }

}
