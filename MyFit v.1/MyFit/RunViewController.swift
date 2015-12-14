//
//  RunViewController.swift
//  MyFit
//
//  Created by Andrew Dowson [sc13ad] on 11/12/2015.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import HealthKit
import MapKit

let SegueName = "RunDetails"

class RunViewController: UIViewController, CLLocationManagerDelegate {
    
    var managedObjectContext: NSManagedObjectContext?
    
    var run: Run!
    
    //outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var hiddenButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var seconds = 0.0
    var distance = 0.0
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        // Filter threshold for new movement events
        _locationManager.distanceFilter = 10.0
        return _locationManager
        }()
    
    lazy var locations = [CLLocation]()
    lazy var timer = NSTimer()
    
    //override for when view is displayed
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide some buttons and labels until run is started
        stopButton.hidden = true
        timeLabel.hidden = true
        distanceLabel.hidden = true
        paceLabel.hidden = true
        hiddenButton.hidden = true
        
        locationManager.requestAlwaysAuthorization()
        
        mapView.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //stop timer
        timer.invalidate()
    }
    
    func eachSecond(timer: NSTimer) {
        seconds++
        //get number of seconds that have passed
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        //update time label
        timeLabel.text = "Time: " + secondsQuantity.description
        //get distance as meters
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
        //update label
        distanceLabel.text = "Distance: " + distanceQuantity.description
        //Work out current meters per second
        let paceUnit = HKUnit.meterUnit().unitDividedByUnit(HKUnit.secondUnit())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: (distance / seconds))
        //update label
        paceLabel.text = "Pace: " + paceQuantity.description
    }
    
    //being geting updates on location
    func startLocationUpdates() {
        // Here, the location manager will be lazily instantiated
        locationManager.startUpdatingLocation()
    }
    
    //Used to save array of locations
    func saveRun() {
        // get managed object and store as run object
        let savedRun = NSEntityDescription.insertNewObjectForEntityForName("Run",
            inManagedObjectContext: managedObjectContext!) as! Run
        savedRun.distance = distance
        savedRun.duration = seconds
        savedRun.timestamp = NSDate()
        
        // Create array of Location objects from CLLocation object array
        var savedLocations = [Location]()
        for location in locations {
            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Location",
                inManagedObjectContext: managedObjectContext!) as! Location
            savedLocation.timestamp = location.timestamp
            savedLocation.latitude = location.coordinate.latitude
            savedLocation.longitude = location.coordinate.longitude
            savedLocations.append(savedLocation)
        }
        //update locations of variable
        savedRun.locations = NSOrderedSet(array: savedLocations)
        //update run object
        run = savedRun
        
        // if we get an error, display message
        var error: NSError?
        let success = managedObjectContext!.save(&error)
        if !success {
            println("Could not save the run!")
        }
    }
    //MARK: Actions
    @IBAction func startPressed(sender: UIButton) {
        
        //hide start button
        startButton.hidden = true
        
        //show other buttons
        timeLabel.hidden = false
        distanceLabel.hidden = false
        paceLabel.hidden = false
        stopButton.hidden = false
        
        //set values for variables to control labels
        seconds = 0.0
        distance = 0.0
        
        //clear locations
        locations.removeAll(keepCapacity: false)
        
        //initialise timer
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "eachSecond:", userInfo: nil, repeats: true)
        
        //call location updates
        startLocationUpdates()
        
        //reveal map view
        mapView.hidden = false
    
    }
    //action for stop button
    @IBAction func stopClicked(sender: UIButton) {
        
        //call save function on completion
        saveRun()
        
        //create action sheet to ask user if they want to save or discard
        let actionSheet = UIActionSheet(title: "Run Stopped", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Save", "Discard")
        actionSheet.actionSheetStyle = .Default
        actionSheet.showInView(view)
    }
    


    //override for segue to pass run object
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let RunResultsViewController = segue.destinationViewController as? RunResultsViewController {
            RunResultsViewController.run = run
        }
    }
}

// MARK: - MKMapViewDelegate
extension RunViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        //if overlay is not a polyline, do nothing
        if !overlay.isKindOfClass(MKPolyline) {
            return nil
        }
        //set colour and size, draw line on map
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3
        return renderer
    }
}

// MARK: - CLLocationManagerDelegate
extension RunViewController: CLLocationManagerDelegate {
    
    //function to handle location updating
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        for location in locations as! [CLLocation] {
            //check how recent a location is
            let howRecent = location.timestamp.timeIntervalSinceNow
            
            if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    distance += location.distanceFromLocation(self.locations.last)
                    
                    //add coordinates to an array
                    var coords = [CLLocationCoordinate2D]()
                    coords.append(self.locations.last!.coordinate)
                    coords.append(location.coordinate)
                    
                    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                    mapView.setRegion(region, animated: true)
                    
                    //add overlay to map
                    mapView.addOverlay(MKPolyline(coordinates: &coords, count: coords.count))
                }
                
                //save location to array
                self.locations.append(location)
            }
        }
    }
}

// MARK: - UIActionSheetDelegate
extension RunViewController: UIActionSheetDelegate {
    //handle action sheet creation
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        //save button selected, perform segue
        if buttonIndex == 1 {
            performSegueWithIdentifier(SegueName, sender: nil)
        }
            //discard button selected, return to initial screen
        else if buttonIndex == 2 {
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}

