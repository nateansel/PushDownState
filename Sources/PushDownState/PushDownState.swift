//
//  PushDownState.swift
//  PushDownState
//
//  Created by Nathan Ansel on 2/25/17.
//  Copyright © 2017 Nathan Ansel. All rights reserved.
//

import UIKit

internal enum DefaultValues {
	static let pushDownDuration: TimeInterval = 0.1
    /// The scale effect value for pushdown animations.
	static let pushDownScale: CGFloat = 0.95
    /// Default toggle for round corner effect.
	static let pushDownRoundCorners: Bool = true
    /// The value of the corner radius when a PushDownButton is pushed
    static let pushedCornerRadius: CGFloat = 8
}

internal extension UIView {
    /// State that represents if a view is in a "pressed" or "unpressed" position.
	enum PushState {
        /// Indicateds the view is not pressed.
		case up
        /// Indicates the view is pressed.
		case down
	}
}

/// Protocol that introduces requirements for animating push down button presses.
@objc internal protocol PushDownView: class {
	/// The duration for the push down animation to last. Default value is 0.1
	/// seconds.
	var pushDownDuration: TimeInterval { get set }
	
	/// The scale for the push down effect to take. Default value is 0.95.
	/// Values should be a percent between 0.0 and 1.0.
	var pushDownScale: CGFloat { get set }
	
	/// Whether or not the corners of the UIView should be rounded. If true, the
	/// corners will be rounded to a value of 8. If the corners are already
	/// rounded to a value greater than 8, the corner radius will not change.
	/// Default value is true.
	var pushDownRoundCorners: Bool { get set }
	
    /// The background color of the view when a view is pressed.
    var pushDownBackgroundColor: UIColor? { get set }
    
    /// The original background color of the view when the view is not pressed.
	var originalBackgroundColor: UIColor? { get set }
    
    /// The original corner radius of the view when the view is not pressed.
	var originalCornerRadius: CGFloat { get set }
    
    /// Original masks to layer
	var originalMasksToLayer: Bool { get set }
    
    /// The toggle set for animations on a `PushDownView`.
	var isAnimating: Bool { get set }
    
    /// Closure that performs additional animations
	var animationsToComplete: (()->())? { get set }
}

// MARK: - Animations

internal extension PushDownView where Self: UIView {
    
    /// Animates a pushdown effect to the given state.
	func animatePush(toState: UIView.PushState) {
		if !isAnimating {
			isAnimating = true
			UIView.animate(
				withDuration: pushDownDuration,
				delay: 0,
				options: .curveEaseInOut,
				animations: { [weak self] in
					self?.snapPush(toState: toState)
				},
                completion: { [weak self] _ in
					self?.isAnimating = false
					self?.animationsToComplete?()
					self?.animationsToComplete = nil
			})
		} else {
			animationsToComplete = { [weak self] in
				self?.animatePush(toState: toState)
			}
		}
	}
	
    /// Performs animation to reach the given Push state.
    /// - Animations Performed:
    ///     -  Changes background color if the `pushDownBackgroundColor` is set for the PushDownView.
    ///     - `easeInEaseOut` animation on the corner radius if the `pushDownRoundCorners` toggle is set to `true`.
	func snapPush(toState: PushState) {
        let pushedCornerRadius = DefaultValues.pushedCornerRadius
        let animationKeyPath = "cornerRadius"
        
		switch toState {
		case .up:
			transform = CGAffineTransform.identity
            
			if let _ = pushDownBackgroundColor {
				backgroundColor = originalBackgroundColor
			}
            
			if pushDownRoundCorners {
                if originalCornerRadius < pushedCornerRadius {
					layer.masksToBounds = originalMasksToLayer
					let animation = CABasicAnimation(keyPath: animationKeyPath)
					animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
					animation.fromValue = layer.cornerRadius
					animation.toValue = originalCornerRadius
					animation.duration = pushDownDuration
					layer.add(animation, forKey: animation.keyPath)
					layer.cornerRadius = originalCornerRadius
				}
			}
		case .down:
			transform = CGAffineTransform.identity.scaledBy(x: pushDownScale, y: pushDownScale)
			originalBackgroundColor = backgroundColor
            
			if let color = pushDownBackgroundColor {
				backgroundColor = color
			}
            
			if pushDownRoundCorners {
				originalCornerRadius = layer.cornerRadius
                if originalCornerRadius < pushedCornerRadius {
					layer.masksToBounds = true
					let animation = CABasicAnimation(keyPath: animationKeyPath)
					animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
					animation.fromValue = layer.cornerRadius
                    animation.toValue = pushedCornerRadius
					animation.duration = pushDownDuration
					layer.add(animation, forKey: animation.keyPath)
					layer.cornerRadius = pushedCornerRadius
				}
			}
		}
	}
}

