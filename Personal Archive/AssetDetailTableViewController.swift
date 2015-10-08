//
//  AssetDetailTableViewController.swift
//  Assetracker
//
//  Created by SB 8 on 10/8/15.
//  Copyright © 2015 vn.haibui. All rights reserved.
//

import UIKit
import Assetracker

class AssetDetailTableViewController: UITableViewController {

    @IBOutlet weak var assetTitleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateAddedLabel: UILabel!
    @IBOutlet weak var dateLastAccessedLabel: UILabel!
    @IBOutlet weak var classesLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var assetTracker : AssetTracker {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.assetTracker!
        
    }
    
    var assetID : String? = nil {
        
        didSet {
            
            guard assetID != nil else {
                
                return
                
            }
            
            reloadViewData()
            
        }
        
    }
    
    
    func reloadViewData () {
        
        if let result = try? assetTracker.getAsset(assetID!){
            
            if let foundAsset = result {
                
                assetTitleLabel?.text = foundAsset.assetName
                summaryLabel?.text = foundAsset.summary
                dateAddedLabel?.text = foundAsset.dateAdded?.description
                dateLastAccessedLabel?.text = foundAsset.dateLastAccessed?.description
                
            }
            
        }

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        reloadViewData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
