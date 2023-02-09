//
//  ButtonLight.swift
//  VapeStore
//
//  Created by Crest Infosystems on 25/07/19.
//  Copyright © 2019 Crest Infosystems. All rights reserved.
//

import UIKit

class ButtonLight: BaseButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func commonInit() {
        self.setFont(UIFont.Font.OpenSansLight)
    }
    
}
