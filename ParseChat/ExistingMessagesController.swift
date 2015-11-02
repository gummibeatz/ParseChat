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
        
        signIn()
        let user = PFUser.currentUser()
        let relation = user?.relationForKey("chatRoom")
        let query = relation?.query()
        do {
            var results = try query?.findObjects()
            print(results)
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
        var vc: ContactProfileViewController = segue.destinationViewController as! ContactProfileViewController
        
        let index: Int = self.tableView.indexPathForSelectedRow!.row

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("userCellIdentifier", forIndexPath: indexPath)
        
        cell.textLabel!.text = "test"//conversations[indexPath.row]
        return cell
    }
    
    func signIn() {
        do {
            try PFUser.logInWithUsername("myUsername", password: "myPassword")
        } catch {
            print (" wioll i hverr ")
        }
        print("in sign in")
        print(PFUser.currentUser())
    }

}
