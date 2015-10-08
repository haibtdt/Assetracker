//
//  CleanUpViewController.swift
//  Assetracker
//
//  Created by SB 8 on 10/8/15.
//  Copyright © 2015 vn.haibui. All rights reserved.
//

import UIKit
import Assetracker

class CleanUpViewController: UIViewController {

    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    var assetTracker : AssetTracker {
        
        let appDelete = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelete.assetTracker!
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func proceedCleanUp(sender: AnyObject) {

        //        TODO: show confirmation
        
        if let deletedCount = try? assetTracker.removeAssetsLastUsedEarlier(than: dateTimePicker.date) {
            
            print("deleted \(deletedCount) asset(s)")
            
        }
        
        
    }

}
