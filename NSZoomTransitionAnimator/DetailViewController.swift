//
//  DetailViewController.swift
//  NSZoomTransitionAnimator
//
//  Created by naoyashiga on 2015/06/25.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, NSZoomTransitionAnimating {
    @IBOutlet weak var mainImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView() {
        if let view = UINib(nibName: "DetailViewController", bundle: nil).instantiateWithOwner(self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    @IBAction func closeButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func transitionSourceImageView() -> UIImageView {
        return mainImageView
    }
    
    func transitionSourceBackgroundColor() -> UIColor {
        return view.backgroundColor!
    }
    
    func transitionDestinationImageViewFrame() -> CGRect {
        return mainImageView.frame
    }
}
