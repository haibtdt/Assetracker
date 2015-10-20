//
//  NotifiOSCumulationCenter.swift
//  NotifiOSCumulation
//
//  Created by Bui Hai on 9/21/15.
//  Copyright © 2015 Bui Hai. All rights reserved.
//

import UIKit
import CoreData

public protocol AssetTrackerObserver: class {
    
    func assetDidAdd(asset : Asset, byTracker tracker : AssetTracker)
    func assetWillBeRemoved (asset:Asset, byTracker tracker : AssetTracker)
    
}

public class AssetTracker {
    
    let persistenceSetup : AssetTrackerPersistenceStackSetup
    public let assetDirectoryURL : NSURL
    
    public weak  var trackingObserver : AssetTrackerObserver? = nil
    
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
    
//    MARK: asset class
    public var allAssetClasses : [AssetClass] {
        
        let fetchRequest = NSFetchRequest(entityName: AssetClass.entityName)
        fetchRequest.predicate = NSPredicate(value: true)
        let results = (try? persistenceSetup.context.executeFetchRequest(fetchRequest)) as? [AssetClass]
        return results ?? []

        
    }
    
    public func getAssetClass (named : String) -> AssetClass? {
        
        
        let fetchRequest = NSFetchRequest(entityName: AssetClass.entityName)
        fetchRequest.predicate = NSPredicate(format: "name == %@", argumentArray: [named])
        fetchRequest.fetchLimit = 1
        do {
            
            let results = try persistenceSetup.context.executeFetchRequest(fetchRequest)
            return (results.first as! AssetClass?)
            
        } catch {
            
            return nil
            
        }
        
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
    
    
//    MARK: asset
    
    public func getAsset(assetID : String) throws -> Asset? {
        
        let fetchRequest = NSFetchRequest(entityName: Asset.entityName)
        fetchRequest.predicate = NSPredicate(format: "assetID == %@", argumentArray: [assetID])
        fetchRequest.fetchLimit = 1
        let results = (try persistenceSetup.context.executeFetchRequest(fetchRequest)) as! [Asset]
        
        return results.first
        
    }
    
    func getAssetURL (asset : Asset) -> NSURL {
        
        let destinationAssetURL = assetDirectoryURL.URLByAppendingPathComponent(asset.assetFileName!)
        return destinationAssetURL
        
    }
    
    public func addAsset(
        name : String,
        identifier : String,
        summary : String?,
        fromFileURL sourceFileURL : NSURL,
        fileSize : Int64 = 0,
        dateAdded : NSDate = NSDate(),
        var fileName : String = "",
        assetClasses : Set<AssetClass>? = nil,
        fileIsInPlace : Bool = false) -> Asset? {
            
            if fileName.isEmpty {
                
                // deduce file name from asset's source path
                fileName = sourceFileURL.lastPathComponent!
                
            }
            
            let addedAsset = NSEntityDescription.insertNewObjectForEntityForName(Asset.entityName, inManagedObjectContext: persistenceSetup.context) as! Asset
            //mandatory attributes
            addedAsset.assetName = name
            addedAsset.assetID = identifier
            addedAsset.summary = summary
            
            //optional attributes
            addedAsset.assetFileSize = NSNumber(longLong: fileSize) //TODO: calculate if unspecified
            addedAsset.dateAdded = dateAdded
            addedAsset.dateLastAccessed = dateAdded
            addedAsset.assetFileName = fileName
            addedAsset.classes = assetClasses
            
            
            
            
            do {
                
                if fileIsInPlace {
                    
                    
                } else {
                    
                    // move the asset source file to the storage directory
                    try NSFileManager.defaultManager().copyItemAtURL(sourceFileURL, toURL: getAssetURL(addedAsset))
                    
                }
                try persistenceSetup.context.save()
                trackingObserver?.assetDidAdd(addedAsset, byTracker: self)
                return addedAsset
                
            } catch {
                
                persistenceSetup.context.deleteObject(addedAsset)
                return nil
                
            }
            
    }
    
    
    
    
    public func removeAsset( assetToRemove : Asset ) throws -> Bool {
        
        guard true else {
            
            
            
        }
        
        trackingObserver?.assetWillBeRemoved(assetToRemove, byTracker: self)
        let _ = try? NSFileManager.defaultManager().removeItemAtURL(getAssetURL(assetToRemove))
        persistenceSetup.context.deleteObject(assetToRemove)
        try persistenceSetup.context.save()

        return true
        
    }
    
    
    public func removeAssets (assets : [Asset]) throws -> Bool {
        
        for asset in assets {
            
            trackingObserver?.assetWillBeRemoved(asset, byTracker: self)
            persistenceSetup.context.deleteObject(asset)
            let _ = try? NSFileManager.defaultManager().removeItemAtURL(getAssetURL(asset))
            
        }
        try persistenceSetup.context.save()
        return true
        
    }
    
    public func removeAssetsWithinClass ( assetClass : AssetClass ) throws -> Bool {
        
        if let assets = assetClass.assets as? Set<Asset>{
            
            let assetsToRemov = Array(assets)
            try removeAssets(assetsToRemov)
            
        }
        
        return true
        
    }
    
    
    public func removeAssetsLastUsedEarlier(than date : NSDate) throws -> Int {
        
        let fetchRequest = NSFetchRequest(entityName: Asset.entityName)
        fetchRequest.predicate = NSPredicate(format: "dateLastAccessed < %@", argumentArray: [date])
        let suchAssets = try persistenceSetup.context.executeFetchRequest(fetchRequest)
            
        try removeAssets(suchAssets as! [Asset])
        return suchAssets.count
        
    }
    
    
    public func getAssetPath( asset : Asset ) throws -> String {
        
        asset.dateLastAccessed = NSDate()
        try persistenceSetup.context.save()        
        return getAssetURL(asset).path!
        
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







