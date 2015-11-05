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
        
        print("view did load")
        
        let currentUser = PFUser.currentUser()
        if currentUser == nil {
            print("could not load user from cache")
            let username = "myUsername"
            let password = "myPassword"
            PFUser.logInWithUsernameInBackground(username, password: password, block: {
                (user: PFUser?, error: NSError?) -> Void in
                if user == nil || error != nil {
                    print("login failed")
                } else {
                    print("login success!!")
                }
            })
        } else {
            print("loaded current user from cache")
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
        print("browse controller passing \(vc.contact)")
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("contactCellIdentifier", forIndexPath: indexPath)
        
        let contact: PFUser = contacts[indexPath.row]
        
        cell.textLabel!.text = contact["username"] as? String
        return cell
    }
    
    func loadContacts() {
        let query = PFUser.query()?.whereKey("isContact", equalTo: true)
        query?.cachePolicy = .CacheThenNetwork
        if (query?.hasCachedResult() == false) {
            print("no cached Contacts exist")
        } else {
            print("cached Contacts exist")
        }
        query?.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                print(error)
            } else {
                self.contacts = objects as! [PFUser]
                print("got contacts from server or cache")
                self.tableView.reloadData()
            }
        })
    }
}
