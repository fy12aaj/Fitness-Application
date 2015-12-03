//
//  ViewController.swift
//  MyFit
//
//  Created by Abdulaziz Jamal on 12/1/15.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    
    var timer = NSTimer() // Object that control the time according the var.
    
    var count = 0.00 // set count to 0.
    
    func updateTime() { // Func updateTime.
        
        count = count + 0.01 // Add one to the count.
        
        var output = Double(round(100*count)/100)
        
        Time.text = "\(output)"
    }
    
    //MARK: Outlets
    
    @IBOutlet var Time: UILabel!
    @IBOutlet weak var FinishButton: UIButton!
    @IBOutlet weak var Finish: UIButton!
    
    //MAKE: Actions
    @IBAction func finishRun(sender: UIButton) {
    timer.invalidate()
    }
    
    
    //MARK: Functions
    
    @IBAction func Rest(sender: AnyObject) { // rest page should be changed soon.
        
        timer.invalidate() // stop the time.
        
        count = 0 // rest time to 0.
        
        Time.text = "0.00" // print 0 to user.
    }
    
    
    @IBAction func Play(sender: AnyObject) {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true) // timer object which tick every 0.01 secound with one view controler, method results run every secound. UpTime.
    }
    
    @IBAction func Pause(sender: AnyObject){
        timer.invalidate()

    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

