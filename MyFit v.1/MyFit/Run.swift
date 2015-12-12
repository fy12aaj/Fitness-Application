//
//  Run.swift
//  MyFit
//
//  Created by Andrew Dowson [sc13ad] on 12/12/2015.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import Foundation
import CoreData

class Run: NSManagedObject {
    
    @NSManaged var duration: NSNumber
    @NSManaged var distance: NSNumber
    @NSManaged var timestamp: NSDate
    @NSManaged var locations: NSOrderedSet
    
}