// MARK: - UIButton

/// `UIButton` that conforms to `PushDownView`
/// Default `PushDownView` extension implementations allow `PushDownButton`
/// to have push animations on pushdown and release.
open class PushDownButton: UIButton, PushDownView {
	@IBInspectable public var pushDownDuration: TimeInterval = DefaultValues.pushDownDuration
	@IBInspectable public var pushDownScale: CGFloat = DefaultValues.pushDownScale
	@IBInspectable public var pushDownRoundCorners = DefaultValues.pushDownRoundCorners
	@IBInspectable public var pushDownBackgroundColor: UIColor?
	internal var originalBackgroundColor: UIColor?
	internal var originalCornerRadius: CGFloat = 0
	internal var originalMasksToLayer = false
	internal var isAnimating = false
	internal var animationsToComplete: (()->())?
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		addTarget(self, action: #selector(animatePushDown), for: [.touchDown, .touchDragEnter])
		addTarget(self, action: #selector(animateRelease), for: [.touchUpInside, .touchCancel, .touchDragExit])
	}
	
	@objc private func animatePushDown() {
		animatePush(toState: .down)
	}
	
	@objc private func animateRelease() {
		animatePush(toState: .up)
	}
}

// MARK: - UITableViewCell

/// `UITableViewCell` that conforms to `PushDownView`
/// Default `PushDownView` extension implementations allow `PushDownTableViewCell`
/// to have push animations on pushdown and release.
open class PushDownTableViewCell: UITableViewCell, PushDownView {
	@IBInspectable public var pushDownDuration: TimeInterval = DefaultValues.pushDownDuration
	@IBInspectable public var pushDownScale: CGFloat = DefaultValues.pushDownScale
	@IBInspectable public var pushDownRoundCorners = DefaultValues.pushDownRoundCorners
	@IBInspectable public var pushDownBackgroundColor: UIColor?
	internal var originalBackgroundColor: UIColor?
	internal var originalCornerRadius: CGFloat = 0
	internal var originalMasksToLayer = false
	internal var isAnimating = false
	internal var animationsToComplete: (()->())?
	
	open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)
		let toState: PushState = highlighted ? .down : .up
		animatePush(toState: toState)
	}
}

// MARK: - UICollectionViewCell

/// `UICollectionViewCell` that conforms to `PushDownView`
/// Default `PushDownView` extension implementations allow `PushDownCollectionViewCell`
/// to have push animations on pushdown and release.
open class PushDownCollectionViewCell: UICollectionViewCell, PushDownView {
	@IBInspectable public var pushDownDuration: TimeInterval = DefaultValues.pushDownDuration
	@IBInspectable public var pushDownScale: CGFloat = DefaultValues.pushDownScale
	@IBInspectable public var pushDownRoundCorners = DefaultValues.pushDownRoundCorners
	@IBInspectable public var pushDownBackgroundColor: UIColor?
	internal var originalBackgroundColor: UIColor?
	internal var originalCornerRadius: CGFloat = 0
	internal var originalMasksToLayer = false
	internal var isAnimating = false
	internal var animationsToComplete: (()->())?
	
	open override var isHighlighted: Bool {
		didSet {
			let toState: PushState = isHighlighted ? .down : .up
			animatePush(toState: toState)
		}
	}
}
