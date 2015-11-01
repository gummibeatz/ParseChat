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
    enum QueryErrors: ErrorType {
        case BadCast
    }
    
    var idx: Int?
    
    override func viewDidLoad() {
        
        myMethod()
        
        var query = PFUser.query()
        query?.whereKey("isContact", equalTo: true)
        do {
            contacts = try query?.findObjects() as! [PFUser]
            print(contacts)
        } catch {
            print("caught")
        }
        
        

    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc: ContactProfileViewController = segue.destinationViewController as! ContactProfileViewController

        let index: Int = self.tableView.indexPathForSelectedRow!.row
        vc.user = contacts[index]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("userCellIdentifier", forIndexPath: indexPath)
        
        cell.textLabel!.text = contacts[indexPath.row].email
        return cell
    }
    
    func myMethod() {
        var user = PFUser()
        user.username = "myUsername4"
        user.password = "myPassword4"
        user.email = "email4@example.com"
        user["isContact"] = true
        // other fields can be set just like with PFObject
        user["phone"] = "415-392-0202"
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
            }
        }
    }
}
