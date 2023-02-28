//
//  OneTimeCodeField.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class OneTimeCodeField: UIControl {
    
    enum FieldState {
        case empty
        case filled
        case respoding
    }
    
    var digit: Int = 6 {
        didSet {
            self.setNeedsDisplay()
            prepareStackItems(for: self.digit)
        }
    }
    
    var spacing: CGFloat = 12
    var onCompletion: ((String)->())?
    var keyboardType: UIKeyboardType = .numberPad
    var textContentType: UITextContentType = .oneTimeCode
    
    // MARK: - ToolBar Management
    private lazy var toolBar: UIToolbar = {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(resignFirstResponder))
        ]
        toolBar.tintColor = UIColor.blue
        
        return toolBar
    }()
    
    override var inputAccessoryView: UIView? {
        return toolBar
    }
    
    // MARK:- Private Properties
    
    /// Used to store the individual labels for the key-input
    private var labels: [UILabel] = []
    private var layers: [CAShapeLayer] = []
    
    /// Cursor management for label to fill key-input
    private var currentIndex: Int = 0
    
    // MARK:- Computed Properities
    private var yPosition: CGFloat {
        return self.bounds.height - 2
    }
    
    private var individualWidth: CGFloat {
        return (self.bounds.width - (CGFloat(digit - 1) * spacing)) / CGFloat(digit)
    }
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        return tapGesture
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = self.spacing
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    // MARK: - Overriding Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        for index in 0..<digit {
            let placeLayer = shapeLayer(at: index)
            self.layer.addSublayer(placeLayer)
            self.layers.append(placeLayer)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        let previousFieldEmpty = labels[currentIndex].text?.count ?? 0 <= 0
        self.updateState(previousFieldEmpty ? .empty : .filled, at: currentIndex)
        return super.resignFirstResponder()
    }
    
    // MARK: - Configurations
    private func setup() {
        self.addGestureRecognizer(tapGesture)
        prepareStackItems(for: digit)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
        
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func prepareStackItems(for digit: Int) {
        self.stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        labels.removeAll()
        for _ in 0..<digit {
            let label = self.label()
            stackView.addArrangedSubview(label)
            labels.append(label)
        }
    }
  
    private func position(for index: Int) -> CGPoint {
        let xPosition = CGFloat(index) * (individualWidth + spacing)
        return CGPoint(x: xPosition, y: yPosition)
    }
    
    private func label() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }
    
    private func shapeLayer(at index: Int) -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.frame.size = CGSize(width: individualWidth, height: 2)
        layer.frame.origin = position(for: index)
        layer.cornerRadius = 1
        layer.masksToBounds = true
        return layer
    }
    
    // MARK: - Tap Action
    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        if hasText {
            let previousFieldEmpty = labels[currentIndex].text?.count ?? 0 <= 0
            let location = sender.location(in: self)
            let frame = CGRect(origin: location, size: CGSize(width: individualWidth, height: self.bounds.height))
            if let index = self.labels.firstIndex(where: {$0.frame.intersects(frame)}) {
                self.updateState(previousFieldEmpty ? .empty : .filled, at: currentIndex)
                self.currentIndex = index
                self.updateState(.respoding, at: index)
            }
        } else {
            updateState(.respoding, at: currentIndex)
        }
        self.becomeFirstResponder()
    }
    
    // MARK: - Computed property for all texts.
    var text: String? {
        labels.reduce("") { (result, label) -> String in
            result + (label.text ?? "")
        }
    }
}

// MARK:- State Decodation
extension OneTimeCodeField {
    
    private func updateState(_ state: FieldState, at index: Int) {
        guard let layer = self.layers[safe: index] else { return }
        switch state {
        case .filled:
            layer.backgroundColor = UIColor.darkGray.cgColor
            layer.borderWidth = 0
            layer.frame.size.height = 2
            layer.frame.origin.y = self.bounds.height - 2
            layer.cornerRadius = 1
        case .empty:
            layer.backgroundColor = UIColor.lightGray.cgColor
            layer.borderWidth = 0
            layer.frame.origin.y = self.bounds.height - 2
            layer.frame.size.height = 2
            layer.cornerRadius = 1
        case .respoding:
            layer.backgroundColor = UIColor.systemBlue.cgColor
            layer.frame.origin.y = self.bounds.height - 5
            layer.frame.size.height = 5
            layer.cornerRadius = 2.5
        }
    }
}

