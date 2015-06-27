//
//  NSZoomTransitionAnimator.swift
//  NSZoomTransitionAnimator
//
//  Created by naoyashiga on 2015/06/25.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

@objc public protocol NSZoomTransitionAnimating {
//    var transitionSourceImageView: UIImageView { get }
//    var transitionSourceBackgroundColor: UIColor { get }
//    var transitionDestinationImageViewFrame: CGRect { get }
    
    func transitionSourceImageView() -> UIImageView
    func transitionSourceBackgroundColor() -> UIColor
    func transitionDestinationImageViewFrame() -> CGRect
//    var asVC: UIViewController { get set }
}

let kForwardAnimationDuration: NSTimeInterval = 0.3
let kForwardCompleteAnimationDuration: NSTimeInterval = 0.3
let kBackwardAnimationDuration: NSTimeInterval = 0.3
let kBackwardCompleteAnimationDuration: NSTimeInterval = 0.3

class NSZoomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var goingForward: Bool = false
//    var sourceTransition: NSZoomTransitionAnimating?
//    var destinationTransition: NSZoomTransitionAnimating?
    
//    var sourceVC: NSZoomTransitionAnimating?
//    var destinationVC: NSZoomTransitionAnimating?
//    override init(sourceTransition: NSZoomTransitionAnimating, destinationTransition: NSZoomTransitionAnimating) {
//        super.init()
//        self.sourceTransition = sourceTransition
//        self.destinationTransition = destinationTransition
//    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        if goingForward {
            return kForwardAnimationDuration + kForwardCompleteAnimationDuration;
        } else {
            return kBackwardAnimationDuration + kBackwardCompleteAnimationDuration;
        }
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let sourceVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let destinationVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let doesNotConfirmProtocol = !sourceVC.conformsToProtocol(NSZoomTransitionAnimating) || !destinationVC.conformsToProtocol(NSZoomTransitionAnimating)
        
        if doesNotConfirmProtocol {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            return
        }
        
        containerView.addSubview(sourceVC.view)
        containerView.addSubview(destinationVC.view)
        
        let alphaView = UIView(frame: transitionContext.finalFrameForViewController(sourceVC))
        var sourceImageView = UIImageView()
        
        if let sourceVC = sourceVC as? NSZoomTransitionAnimating {
            alphaView.backgroundColor = sourceVC.transitionSourceBackgroundColor()
            containerView.addSubview(alphaView)
            
            sourceImageView = sourceVC.transitionSourceImageView()
            containerView.addSubview(sourceImageView)
        }
        
        if self.goingForward {
            UIView.animateWithDuration(kForwardAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                
                if let destinationVC = destinationVC as? NSZoomTransitionAnimating {
                    sourceImageView.frame = destinationVC.transitionDestinationImageViewFrame()
                    sourceImageView.transform = CGAffineTransformMakeScale(1.02, 1.02)
                }
                alphaView.alpha = 0.9
                
                }, completion: {(finished: Bool) in
                    UIView.animateWithDuration(kForwardCompleteAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                        alphaView.alpha = 0
                        sourceImageView.transform = CGAffineTransformIdentity
                        
                        }, completion: {(finished: Bool) in
                            sourceImageView.alpha = 0
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    })
            })
        } else {
            UIView.animateWithDuration(kBackwardAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                if let destinationVC = destinationVC as? NSZoomTransitionAnimating {
                    sourceImageView.frame = destinationVC.transitionDestinationImageViewFrame()
                }
                
                alphaView.alpha = 0
                
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
