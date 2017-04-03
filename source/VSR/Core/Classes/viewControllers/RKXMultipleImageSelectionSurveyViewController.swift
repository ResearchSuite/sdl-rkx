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
    var imageChoice: ORKImageChoice
    var selected: Bool
}

open class RKXMultipleImageSelectionSurveyViewController: ORKStepViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var questionTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var somethingSelectedButton: UIButton!
    @IBOutlet weak var nothingSelectedButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var additionalTextView: UITextView!
    @IBOutlet weak var additionalTextViewHeightConstraint: NSLayoutConstraint!
    
    var _appeared: Bool = false
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self._appeared = true
    }
    
    override convenience init(step: ORKStep?) {
//        let framework = NSBundle(identifier: RKXBundleIdentifier)
        let framework = Bundle(for: RKXMultipleImageSelectionSurveyViewController.self)
        self.init(nibName: "RKXMultipleImageSelectionSurveyViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
//        self.restorationClass = RKXMultipleImageSelectionSurveyViewController.self
    }
    
    convenience override init(step: ORKStep?, result: ORKResult?) {
        self.init(step: step)
        if let stepResult = result {
            self.initializeAnswersForResult(result: stepResult)
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Params for user to configure
    var somethingSelectedButtonColor: UIColor? {
        didSet {
            if let somethingSelectedButton = self.somethingSelectedButton as? RKXBorderedButton {
                somethingSelectedButton.configuredColor = self.somethingSelectedButtonColor
                self.skipButton?.setTitleColor(self.somethingSelectedButtonColor, for: UIControlState.normal)
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
    
    func hashedValue(value: NSCoding & NSCopying & NSObjectProtocol) -> Int {
        if let valueDict = value as? [String: AnyObject] {
            let values: [AnyObject] = Array(valueDict.values)
            return values.reduce(0, { (acc, val) -> Int in
                return acc ^ val.hash
            })
        }
        else {
            return value.hash
        }
    }
    
    var maximumSelectedNumberOfItems: Int?
//    var isOptional: Bool! = true
    
    var visibilityFilter: ((NSCoding & NSCopying & NSObjectProtocol) -> Bool)? {
        guard let step = self.step as? RKXMultipleImageSelectionSurveyStep else {
            return nil
        }
        return step.visibilityFilter
    }
    
    
    var answerDictionary: [Int: RKXMultipleImageSelectionSurveyAnswerStruct]?
    
    //whenver step is set, initialize the answerArray
    override open var step: ORKStep? {
        didSet {
            guard let step = step as? RKXMultipleImageSelectionSurveyStep,
                let answerFormat = step.answerFormat as? ORKImageChoiceAnswerFormat
                else { return }
            
            self.answerDictionary = [Int: RKXMultipleImageSelectionSurveyAnswerStruct]()
            answerFormat.imageChoices.forEach { imageChoice in
                let hash = self.hashedValue(value: imageChoice.value)
                if let _ = self.answerDictionary![hash] {
                    assertionFailure("keys in answer dictionary must be unique!")
                }
                else {
//                    guard let identifier = self.identifierForImageChoice(imageChoice: imageChoice) else {
//                        assertionFailure("could not create identifier for imageChoice!")
//                        return
//                    }
                    self.answerDictionary![hash] = RKXMultipleImageSelectionSurveyAnswerStruct(imageChoice: imageChoice, selected: false)
                }
                
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
        
        if let maximumSelectedNumberOfItems = options.maximumSelectedNumberOfItems {
            self.maximumSelectedNumberOfItems = maximumSelectedNumberOfItems
        }
        
//        if let optional = options.optional {
//            self.isOptional = optional
//        }
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
    
    open func valueForImageChoice(_ imageChoice: ORKImageChoice) -> NSCoding & NSCopying & NSObjectProtocol {
        
        return imageChoice.value
        
    }

    
    
    override open var result: ORKStepResult? {
        guard let parentResult = super.result else {
            return nil
        }
        if self._appeared {
            let step = self.step as? RKXMultipleImageSelectionSurveyStep
            
            let questionResult = RKXMultipleImageSelectionSurveyResult(identifier: step!.identifier)
            questionResult.choiceAnswers = self.selectedAnswers()?.map(self.valueForImageChoice)
            questionResult.startDate = parentResult.startDate
            questionResult.endDate = parentResult.endDate
            questionResult.questionType = self.supportsMultipleSelection ? .multipleChoice : .singleChoice
            questionResult.selectedIdentifiers = self.selectedAnswers()?.map(self.valueForImageChoice) as? [String]
            questionResult.excludedIdentifiers = (self.step as? RKXMultipleImageSelectionSurveyStep)?.excludedIdentifiers
            questionResult.notSelectedIdentifiers = {
                guard let selectedIdentifiers = questionResult.selectedIdentifiers,
                    let excludedIdentifiers = questionResult.excludedIdentifiers,
                    let step = step as? RKXMultipleImageSelectionSurveyStep,
                    let answerFormat = step.answerFormat as? ORKImageChoiceAnswerFormat else {
                        return nil
                }
                
                let selectedSet: Set<String> = Set(selectedIdentifiers)
                let excludedSet: Set<String> = Set(excludedIdentifiers)
                let totalSet: Set<String> = Set(answerFormat.imageChoices.flatMap({$0.value as? String}))
                let notSelectedSet = totalSet.subtracting(excludedSet).subtracting(selectedSet)
                
                return Array(notSelectedSet)
            }()
            
            print(questionResult)
            parentResult.results = [questionResult]
        }
        
        
        return parentResult
    }
    
    
    //TODO: load up results
    //rethink how to handle things like PAM that don;t support multiple selection
    func initializeAnswersForResult(result: ORKResult) {
        print(result)
    }
    
    func getSelectedForImageChoice(imageChoice: ORKImageChoice) -> Bool? {
        let hash = self.hashedValue(value: imageChoice.value)
        guard let answerDictionary = self.answerDictionary,
            let answer = answerDictionary[hash]
            else { return nil }
        
        return answer.selected
    }
    
    func setSelectedForImageChoice(imageChoice: ORKImageChoice, selected: Bool) {
        let hash = self.hashedValue(value: imageChoice.value)
        self.answerDictionary![hash] = RKXMultipleImageSelectionSurveyAnswerStruct(imageChoice: imageChoice, selected: selected)
    }
    
    func selectedAnswers() -> [ORKImageChoice]? {
        guard let answerDictionary = self.answerDictionary
            else { return nil }
        
        return answerDictionary.filter { (key, answer) in
            return answer.selected
            }
            .map { (key, selectedAnswer) in
                return selectedAnswer.imageChoice
        }
    }
    
    func clearSelectedAnswers() {
        if let selectedAnswers = self.selectedAnswers() {
            selectedAnswers.forEach { selectedAnswer in
                self.setSelectedForImageChoice(imageChoice: selectedAnswer, selected: false)
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

    override open func viewDidLoad() {
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
        
        self.skipButton.setTitleColor(self.somethingSelectedButtonColor, for: UIControlState.normal)
        if let step = self.step {
            let optional = step.isOptional
            self.skipButton.isHidden = !optional
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
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let sizeThatFits = self.questionTextView.sizeThatFits(CGSize(width: self.questionTextView.frame.size.width, height: CGFloat(MAXFLOAT)))
        self.questionTextViewHeightConstraint.constant = sizeThatFits.height
        
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
            
            self.nothingSelectedButton.isEnabled = self.step?.isOptional ?? false
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
    
    var visibleImageChoices:[ORKImageChoice]? {
        guard let step = step as? RKXMultipleImageSelectionSurveyStep,
            let answerFormat = step.answerFormat as? ORKImageChoiceAnswerFormat
            else { return [] }
        
        if let visibilityFilterFunction = self.visibilityFilter {
            return answerFormat.imageChoices.filter { imageChoice in
                return visibilityFilterFunction(imageChoice.value)
            }
        }
        else {
            return answerFormat.imageChoices
        }
    }
    
    // MARK: - UICollectionView Methods
    func imageChoiceAtIndex(_ index: Int) -> ORKImageChoice? {
        guard let imageChoices = self.visibleImageChoices
            else { return nil }
        
        return imageChoices[index]
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let imageChoices = self.visibleImageChoices
            else { return 0 }
        
        return imageChoices.count
    }
    
    func configureCellForImageChoice(_ missCell: RKXMultipleImageSelectionSurveyCollectionViewCell, imageChoice: ORKImageChoice) -> RKXMultipleImageSelectionSurveyCollectionViewCell {
        
        missCell.activityImage = imageChoice.normalStateImage
        missCell.isSelected = self.getSelectedForImageChoice(imageChoice: imageChoice) ?? false
        missCell.selectedBackgroundColor = self.itemCellSelectedColor
        missCell.selectedOverlayImage = self.itemCellSelectedOverlayImage
        missCell.textStackViewBackgroundColor = self.itemCellTextBackgroundColor
        
        return missCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rkx_miss_cell", for: indexPath)
        
        guard let missCell = cell as? RKXMultipleImageSelectionSurveyCollectionViewCell,
            let imageChoice = self.imageChoiceAtIndex(indexPath.row)
        else {
            return cell
        }
        
        return self.configureCellForImageChoice(missCell, imageChoice: imageChoice)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageChoice = self.imageChoiceAtIndex(indexPath.row)
            else { return }
        
        if !self.supportsMultipleSelection {
            if let currentlySelected = self.getSelectedForImageChoice(imageChoice: imageChoice) {
                self.clearSelectedAnswers()
                self.setSelectedForImageChoice(imageChoice: imageChoice, selected: !currentlySelected)
            }
            else {
                self.clearSelectedAnswers()
            }
        }
        else {
            
            //if we will be selecting the item, check to see that we have not reached the max amount
            if  let isSelected = self.getSelectedForImageChoice(imageChoice: imageChoice),
                isSelected == false,
                let maxNumberOfSelections = self.maximumSelectedNumberOfItems,
                let answers = self.selectedAnswers() {
                if answers.count < maxNumberOfSelections {
                    self.setSelectedForImageChoice(imageChoice: imageChoice, selected: !self.getSelectedForImageChoice(imageChoice: imageChoice)!)
                }
            }
            else {
                self.setSelectedForImageChoice(imageChoice: imageChoice, selected: !self.getSelectedForImageChoice(imageChoice: imageChoice)!)
            }
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
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = (collectionViewWidth - CGFloat(self.itemsPerRow + 1)*self.itemMinSpacing) / CGFloat(self.itemsPerRow)
        return CGSize(width: cellWidth, height: cellWidth + self.cellTextStackViewHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.itemMinSpacing, left: self.itemMinSpacing, bottom: self.itemMinSpacing, right: self.itemMinSpacing)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.itemMinSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
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

    @IBAction func skipButtonPressed(_ sender: Any) {
        self.notifyDelegateAndMoveForward()
    }
    
    
    //differing step behaviors
    
    
    
    
    
}
