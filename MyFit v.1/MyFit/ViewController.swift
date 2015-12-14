//
//  ViewController.swift
//  MyFit
//
//  Created by Abdulaziz Jamal on 12/6/15.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var startRun: UIButton!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //override for segue, to pass managdObjectContext to RunViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(RunViewController) {
            if let RunViewController = segue.destinationViewController as? RunViewController {
                RunViewController.managedObjectContext = managedObjectContext
    
            }
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

