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
    var chatrooms: [PFObject] = []
    enum QueryErrors: ErrorType {
        case BadCast
    }
    
    
    
    override func viewDidLoad() {
    
        let query = PFQuery(className: "Chatroom").whereKey("users", equalTo: PFUser.currentUser()!)
        query.includeKey("users")
        do {
            chatrooms = try query.findObjects()
            self.tableView.reloadData()
        } catch {
            
        }
        print(chatrooms)

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatrooms.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("contactCellIdentifier", forIndexPath: indexPath)
       
        print(chatrooms[indexPath.row].objectForKey("users") as! [PFUser])
        
        cell.textLabel!.text = (chatrooms[indexPath.row].objectForKey("users") as! [PFUser]).filter({$0 != PFUser.currentUser()!}).first?.username
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select row")
        let chatVC: ChatViewController = ChatViewController()
        chatVC.users = (self.chatrooms[indexPath.row] as! PFObject).objectForKey("users") as! [PFUser]
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
}
