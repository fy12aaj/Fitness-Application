//
//  ViewController.swift
//  MyFit
//
//  Created by Abdulaziz Jamal on 12/1/15.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer = NSTimer() // Object that control the time according the var.
    
    var count = 0 // Var count start from 0 for the timer object.
    
    func result() { // Results function
        
        count++ // count 1.
        println(count) // appear in the log.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("result"), userInfo: nil, repeats: true) // timer object which tick every 1 secound with one view controler, method results run every secound.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

