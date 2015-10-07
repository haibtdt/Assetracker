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

    @NSManaged public var assetID: String?
    @NSManaged public var assetName: String?
    @NSManaged public var summary: String?
    @NSManaged var customStorageURL: String?
    @NSManaged public var assetFileSize: NSNumber?
    @NSManaged var filePath: String?
    @NSManaged public var dateAdded: NSDate?
    @NSManaged public var dateLastAccessed: NSDate?
    @NSManaged public var assetFileName: String?
    @NSManaged public var classes: NSSet?

}
