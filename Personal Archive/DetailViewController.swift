//
//  DetailViewController.swift
//  Personal Archive
//
//  Created by SB 8 on 10/6/15.
//  Copyright © 2015 vn.haibui. All rights reserved.
//

import UIKit
import Assetracker

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    var assetTracker : AssetTracker {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.assetTracker!
        
    }

    var allAssets : [Asset] = []
    var assetClass: AssetClass? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    @IBAction func addAsset(sender: AnyObject) {
        
        let sampleFileURL = NSBundle.mainBundle().URLForResource("unread_indicator", withExtension: "png")!
        if let addedAsset = assetTracker.addAsset(
            (sampleFileURL.lastPathComponent)!,
            identifier: "an effective identifier goes here",
            summary: "sample summary",
            fromFileURL: sampleFileURL,
            assetClasses : Set(arrayLiteral: assetClass!)
            ) {
                
                
                allAssets.append(addedAsset)
                let insertedIndexPath = NSIndexPath(forRow: allAssets.count-1, inSection: 0)
                tableView?.insertRowsAtIndexPaths([insertedIndexPath], withRowAnimation: .Right)
                
        }
        
        
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let assets = self.assetClass?.assets as? Set<Asset>{

            allAssets = Array(assets)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }


//    TableView protocols
    let cellIdentifier = "vn.haibui.AssetCell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            
        }
        let asset = allAssets[indexPath.row]
        if let image = try? UIImage(contentsOfFile: assetTracker.getAssetPath(asset)) {
            
            cell?.imageView?.image = image
            
        }
        cell?.detailTextLabel?.text = asset.dateLastAccessed?.description
        cell?.textLabel?.text = "\(asset.assetName!) - \(asset.dateLastAccessed!)"
        
        
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allAssets.count
        
        
    }
    
    @IBAction func removeAllAssets(sender: AnyObject) {
        
        if let removed = try? assetTracker.removeAssets(allAssets) {
            
            guard removed else {

                return
                
            }
            
            configureView()
            tableView.reloadData()
            
        }
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {

            let assetToDelete = allAssets[indexPath.row]
            if let deleted = try? assetTracker.removeAsset(assetToDelete){
                
                guard deleted else {
                    
                    return
                    
                }
                
                allAssets.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

                
            } else {
                
                
                
            }
            
        } else if editingStyle == .Insert {
            
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    

}

