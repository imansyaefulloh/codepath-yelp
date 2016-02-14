//
//  FiltersTableViewController.swift
//  Yelp
//
//  Created by Tejen Hasmukh Patel on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersTableViewController: UITableViewController, UIGestureRecognizerDelegate {
   
    @IBOutlet weak var segment1: UIView!
    @IBOutlet weak var segment2: UIView!
    @IBOutlet weak var segment3: UIView!
    @IBOutlet weak var segment4: UIView!
    
    @IBOutlet weak var distance1: UITableViewCell!
    @IBOutlet weak var distance2: UITableViewCell!
    @IBOutlet weak var distance3: UITableViewCell!
    @IBOutlet weak var distance4: UITableViewCell!
    @IBOutlet weak var distance5: UITableViewCell!
    
    @IBOutlet weak var sort1: UITableViewCell!
    @IBOutlet weak var sort2: UITableViewCell!
    @IBOutlet weak var sort3: UITableViewCell!
    
    @IBOutlet weak var switchOfferingDeal: UISwitch!
    @IBOutlet weak var switchOpenNow: UISwitch!
    
    var prefCost : [String] = appDelegate.searchFilter_cost;
    var costSegments : [UIView] = [];
    
    var prefOfferingDeal = appDelegate.searchFilter_offeringDeal;
    var prefOpenNow = appDelegate.searchFilter_openNow;
    
    var radioPrefs : [String: String] = [
        "distance": appDelegate.searchFilter_distance,
        "sort": appDelegate.searchFilter_sort,
    ];
    var radioSections: [[[String]]] = [];
    var sortCells: [UITableViewCell] = [];
    var sortCellIdentifiers: [String] = [];
    var distanceCells: [UITableViewCell] = [];
    var distanceCellIdentifiers: [String] = [];
    var cells : [String: [UITableViewCell]] = ["":[]];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor(red: 0.765, green: 0.141, blue: 0, alpha: 1);
        navigationController?.navigationBar.translucent = false;
        navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        distanceCells = [distance1, distance2, distance3, distance4, distance5];
        distanceCellIdentifiers = ["Distance1", "Distance2", "Distance3", "Distance4", "Distance5"];
        sortCells = [sort1, sort2, sort3];
        sortCellIdentifiers = ["Sort1", "Sort2", "Sort3"];
        radioSections = [[["distance"], distanceCellIdentifiers], [["sort"], sortCellIdentifiers]];
        cells = ["distance": distanceCells, "sort": sortCells];
        for identifierSet in radioSections {
            let setIdentifier = identifierSet[0][0];
            let identifiers = identifierSet[1];
            let currentValue = radioPrefs[setIdentifier];
            let cellIndex = identifiers.indexOf(currentValue!);
            cells[setIdentifier]![cellIndex!].accessoryType = .Checkmark;
        }
        
        costSegments = [segment1, segment2, segment3, segment4];
        for i in 0...3 {
            let tap = UITapGestureRecognizer(target: self, action: Selector("segmentTap:"));
            tap.delegate = self;
            costSegments[i].addGestureRecognizer(tap);
            activateSegment(costSegments[i], active: prefCost.contains(String(count: i + 1, repeatedValue: Character("$"))));
        }
        
        if(prefOfferingDeal) {
            switchOfferingDeal.setOn(true, animated: true);
        }
        if(prefOpenNow) {
            switchOpenNow.setOn(true, animated: true);
        }
        
        // create navbar buttons
        var button: UIButton;
        var navItem: UIBarButtonItem;
        // generate and attach left bar button
        button = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 30))
        button.setImage(UIImage(named: "Button-Cancel"), forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonCancel", forControlEvents:  UIControlEvents.TouchUpInside)
        navItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = navItem;
        // generate and attach right bar button
        button = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 30))
        button.setImage(UIImage(named: "Button-Search"), forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonSearch", forControlEvents:  UIControlEvents.TouchUpInside)
        navItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = navItem;

        let borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor;
        segment1.layer.borderWidth = 1;
        segment1.layer.borderColor = borderColor;
        segment2.layer.borderWidth = 1;
        segment2.layer.borderColor = borderColor;
        segment3.layer.borderWidth = 1;
        segment3.layer.borderColor = borderColor;
        segment4.layer.borderWidth = 1;
        segment4.layer.borderColor = borderColor;
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cellIdentifier = tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier {
            for identifierSet in radioSections {
                let setIdentifier = identifierSet[0][0];
                var identifiers = identifierSet[1];
                if(identifiers.contains(cellIdentifier)) {
                    // distance cell selected
                    for cell in cells[setIdentifier]! {
                        cell.accessoryType = .None;
                    }
                    tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark;
                    tableView.deselectRowAtIndexPath(indexPath, animated: true);
                    
                    self.radioPrefs[setIdentifier] = identifiers[indexPath.row];
                }
            }
        }
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func segmentTap(sender: UITapGestureRecognizer? = nil) {
        let amount = (sender!.view?.subviews[0] as! UILabel).text?.characters.count;
        let index = prefCost.indexOf(String(count: amount!, repeatedValue: Character("$")));
        if let index = index {
            prefCost.removeAtIndex(index);
            activateSegment(sender!.view!, active: false);
        } else {
            prefCost.append(String(count: amount!, repeatedValue: Character("$")));
            activateSegment(sender!.view!, active: true);
        }
    }
    
    func activateSegment(segment: UIView, active: Bool) {
        segment.backgroundColor = (active ? UIColor(red: 0, green: 146/255.0, blue: 239/255.0, alpha: 1) : UIColor.whiteColor());
        (segment.subviews[0] as! UILabel).textColor = (active ? UIColor.whiteColor() : UIColor.lightGrayColor());
    }
    
    func buttonCancel() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func buttonSearch() {
        // save ephemeral state
        prefOfferingDeal = switchOfferingDeal.on;
        prefOpenNow = switchOpenNow.on;
        
        // commit changes (observers save to NSUserDefaults)
        appDelegate.searchFilter_distance = radioPrefs["distance"]!;
        appDelegate.searchFilter_sort = radioPrefs["sort"]!;
        appDelegate.searchFilter_cost = prefCost;
        appDelegate.searchFilter_offeringDeal = prefOfferingDeal;
        appDelegate.searchFilter_openNow = prefOpenNow;
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
}
