//
//  NSZoomTransitionAnimator.swift
//  NSZoomTransitionAnimator
//
//  Created by naoyashiga on 2015/06/25.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

protocol NSZoomTransitionAnimating {
    var transitionSourceImageView: UIImageView { get set }
    var transitionSourceBackgroundColor: UIColor { get set }
    var transitionDestinationImageViewFrame: CGRect { get set }
}

let kForwardAnimationDuration: NSTimeInterval = 0.3
let kForwardCompleteAnimationDuration: NSTimeInterval = 0.3
let kBackwardAnimationDuration: NSTimeInterval = 0.3
let kBackwardCompleteAnimationDuration: NSTimeInterval = 0.3

class NSZoomTransitionAnimator: NSObject, UIViewControllerTransitioningDelegate {
    var goingForward: Bool = false
    var sourceTransition: NSZoomTransitionAnimating?
    var destinationTransition: NSZoomTransitionAnimating?
}

extension NSZoomTransitionAnimator: UIViewControllerTransitioningDelegate {
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
        
        containerView.addSubview(sourceVC.view)
        containerView.addSubview(destinationVC.view)
        
//        var animating: Protocol = null
//        var doesNotConfirmProtocol: Bool = !self.sourceTransition.conformsToProtocol(animating) || !self.destinationTransition.conformsToProtocol(animating)
//        if doesNotConfirmProtocol {
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//            return
//        }
        
        let alphaView = UIView(frame: transitionContext.finalFrameForViewController(sourceVC))
        var sourceImageView = UIImageView()
        
        if let sourceTransition = sourceTransition {
            alphaView.backgroundColor = sourceTransition.transitionSourceBackgroundColor
            containerView.addSubview(alphaView)
            
            sourceImageView = sourceTransition.transitionSourceImageView
            containerView.addSubview(sourceImageView)
        }
        
        if self.goingForward {
            UIView.animateWithDuration(kForwardAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                
                if let destinationTransition = self.destinationTransition {
                    sourceImageView.frame = destinationTransition.transitionDestinationImageViewFrame
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
                if let destinationTransition = self.destinationTransition {
                    sourceImageView.frame = destinationTransition.transitionDestinationImageViewFrame
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
