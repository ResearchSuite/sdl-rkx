//
//  RKXMultipleImageSelectionSurveyViewController.swift
//  SDL-RKX
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

struct RKXMultipleImageSelectionSurveyAnswerStruct {
    var identifier: NSCoding & NSCopying & NSObjectProtocol
    var selected: Bool
}

class RKXMultipleImageSelectionSurveyViewController: ORKStepViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var somethingSelectedButton: UIButton!
    @IBOutlet weak var nothingSelectedButton: UIButton!
    @IBOutlet weak var additionalTextView: UITextView!
    @IBOutlet weak var additionalTextViewHeightConstraint: NSLayoutConstraint!
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override convenience init(step: ORKStep?) {
//        let framework = NSBundle(identifier: RKXBundleIdentifier)
        let framework = Bundle(for: RKXMultipleImageSelectionSurveyViewController.self)
        self.init(nibName: "RKXMultipleImageSelectionSurveyViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
        self.restorationClass = RKXMultipleImageSelectionSurveyViewController.self
    }
    
    convenience override init(step: ORKStep?, result: ORKResult?) {
        self.init(step: step)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Params for user to configure
    var somethingSelectedButtonColor: UIColor? {
        didSet {
            if let somethingSelectedButton = self.somethingSelectedButton as? RKXBorderedButton {
                somethingSelectedButton.configuredColor = self.somethingSelectedButtonColor
            }
        }
    }
    
    var nothingSelectedButtonColor: UIColor? {
        didSet {
            if let nothingSelectedButton = self.nothingSelectedButton as? RKXBorderedButton {
                nothingSelectedButton.configuredColor = self.nothingSelectedButtonColor
            }
        }
    }
    
    var itemCellTextBackgroundColor:UIColor? {
        didSet {
            if let collectionView = self.imagesCollectionView {
                collectionView.reloadData()
            }
        }
    }
    
    var itemCellSelectedColor:UIColor? {
        didSet {
            if let collectionView = self.imagesCollectionView {
                collectionView.reloadData()
            }
        }
    }
    
    var itemCellSelectedOverlayImage: UIImage? = nil {
        didSet {
            if let collectionView = self.imagesCollectionView {
                collectionView.reloadData()
            }
        }
    }
    
    //collection view background color
    var itemCollectionViewBackgroundColor = UIColor.clear {
        didSet {
            if let collectionView = self.imagesCollectionView {
                collectionView.backgroundColor = self.itemCollectionViewBackgroundColor
            }
        }
    }
    
    //collectionViewLayout properties
    var itemsPerRow = 3 {
        didSet {
            if let collectionView = self.imagesCollectionView {
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    var itemMinSpacing: CGFloat = 10.0 {
        didSet {
            if let collectionView = self.imagesCollectionView {
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    
    
    var answerDictionary: [Int: RKXMultipleImageSelectionSurveyAnswerStruct]?
    
    //whenver step is set, initialize the answerArray
    override var step: ORKStep? {
        didSet {
            guard let step = step as? RKXMultipleImageSelectionSurveyStep,
                let answerFormat = step.answerFormat as? ORKImageChoiceAnswerFormat
                else { return }
            
            self.answerDictionary = [Int: RKXMultipleImageSelectionSurveyAnswerStruct]()
            answerFormat.imageChoices.forEach { imageChoice in
                self.answerDictionary![imageChoice.value.hash] = RKXMultipleImageSelectionSurveyAnswerStruct(identifier: imageChoice.value, selected: false)
            }
            
            self.setupTextViews()
        }
    }
    
    func setupOptions(_ options: RKXMultipleImageSelectionSurveyOptions) {
        if let somethingSelectedButtonColor = options.somethingSelectedButtonColor {
            self.somethingSelectedButtonColor = somethingSelectedButtonColor
        }
        
        if let nothingSelectedButtonColor = options.nothingSelectedButtonColor {
            self.nothingSelectedButtonColor = nothingSelectedButtonColor
        }
        
        if let itemCellSelectedColor = options.itemCellSelectedColor {
            self.itemCellSelectedColor = itemCellSelectedColor
        }
        
        if let itemCellTextBackgroundColor = options.itemCellTextBackgroundColor {
            self.itemCellTextBackgroundColor = itemCellTextBackgroundColor
        }
        
        self.itemCellSelectedOverlayImage = options.itemCellSelectedOverlayImage
        
        if let itemCollectionViewBackgroundColor = options.itemCollectionViewBackgroundColor {
            self.itemCollectionViewBackgroundColor = itemCollectionViewBackgroundColor
        }
        
        if let itemsPerRow = options.itemsPerRow {
            self.itemsPerRow = itemsPerRow
        }
        
        if let itemMinSpacing = options.itemMinSpacing {
            self.itemMinSpacing = itemMinSpacing
        }
    }
    
//    func setupOptionsFromTask(task: RKXMultipleImageSelectionSurveyTask) {
//        if let somethingSelectedButtonColor = task.options?.somethingSelectedButtonColor {
//            self.somethingSelectedButtonColor = somethingSelectedButtonColor
//        }
//        
//        if let nothingSelectedButtonColor = task.options?.nothingSelectedButtonColor {
//            self.nothingSelectedButtonColor = nothingSelectedButtonColor
//        }
//        
//        if let itemCellSelectedColor = task.options?.itemCellSelectedColor {
//            self.itemCellSelectedColor = itemCellSelectedColor
//        }
//        
//        if let itemCellTextBackgroundColor = task.options?.itemCellTextBackgroundColor {
//            self.itemCellTextBackgroundColor = itemCellTextBackgroundColor
//        }
//        
//        self.itemCellSelectedOverlayImage = task.options?.itemCellSelectedOverlayImage
//        
//        if let itemCollectionViewBackgroundColor = task.options?.itemCollectionViewBackgroundColor {
//            self.itemCollectionViewBackgroundColor = itemCollectionViewBackgroundColor
//        }
//        
//        if let itemsPerRow = task.options?.itemsPerRow {
//            self.itemsPerRow = itemsPerRow
//        }
//        
//        if let itemMinSpacing = task.options?.itemMinSpacing {
//            self.itemMinSpacing = itemMinSpacing
//        }
//    }
    
    override var result: ORKStepResult? {
        guard let parentResult = super.result else {
            return nil
        }
        let step = self.step as? RKXMultipleImageSelectionSurveyStep
        
        let questionResult = ORKChoiceQuestionResult(identifier: step!.identifier)
        questionResult.choiceAnswers = self.selectedAnswers()
        questionResult.startDate = parentResult.startDate
        questionResult.endDate = parentResult.endDate
        
        parentResult.results = [questionResult]
        
        return parentResult
    }
    
    func getSelectedForValue(_ value: NSCoding & NSCopying & NSObjectProtocol) -> Bool? {
        guard let answerDictionary = self.answerDictionary,
            let answer = answerDictionary[value.hash]
            else { return nil }
        
        return answer.selected
    }
    
    func setSelectedForValue(_ value: NSCoding & NSCopying & NSObjectProtocol, selected: Bool) {
        self.answerDictionary![value.hash] = RKXMultipleImageSelectionSurveyAnswerStruct(identifier: value, selected: selected)
    }
    
    func selectedAnswers() -> [NSCoding & NSCopying & NSObjectProtocol]? {
        guard let answerDictionary = self.answerDictionary
            else { return nil }
        
        return answerDictionary.filter { (key, answer) in
            return answer.selected
            }
            .map { (key, selectedAnswer) in
                return selectedAnswer.identifier
        }
    }
    
    func clearSelectedAnswers() {
        if let selectedAnswers = self.selectedAnswers() {
            selectedAnswers.forEach { selectedAnswer in
                self.setSelectedForValue(selectedAnswer, selected: false)
            }
        }
    }
    
    var questionViewText: String? {
        if let step = self.step as? RKXMultipleImageSelectionSurveyStep {
            return step.title
        }
        else {
            return ""
        }
    }
    
    var additionalTextViewText: String? {
        return nil
    }
    
    var additionalTextViewHeight: CGFloat {
        return 0.0
    }
    
    func setupTextViews() {
        self.questionTextView?.text = self.questionViewText
        self.additionalTextView?.text = self.additionalTextViewText
        self.additionalTextViewHeightConstraint?.constant = self.additionalTextViewHeight
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let framework = Bundle(for: RKXMultipleImageSelectionSurveyViewController.self)
        self.imagesCollectionView.register(UINib(nibName: "RKXMultipleImageSelectionSurveyCollectionViewCell", bundle: framework), forCellWithReuseIdentifier: "rkx_miss_cell")
        
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.backgroundColor = self.itemCollectionViewBackgroundColor
//        self.imagesCollectionView.layer.borderWidth = 1.0
//        self.imagesCollectionView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        if let somethingSelectedButton = self.somethingSelectedButton as? RKXBorderedButton {
            somethingSelectedButton.configuredColor = self.somethingSelectedButtonColor
        }
        
        if let nothingSelectedButton = self.nothingSelectedButton as? RKXBorderedButton {
            nothingSelectedButton.configuredColor = self.nothingSelectedButtonColor
        }

        self.setupTextViews()
        
        if let step = self.step as? RKXMultipleImageSelectionSurveyStep,
            let options = step.options {
            self.setupOptions(options)
        }
        
//        if let taskViewController = self.taskViewController,
//            let task = taskViewController.task as? RKXMultipleImageSelectionSurveyTask {
//            self.setupOptionsFromTask(task)
//        }
        
        self.updateUI()
    }
    
    

    func updateUI() {
        //nothing to report button is visible IFF there are no selected images
        //submit button is visible IFF there are 1 or more selected images
        //submit button title contains the number of selected images
        if let selectedAnswers = self.selectedAnswers() {

            self.somethingSelectedButton.setTitle(self.somethingSelectedButtonText, for: UIControlState())
            self.nothingSelectedButton.setTitle(self.nothingSelectedButtonText, for: UIControlState())
            
            self.somethingSelectedButton.isHidden = !(selectedAnswers.count > 0)
            self.nothingSelectedButton.isHidden = (selectedAnswers.count > 0)
        }
        
        //reload collection view
        self.imagesCollectionView.reloadData()
    }
    
    func notifyDelegateAndMoveForward() {
        if let delegate = self.delegate {
            delegate.stepViewControllerResultDidChange(self)
        }
        self.goForward()
    }
    
    // MARK: - UICollectionView Methods
    func imageChoiceAtIndex(_ index: Int) -> ORKImageChoice? {
        guard let step = step as? RKXMultipleImageSelectionSurveyStep,
            let answerFormat = step.answerFormat as? ORKImageChoiceAnswerFormat
            else { return nil }
        
        return answerFormat.imageChoices[index]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let step = step as? RKXMultipleImageSelectionSurveyStep,
            let answerFormat = step.answerFormat as? ORKImageChoiceAnswerFormat
            else { return 0 }
        
        return answerFormat.imageChoices.count
    }
    
    func configureCellForImageChoice(_ missCell: RKXMultipleImageSelectionSurveyCollectionViewCell, imageChoice: ORKImageChoice) -> RKXMultipleImageSelectionSurveyCollectionViewCell {
        
        missCell.activityImage = imageChoice.normalStateImage
        missCell.selected = self.getSelectedForValue(imageChoice.value)!
        missCell.selectedBackgroundColor = self.itemCellSelectedColor
        missCell.selectedOverlayImage = self.itemCellSelectedOverlayImage
        missCell.textStackViewBackgroundColor = self.itemCellTextBackgroundColor
        
        return missCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rkx_miss_cell", for: indexPath)
        
        guard let missCell = cell as? RKXMultipleImageSelectionSurveyCollectionViewCell,
            let imageChoice = self.imageChoiceAtIndex(indexPath.row)
        else {
            return cell
        }
        
        return self.configureCellForImageChoice(missCell, imageChoice: imageChoice)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageChoice = self.imageChoiceAtIndex(indexPath.row)
            else { return }
        
        if !self.supportsMultipleSelection {
            if let currentlySelected = self.getSelectedForValue(imageChoice.value) {
                self.clearSelectedAnswers()
                self.setSelectedForValue(imageChoice.value, selected: !currentlySelected)
            }
            else {
                self.clearSelectedAnswers()
            }
        }
        else {
            self.setSelectedForValue(imageChoice.value, selected: !self.getSelectedForValue(imageChoice.value)!)
        }
        
        
        if self.transitionOnSelection {
            self.notifyDelegateAndMoveForward()
        }
        else {
            self.updateUI()
        }
        
    }
    
    var cellTextStackViewHeight: CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = (collectionViewWidth - CGFloat(self.itemsPerRow + 1)*self.itemMinSpacing) / CGFloat(self.itemsPerRow)
        return CGSize(width: cellWidth, height: cellWidth + self.cellTextStackViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.itemMinSpacing, left: self.itemMinSpacing, bottom: self.itemMinSpacing, right: self.itemMinSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.itemMinSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.itemMinSpacing
    }
    
    // MARK: - Subclass Functionality
    var supportsMultipleSelection: Bool {
        fatalError("Unimplemented")
    }
    
    var transitionOnSelection: Bool {
        fatalError("Unimplemented")
    }
    
    // MARK: - Button Methods and Properties
    // These must be overridden by subclasses
    
    var somethingSelectedButtonText: String {
        fatalError("Unimplemented")
    }
    
    var nothingSelectedButtonText: String {
        fatalError("Unimplemented")
    }
    
    @IBAction func somethingSelectedButtonPressed(_ sender: AnyObject) {
        fatalError("Unimplemented")
    }
    
    @IBAction func nothingSelectedButtonPressed(_ sender: AnyObject) {
        fatalError("Unimplemented")
    }
    
    
    //differing step behaviors
    
    
    
    
    
}
