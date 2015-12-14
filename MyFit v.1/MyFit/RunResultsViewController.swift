//
//  RunResultsViewController.swift
//  MyFit
//
//  Created by Abdulaziz Jamal on 12/12/15.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import UIKit
import Social
import CoreLocation
import HealthKit
import MapKit

class RunResultsViewController: UIViewController {
    var run: Run!
    
    //MARK: Labels
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var facebookButton: UIButton! //Facebook Button
    @IBOutlet weak var twitterButton: UIButton! // Twitter Button.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: Func
   //Displaying Run
    
    func configureView(){ // Display Distance in meters.
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: run!.distance.doubleValue)
        distanceLabel.text = "Distance: " + distanceQuantity.description
        
        let dateFormatter = NSDateFormatter() // Calculate the date.
        dateFormatter.dateStyle = .MediumStyle
        dateLabel.text = dateFormatter.stringFromDate(run!.timestamp)
        
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: run!.duration.doubleValue) // Calculate the time.
        timeLabel.text = "Time: " + secondsQuantity.description
        
        let paceUnit = HKUnit.meterUnit().unitDividedByUnit(HKUnit.secondUnit()) // Calculate the pace.
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: run!.distance.doubleValue / run!.duration.doubleValue)
        paceLabel.text = "Pace: " + paceQuantity.description
        
        loadMap()
    }
    
    func mapRegion() -> MKCoordinateRegion { // Calculate map region to display the latitude and longitude.
        let initialLoc = run!.locations.firstObject as! Location
        
        var minLat = initialLoc.latitude.doubleValue
        var minLng = initialLoc.longitude.doubleValue
        var maxLat = minLat
        var maxLng = minLng
        
        let locations = run!.locations.array as! [Location]
        
        for location in locations {
            minLat = min(minLat, location.latitude.doubleValue)
            minLng = min(minLng, location.longitude.doubleValue)
            maxLat = max(maxLat, location.latitude.doubleValue)
            maxLng = max(maxLng, location.longitude.doubleValue)
        }
        
        return MKCoordinateRegion( // Calculte the coordinates of the location.
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                longitude: (minLng + maxLng)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.1,
                longitudeDelta: (maxLng - minLng)*1.1))
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! { // Draw's a polyline in the map. ( for some reasons it does not appear in the map viewed).
        if !overlay.isKindOfClass(MKPolyline) {
            return nil
        }
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blueColor() // Color of polyline.
        renderer.lineWidth = 3
        return renderer
    }
    
    func polyline() -> MKPolyline { // Polyline takes the CLocation for 2D coordinate.
        var coords = [CLLocationCoordinate2D]()
        
        let locations = run!.locations.array as! [Location] // locations array.
        for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: location.latitude.doubleValue,
                longitude: location.longitude.doubleValue))
        }
        
        return MKPolyline(coordinates: &coords, count: run!.locations.count)
    }
    
    func loadMap() {
        if run!.locations.count > 0 {
            mapView.hidden = false
            
            // Set the map bounds
            mapView.region = mapRegion()
            
            // Make the line(s!) on the map
            mapView.addOverlay(polyline())
        } else {
            // No locations were found!
            mapView.hidden = true
            
            UIAlertView(title: "Error",
                message: "Sorry, this run has no locations saved",
                delegate:nil,
                cancelButtonTitle: "OK").show()
        }
    }
    
    //MARK: Actions
    
    
    @IBAction func twitterAction(sender: UIButton) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {        // Check if the user has the Twitter Application Installed and login.
            
            var tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert) // Alert the user to login to Twitter account to share. If the user has not installed the Twitter app or is not logged in, we create a UIAlertController and notify the user that they need to Login.
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)) // If the user has installed the Twitter app and is logged in, then write the code to open the "Share Controller".
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func facebookAction(sender: UIButton) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook) // Check if the user has their Facebook Application installed and login.
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)// Alert the user to login to Facebook account to share. If the user has not installed the Facebook app or is not logged in, we create a UIAlertController and notify the user that they need to Login.
            
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil) // If the user has installed the Facebook app and is logged in, then write the code to open the "Share Controller".
            
            
        }
    }
    
    
}