//
//  Location.swift
//  Yelp
//
//  Created by Tejen Hasmukh Patel on 2/15/16.
//  Copyright © 2016 Tejen Patel. All rights reserved.
//

import UIKit
import MapKit;

class Location: NSObject, MKAnnotation {
    var title: String?;
    var coordinate: CLLocationCoordinate2D;
    var business: Business?;
    
    init(title: String, latitude: Double, longitude: Double, business: Business) {
        self.title = title;
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
        self.business = business;
    }
}