// MARK: - UIKeyInput
extension OneTimeCodeField: UIKeyInput {
    
    //MARK: Computed Property/Functions
    private var textCount: Int {
        let count = labels.reduce(0) { (result, label) -> Int in
            return result + (label.text?.count ?? 0)
        }
        return count
    }
    
    private func resignFirstResponderIfNeeded() -> Bool {
        if currentIndex >= (digit - 1), let text = text {
            self.onCompletion?(text)
            resignFirstResponder()
            return true
        }
        return false
    }
    
    //MARK: UIKeyInput Protocol Requirements
    var hasText: Bool {
        textCount > 0
    }
    
    func insertText(_ text: String) {
        if text.count == digit {
            for (index, character) in text.enumerated() {
                labels[index].text = String(character)
                currentIndex = index
                updateState(.filled, at: currentIndex)
            }
            if resignFirstResponderIfNeeded() {
                return
            }
        } else {
            guard let label = labels[safe: currentIndex] else { return }
            label.text = text
            updateState(.filled, at: currentIndex)
            if resignFirstResponderIfNeeded() {
                return
            }
            currentIndex += 1
            updateState(.respoding, at: currentIndex)
            return
        }
    }
    
    func deleteBackward() {
        let label = labels[safe: currentIndex]
        label?.text = nil
        updateState(.empty, at: currentIndex)
        if currentIndex <= 0 {
            currentIndex = 0
            updateState(.respoding, at: currentIndex)
            return
        }
        currentIndex -= 1
        updateState(.respoding, at: currentIndex)
    }
}


private extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

// MARK: - UITextInput Protocol Requirements
/// For OneTimeCode to be appear on UIKeyboard
/// So this just fills the empty requirement since it does not do any editing, marking, tokenizing
extension OneTimeCodeField: UITextInput {
    func replace(_ range: UITextRange, withText text: String) {}
    
    var tokenizer: UITextInputTokenizer { UITextInputStringTokenizer() }
    
    var selectedTextRange: UITextRange? {
        get { nil }
        set(selectedTextRange) {}
    }
    
    var markedTextRange: UITextRange? { nil }
    
    var markedTextStyle: [NSAttributedString.Key : Any]? {
        get { nil }
        set(markedTextStyle) {}
    }
    
    var inputDelegate: UITextInputDelegate? {
        get { nil }
        set(inputDelegate) {}
    }
    
    func setMarkedText(_ markedText: String?, selectedRange: NSRange) {}
    
    func unmarkText() {}
    
    var beginningOfDocument: UITextPosition { .init() }
    
    var endOfDocument: UITextPosition { .init() }
    
    func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? { nil }
    
    func position(from position: UITextPosition, offset: Int) -> UITextPosition? { nil }
    
    func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? { nil }
    
    func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult { .orderedSame }
    
    func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int { 0 }
    
    func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? { nil }
    
    func characterRange(byExtending position: UITextPosition, in direction: UITextLayoutDirection) -> UITextRange? { nil }
    
    func baseWritingDirection(for position: UITextPosition, in direction: UITextStorageDirection) -> NSWritingDirection { .natural }
    
    func setBaseWritingDirection(_ writingDirection: NSWritingDirection, for range: UITextRange) {}
    
    func firstRect(for range: UITextRange) -> CGRect { .zero }
    
    func caretRect(for position: UITextPosition) -> CGRect { .zero }
    
    func selectionRects(for range: UITextRange) -> [UITextSelectionRect] { []}
    
    func closestPosition(to point: CGPoint) -> UITextPosition? { nil }
    
    func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? { nil }
    
    func characterRange(at point: CGPoint) -> UITextRange? { nil }
    
    func text(in range: UITextRange) -> String? { text }
}


extension Array {
    subscript(safe index: Array.Index) -> Element? {
        if index < 0 || index >= self.count { return nil }
        return self[index]
    }
}

