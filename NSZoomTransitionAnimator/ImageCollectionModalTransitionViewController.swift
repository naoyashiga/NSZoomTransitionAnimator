//
//  ImageCollectionModalTransitionViewController.swift
//  NSZoomTransitionAnimator
//
//  Created by naoyashiga on 2015/06/25.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class ImageCollectionModalTransitionViewController: ImageCollectionViewController, UIViewControllerTransitioningDelegate, NSZoomTransitionAnimating {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func showDetail() {
        //subclass
        let vc = DetailViewController(nibName: "DetailViewController", bundle: nil)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        vc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Detail" {
            let vc = segue.destinationViewController as! DetailViewController
            vc.transitioningDelegate = self
        }
    }
    
    //MARK: NSZoomTransitionAnimating
    func transitionSourceImageView() -> UIImageView {
        let selectedIndexPath = collectionView?.indexPathsForSelectedItems().first as! NSIndexPath
        let cell = collectionView?.cellForItemAtIndexPath(selectedIndexPath) as! ImageCollectionViewCell
        let imageView = UIImageView(image: cell.imageView.image)
        
        imageView.contentMode = cell.imageView.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        imageView.frame = cell.imageView.convertRect(cell.imageView.frame, toView: collectionView?.superview)
        return imageView
    }
    
    func transitionSourceBackgroundColor() -> UIColor {
//        return collectionView?.backgroundColor!
        return UIColor.blackColor()
    }
    
    func transitionDestinationImageViewFrame() -> CGRect {
        let selectedIndexPath = collectionView?.indexPathsForSelectedItems().first as! NSIndexPath
        let cell = collectionView?.cellForItemAtIndexPath(selectedIndexPath) as! ImageCollectionViewCell
        
        let cellFrameInSuperview = cell.imageView.convertRect(cell.imageView.frame, toView: collectionView?.superview)
        return cellFrameInSuperview
    }

    
    //MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if source.conformsToProtocol(NSZoomTransitionAnimating) && presented.conformsToProtocol(NSZoomTransitionAnimating) {
            let animator = NSZoomTransitionAnimator()
            animator.goingForward = true
            return animator
        }
        
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed.conformsToProtocol(NSZoomTransitionAnimating) && self.conformsToProtocol(NSZoomTransitionAnimating) {
            let animator = NSZoomTransitionAnimator()
            animator.goingForward = false
            return animator
        }
        
        return nil
    }
    
}
