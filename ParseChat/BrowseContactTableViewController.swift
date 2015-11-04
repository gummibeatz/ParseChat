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
    
    var idx: Int?
    var contacts: [PFUser] = []
    enum QueryErrors: ErrorType {
        case BadCast
    }
    

    
    override func viewDidLoad() {
        let username = "myUsername"
        let password = "myPassword"
        PFUser.logInWithUsernameInBackground(username, password: password, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if user == nil || error != nil{
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

        let index: Int = self.tableView.indexPathForSelectedRow!.row
        vc.contact = contacts[index]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("userCellIdentifier", forIndexPath: indexPath)
        
        cell.textLabel!.text = contacts[indexPath.row].email
        return cell
    }
    
    func loadContacts() {
        let query = PFUser.query()
        query?.whereKey("isContact", equalTo: true)
        query?.findObjectsInBackgroundWithBlock({
            PFQueryArrayResultBlock in
            self.contacts = PFQueryArrayResultBlock.0 as! [PFUser]
            self.tableView.reloadData()
            PFObject.pinAllInBackground(self.contacts)
        })
    }
}
