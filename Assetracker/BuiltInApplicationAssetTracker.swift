//
//  BuiltInApplicationAssetTracker.swift
//  Assetracker
//
//  Created by SB 8 on 10/20/15.
//  Copyright © 2015 vn.haibui. All rights reserved.
//

import UIKit

public enum BuiltInAssetClass : String {
    
    case AppImages
    case UserSpecifics
    
}

public class BuiltInApplicationAssetTracker: NSObject {

    var assetTracker_ : AssetTracker! = nil
    public var assetTracker : AssetTracker {
        
        if assetTracker_ == nil {
            
            let defaultFileManager = NSFileManager.defaultManager()
            let appSupportDir = try! defaultFileManager.URLForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
            let assetDirURL = appSupportDir.URLByAppendingPathComponent("asset_files")
            try! defaultFileManager.createDirectoryAtURL(assetDirURL, withIntermediateDirectories: true, attributes: nil)
            assetTracker_ = AssetTracker(assetDirectoryURL: assetDirURL)
            prepopulateDefaultAssetClasses()
            
            
        }
        
        return assetTracker_
        
    }

    
    func prepopulateDefaultAssetClasses () {
        
        if assetTracker_.getAssetClass(BuiltInAssetClass.AppImages.rawValue) == nil {
            
            assetTracker_.addAssetClass(BuiltInAssetClass.AppImages.rawValue)
            
        }

        
        if assetTracker_.getAssetClass(BuiltInAssetClass.UserSpecifics.rawValue) == nil {
            
            assetTracker_.addAssetClass(BuiltInAssetClass.UserSpecifics.rawValue)
            
        }
        
        
    }
    
}
