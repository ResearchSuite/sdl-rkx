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

class ViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    // MARK: Properties
    
    /**
     When a task is completed, the `TaskListViewController` calls this closure
     with the created task.
     */
    var taskResultFinishedCompletionHandler: ((ORKResult) -> Void)?
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
            RTSBElementSelectorGenerator()
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
    
    // MARK: ORKTaskViewControllerDelegate
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
//        if reason == ORKTaskViewControllerFinishReason.completed {
//            //if YADL full task, extract results and store for filtering
//            if let _ = taskViewController.task as? YADLFullAssessmentTask,
//                let results:[ORKChoiceQuestionResult] = YADLFullAssessmentTask.fullAssessmentResults(taskViewController.result)
//            {
//                print(results)
//                let activityIdentifiers:[String] = results.filter { result  in
//                    
//                    guard let choiceAnswers = result.choiceAnswers
//                        else {
//                            return false
//                    }
//                    if choiceAnswers.count == 1,
//                        let answer = choiceAnswers[0] as? String {
//                        return (answer == "hard") || (answer == "moderate")
//                    }
//                    else {
//                        return false
//                    }
//                    }
//                    .map { $0.identifier }
//                self.storeActivitiesForSpotAssessment(activityIdentifiers)
//            }
//            //if YADL full task, extract results and store for filtering
//            if let _ = taskViewController.task as? MEDLFullAssessmentTask,
//                let results:[ORKChoiceQuestionResult] = MEDLFullAssessmentTask.fullAssessmentResults(taskViewController.result)
//            {
//                print(results)
//                let copingIdentifiers: [String] = results.reduce([], { (acc, result) -> [String] in
//                    if let identifiers = result.answer as? [String] {
//                        return acc + identifiers
//                    }
//                    else {
//                        return acc
//                    }
//                })
//                self.storeMedicationsForSpotAssessment(copingIdentifiers)
//            }
//            else if let _ = taskViewController.task as? PAMTask {
//                print(taskViewController.result)
//            }
//        }
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
    

    func launchAssessmentForTask(_ task: ORKOrderedTask) {
        /*
         Passing `nil` for the `taskRunUUID` lets the task view controller
         generate an identifier for this run of the task.
         */
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        
        // Make sure we receive events from `taskViewController`.
        taskViewController.delegate = self
        
        // Assign a directory to store `taskViewController` output.
        taskViewController.outputDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        /*
         We present the task directly, but it is also possible to use segues.
         The task property of the task view controller can be set any time before
         the task view controller is presented.
         */
        present(taskViewController, animated: true, completion: nil)
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

