//
//  HomeTableViewController.swift
//  NSZoomTransitionAnimator
//
//  Created by naoyashiga on 2015/06/29.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    private let reuseIdentifier = "HomeTableViewCell"
    private let sections = [
        "CollectionView",
        "TableView"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userDetailsNIB = UINib(nibName: reuseIdentifier, bundle: nil)
        self.tableView.registerNib(userDetailsNIB, forCellReuseIdentifier: reuseIdentifier)
        
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.estimatedRowHeight = self.view.frame.height / 20
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! HomeTableViewCell
        
        if indexPath.row % 2 == 0 {
            cell.title.text = "Navigation Push Transition"
        } else {
            cell.title.text = "Modal Transition"
        }
        
        cell.layoutIfNeeded()
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! HomeTableViewCell
        
        var vc = UIViewController()
        if indexPath.section == 0 {
            if indexPath.row == 0 {
            } else {
                performSegueWithIdentifier("CollectionModal", sender: nil)
                
            }
        } else {
            
        }
    }
}
