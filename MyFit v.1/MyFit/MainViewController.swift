//
//  MainViewController.swift
//  MyFit
//
//  Created by Abdulaziz Jamal on 12/13/15.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import Foundation
import UIKit

class MainViewController : UIViewController {
    
    @IBOutlet weak var Pause: UIButton!
    @IBOutlet weak var Play: UIButton!
    
    @IBAction func Pause(sender: AnyObject) {
        
        AudioPlayer.pause()
    }
    
    
    
    @IBAction func Play(sender: AnyObject) {
        
        AudioPlayer.play()
    }
    
    
    override func viewDidLoad() {
        
        
        
    }

}