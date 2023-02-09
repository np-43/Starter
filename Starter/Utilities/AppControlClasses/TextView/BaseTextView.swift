//
//  BaseTextView.swift
//  VapeStore
//
//  Created by Crest Infosystems on 29/07/19.
//  Copyright © 2019 Crest Infosystems. All rights reserved.
//

import UIKit

protocol BaseTextViewDelegate {
    func textViewDidBeginEditing(_ baseTextView: BaseTextView)
    func textViewDidEndEditing(_ baseTextView: BaseTextView)
    func textViewDidChange(_ baseTextView: BaseTextView)
    func textView(_ baseTextView: BaseTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
}

class BaseTextView: UITextView {
    
    @IBInspectable
    var textStyleValue: Int = TextStyle.none.value {
        didSet {
            self.applyFontTextStyle()
        }
    }
    
    var textStyle: TextStyle {
        if self.textStyleValue == TextStyle.largeTitle.value {
            return .largeTitle
        } else if self.textStyleValue == TextStyle.title1.value {
            return .title1
        } else if self.textStyleValue == TextStyle.title2.value {
            return .title2
        } else if self.textStyleValue == TextStyle.title3.value {
            return .title3
        } else if self.textStyleValue == TextStyle.headline.value {
            return .headline
        } else if self.textStyleValue == TextStyle.body.value {
            return .body
        } else if self.textStyleValue == TextStyle.callout.value {
            return .callout
        } else if self.textStyleValue == TextStyle.subheadline.value {
            return .subheadline
        } else if self.textStyleValue == TextStyle.footnote.value {
            return .footnote
        } else if self.textStyleValue == TextStyle.caption1.value {
            return .caption1
        } else if self.textStyleValue == TextStyle.caption2.value {
            return .caption2
        }
        return .none
    }
    
    fileprivate var placeholderLabel: UILabel!
    fileprivate let placeholderLabelTag: Int = 100
    
    @IBInspectable
    var placeholderText: String? {
        didSet {
            if self.placeholderLabel != nil {
                self.placeholderLabel.text = self.placeholderText
            }
            self.setupPlaceholder()
        }
    }
    
    @IBInspectable
    var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            self.setupPlaceholder()
        }
    }
    
    @IBInspectable
    var topPadding: CGFloat = 0 {
        didSet {
            self.setPadding()
        }
    }
    
    @IBInspectable
    var bottomPadding: CGFloat = 0 {
        didSet {
            self.setPadding()
        }
    }
    
    @IBInspectable
    var leftPadding: CGFloat = 0 {
        didSet {
            self.setPadding()
        }
    }
    
    @IBInspectable
    var rightPadding: CGFloat = 0 {
        didSet {
            self.setPadding()
        }
    }
    
    override var textColor: UIColor? {
        didSet {
            self.tintColor = self.textColor
        }
    }
    
    var placeholderAlignment : NSTextAlignment = .left {
        didSet {
            self.setupPlaceholder()
        }
    }
    
    var baseDelegate: BaseTextViewDelegate?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.tintColor = self.textColor
    }
    
    func commonInit() {
        self.setupPlaceholder()
    }
    
    func setFont(_ fontEnum: UIFont.Font) {
        self.font = UIFont.font(fontEnum, fontSize: self.font?.pointSize ?? 15)
        self.applyFontTextStyle()
    }
    
    func applyFontTextStyle() {
        if self.textStyle != .none {
            self.font = self.font?.getFontTextStyled(self.textStyle.textStyle)
            self.adjustsFontForContentSizeCategory = true
        }
    }
    
}

extension BaseTextView {
    
    func setupPlaceholder() {
        
        if let label = self.subviews.filter({($0 as? UILabel)?.tag == self.placeholderLabelTag}).first as? UILabel {
            label.removeFromSuperview()
        }
        
        self.delegate = self
        self.placeholderLabel = UILabel()
        self.placeholderLabel.tag = self.placeholderLabelTag
        self.placeholderLabel.text = self.placeholderText
        self.placeholderLabel.font = self.font
        self.placeholderLabel.numberOfLines = 0
        self.placeholderLabel.textAlignment = self.placeholderAlignment
        self.addSubview(self.placeholderLabel)
        
        self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        let superViewMargins = self.layoutMarginsGuide
        
        let constant = (self.font!.pointSize/2) - 5
        
        self.placeholderLabel.leadingAnchor.constraint(equalTo: superViewMargins.leadingAnchor, constant: (0 - constant)).isActive = true
        self.placeholderLabel.trailingAnchor.constraint(equalTo: superViewMargins.trailingAnchor, constant: constant).isActive = true
        self.placeholderLabel.topAnchor.constraint(equalTo: superViewMargins.topAnchor, constant: 0).isActive = true
        self.placeholderLabel.bottomAnchor.constraint(lessThanOrEqualTo: superViewMargins.bottomAnchor, constant: 0).isActive = true
        
        self.placeholderLabel.textColor = self.placeholderColor
        self.updatePlaceholderLabelHiddenAttribute(self.text)
        
    }
    
    func updatePlaceholderLabelHiddenAttribute(_ text: String) {
        DispatchQueue.main.async {
            self.placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
    fileprivate func defaultAttributes() -> [NSAttributedString.Key : Any] {
        let attributes = [NSAttributedString.Key.foregroundColor : self.textColor,
                          NSAttributedString.Key.font: self.font]
        return attributes as [NSAttributedString.Key : Any]
    }
    
    fileprivate func setPadding() {
        self.textContainerInset = UIEdgeInsets.init(top: self.topPadding, left: self.leftPadding, bottom: self.bottomPadding, right: self.rightPadding)
    }
    
}

extension BaseTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let color = textView.textColor
        textView.tintColor = .clear
        textView.tintColor = color
        self.baseDelegate?.textViewDidBeginEditing(self)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updatePlaceholderLabelHiddenAttribute(textView.text)
        self.baseDelegate?.textViewDidChange(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return self.baseDelegate?.textView(self, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.baseDelegate?.textViewDidEndEditing(self)
    }
    
}

