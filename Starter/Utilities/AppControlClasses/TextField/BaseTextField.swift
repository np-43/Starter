//
//  BaseTextField.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import UIKit

class BaseTextField: UITextField {
    
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
    
    @IBInspectable
    var leftPadding: CGFloat = 10
    
    @IBInspectable
    var rightPadding: CGFloat = 5
    
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        self.applyCommonTheme()
//    }
//
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: self.padding)
//    }
//
//    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: self.padding)
//    }
//
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: self.padding)
//    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += self.leftPadding
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= self.rightPadding
        return rect
    }
    
    func commonInit() {}
    
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

extension BaseTextField {
    
    fileprivate func applyCommonTheme() {
        self.borderStyle = .none
        self.backgroundColor = UIColor.init(hex: "#F5F5F6")
    }
    
}
