//
//  ExistingMessageController.swift
//  ParseChat
//
//  Created by Linus Liang on 11/1/15.
//  Copyright © 2015 Linus Liang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ExistingMessagesController: UITableViewController {
    
    var idx: Int?
    var conversations: [PFObject] = []
    enum QueryErrors: ErrorType {
        case BadCast
    }
    
    
    
    override func viewDidLoad() {
    
        let query = PFQuery(className: "Chatroom").whereKey("users", equalTo: PFUser.currentUser()!)
        query.includeKey("users")
        do {
            conversations = try query.findObjects()
            self.tableView.reloadData()
        } catch {
            
        }
        print(conversations)

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("contactCellIdentifier", forIndexPath: indexPath)
       
        print(conversations[indexPath.row].objectForKey("users") as! [PFUser])
        
        cell.textLabel!.text = (conversations[indexPath.row].objectForKey("users") as! [PFUser]).filter({$0 != PFUser.currentUser()!}).first?.username
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select row")
    }
    
}
