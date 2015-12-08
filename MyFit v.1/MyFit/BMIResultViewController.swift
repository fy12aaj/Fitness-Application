//
//  BMIResultViewController.swift
//  MyFit
//
//  Created by Abdulaziz Jamal on 12/8/15.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//


import UIKit

class BMIResultViewController: UIViewController {
    
    
    @IBOutlet weak var bmiGenderField: UILabel!
    

    @IBOutlet weak var bmiResultField: UILabel!
    var height:  Int = 0
    var weight:  Int = 0   // variable declaration
    var gender:  Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let res :  Int = (weight *  703) / ( height *  height) //  calculation formula
        var val :  String
        if(res <  18)
        {
            val = "under weight"  // less then 18 under weight
        }
        else if(res <  25)
        {
            val = "normal weight"  // less then 25 normal weight
        }
        else if(res < 30)
        {
            val = "over weight"  //less then 30 over weight
        }
        else
        {
            val = "obsessed"  // otherwise obsessed.
        }
        if(gender == 0)
        {
            bmiGenderField.text = "You are male."  // gender condition
        }
        else
        {
            bmiGenderField.text = "You are female."
        }
        bmiResultField.text = "You are "  + val +  ". Your BMI  is " +  String(res) // print the result
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
