//
//  File.swift
//  ParseChat
//
//  Created by Linus Liang on 10/31/15.
//  Copyright © 2015 Linus Liang. All rights reserved.
//

import Foundation
import Parse
import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    var user: PFUser?
    
    var messages = [JSQMessage]()
    var avatars = Dictionary<String, UIImage>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputToolbar?.contentView?.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        navigationController?.navigationBar.topItem?.title = "Logout"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.collectionViewLayout.springinessEnabled = true
    }

    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        sendMessages(text, sender: senderDisplayName)
        finishSendingMessage()
    }
    
    func sendMessages(text: String!, sender: String!) {
        print(text)
        print(sender)
        let message = JSQMessage(senderId: "asdfa", displayName: sender, text: text)
        messages.append(message)
        
        
    }
    
    
    
    // collection view copy begins
    

}