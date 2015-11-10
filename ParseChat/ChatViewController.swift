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
    
    var chatroom: Chatroom?
    var users = [PFUser]()
    var messages = [JSQMessage]()
    
    var avatars = Dictionary<String, UIImage>()

    override func viewDidLoad() {
        print("chat view loaded")
        super.viewDidLoad()
        print("users = \(users)")
        senderId = PFUser.currentUser()?.objectId
        senderDisplayName = PFUser.currentUser()?.username
        
        self.chatroom = Chatroom(users: users)
        self.chatroom?.delegate = self
//        createOrLoadChatRoom {
//            () -> Void in
//            self.loadMessages()
//        }
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        if (PFUser.currentUser() != nil) {
            sendMessages(text)
            finishSendingMessage()
        } else {
            
            let alert = UIAlertController(title: "Could Not Send Message", message: "You must be logged in to chat", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func sendMessages(text: String!) {
        print("creating message object")
        let message = JSQMessage(senderId: PFUser.currentUser()?.objectId, displayName: PFUser.currentUser()?.username, text: text)
        messages.append(message)
        
        let postMessage: PFObject = PFObject(className: "Message")
        postMessage["text"] = text
        postMessage["senderId"] = PFUser.currentUser()!.objectId
        
        
        chatroom?.addObject(postMessage, forKey: "messages")
        print("added message to chatroom")
        print("chatroom about to be saved: \(chatroom)")

        chatroom!.saveInBackgroundWithBlock {
            (success: Bool?, error: NSError?) -> Void in
            print("saving chatroom in background")
            if (success!){
                print("saved chatroom")
            } else {
                print("chatroom not saved")
                print("error: \(error)")
            }
        }
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        var bubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        
        print( "message sender name: \(messages[indexPath.row].senderDisplayName) ")
        print( "current user username: \(PFUser.currentUser()?.username)" )
        if messages[indexPath.row].senderDisplayName != PFUser.currentUser()?.username {
            bubbleImageView = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        }
        return bubbleImageView
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        super.collectionView(collectionView, didDeleteMessageAtIndexPath: indexPath)
        print("deleted but not really")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let icon = UIImage(named: "icon")
        let avatar = JSQMessagesAvatarImage(avatarImage: icon, highlightedImage: icon, placeholderImage: icon)
        return avatar
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.blackColor()
        } else {
            cell.textView!.textColor = UIColor.whiteColor()
        }
        let attributes : [String:AnyObject] = [NSForegroundColorAttributeName:cell.textView!.textColor!, NSUnderlineStyleAttributeName: 1]
        cell.textView!.linkTextAttributes = attributes
        cell.textView!.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView!.textColor!, NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        return cell
    }
    
    func loadMessages() {
        print("start loading messages")
        let rawMessages = chatroom?.messages
        let currentUser: PFUser = PFUser.currentUser()! as PFUser!
        
        for user in chatroom?.objectForKey("users") as! [PFUser] {
            print(user.username)
        }
        let otherUser: PFUser = (chatroom?.objectForKey("users") as! [PFUser]).filter({$0.objectId != currentUser.objectId!}).first! as PFUser!
        
        print("currentUser = \(currentUser)")
        print("otherUser = \(otherUser)")
        print(rawMessages!.count)
        messages.removeAll()
        for message in rawMessages! {
            let senderId: String = message.objectForKey("senderId") as! String
            let text: String = message.objectForKey("text") as! String
            var displayName: String = currentUser.username!
            print("senderId = \(senderId)")
            print("displayName = \(displayName)")
            print("if statement = \(senderId != currentUser.objectId)")
            print("dfoisefoseicnesoncs")
            
            
            if senderId != currentUser.objectId! {
                
                print("otheruser = \(otherUser.username!)")
                displayName = otherUser.username!
            }
            
            messages.append(JSQMessage(senderId: senderId, displayName: displayName, text: text))

        }
        self.collectionView?.reloadData()
        print(messages)
        
    }
}

extension ChatViewController: ChatroomDelegate {
    func didFinishLoading() {
        print("didFinish Loading")
        self.loadMessages()
    }
}


// Forr REFERENCE COOL COMPARATORS
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedAscending
}

extension NSDate: Comparable{}