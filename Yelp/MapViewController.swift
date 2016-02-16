//
//  MapViewController.swift
//  Yelp
//
//  Created by Tejen Hasmukh Patel on 2/15/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit;

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var map: MKMapView!
    
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        map.delegate = self;
        var locations: [Location] = [];
        
        for business in businesses {
            let location = Location(
                title: business.name!,
                latitude: business.latitude!,
                longitude: business.longitude!,
                business: business
            );
            locations.append(location);
        }
        
        map.showAnnotations(locations, animated: true);

    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView {
        let reuseId = "pin"
        
        var pinView = map.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            
            let rightButton: AnyObject! = UIButton(type: .DetailDisclosure)
            rightButton.titleForState(UIControlState.Normal)
            
            pinView!.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView!
    }
    
    func mapView(map: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegueWithIdentifier("toDetails", sender: view)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let annotation = (sender as! MKAnnotationView).annotation!;
        let location = annotation as! Location;
        let detailVc = segue.destinationViewController as! DetailsViewController;
        detailVc.business = location.business;
    }

}
