//
//  RSEnhancedMultipleChoiceStepViewController.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import UIKit

open class RSEnhancedMultipleChoiceStepViewController: RSQuestionTableViewController {

    
    var enhancedMultiChoiceStep: RSEnhancedMultipleChoiceStep?
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
        
        self.enhancedMultiChoiceStep = enhancedMultiChoiceStep
        
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.enhancedMultiChoiceStep?.answerFormat?.textChoices.count ?? 0
    }
    
    open func textChoice(indexPath: IndexPath) -> RSTextChoiceWithAuxiliaryAnswer? {
        
        guard let textChoices = self.enhancedMultiChoiceStep?.answerFormat?.textChoices,
            textChoices.count > indexPath.row,
            let textChoice = textChoices[indexPath.row] as? RSTextChoiceWithAuxiliaryAnswer
            else {
            return nil
        }
        return textChoice
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "enhanced_multi_choice"
        
        guard let textChoice = self.textChoice(indexPath: indexPath),
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? RSEnhancedMultipleChoiceCell else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "default")
            cell.textLabel?.text = "Default Cell"
            return cell
        }
        
        cell.configure(forTextChoice: textChoice)
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        tableView.deselectRow(at: indexPath, animated: false)

        print(tableView.indexPathsForSelectedRows)
        tableView.beginUpdates()
        tableView.endUpdates()
        
        self.view.setNeedsLayout()
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(tableView.indexPathsForSelectedRows)
        tableView.beginUpdates()
        tableView.endUpdates()
        
        self.view.setNeedsLayout()
    }

}
