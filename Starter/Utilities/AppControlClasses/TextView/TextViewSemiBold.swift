//
//  TextViewSemiBold.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import UIKit

class TextViewSemiBold: BaseTextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func commonInit() {
        self.setFont(UIFont.Font.OpenSansSemiBold)
    }
    
}
