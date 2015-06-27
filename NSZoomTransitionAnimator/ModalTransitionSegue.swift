//
//  ModalTransitionSegue.swift
//  NSZoomTransitionAnimator
//
//  Created by naoyashiga on 2015/06/27.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class ModalTransitionSegue: UIStoryboardSegue {
    let transitionAnimator = NSZoomTransitionAnimator()
    
    override func perform() {
        let sourceViewController = self.sourceViewController as! UIViewController
        let destinationViewController = self.destinationViewController as! UIViewController
        
        destinationViewController.transitioningDelegate = transitionAnimator
        sourceViewController.presentViewController(destinationViewController, animated: true, completion: nil)
    }
}
