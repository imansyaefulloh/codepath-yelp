//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navFilter: UIBarButtonItem!;
    @IBOutlet weak var navMap: UIBarButtonItem!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    var businesses: [Business]!
    var businessesBackup: [Business]!
    var searchBar: UISearchBar!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingSpinner.hidesWhenStopped = true;
        loadingSpinner.startAnimating();
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = UITableViewAutomaticDimension; // needs estimatedRowHeight
        tableView.estimatedRowHeight = 120; // mostly just for the scroll bar handle size
        
        searchBar = UISearchBar();
        searchBar.delegate = self;
        searchBar.sizeToFit();
        navigationItem.titleView = searchBar;

        navigationController?.navigationBar.barTintColor = UIColor(red: 0.765, green: 0.141, blue: 0, alpha: 1);
        navigationController?.navigationBar.translucent = false;
        navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        
        // create navbar buttons
        var button: UIButton;
        var navItem: UIBarButtonItem;
        // generate and attach left bar button
        button = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 30))
        button.setImage(UIImage(named: "Button-Filter"), forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonFilter", forControlEvents:  UIControlEvents.TouchUpInside)
        navItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = navItem;
        // generate and attach right bar button
        button = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 30))
        button.setImage(UIImage(named: "Button-Map"), forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonMap", forControlEvents:  UIControlEvents.TouchUpInside)
        navItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = navItem;

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.alpha = 0;
        loadingSpinner.startAnimating();
        Business.search("", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            self.reloadTable();
            self.tableView.alpha = 1;
            self.loadingSpinner.stopAnimating();
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(businesses != nil) {
            return businesses.count;
        } else {
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell;
        
        cell.itemNumber = indexPath.row + 1;
        cell.business = businesses[indexPath.row];
        return cell;
    }
    
    func scrollViewWillBeginDragging(tableView: UIScrollView) {
        searchBar.endEditing(false);
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(false);
        self.resignFirstResponder();
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        
        if(businessesBackup == nil) {
            businessesBackup = businesses;
        }
        
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            businesses = businessesBackup;
            searchBar.endEditing(false);
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            businesses = businesses.filter({(dataItem: Business) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if dataItem.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    
    func buttonFilter() {
        let filters = storyboard?.instantiateViewControllerWithIdentifier("FiltersViewController");
        self.presentViewController(filters!, animated: true) { () -> Void in
            
        }
    }
    
    func buttonMap() {
        print("clicked map");
    }
    
    func reloadTable() {
        loadingSpinner.stopAnimating();
        tableView.reloadData();
        tableView.alpha = 1;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toDetails") {
            let cell = sender as! UITableViewCell;
            let indexPath = tableView.indexPathForCell(cell);
            let detailsVc = segue.destinationViewController as! DetailsViewController;
            detailsVc.business = businesses[indexPath!.row];
        }
    }

}
