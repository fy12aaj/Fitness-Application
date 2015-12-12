//
//  ViewController.swift
//  MyFit
//
//  Created by Abdulaziz Jamal on 12/6/15.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Social


class ViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var theLabel: UILabel!
    
    //MARK: Func for Facebook and Twitter share.
    
    // User need to put the login details from the setting either in the emulator or the phone.
    
    // Facebook.
    @IBAction func shareToFacebook(){
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook) // Check if the user has their Facebook Application installed and login.
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)// Alert the user to login to Facebook account to share. If the user has not installed the Facebook app or is not logged in, we create a UIAlertController and notify the user that they need to Login.

            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil) // If the user has installed the Facebook app and is logged in, then write the code to open the "Share Controller".
            

        }
    }
    
    // Twitter.
    @IBAction func shareToTwitter(){
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {        // Check if the user has their Twitter Application Installed and login.
            
            var tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert) // Alert the user to login to Twitter account to share. If the user has not installed the Twitter app or is not logged in, we create a UIAlertController and notify the user that they need to Login.
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)) // If the user has installed the Twitter app and is logged in, then write the code to open the "Share Controller".
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        
    }

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}

