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
	override var isHighlighted: Bool {
		didSet {
			changeColors(highlighted: isHighlighted)
		}
	}
	
	private func changeColors(highlighted: Bool) {
		UIView.animate(withDuration: pushDownDuration) { [unowned self] in
			if highlighted {
				self.backgroundColor = .groupTableViewBackground
			} else {
				self.backgroundColor = nil
			}
		}
	}
}
