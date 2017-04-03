//
//  ViewController.swift
//  sdlrkx
//
//  Created by James Kizer on 04/28/2016.
//  Copyright (c) 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit
import sdlrkx
import ResearchSuiteTaskBuilder

let kActivityIdentifiers = "activity_identifiers"
let kMedicationIdentifiers = "medication_identifiers"

class VSRViewController: RKViewController {
    
    // MARK: Properties
    
    var taskBuilder: RSTBTaskBuilder!

    var stateHelper: UserDefaultsStateHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stepGeneratorServices: [RSTBStepGenerator] = [
            RSTBInstructionStepGenerator(),
            PAMStepGenerator(),
            YADLFullStepGenerator(),
            YADLSpotStepGenerator(),
            RSTBSingleChoiceStepGenerator()
        ]
        
        let answerFormatGeneratorServices: [RSTBAnswerFormatGenerator] = [
            RSTBSingleChoiceStepGenerator()
        ]
        
        let elementGeneratorServices: [RSTBElementGenerator] = [
            RSTBElementListGenerator(),
            RSTBElementFileGenerator(),
            RSTBElementSelectorGenerator()
        ]
        
        self.stateHelper = UserDefaultsStateHelper()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.taskBuilder = RSTBTaskBuilder(
            stateHelper: self.stateHelper,
            elementGeneratorServices: elementGeneratorServices,
            stepGeneratorServices: stepGeneratorServices,
            answerFormatGeneratorServices: answerFormatGeneratorServices)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func storeActivitiesForSpotAssessment(_ activities: [String]) {
//        UserDefaults().set(activities, forKey: kActivityIdentifiers)
//    }
//    
    func loadActivitiesForSpotAssessment() -> [String]? {
        return self.stateHelper.valueInState(forKey: kActivityIdentifiers) as? [String]
    }
    func storeMedicationsForSpotAssessment(_ medications: [String]) {
        UserDefaults().set(medications, forKey: kMedicationIdentifiers)
    }
    
    func loadMedicationsForSpotAssessment() -> [String]? {
        return UserDefaults().array(forKey: kMedicationIdentifiers) as? [String]
    }
    
    @IBAction func launchPAM(_ sender: AnyObject) {
        
        guard let steps = self.taskBuilder.steps(forElementFilename: "PAMTask") else { return }
        
        let task = ORKOrderedTask(identifier: "PAM identifier", steps: steps)
        
        self.launchAssessmentForTask(task)
        
    }
    
    @IBAction func launchYADLFullAssessment(_ sender: AnyObject) {
        
        //create a YADL full assessment task
        
        guard let steps = self.taskBuilder.steps(forElementFilename: "yadl_full_rstb") else { return }
        
        let task = ORKOrderedTask(identifier: "YADL Full Assessment Identifier", steps: steps)
        
        self.launchAssessmentForTask(task) { (taskResult) in
            
            if let difficultActivities: [String]? = taskResult.results?.flatMap({ (stepResult) in
                if let stepResult = stepResult as? ORKStepResult,
                    stepResult.identifier.hasPrefix("yadl_full."),
                    let choiceResult = stepResult.firstResult as? ORKChoiceQuestionResult,
                    let answer = choiceResult.choiceAnswers?.first as? String,
                    answer == "hard" || answer == "moderate"
                {
                    return stepResult.identifier.replacingOccurrences(of: "yadl_full.", with: "")
                }
                return nil
            }) {
                if let answers = difficultActivities {
                    self.stateHelper.setValueInState(value: answers as NSSecureCoding, forKey: kActivityIdentifiers)
                }
            }
            
        }
    }
    
    @IBAction func launchYADLSpotAssessment(_ sender: AnyObject) {
        //create a YADL spot assessment task
        
        guard let steps = self.taskBuilder.steps(forElementFilename: "yadl_spot_rstb") else { return }
        
        let task = ORKOrderedTask(identifier: "YADL Spot Assessment", steps: steps)
        
        self.launchAssessmentForTask(task)
    }
    
    @IBAction func launchMEDLFullAssessment(_ sender: AnyObject) {
        
        guard let steps = try! MEDLFullAssessmentCategoryStep.create(identifier: "MEDL Full Assessment Identifier", propertiesFileName: "MEDL") else {
            return
        }
        
        let task = ORKOrderedTask(identifier: "MEDL Full Assessment Identifier", steps: steps)
        
        self.launchAssessmentForTask(task)
    }
    
    @IBAction func launchMEDLSpotAssessment(_ sender: AnyObject) {
        
        guard let step = try! MEDLSpotAssessmentStep.create(identifier: "MEDL Spot Assessment Identifier", propertiesFileName: "MEDL", itemIdentifiers: self.loadMedicationsForSpotAssessment()) else {
            return
        }
        
        let task = ORKOrderedTask(identifier: "MEDL Spot Assessment", steps: [step])
        
        self.launchAssessmentForTask(task)
    }
    
}

