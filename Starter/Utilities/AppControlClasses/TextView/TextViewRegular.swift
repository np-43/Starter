//
//  TextViewRegular.swift
//  VapeStore
//
//  Created by Crest Infosystems on 29/07/19.
//  Copyright © 2019 Crest Infosystems. All rights reserved.
//

import UIKit

class TextViewRegular: BaseTextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func commonInit() {
        self.setFont(UIFont.Font.OpenSansRegular)
    }
    
}
