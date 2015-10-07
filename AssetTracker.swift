//
//  NotifiOSCumulationCenter.swift
//  NotifiOSCumulation
//
//  Created by Bui Hai on 9/21/15.
//  Copyright © 2015 Bui Hai. All rights reserved.
//

import UIKit
import CoreData

public class AssetTracker {
    
    let persistenceSetup : AssetTrackerPersistenceStackSetup
    let assetDirectoryURL : NSURL
    
    /// Creates a tracker with paths configuration
    /// - Parameter assetDirectoryURL:Where asset files are stored
    /// - Parameter databasesURL: Where the asset metadata database is stored
    public init(assetDirectoryURL : NSURL, var databasesURL : NSURL? = nil) {
        
        if databasesURL == nil {
            
            var storeURL : NSURL {
                
                let defaultFileManager = NSFileManager.defaultManager()
                let appDirURL = try! defaultFileManager.URLForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
                return appDirURL.URLByAppendingPathComponent("assets.store")
                
                
            }
            databasesURL = storeURL
            
        }
        
        persistenceSetup = AssetTrackerPersistenceStackSetup(storePath: databasesURL!)
        self.assetDirectoryURL = assetDirectoryURL
        persistenceSetup.setUpContext()
        
        
    }
    
    
    public var allAssetClasses : [AssetClass] {
        
        let fetchRequest = NSFetchRequest(entityName: AssetClass.entityName)
        fetchRequest.predicate = NSPredicate(value: true)
        let results = (try? persistenceSetup.context.executeFetchRequest(fetchRequest)) as? [AssetClass]
        return results ?? []

        
    }
    
    public func addAssetClass(
        name : String,
        var identifier : String = "",
        summary : String? = ""
        ) -> AssetClass? {
            
            if identifier.isEmpty {
                
                identifier = name
                
            }
            
            let addedClass = NSEntityDescription.insertNewObjectForEntityForName(AssetClass.entityName, inManagedObjectContext: persistenceSetup.context) as! AssetClass
            addedClass.name = name
            addedClass.identifier = identifier
            addedClass.summary = summary
            
            do {
                
                try persistenceSetup.context.save()
                return addedClass
                
            } catch {
            
                return nil
                
            }
            
    }
    
    public func removeAssetClass (assetClass : AssetClass) throws -> Bool {
        
        guard true else {
            
            
        }
        
        persistenceSetup.context.deleteObject(assetClass)
        try persistenceSetup.context.save()
        
        return true
        
    }
    
    public func addAsset(
        name : String,
        identifier : String,
        summary : String?,
        fromFileURL sourceFileURL : NSURL,
        fileSize : Int64 = 0,
        customStorageURL : NSURL? = nil,
        dateAdded : NSDate = NSDate(),
        var fileName : String = "",
        assetClasses : Set<AssetClass>? = nil) -> Asset? {
            
            if fileName.isEmpty {
                
                // deduce file name from asset's source path
                fileName = sourceFileURL.lastPathComponent!
                
            }
            
            let addedAsset = NSEntityDescription.insertNewObjectForEntityForName(Asset.entityName, inManagedObjectContext: persistenceSetup.context) as! Asset
            //mandatory attributes
            addedAsset.assetName = name
            addedAsset.assetID = identifier
            addedAsset.summary = summary
            let destinationAssetURL = assetDirectoryURL.URLByAppendingPathComponent(fileName)
            addedAsset.filePath = destinationAssetURL.path
            
            //optional attributes
            addedAsset.assetFileSize = NSNumber(longLong: fileSize) //TODO: calculate if unspecified
            addedAsset.customStorageURL = customStorageURL?.path
            addedAsset.dateAdded = dateAdded
            addedAsset.assetFileName = fileName
            addedAsset.classes = assetClasses
            
            
            
            
            do {
                
                // move the asset source file to the storage directory
                try NSFileManager.defaultManager().copyItemAtURL(sourceFileURL, toURL: destinationAssetURL)
                try persistenceSetup.context.save()
                return addedAsset
                
            } catch {
                
                persistenceSetup.context.deleteObject(addedAsset)
                return nil
                
            }
            
    }
    
    
    public func removeAsset( assetToRemove : Asset ) throws -> Bool {
        
        guard true else {
            
            
            
        }
        
        try NSFileManager.defaultManager().removeItemAtPath(assetToRemove.filePath!)
        
        //remove the metadata
        persistenceSetup.context.deleteObject(assetToRemove)
        try persistenceSetup.context.save()

        return true
        
    }
    
    
    public func removeAssets (assets : [Asset]) throws -> Bool {
        
        for asset in assets {
            
            persistenceSetup.context.deleteObject(asset)
            try NSFileManager.defaultManager().removeItemAtPath(asset.filePath!)
            
        }
        try persistenceSetup.context.save()
        return true
        
    }
    
}



class AssetTrackerPersistenceStackSetup : NSObject{
    
    var storePath_ : NSURL
    var storePath : NSURL {
        
        return storePath_
        
    }
    

    
    init (storePath : NSURL) {
        
        storePath_ = storePath
        
    }
    
    
    var context_ : NSManagedObjectContext! = nil
    var context : NSManagedObjectContext! {
     
            return context_
        
    }
    
    
    func setUpContext () {
        
        if context_ == nil {
            
            let thisBundle = NSBundle(forClass: AssetTrackerPersistenceStackSetup.classForCoder())
            var managedModel_ : NSManagedObjectModel! = nil
            var persistenceCoordinator_ : NSPersistentStoreCoordinator! = nil
            managedModel_ = NSManagedObjectModel(contentsOfURL: thisBundle.URLForResource("Model", withExtension: "momd")!)
            persistenceCoordinator_ = NSPersistentStoreCoordinator(managedObjectModel: managedModel_)
            try! persistenceCoordinator_.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storePath, options: [NSInferMappingModelAutomaticallyOption:true])
            context_ = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            context_?.persistentStoreCoordinator = persistenceCoordinator_
            
        }
        
    }
    
}







