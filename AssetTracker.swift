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
    public init(storeURL : NSURL) {
        
        persistenceSetup = AssetTrackerPersistenceStackSetup(storePath: storeURL)
        persistenceSetup.setUpContext()
        
        
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







