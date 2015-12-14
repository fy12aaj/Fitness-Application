//
//  RunViewController.swift
//  MyFit
//
//  Created by Andrew Dowson [sc13ad] on 11/12/2015.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import CoreData
import UIKit
import CoreLocation
import HealthKit
import MapKit

let DetailSegueName = "RunDetails"

class RunViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!    
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    //MARK: Variables
    
    var managedObjectContext: NSManagedObjectContext?
    var run: Run!
    var seconds = 0.0
    var distance = 0.0
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 10.0
        return _locationManager
        }()
    
    lazy var locations = [CLLocation]()
    lazy var timer = NSTimer()
    
    //MARK: Load functions
    
    override func viewWillAppear(animated: Bool) {
        locationManager.requestAlwaysAuthorization()
        
        finishButton.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        seconds = 0.0
        distance = 0.0
        locations.removeAll(keepCapacity: false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1,
            target: self,
            selector: "eachSecond:",
            userInfo: nil,
            repeats: true)
        startLocationUpdates()
    }
    
    //MARK: Location Tracking
    
    func eachSecond(timer: NSTimer) {
        seconds++
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        timeLabel.text = "Time: " + secondsQuantity.description
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
        distanceLabel.text = "Distance: " + distanceQuantity.description
        
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
        paceLabel.text = "Pace: " + paceQuantity.description
    }
    
    func startLocationUpdates() {
        // Here, the location manager will be lazily instantiated
        locationManager.startUpdatingLocation()
    }
    
    //MARK: Actions
    
    
    @IBAction func stopClicked(sender: UIButton) {
        stopButton.hidden = true
        finishButton.hidden = false
        let actionSheet = UIActionSheet(title: "Run Stopped", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Save", "Discard")
        actionSheet.actionSheetStyle = .Default
        actionSheet.showInView(view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailViewController = segue.destinationViewController as? RunResultsViewController {
            detailViewController.run = run
        }
    }
    
    
    
    //MARK: Saving the run
    
    
    func saveRun() {
        // 1
        let savedRun = NSEntityDescription.insertNewObjectForEntityForName("Run",
            inManagedObjectContext: managedObjectContext!) as! Run
        savedRun.distance = distance
        savedRun.duration = seconds
        savedRun.timestamp = NSDate()
        
        // 2
        var savedLocations = [Location]()
        for location in locations {
            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Location",
                inManagedObjectContext: managedObjectContext!) as! Location
            savedLocation.timestamp = location.timestamp
            savedLocation.latitude = location.coordinate.latitude
            savedLocation.longitude = location.coordinate.longitude
            savedLocations.append(savedLocation)
        }
        
        savedRun.locations = NSOrderedSet(array: savedLocations)
        run = savedRun
        
        // error checking for run save
        var error: NSError?
        let success = managedObjectContext!.save(&error)
        if !success {
            println("Could not save the run!")
        }
    }
    
}

// MARK: - MKMapViewDelegate
extension RunViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if !overlay.isKindOfClass(MKPolyline) {
            return nil
        }
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3
        return renderer
    }
}

// MARK: - CLLocationManagerDelegate
extension RunViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        for location in locations as! [CLLocation] {
            if location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    distance += location.distanceFromLocation(self.locations.last)
                }
                
                //save location
                self.locations.append(location)
            }
        }
    }
}

// MARK: UIActionSheetDelegate
extension RunViewController: UIActionSheetDelegate {
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        //save
        if buttonIndex == 1 {
            saveRun()
            performSegueWithIdentifier(DetailSegueName, sender: nil)
        }
            //discard
        else if buttonIndex == 2 {
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}
