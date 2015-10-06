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
                let insertedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
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
        cell?.textLabel?.text = asset.assetName
        
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allAssets.count
        
        
    }

}

