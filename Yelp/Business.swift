//
//  Business.swift
//  Yelp
//
//  Copyright © 2016 Tejen Patel. All rights reserved.
//

import UIKit

class Business: NSObject {
    let id: String?;
    let name: String?
    let address: String?
    let imageURL: NSURL?
    let categories: String?
    let distance: String?
    let ratingImageURL: NSURL?
    let reviewCount: NSNumber?
    let latitude: Double?;
    let longitude: Double?;
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? String;
        
        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = NSURL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        latitude = location!["coordinate"]!["latitude"]! as? Double;
        longitude = location!["coordinate"]!["longitude"]! as? Double;
        var address = ""
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
        }
        self.address = address
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joinWithSeparator(", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = NSURL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
    }
    
    class func businesses(array array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func search(term: String, offset: Int = 0, completion: ([Business]!, NSError!) -> Void) -> Void {
        
        var sort = YelpSortMode.BestMatched;
        switch(appDelegate.searchFilter_sort) {
        case "Sort2":
            sort = YelpSortMode.Distance;
        case "Sort3":
            sort = YelpSortMode.HighestRated;
        default:
            sort = YelpSortMode.BestMatched;
        }
        
        var deals: Bool?;
        if(appDelegate.searchFilter_offeringDeal) {
            deals = true;
        }
        
        let metersPerBlock = 177;
        let metersPerMile = 1609;
        var radius: Int?;
        switch(appDelegate.searchFilter_distance) {
        case "Distance2":
            radius = metersPerBlock * 2;
        case "Distance3":
            radius = metersPerBlock * 6;
        case "Distance4":
            radius = metersPerMile * 1;
        case "Distance5":
            radius = metersPerMile * 5;
        default:
            radius = nil;
        }
        
        YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: nil, deals: deals, radius: radius, offset: offset, completion: completion)
    }
}
