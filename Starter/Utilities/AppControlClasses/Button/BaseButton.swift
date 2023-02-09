//
//  BaseButton.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import UIKit

class BaseButton: UIButton {
    
    @IBInspectable
    var textStyleValue: Int = TextStyle.none.value {
        didSet {
            self.applyFontTextStyle()
        }
    }
    
    @IBInspectable
    var addUnderline: Bool = false {
        didSet {
            if addUnderline {
                self.underlineText()
            }
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {}
    
    func underlineText() {
      guard let title = title(for: .normal) else { return }
      let titleString = NSMutableAttributedString(string: title)
      titleString.addAttribute(
        .underlineStyle,
        value: NSUnderlineStyle.single.rawValue,
        range: NSRange(location: 0, length: title.count)
      )
      setAttributedTitle(titleString, for: .normal)
    }
    
    func setFont(_ fontEnum: UIFont.Font) {
        self.titleLabel?.font = UIFont.font(fontEnum, fontSize: self.titleLabel?.font.pointSize ?? 15)
        self.applyFontTextStyle()
    }
    
    func applyFontTextStyle() {
        if self.textStyle != .none {
            self.titleLabel?.font = self.titleLabel?.font.getFontTextStyled(self.textStyle.textStyle)
            self.titleLabel?.adjustsFontForContentSizeCategory = true
        }
    }
    
}

