//
//  RSQuestionTableViewController.swift
//  Pods
//
//  Created by James Kizer on 4/6/17.
//
//

import UIKit
import ResearchKit

open class RSQuestionTableViewController: ORKStepViewController, UITableViewDataSource, UITableViewDelegate {
//, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var continueButton: CTFBorderedButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIStackView!
    @IBOutlet weak var footerContainer: UIView!
    
    var rawFooterHeight: CGFloat?
    
    var tableViewStep: RSQuestionTableViewStep?
    
    override convenience init(step: ORKStep?) {
        self.init(step: step, result: nil)
    }
    
    override convenience init(step: ORKStep?, result: ORKResult?) {
        
        let framework = Bundle(for: RSQuestionTableViewController.self)
        self.init(nibName: "RSQuestionTableViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
    }
    
    override open func viewDidLoad() {
        
//        print(self.step)
        
        self.titleLabel.text = self.step?.title
        self.textLabel.text = self.step?.text
        
        if self.hasNextStep() {
            self.continueButton.setTitle("Next", for: .normal)
        }
        else {
            self.continueButton.setTitle("Done", for: .normal)
        }
        
        if let tableViewStep = self.step as? RSQuestionTableViewStep {
            self.skipButton.isHidden = !tableViewStep.isOptional
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let header = self.tableView.tableHeaderView {
            let titleSize = self.titleLabel.sizeThatFits(CGSize(width: self.tableView.frame.size.width, height: CGFloat(MAXFLOAT)))
            let textSize = self.textLabel.sizeThatFits(CGSize(width: self.tableView.frame.size.width, height: CGFloat(MAXFLOAT)))
            header.frame.size.height = titleSize.height + textSize.height
            self.tableView.tableHeaderView = header
        }
    }
    
    //Note that we want the table view to be as large as the screen,
    //should return one more than actual data source
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
//    //this method adjusts the sizing of the footer
//    //in order to
//    override open func viewDidLayoutSubviews() {
//        
//        guard let tableView = self.tableView else  {
//            return
//        }
//        
////        if self.rawFooterHeight == nil {self.rawFooterHeight = tableView.tableFooterView?.bounds.size.height}
//        
//       let rawFooterHeight = self.footerContainer.bounds.size.height
//        
//        
//        if let footerView = tableView.tableFooterView {
//            
//            //calculate current footer padding
//            let currentFooterPadding = footerView.bounds.height - rawFooterHeight
//            
//            let contentHeightDifference = tableView.frame.size.height - tableView.contentSize.height
//            
//            //grow (or shrink) padding by contentHeightDifference
//            if currentFooterPadding + contentHeightDifference > 0 {
//                tableView.isScrollEnabled = false
//                footerView.bounds.size.height = footerView.bounds.height + contentHeightDifference
//                tableView.tableFooterView = footerView
//            }
//            else {
//                tableView.isScrollEnabled = true
//                footerView.bounds.size.height = rawFooterHeight
//                tableView.tableFooterView = footerView
//            }
//            
//        }
//        
////        let currentFooterPadding
////        
////        let contentHeightDifference = tableView.frame.size.height - tableView.contentSize.height
////        
////        if contentHeightDifference > 0 {
////            tableView.isScrollEnabled = false
////            
////            if let footerView = tableView.tableFooterView {
////                let additionalPadding = tableView.frame.size.height - tableView.contentSize.height
////                let currentFooterSize = footerView.bounds.size
////                footerView.bounds.size.height = currentFooterSize.height + additionalPadding
////                tableView.tableFooterView = footerView
////            }
////            
////        }
////        else {
////            tableView.isScrollEnabled = true
////            
////            if let footerView = tableView.tableFooterView {
////                let rawFooterSize = self.footerContainer.bounds.size
////                footerView.bounds.size.height = rawFooterSize.height
////                tableView.tableFooterView = footerView
////            }
////        }
//    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "default")
        cell.textLabel?.text = "Default Cell"
        cell.detailTextLabel?.text = "You should override cellForRowAt"
        return cell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    open func clearAnswer() {
        
    }
    
    open func notifyDelegateAndMoveForward() {
        if let delegate = self.delegate {
            delegate.stepViewControllerResultDidChange(self)
        }
        self.goForward()
    }

    @IBAction func continueTapped(_ sender: Any) {
        self.notifyDelegateAndMoveForward()
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        self.clearAnswer()
        self.notifyDelegateAndMoveForward()
    }
    
    
    
}
