//
//  AssetClass+CoreDataProperties.swift
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

extension AssetClass {

    @NSManaged public var name: String?
    @NSManaged public var identifier: String?
    @NSManaged public var summary: String?
    @NSManaged public var assets: NSSet?

}
