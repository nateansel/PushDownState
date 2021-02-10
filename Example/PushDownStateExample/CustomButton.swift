//
//  CustomButton.swift
//  Example
//
//  Created by Nikhil Menon on 2/4/21.
//

import UIKit
import PushDownState

class CustomButton: PushDownButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        pushDownBackgroundColor = .systemGroupedBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        pushDownBackgroundColor = .systemGroupedBackground
    }
}
