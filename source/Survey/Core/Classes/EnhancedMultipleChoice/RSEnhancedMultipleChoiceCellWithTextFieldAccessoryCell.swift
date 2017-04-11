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
    func cellAuxiliaryAnswerChanged(_ id: Int, answer: Any?, valid: Bool)
    func showValidityAlertMessage(_ id: Int, message: String)
}

open class RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCell: UITableViewCell, UITextFieldDelegate {

    static let EmailValidationRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    
    var identifier: Int!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var auxContainer: UIView!
    @IBOutlet weak var choiceContainer: UIView!
    weak var delegate: RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCellDelegate?
    
    var titleHeight: NSLayoutConstraint?
    var choiceContainerHeight: NSLayoutConstraint?
    
    var auxFormItem: ORKFormItem?
    var auxFormAnswer: Any? = nil
    var auxHeight: NSLayoutConstraint?
    
    @IBOutlet weak var auxTextLabel: UILabel!
    @IBOutlet weak var auxTextField: UITextField!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let auxContainerHeight = NSLayoutConstraint(item: self.auxContainer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
        auxContainerHeight.priority = 750
        self.auxHeight = auxContainerHeight
        self.auxContainer.addConstraint(auxContainerHeight)
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        self.updateUI(selected: selected, animated: animated, updateResponder: true)
    }
    
