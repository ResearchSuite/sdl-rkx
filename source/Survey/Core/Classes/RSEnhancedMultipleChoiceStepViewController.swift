//
//  RSEnhancedMultipleChoiceStepViewController.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import UIKit
import ResearchKit

open class RSEnhancedMultipleChoiceStepViewController: RSQuestionTableViewController, RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCellDelegate {
    
    var enhancedMultiChoiceStep: RSEnhancedMultipleChoiceStep!
    
    var selected: Set<Int>!
    var auxiliaryResultOptional: Set<Int>!
    var auxiliaryResultForIndex: [Int: ORKResult]!
    var resultIsValidForIndex: [Int: Bool]!
    
    convenience init(step: ORKStep?) {
        self.init(step: step, result: nil)
    }
    
    convenience init(step: ORKStep?, result: ORKResult?) {
        
        let framework = Bundle(for: RSQuestionTableViewController.self)
        self.init(nibName: "RSQuestionTableViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
        
        self.enhancedMultiChoiceStep = step as! RSEnhancedMultipleChoiceStep
        
        //compute the set of optional selections
        if let textChoices = self.enhancedMultiChoiceStep.answerFormat?.textChoices {
            //if regular text choice, optional is true
            //if RSTextChoiceWithAuxiliaryAnswer, but auxiliaryItem is nil, optional is true
            //if RSTextChoiceWithAuxiliaryAnswer and auxiliaryItem is optional, optional is true
            let optionalIndexes: [Int] = textChoices.enumerated().filter { offset, textChoice in
                
                if let textChoiceWithAux = textChoice as? RSTextChoiceWithAuxiliaryAnswer,
                    let formItem = textChoiceWithAux.auxiliaryItem {
                    return formItem.isOptional
                }
                
                return true
                }.map { offset, textChoice in return offset }
            
            self.auxiliaryResultOptional = Set(optionalIndexes)
        }
        
        
        
        //configure based on result result
        if let stepResult = result as? ORKStepResult,
            let choiceResult = stepResult.results?.first as? RSEnhancedMultipleChoiceResult,
            let choiceAnswers = choiceResult.choiceAnswers {
            //set selected
            
            var selected: Set<Int> = Set()
            var auxiliaryResultForIndex: [Int: ORKResult] = [:]
            var resultIsValidForIndex: [Int: Bool] = [:]
            choiceAnswers.forEach({ (choiceSelection) in
                
                if let index = self.index(value: choiceSelection.value) {
                    selected = selected.union(Set([index]))
                    if let auxiliaryResult = choiceSelection.auxiliaryResult {
                        auxiliaryResultForIndex[index] = auxiliaryResult
                        resultIsValidForIndex[index] = true
                    }
                }
                
            })
            
            self.selected = selected
            self.auxiliaryResultForIndex = auxiliaryResultForIndex
            self.resultIsValidForIndex = resultIsValidForIndex
        }
        else {
            self.selected = Set()
            self.auxiliaryResultForIndex = [:]
            self.resultIsValidForIndex = [:]
        }
        
        
        
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "RSEnhancedMultipleChoiceCellWithTextFieldAccessory", bundle: Bundle(for: RSEnhancedMultipleChoiceStepViewController.self))
        self.tableView.register(nib, forCellReuseIdentifier: "enhanced_multi_choice")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.tableView.separatorInset = UIEdgeInsets.zero
        
        // Do any additional setup after loading the view.
        guard let enhancedMultiChoiceStep = step as? RSEnhancedMultipleChoiceStep,
            let answerFormat = enhancedMultiChoiceStep.answerFormat else {
            return
        }
        
        self.tableView.allowsSelection = true
        self.tableView.allowsMultipleSelection = answerFormat.style == .multipleChoice
        
        self.selected.forEach( { index in
            self.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.top )
        })
        
        
        self.updateUI()
    }
    
    func updateUI() {
        if let selectedPaths = self.tableView.indexPathsForSelectedRows,
            selectedPaths.count > 0 {
            
            //for each selected value, need to see if the aux result is optional or not,
            //check to see if we have a result if it is
            
            //we can do this via set math
            //iff selected set - optional set - results set = 0, we should be good
            let indicesWithResults = self.auxiliaryResultForIndex.map { index, value in return index}
            
            let remainingSet = self.selected.subtracting(self.auxiliaryResultOptional).subtracting(indicesWithResults)
            
            self.continueButton.isEnabled = remainingSet.count == 0
        }
        else {
            self.continueButton.isEnabled = false
        }
        
        
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.enhancedMultiChoiceStep.answerFormat?.textChoices.count ?? 0
    }
    
    open func textChoice(id: Int) -> RSTextChoiceWithAuxiliaryAnswer? {
        
        guard let textChoices = self.enhancedMultiChoiceStep?.answerFormat?.textChoices,
            textChoices.count > id,
            let textChoice = textChoices[id] as? RSTextChoiceWithAuxiliaryAnswer
            else {
            return nil
        }
        return textChoice
    }
    
    open func auxFormItem(id: Int) -> ORKFormItem? {
        return self.textChoice(id: id)?.auxiliaryItem
    }
    
    open func index(value: NSCoding & NSCopying & NSObjectProtocol) -> Int? {
        
        guard let textChoices = self.enhancedMultiChoiceStep.answerFormat?.textChoices else {
            return nil
        }
        
        if let value = value as? String {
            
            ///iterate over textChoices, look for right answer
            let matchingPairs = textChoices.enumerated().filter({ pair in
                
                if let val = pair.1.value as? String,
                    val == value {
                    return true
                }
                return false
            })
            
            assert(matchingPairs.count <= 1)
            
            return matchingPairs.first?.0
        }
        else if let value = value as? Int {
            
            ///iterate over textChoices, look for right answer
            let matchingPairs = textChoices.enumerated().filter({ pair in
                
                if let val = pair.1.value as? Int,
                    val == value {
                    return true
                }
                return false
            })
            
            assert(matchingPairs.count <= 1)
            
            return matchingPairs.first?.0
            
        }
        else if let value = value as? Double {
            
            ///iterate over textChoices, look for right answer
            let matchingPairs = textChoices.enumerated().filter({ pair in
                
                if let val = pair.1.value as? Double,
                    val == value {
                    return true
                }
                return false
            })
            
            assert(matchingPairs.count <= 1)
            
            return matchingPairs.first?.0
            
        }
        
        return nil
        
        
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "enhanced_multi_choice"
        
        guard let textChoice = self.textChoice(id: indexPath.row),
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCell else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "default")
            cell.textLabel?.text = "Default Cell"
            return cell
        }
        
        let auxResult = self.auxiliaryResultForIndex[indexPath.row]
        cell.configure(forTextChoice: textChoice, withId: indexPath.row, result: auxResult)
        cell.delegate = self
        
        cell.updateUI(selected: self.tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false, animated: false, updateResponder: false)
        //cell.setSelected(self.selected.contains(indexPath.row), animated: false)
        cell.setNeedsLayout()
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selected = self.selected.union(Set([indexPath.row]))
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        self.view.setNeedsLayout()
        self.updateUI()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selected = self.selected.subtracting(Set([indexPath.row]))
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        
        
        self.view.setNeedsLayout()
        self.updateUI()
    }
    
    func showValidityAlertMessage(_ id: Int, message: String) {
        
        let title = "Invalid value"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        //        weak var nav: UINavigationController? = self.navigationController
        
//        let endSessionAction = UIAlertAction(title: "End Session", style: .destructive, handler: { _ in
//            assert(self.sessionId.get() != nil)
//            if let delegate = UIApplication.shared.delegate as? RSLApplicationDelegate,
//                let item = delegate.endSessionItem(),
//                let store = delegate.reduxStore,
//                let taskBuilder = self.sessionTaskBuilder
//            {
//                let action = RSAFActionCreators.queueActivity(fromScheduleItem: item, taskBuilder: taskBuilder)
//                store.dispatch(action)
//                
//            }
//            
//            //            if let store = self.store {
//            //                let asyncActionCreator: RSAFActionCreators.AsyncActionCreator = { (state, store, actionCreatorCallback) in
//            //                    let endSessionAction = RSLLabActionCreators.endCurrentSession()
//            //                    actionCreatorCallback( { (store, state) in
//            //                        return endSessionAction
//            //                    })
//            //
//            //                }
//            //
//            //                store.dispatch(asyncActionCreator, callback: { (state) in
//            //                    nav?.popViewController(animated: true)
//            //                })
//            //            }
//        })
//        alert.addAction(endSessionAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func cellAuxiliaryAnswerChanged(_ id: Int, answer: Any?, valid: Bool) {
        
        print("answer changed for \(id), \(answer)")
        
        guard let auxFormItem = self.auxFormItem(id: id),
            let answerFormat = auxFormItem.answerFormat else {
            self.auxiliaryResultForIndex[id] = nil
            self.resultIsValidForIndex[id] = false
            return
        }
        
        //convert into a result
        let result: ORKResult? = {
            
            switch(answerFormat) {
            case _ as ORKTextAnswerFormat:
                
                if let answer = answer as? String {
                    let result = ORKTextQuestionResult(identifier: auxFormItem.identifier)
                    result.textAnswer = answer
                    return result
                }
                
                return nil
            case _ as ORKEmailAnswerFormat:
                
                if let answer = answer as? String {
                    let result = ORKTextQuestionResult(identifier: auxFormItem.identifier)
                    result.textAnswer = answer
                    return result
                }
                
                return nil
            case let answerFormat as ORKNumericAnswerFormat:
                
                if answerFormat.style == .decimal {
                    if let answer = answer as? Double {
                        let result = ORKNumericQuestionResult(identifier: auxFormItem.identifier)
                        result.numericAnswer = NSNumber(floatLiteral: answer)
                        result.unit = answerFormat.unit
                        return result
                    }
                }
                else {
                    if let answer = answer as? Int {
                        let result = ORKNumericQuestionResult(identifier: auxFormItem.identifier)
                        result.numericAnswer = NSNumber(integerLiteral: answer)
                        result.unit = answerFormat.unit
                        return result
                    }
                }
                return nil
            default:
                return nil
            }
            
            
        }()
        
        self.auxiliaryResultForIndex[id] = result
        self.resultIsValidForIndex[id] = valid
        self.updateUI()
        
    }
    
    override open func clearAnswer() {
        self.selected = []
    }
    
    override func continueTapped(_ sender: Any) {
//        self.resignFirstResponder()
        self.view.endEditing(true)
        
        //check to see that all selected results are valid
        //if any are invalid, dont go forward
        let selectedValid: [Bool] = self.resultIsValidForIndex.flatMap { (pair) -> Bool? in
            
            //ignore if pair index is not in selected set
            if !self.selected.contains(pair.0) {
                return nil
            }
            
            return pair.1
            
        }
            
        let allValid = selectedValid.reduce(true) { (acc, isValid) -> Bool in
            return acc && isValid
        }
        
        if allValid {
            super.continueTapped(sender)
        }
        
    }
    
    override open var result: ORKStepResult? {
        guard let result = super.result else {
            return nil
        }
        
        let multipleChoiceResult = RSEnhancedMultipleChoiceResult(identifier: self.enhancedMultiChoiceStep.identifier)
        let selections:[RSEnahncedMultipleChoiceSelection] = self.selected.flatMap { (index) -> RSEnahncedMultipleChoiceSelection? in
            guard let textChoice = self.textChoice(id: index) else {
                return nil
            }
            
            return RSEnahncedMultipleChoiceSelection(value: textChoice.value, auxiliaryResult: self.auxiliaryResultForIndex[index])
        }
        
        multipleChoiceResult.choiceAnswers = selections
        
        result.results = [multipleChoiceResult]
        
        return result
    }

}
