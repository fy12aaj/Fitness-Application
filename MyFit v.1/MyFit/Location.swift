//
//  Location.swift
//  MyFit
//
//  Created by Andrew Dowson [sc13ad] on 12/12/2015.
//  Copyright (c) 2015 Abdulaziz Jamal. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject {
    
    @NSManaged var timestamp: NSDate
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var run: NSManagedObject
    
}
