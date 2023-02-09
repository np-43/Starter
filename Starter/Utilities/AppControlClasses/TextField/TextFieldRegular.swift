//
//  TextFieldRegular.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import UIKit

class TextFieldRegular: BaseTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func commonInit() {
        self.setFont(UIFont.Font.OpenSansRegular)
    }
    
}
