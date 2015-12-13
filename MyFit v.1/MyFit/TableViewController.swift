//
//  TableViewController.swift
//  MyFit
//
//  Created by Abdulaziz Jamal on 12/13/15.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import Foundation

import UIKit
import Parse
import AVFoundation
import AVKit


public var AudioPlayer = AVPlayer() // Allow edit song which in other viewcontrollers.
public var SelectedSongNumber = Int() // Change song and play different song.

class TableViewController: UITableViewController, AVAudioPlayerDelegate {
    
    var iDArray = [String]() // Storing Array of songs.
    var NameArray = [String]() // Storing Name of the songs.
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var ObjectIDQuery = PFQuery(className: "Songs") // Class ID from Parse which name is Songs.
        ObjectIDQuery.findObjectsInBackgroundWithBlock({ // Created objects and finds it in the background.
            (objectsArray :[AnyObject]?, error: NSError?) -> Void in // Store objects in Background in the Array.
            
            
            var objectIDs = objectsArray as! [PFObject] // Creates new object to get the songs from Parse.
            
            NSLog("\(objectIDs)") // ObjectID which stores in Parse.
            
            for i in 0...objectIDs.count-1{
                
                self.iDArray.append(objectIDs[i].valueForKey("objectId") as! String) // store new elemet in the new array of objectId which is a string.
                self.NameArray.append(objectIDs[i].valueForKey("SongName") as! String) // Store the new songs in the NameArray.
                
                self.tableView.reloadData() // Reload the page if songs was added in Parse which update the tableView.
                
                
                
            }
            
            
            
        })
    }
    
    func grapSong(){ // Get the songs.
        var SongQuery =  PFQuery(className: "Songs") // Get from the class Songs.
        SongQuery.getObjectInBackgroundWithId(iDArray[SelectedSongNumber], block: { // Taking first object depends on the tableview.
            
            (object : PFObject?, error : NSError?) -> Void in // Store the objects inside a PFObjects.
            
            
            if let AudioFileURLTemp = object?.objectForKey("SongFile")?.url { // Take all objects and store them in the AudioPlayer.
                
                AudioPlayer = AVPlayer(URL: NSURL(string: AudioFileURLTemp!))
                AudioPlayer.play()
                
                
                
            }
            
            
            
        })
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iDArray.count // Counting how many IDArray and return it..
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { // set the tableview and the cell for the idetifier to show the songs.
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        cell.textLabel?.text =  NameArray[indexPath.row] // Creates each of the cells from the indexPath.
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        SelectedSongNumber = indexPath.row // Selected the row of upload songs from Parse. Does not overlap.
        grapSong() // grap and play the song in the tableView.
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


