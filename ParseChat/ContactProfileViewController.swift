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
        print("chat button tapped")
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
        query.fromLocalDatastore()
        let contacts = [PFUser.currentUser()!, contact!]
        query.includeKey("messages")
        query.whereKey("users", containsAllObjectsInArray: contacts)
        print("about to get query")
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("no chatroom")
                self.chatRoom!["messages"] = []
                self.chatRoom!["users"] = contacts
                self.chatRoom?.saveEventually({
                    (succeeded: Bool?, error: NSError?) in
                    print("inside chatroom save in background with block")
                    print("succeeded = \(succeeded)")
                    print("error = \(error)")
                    if(succeeded! && (error == nil)) {
                        print("chat room saved!!")
                        self.chatRoom?.pinInBackground()
                    }
                })
            } else {
                print("chat room exists already")
                self.chatRoom! = object!
                self.chatRoom?.pinInBackground()
            }
            print(self.chatRoom)
            completionHandler()
        }
        
    }
    
}

