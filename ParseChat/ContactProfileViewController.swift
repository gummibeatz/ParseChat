//
//  ContactProfileViewController.swift
//  ParseChat
//
//  Created by Linus Liang on 10/31/15.
//  Copyright © 2015 Linus Liang. All rights reserved.
//

import Foundation
import UIKit
import Parse
import JSQMessagesViewController

class ContactProfileViewController: UIViewController {
    
    var contact: PFUser?
    var chatRoom: PFObject?
    
    @IBAction func startChattingButtonTapped(sender: UIButton) {
        let chatVC: ChatViewController = ChatViewController()

        chatVC.senderDisplayName = PFUser.currentUser()?.username
        chatVC.senderId = PFUser.currentUser()?.objectId
        chatVC.contact = contact
        
        createOrLoadChatRoom( {
            completionHandler in
            print("finished creating or loading chatroom")
            chatVC.chatRoom = self.chatRoom
            self.presentViewController(chatVC, animated: true, completion: nil)
            self.didMoveToParentViewController(self)
        })

    }
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        emailLabel.text = contact?.email
    }
    
    func createOrLoadChatRoom(completionHandler: () -> Void) {
        self.chatRoom = PFObject(className: "Chatroom")
        
        let query = PFQuery(className: "Chatroom")
        var contacts:[PFUser] = [PFUser.currentUser()!,contact!]
        query.whereKey("users", containsAllObjectsInArray: contacts)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("no chatroom")
                contacts = [PFUser.currentUser()!,self.contact!]
                self.chatRoom!["users"] = contacts
                self.chatRoom!["messages"] = []
                print("before chatroom is set to PFuser is set")
//                let relation = self.chatRoom?.relationForKey("user")
//                relation?.addObject(PFUser.currentUser()!)
//                relation?.addObject(self.contact!)
//                PFUser.currentUser()!["chatRoom"] = self.chatRoom
                PFUser.currentUser()!.saveInBackground()
            } else {
                print("chat room exists already")
                self.chatRoom! = object!
            }
            completionHandler()
        }
        
    }
    
}

