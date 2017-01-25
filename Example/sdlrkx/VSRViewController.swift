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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stepGeneratorServices: [RSTBStepGenerator] = [
            RSTBInstructionStepGenerator(),
            PAMStepGenerator(),
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
        
        // Do any additional setup after loading the view, typically from a nib.
        self.taskBuilder = RSTBTaskBuilder(
            stateHelper: nil,
            elementGeneratorServices: elementGeneratorServices,
            stepGeneratorServices: stepGeneratorServices,
            answerFormatGeneratorServices: answerFormatGeneratorServices)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func storeActivitiesForSpotAssessment(_ activities: [String]) {
        UserDefaults().set(activities, forKey: kActivityIdentifiers)
    }
    
    func loadActivitiesForSpotAssessment() -> [String]? {
        return UserDefaults().array(forKey: kActivityIdentifiers) as? [String]
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
        
        guard let steps = try! YADLFullAssessmentStep.create(identifier: "YADL Full Assessment Identifier", propertiesFileName: "YADL") else {
            return
        }
        
        let task = ORKOrderedTask(identifier: "YADL Full Assessment Identifier", steps: steps)
        
        self.launchAssessmentForTask(task)
    }
    
    @IBAction func launchYADLSpotAssessment(_ sender: AnyObject) {
        //create a YADL spot assessment task
        
        guard let step = try! YADLSpotAssessmentStep.create(identifier: "YADL Spot Assessment Identifier", propertiesFileName: "YADL", itemIdentifiers: self.loadActivitiesForSpotAssessment()) else {
            return
        }
        
        let task = ORKOrderedTask(identifier: "YADL Spot Assessment", steps: [step])
        
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

