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
    
    //MARK: Labels.
    @IBOutlet weak var Pause: UIButton!
    @IBOutlet weak var Play: UIButton!
    
    //MARK: Functions.
    @IBAction func Pause(sender: AnyObject) {
        
        AudioPlayer.pause() // Pause the audio.
    }
    
    
    
    @IBAction func Play(sender: AnyObject) {
        
        AudioPlayer.play() // Play the audio.
    }
    
    
    override func viewDidLoad() {
        
        
        
    }

}