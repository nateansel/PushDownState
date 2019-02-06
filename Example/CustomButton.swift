//
//  CustomButton.swift
//  PushDownState
//
//  Created by Nathan Ansel on 2/25/17.
//  Copyright © 2017 Nathan Ansel. All rights reserved.
//

import UIKit
import PushDownState

class CustomButton: PushDownButton {
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.pushDownBackgroundColor = .groupTableViewBackground
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.pushDownBackgroundColor = .groupTableViewBackground
	}
}
