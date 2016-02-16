//
//  BusinessesViewController.swift
//  Yelp
//
//  Copyright © 2016 Tejen Patel. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navFilter: UIBarButtonItem!;
    @IBOutlet weak var navMap: UIBarButtonItem!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loadingMessageInitial: UILabel!
    
    let refreshControl = UIRefreshControl();
    var isMoreDataLoading = false;
    
    var businesses: [Business]!
    var businessesBackup: [Business]!
    var searchBar: UISearchBar!;
    var searchTerm = appDelegate.search_term;
    var offset = 0;
    
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
        
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged);
        tableView.insertSubview(refreshControl, atIndex: 0);

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
        searchTerm = appDelegate.search_term;
        searchBar.text = searchTerm;
        reloadSearch();
        
        appDelegate.BusinessesVC = self;
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(7))
        dispatch_after(time, dispatch_get_main_queue()) {
            if(self.businesses == nil) {
                self.reloadSearch();
            }
        }
    }
    
    func searchLoadComplete() {
        reloadTable();
        tableView.alpha = 1;
        loadingMessageInitial.hidden = true;
        loadingSpinner.stopAnimating();
        refreshControl.endRefreshing();
        isMoreDataLoading = false;
    }
    
    func reloadSearch(offset: Int = 0) {
        self.offset = offset;
        var completion = { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.searchLoadComplete();
        };
        if(self.offset > 0) {
            completion = { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses.appendContentsOf(businesses);
                self.searchLoadComplete();
            };
        } else {
            tableView.alpha = 0;
            loadingSpinner.startAnimating();
        }
        if let query = searchBar.text {
            searchTerm = query;
        }
        appDelegate.search_term = searchTerm;
        Business.search(searchTerm, offset: offset, completion: completion);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        offset = 0;
        reloadSearch();
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
        
        if searchText.isEmpty {
            businesses = businessesBackup;
            searchBar.endEditing(false);
        } else {
            offset = 0;
            reloadSearch();
        }
    }
    
    func buttonFilter() {
        let filters = storyboard?.instantiateViewControllerWithIdentifier("FiltersViewController");
        self.presentViewController(filters!, animated: true) { () -> Void in
            
        }
    }
    
    func buttonMap() {
        if(businesses != nil) {
            self.performSegueWithIdentifier("toMap", sender: self);
        }
    }
    
    func reloadTable() {
        loadingSpinner.stopAnimating();
        tableView.reloadData();
        tableView.alpha = 1;
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height - 1000;
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                reloadSearch(++offset);
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toDetails") {
            let cell = sender as! UITableViewCell;
            let indexPath = tableView.indexPathForCell(cell);
            let detailsVc = segue.destinationViewController as! DetailsViewController;
            detailsVc.business = businesses[indexPath!.row];
        }
        if(segue.identifier == "toMap") {
            let mapVc = segue.destinationViewController as! MapViewController;
            mapVc.businesses = businesses;
        }
    }

}
