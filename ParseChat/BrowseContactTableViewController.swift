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

class BrowseContactTableViewController: UITableViewController {
    
    var contacts: [PFUser] = []
    

    override func viewDidLoad() {
        let username = "myUsername"
        let password = "myPassword"
        print("view did load")
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject("qxhbCealXf", forKey: "userId")
        
        PFUser.logInWithUsernameInBackground(username, password: password, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if user == nil || error != nil {
                print("login failed")
            } else {
                print("login success!!")
                self.loadContacts()
            }
        })
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
        let query = PFUser.query()
        query?.whereKey("isContact", equalTo: true)
//        query?.fromLocalDatastore()
        query?.findObjectsInBackgroundWithBlock({
            PFQueryArrayResultBlock in
            self.contacts = PFQueryArrayResultBlock.0 as! [PFUser]
            self.tableView.reloadData()
            PFObject.pinAllInBackground(self.contacts)
        })
    }
}
