//
//  ImageCollectionViewController.swift
//  NSZoomTransitionAnimator
//
//  Created by naoyashiga on 2015/06/25.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

let reuseIdentifier_ImageModalCell = "ImageModalCell"

class ImageCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.registerNib(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier_ImageModalCell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier_ImageModalCell, forIndexPath: indexPath) as! ImageCollectionViewCell
        
        cell.backgroundColor = UIColor.grayColor()
        let img = UIImage(named: "catCafe")
        cell.imageView.image = img
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            performSegueWithIdentifier("Detail", sender: cell)
        }
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSize(width: self.view.bounds.width, height: self.view.bounds.height / 2.5)
        return CGSize(width: self.view.bounds.width / 2, height: self.view.bounds.width / 2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
}