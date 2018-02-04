//
//  ActionSheetAnimator.swift
//  Currency Calculator
//
//  Created by Pantelis Giazitsis on 04/02/2018.
//  Copyright © 2018 Pantelis Giazitsis. All rights reserved.
//

import UIKit

class ActionSheetAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var duration: TimeInterval = 0.5
    
    private var reverse: Bool = false
    lazy private var gradientView = UIView()
    
    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)

        if !reverse {
            gradientView.backgroundColor = UIColor.black
            gradientView.alpha = 0.0
            gradientView.frame = containerView.bounds
            containerView.addSubview(gradientView)
            
            let finalFrame = transitionContext.finalFrame(for: toViewController)
            var initialFrame = finalFrame
            initialFrame.origin.y = initialFrame.size.height
            toViewController.view.frame = initialFrame
            containerView.addSubview(toViewController.view)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { [weak self] in
                toViewController.view.frame = finalFrame
                self?.gradientView.alpha = 0.5
            }, completion: { (finished) in
                fromViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
                transitionContext.completeTransition(true)
            })
        } else {
            var finalFrame = fromViewController.view.frame
            finalFrame.origin.y = finalFrame.size.height
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: { [weak self] in
                fromViewController.view.frame = finalFrame
                self?.gradientView.alpha = 0.0
            }, completion: { [weak self] (finished) in
                self?.gradientView.removeFromSuperview()
                fromViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
                fromViewController.view.removeFromSuperview()
                transitionContext.completeTransition(true)
            })

        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        reverse = true
        return self
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        reverse = false
        return self
    }
}
