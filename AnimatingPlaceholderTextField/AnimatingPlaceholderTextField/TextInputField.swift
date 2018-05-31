//
//  TextInputField.swift
//  TextInputField
//
//  Created by Sooraj K S on 29/05/18.
//  Copyright © 2018 techjini. All rights reserved.
//

import UIKit

class TextInputField: UITextField {
    
    // MARK: - Public Variables
    var shouldEnableMaterialPlaceHolder: Bool = true
    var isUnderLineAvailabe: Bool = true
    let underLine = UIView()
    static var animate:Bool = true
    // MARK: - Private Variables
    private var placeholderLabel = UILabel()
    private var placeholderOffset: CGFloat {
        return self.defaultFont.pointSize + 2.0
    }
    
    private var defaultFont : UIFont {
        return self.font ?? UIFont.systemFont(ofSize: 17.0)
    }
    
    private var isUnderLineAdded: Bool = false
    
    // MARK: - Constraints
    private var placeHolderBottomConstraint: NSLayoutConstraint!
    
    private var placeHolderRightConstraint: NSLayoutConstraint!
    
    // MARK: - Custom Properties
    @IBInspectable var placeHolderColor: UIColor = UIColor.lightGray {
        didSet {
            if let placeholder = self.placeholder {
                let attrib: [NSAttributedStringKey : Any]  = [.foregroundColor: placeHolderColor,
                                                              .font: defaultFont.pointSize]
                self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                attributes: attrib)
            }
        }
    }
    
    internal var attributedPlaceholderText: NSAttributedString? {
        willSet {
            if self.placeholderLabel.attributedText != newValue {
                if let value = newValue {
                    self.setPlaceholder(value.string)
                } else {
                    self.setPlaceholder("")
                }
            }
        }
    }
    
    // MARK: - Overriden Properties
    override internal var placeholder: String? {
        willSet {
            if self.placeholderLabel.text != newValue {
                if let value = newValue {
                    self.setPlaceholder(value)
                } else {
                    self.setPlaceholder("")
                }
            }
        }
    }
    
    override internal var text: String? {
        didSet {
            if self.placeholderLabel.text == nil  {
                self.initialize()
            }
            self.textFieldDidChange()
        }
    }
    
    // MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if self.placeholderLabel.text == nil {
            self.initialize()
        }
    }
    
    // MARK: - TextView Delegate Bridges
    override func becomeFirstResponder() -> Bool {
        let returnValue = super.becomeFirstResponder()
        return returnValue
    }
    
    override func resignFirstResponder() -> Bool {
        let returnValue = super.resignFirstResponder()
        return returnValue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Private Methods
    
    func initialize() {
        self.clipsToBounds = false
        self.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
        self.enableMaterialPlaceHolder()
        
        if isUnderLineAvailabe {
            if self.isUnderLineAdded {
                self.underLine.removeFromSuperview()
            }
            
            self.underLine.backgroundColor = UIColor.gray
            self.underLine.clipsToBounds = true
            self.addSubview(underLine)
            self.underLine.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.init(item: self.underLine,
                                    attribute: .left,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .left,
                                    multiplier: 1.0,
                                    constant: 0.0).isActive = true
            NSLayoutConstraint.init(item: self.underLine,
                                    attribute: .right,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .right,
                                    multiplier: 1.0,
                                    constant: 0.0).isActive = true
            NSLayoutConstraint.init(item: self.underLine,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .bottom,
                                    multiplier: 1.0,
                                    constant: 4.0).isActive = true
            NSLayoutConstraint.init(item: self.underLine,
                                    attribute: .height,
                                    relatedBy: .equal,
                                    toItem: nil,
                                    attribute: .notAnAttribute,
                                    multiplier: 1.0,
                                    constant: 0.5).isActive = true
            
            self.isUnderLineAdded = true
        }
    }
    
    @objc private func textFieldDidChange() {
        if self.shouldEnableMaterialPlaceHolder {
            let fontSize = self.defaultFont.pointSize
            if self.text == nil || self.text!.count <= 0 {
                self.placeholderLabel.font = UIFont.systemFont(ofSize: fontSize)
                self.placeHolderBottomConstraint.constant = 0
                if let rightView = self.rightView {
                    self.placeHolderRightConstraint.constant = -rightView.frame.width
                }
            } else {
                self.placeholderLabel.font = UIFont.systemFont(ofSize: fontSize - 2)
                self.placeHolderBottomConstraint.constant = -self.placeholderOffset
                if let rightView = self.rightView {
                    self.placeHolderRightConstraint.constant = -rightView.frame.width
                }
            }
            
            UIView.animate(withDuration: TextInputField.animate ? 0.5 : 0,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseIn,
                           animations: {
                            if self.text == nil || self.text!.count <= 0 {
                                self.placeholderLabel.alpha = 0
                            } else {
                                self.placeholderLabel.alpha = 1
                            }
                            
                            self.setNeedsLayout()
                            self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    private func enableMaterialPlaceHolder() {
        let fontSize = self.defaultFont.pointSize
        if self.text == nil || self.text!.count <= 0 {
            self.placeholderLabel.alpha = 0
            self.placeholderLabel.font = UIFont.systemFont(ofSize: fontSize)
        } else {
            self.placeholderLabel.alpha = 1
            self.placeholderLabel.font = UIFont.systemFont(ofSize: fontSize - 2)
        }
        
        self.placeholderLabel.clipsToBounds = true
        self.addSubview(self.placeholderLabel)
        self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if self.placeHolderBottomConstraint == nil {
            NSLayoutConstraint.init(item: self.placeholderLabel,
                                    attribute: .left,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .left,
                                    multiplier: 1.0,
                                    constant: 0.0).isActive = true
            NSLayoutConstraint.init(item: self.placeholderLabel,
                                    attribute: .height,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .height,
                                    multiplier: 1.0,
                                    constant: 0.0).isActive = true
            self.placeHolderBottomConstraint = NSLayoutConstraint(item: self.placeholderLabel,
                                                                  attribute: .bottom,
                                                                  relatedBy: .equal,
                                                                  toItem: self,
                                                                  attribute: .bottom,
                                                                  multiplier: 1.0,
                                                                  constant: 0.0)
            self.placeHolderBottomConstraint.isActive = true
            self.placeHolderRightConstraint = NSLayoutConstraint.init(item: self.placeholderLabel,
                                                                      attribute: .right,
                                                                      relatedBy: .equal,
                                                                      toItem: self,
                                                                      attribute: .right,
                                                                      multiplier: 1.0,
                                                                      constant: 0.0)
            self.placeHolderRightConstraint.isActive =  true
        }
        
        self.placeholderLabel.textColor = self.placeHolderColor
        self.placeholderLabel.attributedText = self.attributedPlaceholder
        self.attributedPlaceholder = nil
    }
    
    private func setPlaceholder(_ value: String) {
        let font: UIFont = self.text == nil || self.text!.count <= 0 ?
            UIFont.systemFont(ofSize: defaultFont.pointSize) :
            UIFont.systemFont(ofSize: defaultFont.pointSize - 2)
        
        let attrib: [NSAttributedStringKey : Any]  = [.foregroundColor: placeHolderColor,
                                                      .font: font]
        self.attributedPlaceholder = NSAttributedString(string: value,
                                                        attributes: attrib)
        self.enableMaterialPlaceHolder()
    }
}

