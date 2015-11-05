//
//  BrowseContactTableViewController.swift
//  ParseChat
//
//  Created by Linus Liang on 10/31/15.
//  Copyright © 2015 Linus Liang. All rights reserved.
//

import UIKit
import Foundation
import Parse
import ReachabilitySwift

class BrowseContactTableViewController: UITableViewController {
    
    var contacts: [PFUser] = []
//    let offlineObjectId = "qxhbCealXf" //user
    let offlineObjectId = "zXdDZGzPno" //user3
    

    override func viewDidLoad() {
        let username = "myUsername3"
        let password = "myPassword3"
        print("view did load")
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(offlineObjectId, forKey: "userId")
        if networkIsAvailable() {
            PFUser.logInWithUsernameInBackground(username, password: password)
        }

        self.loadContacts()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc: ContactProfileViewController = segue.destinationViewController as! ContactProfileViewController

        let indexPath = self.tableView.indexPathForSelectedRow
        vc.contact = contacts[indexPath!.row]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("contactCellIdentifier", forIndexPath: indexPath)
        
        let contact: PFUser = contacts[indexPath.row]
        
        cell.textLabel!.text = contact["username"] as? String
        return cell
    }
    
    func loadContacts() {
        print("in load contacts")
        let query = PFUser.query()
        query?.whereKey("isContact", equalTo: true)
        if !networkIsAvailable() {
            print("network is not available")
            query?.fromLocalDatastore()
        }
        query?.findObjectsInBackgroundWithBlock({
            PFQueryArrayResultBlock in
            self.contacts = (PFQueryArrayResultBlock.0 as! [PFUser]).filter({$0.objectId != PFUser.currentUser()?.objectId})
            if(!networkIsAvailable()) {
                self.contacts = (PFQueryArrayResultBlock.0 as! [PFUser]).filter({$0.objectId != self.offlineObjectId})
            }
            self.tableView.reloadData()
            PFObject.pinAllInBackground(self.contacts)
        })
        
    }

}
