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
        createOrLoadChatRoom()
        
        chatVC.senderDisplayName = PFUser.currentUser()?.username
        chatVC.senderId = PFUser.currentUser()?.objectId
        chatVC.contact = contact
        chatVC.chatRoom = self.chatRoom!
        self.presentViewController(chatVC, animated: true, completion: nil)
        self.didMoveToParentViewController(self)
    }
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        emailLabel.text = contact?.email
    }
    
    func createOrLoadChatRoom() {
        self.chatRoom = PFObject(className: "Chatroom")
        
        let query = PFQuery(className: "Chatroom")
        let contacts:[PFUser] = [PFUser.currentUser()!,contact!]
        query.whereKey("users", containsAllObjectsInArray: contacts)
        do {
            let results = try query.getFirstObject()
            self.chatRoom = results
        } catch {
            let contacts: [PFUser] = [PFUser.currentUser()!,contact!]
            self.chatRoom!["users"] = contacts
            self.chatRoom!["messages"] = []
            print("before chatroom is set to PFuser is set")
            let relation = chatRoom?.relationForKey("user")
            relation?.addObject(PFUser.currentUser()!)
            relation?.addObject(contact!)
            PFUser.currentUser()!["chatRoom"] = self.chatRoom
            do {
                try PFUser.currentUser()?.save()
            } catch{
                print("caught 2")
            }
        }

        do {
            try self.chatRoom!.save()
            
        } catch {
            
        }
        
    }
    
}

