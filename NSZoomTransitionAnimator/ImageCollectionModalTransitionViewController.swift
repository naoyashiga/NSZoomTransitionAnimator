//
//  ImageCollectionModalTransitionViewController.swift
//  NSZoomTransitionAnimator
//
//  Created by naoyashiga on 2015/06/25.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class ImageCollectionModalTransitionViewController: ImageCollectionViewController, NSZoomTransitionAnimating, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Detail" {
            let vc = segue.destinationViewController as! DetailViewController
            vc.transitioningDelegate = self
        }
    }
    
    var selectedIndexPath = NSIndexPath()
    //MARK: NSZoomTransitionAnimating
    func transitionSourceImageView() -> UIImageView {
        if let selectedIndexPath = collectionView?.indexPathsForSelectedItems().first as? NSIndexPath {
            self.selectedIndexPath = selectedIndexPath
        }
        
        let cell = collectionView?.cellForItemAtIndexPath(self.selectedIndexPath) as! ImageCollectionViewCell
        let imageView = UIImageView(image: cell.imageView.image)
        
        imageView.contentMode = cell.imageView.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        imageView.frame = cell.imageView.convertRect(cell.imageView.frame, toView: collectionView?.superview)
        return imageView
    }
    
    func transitionSourceBackgroundColor() -> UIColor {
        return UIColor.blackColor()
    }
    
    func transitionDestinationImageViewFrame() -> CGRect {
        let cell = collectionView?.cellForItemAtIndexPath(selectedIndexPath) as! ImageCollectionViewCell
        let cellFrameInSuperview = cell.imageView.convertRect(cell.imageView.frame, toView: collectionView?.superview)
        
        return cellFrameInSuperview
    }
    
    //MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if source.conformsToProtocol(NSZoomTransitionAnimating) && presented.conformsToProtocol(NSZoomTransitionAnimating) {
            let animator = NSZoomTransitionAnimator()
            animator.sourceVC = source
            animator.destinationVC = presented
            animator.goingForward = true
            return animator
        }
        
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed.conformsToProtocol(NSZoomTransitionAnimating) && self.conformsToProtocol(NSZoomTransitionAnimating) {
            let animator = NSZoomTransitionAnimator()
            animator.sourceVC = dismissed
            animator.destinationVC = self
            animator.goingForward = false
            return animator
        }
        return nil
    }
}
