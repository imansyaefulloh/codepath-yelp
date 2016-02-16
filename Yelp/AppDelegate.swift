//
//  AppDelegate.swift
//  Yelp
//
//  Copyright © 2016 Tejen Patel. All rights reserved.
//

import UIKit
import CoreLocation;

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager();
    var BusinessesVC: UIViewController?;
    var BusinessesVCInitialUpdateDone = false;
    
    let prefs = NSUserDefaults.standardUserDefaults();

    var currentLocation: CLLocationCoordinate2D?;
    
    var latitudeLongitude : String = "37.785771,-122.406165" { // // default to San Francisco
        didSet {
            prefs.setValue(latitudeLongitude, forKey: "latitudeLongitude");
        }
    }
    var search_term : String = "" { // default to Best Match
        didSet {
            prefs.setValue(search_term, forKey: "search_term");
        }
    }
    
    var searchFilter_distance : String = "Distance1" { // default to Best Match
        didSet {
            prefs.setValue(searchFilter_distance, forKey: "searchFilter_distance");
        }
    }
    var searchFilter_sort : String = "Sort2" { // default to Distance
        didSet {
            prefs.setValue(searchFilter_sort, forKey: "searchFilter_sort");
        }
    }
    var searchFilter_cost : [String] = ["$","$$","$$$","$$$$"] { // default to (all)
        didSet {
            prefs.setValue(searchFilter_cost.joinWithSeparator(","), forKey: "searchFilter_cost");
        }
    }
    var searchFilter_offeringDeal : Bool = false { // default to False
        didSet {
            prefs.setValue((searchFilter_offeringDeal ? "true" : "false"), forKey: "searchFilter_offeringDeal");
        }
    }
    var searchFilter_openNow : Bool = false { // default to False
        didSet {
            prefs.setValue((searchFilter_openNow ? "true" : "false"), forKey: "searchFilter_openNow");
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = .LightContent;
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        
        if let term = prefs.stringForKey("search_term") {
            search_term = term;
        }
        if let distance = prefs.stringForKey("searchFilter_distance") {
            searchFilter_distance = distance;
        }
        if let sort = prefs.stringForKey("searchFilter_sort") {
            searchFilter_sort = sort;
        }
        if let cost = prefs.stringForKey("searchFilter_cost") {
            searchFilter_cost = cost.componentsSeparatedByString(",");
        }
        if let offeringDeal = prefs.stringForKey("searchFilter_offeringDeal") {
            searchFilter_offeringDeal = (offeringDeal == "true");
        }
        if let openNow = prefs.stringForKey("searchFilter_openNow") {
            searchFilter_openNow = (openNow == "true");
        }
        
        return true
    }
    
    func switchToSearchTab() {
        if self.window!.rootViewController as? UITabBarController != nil {
            var tababarController = self.window!.rootViewController as! UITabBarController;
            tababarController.selectedIndex = 1
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locationManager.location! as CLLocation;
        currentLocation = location.coordinate;
        latitudeLongitude = "\(location.coordinate.latitude),\(location.coordinate.longitude)";
        if let vc = BusinessesVC {
            if(!BusinessesVCInitialUpdateDone) {
                BusinessesVCInitialUpdateDone = true;
                let bVc = vc as! BusinessesViewController;
                bVc.reloadSearch();
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
            print("authorized")
        case .AuthorizedWhenInUse:
            print("authorized when in use")
        case .Denied:
            print("denied")
        case .NotDetermined:
            print("not determined")
        case .Restricted:
            print("restricted")
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

