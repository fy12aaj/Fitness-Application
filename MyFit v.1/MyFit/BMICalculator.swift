//
//  BMICalculator.swift
//  MyFit
//
//  Created by Abdulaziz Jamal on 12/8/15.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import UIKit

class BMICalculator: UIViewController {
    
    // MARK: Outlets.
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var genderControl: UISegmentedControl!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var motionsegue: UILabel!
    
    
    // MARK: Actions
    @IBAction func weightChanged(sender: AnyObject) {
        weightLabel.text = String(stringInterpolationSegment: weightSlider.value) + "lbs"
    }
    
    
    // MARK: Functions
    
    override func canBecomeFirstResponder() -> Bool{
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            performSegueWithIdentifier("showres", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderControl.selectedSegmentIndex = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    
        let detailController = segue.destinationViewController as! BMIResultViewController
        let a: Int? = (heightTextField.text!).toInt()
        let b: Int = Int(weightSlider.value)
        let c: Int? = (genderControl.selectedSegmentIndex)
    
        detailController.height = a!
        detailController.weight = b
        detailController.gender = c!
        
    }
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    
}
