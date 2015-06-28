//
//  NSZoomTransitionAnimator.swift
//  NSZoomTransitionAnimator
//
//  Created by naoyashiga on 2015/06/25.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

@objc public protocol NSZoomTransitionAnimating {
    func transitionSourceImageView() -> UIImageView
    func transitionSourceBackgroundColor() -> UIColor
    func transitionDestinationImageViewFrame() -> CGRect
}

let kForwardAnimationDuration: NSTimeInterval = 0.3
let kForwardCompleteAnimationDuration: NSTimeInterval = 0.3
let kBackwardAnimationDuration: NSTimeInterval = 0.3
let kBackwardCompleteAnimationDuration: NSTimeInterval = 0.3

class NSZoomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var goingForward: Bool = false
    var sourceVC = UIViewController()
    var destinationVC = UIViewController()
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        if goingForward {
            return kForwardAnimationDuration + kForwardCompleteAnimationDuration;
        } else {
            return kBackwardAnimationDuration + kBackwardCompleteAnimationDuration;
        }
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        
        toVC.view.frame = fromVC.view.frame
//        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
//        toVC.updateViewConstraints()
        
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        toVC.view.layoutIfNeeded()
//        toVC.view.setNeedsLayout()
        
//        let alphaView = UIView(frame: transitionContext.finalFrameForViewController(fromVC))
        var sourceImageView = UIImageView()
        var destinationImageView = UIImageView()
        
        
        if let sourceVC = sourceVC as? NSZoomTransitionAnimating {
//            alphaView.backgroundColor = sourceVC.transitionSourceBackgroundColor()
//            containerView.addSubview(alphaView)
            
            sourceImageView = sourceVC.transitionSourceImageView()
            containerView.addSubview(sourceImageView)
        }
        
        if let destinationVC = self.destinationVC as? NSZoomTransitionAnimating {
            destinationImageView = destinationVC.transitionSourceImageView()
            destinationImageView.hidden = true
        }
        
        if self.goingForward {
            UIView.animateWithDuration(kForwardAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                
                if let destinationVC = self.destinationVC as? NSZoomTransitionAnimating {
                    sourceImageView.frame = destinationVC.transitionDestinationImageViewFrame()
//                    sourceImageView.transform = CGAffineTransformMakeScale(1.02, 1.02)
                }
//                alphaView.alpha = 0.9
                
                }, completion: {(finished: Bool) in
                    UIView.animateWithDuration(kForwardCompleteAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
//                        alphaView.alpha = 0
//                        sourceImageView.transform = CGAffineTransformIdentity
                        destinationImageView.hidden = false
                        
                        }, completion: {(finished: Bool) in
                            sourceImageView.alpha = 0
//                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                            transitionContext.completeTransition(finished)
                    })
            })
        } else {
            UIView.animateWithDuration(kBackwardAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                if let destinationVC = self.destinationVC as? NSZoomTransitionAnimating {
                    sourceImageView.frame = destinationVC.transitionDestinationImageViewFrame()
                }
                
//                alphaView.alpha = 0
                
                }, completion: {(finished: Bool) in
                    UIView.animateWithDuration(kBackwardCompleteAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                        sourceImageView.alpha = 0
                        
                        }, completion: {(finished: Bool) in
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    })
                    
            })
        }
    }
}

extension NSZoomTransitionAnimator: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    //MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if source.conformsToProtocol(NSZoomTransitionAnimating) && presented.conformsToProtocol(NSZoomTransitionAnimating) {
            sourceVC = source
            destinationVC = presented
//            let animator = NSZoomTransitionAnimator()
//            animator.goingForward = true
            self.goingForward = true
            return self
        }
        
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
//        return self
        if dismissed.conformsToProtocol(NSZoomTransitionAnimating) && self.conformsToProtocol(NSZoomTransitionAnimating) {
//            sourceVC = dismissed
//            destinationVC = self
//            let animator = NSZoomTransitionAnimator()
//            animator.goingForward = false
//            return animator
            self.goingForward = false
            return self
        }
//
        return nil
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC.conformsToProtocol(NSZoomTransitionAnimating) && toVC.conformsToProtocol(NSZoomTransitionAnimating) {
            //            let animator = NSZoomTransitionAnimator()
            //            animator.goingForward = true
            self.goingForward = true
            return self
        }
        
        return nil
    }
}