    open func configure(forTextChoice textChoice: RSTextChoiceWithAuxiliaryAnswer, withId: Int, result: ORKResult?) {
        self.identifier = withId
        self.separatorInset = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.titleLabel?.text = textChoice.text
        //        self.detailTextLabel?.text = textChoice.detailText
        self.selectionStyle = .none
        
        self.checkImageView.image = UIImage(named: "checkmark", in: Bundle(for: ORKStep.self), compatibleWith: nil)
        
        
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
            
            if let textResult = result as? ORKTextQuestionResult,
                let textAnswer = textResult.textAnswer {
                self.auxTextField.text = textAnswer
            }
            else {
                self.auxTextField.text = nil
            }
            
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
            
            if let textResult = result as? ORKTextQuestionResult,
                let textAnswer = textResult.textAnswer {
                self.auxTextField.text = textAnswer
            }
            else {
                self.auxTextField.text = nil
            }
            
            break
        case let answerFormat as ORKNumericAnswerFormat:
            self.auxFormItem = auxItem
            self.auxTextLabel.text = auxItem.text
            self.auxTextField.placeholder = auxItem.placeholder
            self.auxTextField.delegate = self
            
            self.auxTextField.autocapitalizationType = UITextAutocapitalizationType.none
            self.auxTextField.autocorrectionType = UITextAutocorrectionType.default
            self.auxTextField.spellCheckingType = UITextSpellCheckingType.default
            self.auxTextField.keyboardType = UIKeyboardType.numberPad
            self.auxTextField.isSecureTextEntry = false
            
            if let numericResult = result as? ORKNumericQuestionResult,
                let numericAnswer = numericResult.numericAnswer {
                
                self.auxTextField.text = String(describing: numericAnswer)

            }
            else {
                self.auxTextField.text = nil
            }
            
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
            
            if updateResponder { self.auxTextField.resignFirstResponder() }
            
            self.endEditing(true)
            
        }
        
    }
    
    open func convertToResult(text: String, doValidationChecking: Bool) -> (Any?, Bool) {
        guard let auxItem = self.auxFormItem else  {
            return (nil, false)
        }
        
        switch auxItem.answerFormat {
            
        case _ as ORKTextAnswerFormat:
            
            if doValidationChecking {
                if self.validateTextForLength(text: text) && self.validateTextForRegEx(text: text) {
                    return (text, true)
                }
                else {
                    return (nil, false)
                }
            }
            else {
                return (text, false)
            }
            
            
        case _ as ORKEmailAnswerFormat:
            
            if doValidationChecking {
                if self.validateTextForLength(text: text) && self.validateTextForRegEx(text: text) {
                    return (text, true)
                }
                else {
                    return (nil, false)
                }
            }
            else {
                return (text, false)
            }
            
        case let answerFormat as ORKNumericAnswerFormat:
            
            if doValidationChecking {
                
                if self.validateNumericTextForRange(text: text) {
                    if answerFormat.style == ORKNumericAnswerStyle.decimal,
                        let decimalAnswer = Double(text) {
                        return (decimalAnswer, true)
                    }
                    else if let integerAnswer = Int(text) {
                        return (integerAnswer, true)
                    }
                    else {
                        return (nil, false)
                    }
                }
                else {
                    return (nil, false)
                }
                
            }
            else {
                if answerFormat.style == ORKNumericAnswerStyle.decimal,
                    let decimalAnswer = Double(text) {
                    return (decimalAnswer, false)
                }
                else if let integerAnswer = Int(text) {
                    return (integerAnswer, false)
                }
                else {
                    return (nil, false)
                }
            }
            
            
        default:
            return (nil, false)
            
        }
        
    }
    
    //do validation checks here
    open func textFieldDidEndEditing(_ textField: UITextField) {
        
        //we only need to perform validity checking if we are selected
        // but we do nneed to pass null result
        if !self.isSelected {
            return
        }
        
        guard let auxItem = self.auxFormItem else  {
            return
        }
        
        //emtpy should be considered valid in all cases
        if let text = textField.text,
            text.characters.count > 0 {
            
            let (answer, valid) = self.convertToResult(text: text, doValidationChecking: true)
            self.delegate?.cellAuxiliaryAnswerChanged(self.identifier, answer: answer, valid: valid)
            
        }
        else {
            //is this empty?
            self.delegate?.cellAuxiliaryAnswerChanged(self.identifier, answer: nil, valid: true)
        }
    }
    
    open func validateTextForLength(text: String) -> Bool {
        
        guard let auxItem = self.auxFormItem,
            let answerFormat = auxItem.answerFormat as? ORKTextAnswerFormat,
            answerFormat.maximumLength > 0 else {
                return true
        }
        
        if text.characters.count > answerFormat.maximumLength {
            self.delegate?.showValidityAlertMessage(self.identifier, message: "Text content exceeding maximum length: \(answerFormat.maximumLength)")
            return false
        }
        else {
            return true
        }
        
    }
    
    //returns true for empty text
    open func validateTextForRegEx(text: String) -> Bool {
        
        guard let auxItem = self.auxFormItem,
            let answerFormat = auxItem.answerFormat as? ORKTextAnswerFormat,
            let regex = answerFormat.validationRegex,
            let invalidMessage = answerFormat.invalidMessage else {
                return true
        }
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let matchCount = regex.numberOfMatches(in: text, options: [], range: NSMakeRange(0, text.characters.count))
            
            if matchCount != 1 {
                self.delegate?.showValidityAlertMessage(self.identifier, message: invalidMessage)
                return false
            }
            return true
        } catch {
            self.delegate?.showValidityAlertMessage(self.identifier, message: "Invalid Regular Expression")
            return false
        }
    }
    
    open func validateNumericTextForRange(text: String) -> Bool {
        guard let auxItem = self.auxFormItem,
            let answerFormat = auxItem.answerFormat as? ORKNumericAnswerFormat else {
                return true
        }
        
        if answerFormat.style == ORKNumericAnswerStyle.decimal,
            let decimalAnswer = Double(text) {
            
            if let minValue = answerFormat.minimum?.doubleValue,
                decimalAnswer < minValue {
                self.delegate?.showValidityAlertMessage(self.identifier, message: "\(decimalAnswer) is less than the minimum allowed value \(minValue).")
                return false
            }
            
            if let maxValue = answerFormat.maximum?.doubleValue,
                decimalAnswer > maxValue {
                self.delegate?.showValidityAlertMessage(self.identifier, message: "\(decimalAnswer) is more than the maximum allowed value \(maxValue).")
                return false
            }
            
            return true
        }
        else if answerFormat.style == ORKNumericAnswerStyle.integer,
            let integerAnswer = Int(text)  {
            
            if let minValue = answerFormat.minimum?.intValue,
                integerAnswer < minValue {
                self.delegate?.showValidityAlertMessage(self.identifier, message: "\(integerAnswer) is less than the minimum allowed value \(minValue).")
                return false
            }
            
            if let maxValue = answerFormat.maximum?.intValue,
                integerAnswer > maxValue {
                self.delegate?.showValidityAlertMessage(self.identifier, message: "\(integerAnswer) is more than the maximum allowed value \(maxValue).")
                return false
            }
            
            return true
        }
        else {
            return true
        }
    }
    
    //do length check here
    //after valid length check, we should signal that we have a potential result
    //note that we will do full validity checking when we change the responder
    //TODO: I don't like this, clean this up
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let startingText = textField.text {
            
            let start = startingText.index(startingText.startIndex, offsetBy: range.location)
            let end = startingText.index(startingText.startIndex, offsetBy: range.location + range.length)
            let stringRange = start..<end
            let text = startingText.replacingCharacters(in: stringRange, with: string)
            let textWithoutNewlines = text.components(separatedBy: CharacterSet.newlines).joined(separator: "")
            
            if self.validateTextForLength(text: textWithoutNewlines) == false {
                return false
            }
            
            let (answer, valid) = self.convertToResult(text: text, doValidationChecking: false)
            self.delegate?.cellAuxiliaryAnswerChanged(self.identifier, answer: answer, valid: valid)
            
        }
        
        return true
    }

}
