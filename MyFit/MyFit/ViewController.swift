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
    
    var count = 0
    
    func updateTime() { // Func updateTime.
        
        count++ // Add one to the count.
        Time.text = "\(count)" // Convert count to int.
    
    }
    
    @IBAction func Rest(sender: AnyObject) { // rest page should be changed soon.
        
        timer.invalidate() // stop the time.
        
        count = 0 // rest time to 0.
        
        Time.text = "0" // print 0 to user.
    }
    
    @IBOutlet var Time: UILabel!
    
    @IBAction func Finish(sender: AnyObject) { // this should take us to the next page.
        
    }
    
    
    @IBAction func Play(sender: AnyObject) {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true) // timer object which tick every 1 secound with one view controler, method results run every secound. UpTime.
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

