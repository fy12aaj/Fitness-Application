//
//  WaistRationViewController.swift
//  MyFit
//
//  Created by Abdulaziz Jamal on 12/10/15.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import UIKit


class WaistRatioViewController: UIViewController {
    
    //MARK: OutLet
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var waistField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var resCategory: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            
        }
    }
    
    
    // MARK: Functions
    @IBAction func calCulateDown(sender: AnyObject) {
        
        let a: Int? = (waistField.text!).toInt()
        let b: Int? = (heightField.text!).toInt()
        
        var res =  (Float(a!)/Float(b!))
        res = round(res*100)/100
        resultLabel.text = "\(res)" // result wth
        if(0.34 > res) {
            resCategory.text = "You are extremely slim." // body calculation
        }
        else if(res < 0.45) {
            resCategory.text = "You are healthy slim."
        }
        else if(res < 0.51) {
            resCategory.text = "You are healthy."
        }
        else if(res < 0.63) {
            resCategory.text = "You are over weight."
        }
        else if(res < 0.63) {
            resCategory.text = "You are very over weight."
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
