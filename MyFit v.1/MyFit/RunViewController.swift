//
//  RunViewController.swift
//  MyFit
//
//  Created by Andrew Dowson [sc13ad] on 11/12/2015.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit

class RunViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
  
    
    override func viewWillAppear(animated: Bool) {
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    //MARK: Location Tracking
    
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
    
    // MARK: - CLLocationManagerDelegate
    extension NewRunViewController: CLLocationManagerDelegate {
    }
    
}

