//
//  Asset+CoreDataProperties.swift
//  Assetracker
//
//  Created by SB 8 on 10/6/15.
//  Copyright © 2015 vn.haibui. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Asset {

    @NSManaged var assetID: String?
    @NSManaged var assetName: String?
    @NSManaged var customStorageURL: String?
    @NSManaged var assetFileSize: NSNumber?
    @NSManaged var filePath: String?
    @NSManaged var dateAdded: NSDate?
    @NSManaged var assetFileName: String?
    @NSManaged var classes: NSSet?

}
