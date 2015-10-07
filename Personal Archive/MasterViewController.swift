//
//  MasterViewController.swift
//  Personal Archive
//
//  Created by SB 8 on 10/6/15.
//  Copyright © 2015 vn.haibui. All rights reserved.
//

import UIKit
import Assetracker

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var assetClasses = [AssetClass]()
    var assetTracker_ : AssetTracker! = nil
    var assetTracker : AssetTracker {
        
        if assetTracker_ != nil { return assetTracker_ }
        let defaultFileManager = NSFileManager.defaultManager()
        let assetDirURL = try! defaultFileManager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        assetTracker_ = AssetTracker(assetDirectoryURL: assetDirURL)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.assetTracker = assetTracker_
        
        return assetTracker_
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // Retrieve all asset classes
        assetClasses = assetTracker.allAssetClasses
        
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }


    func insertNewObject(sender: AnyObject) {

        if let addedClass = assetTracker.addAssetClass(NSDate().description) {
            
            assetClasses.append(addedClass)
            let insertedIndexPath = NSIndexPath(forRow: assetClasses.count-1, inSection: 0)
            tableView.insertRowsAtIndexPaths([insertedIndexPath], withRowAnimation: UITableViewRowAnimation.Right)
            
        }
        
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let assetClass = assetClasses[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.assetClass = assetClass
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetClasses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = assetClasses[indexPath.row]
        cell.textLabel!.text = object.name
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            assetClasses.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

