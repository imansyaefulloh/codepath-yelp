//
//  CategoriesTableViewController.swift
//  Yelp
//
//  Created by Tejen Hasmukh Patel on 2/15/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        appDelegate.search_term = (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text!)!;
        appDelegate.switchToSearchTab();
    }
    
}
