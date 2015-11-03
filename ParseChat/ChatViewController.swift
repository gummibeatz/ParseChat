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
    
    var contact: PFUser?
    var chatRoom: PFObject?
    
    var messages = [JSQMessage]()
    var avatars = Dictionary<String, UIImage>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMessages()
        
        inputToolbar?.contentView?.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        navigationController?.navigationBar.topItem?.title = "Logout"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        sendMessages(text)
        finishSendingMessage()
    }
    
    func sendMessages(text: String!) {
        print("in send message")
        let message = JSQMessage(senderId: PFUser.currentUser()?.objectId, displayName: PFUser.currentUser()?.username, text: text)
        messages.append(message)
        
        let postMessage: PFObject = PFObject(className: "Message")
        postMessage["text"] = text
        postMessage["from"] = PFUser.currentUser()
        postMessage["chatRoom"] = chatRoom
        
        print("chatRoom = \(chatRoom)")
        
//        chatRoom!.saveInBackgroundWithBlock {
//            PFBooleanResultBlock in
//            print("saving chatroom in background")
//            if (PFBooleanResultBlock.0){
//                print("yay")
//            } else {
//                print("sadness")
//            }
//        }
        
        postMessage.saveInBackground()
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        var bubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        
        print( "message sender = \(messages[indexPath.row].senderDisplayName) ")
        print( "current user = \(PFUser.currentUser()?.username)" )
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
        let icon = UIImage(named: "Estefania")
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
        
        //        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
        //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
        return cell
    }
    
    
    func loadMessages() {
        let chatRoomId = chatRoom?.objectId
        let query = PFQuery(className: "Message")
        query.findObjectsInBackgroundWithBlock({
            PFQueryArrayResultBlock in
            let rawMessages = PFQueryArrayResultBlock.0!
            for message in rawMessages {
                let user: PFUser = message["from"] as! PFUser
                let senderId = user.objectId
                let displayName = user.username
                let text = message["text"] as! String
                self.messages.append(JSQMessage(senderId: senderId, displayName: displayName, text: text))
            }
            self.collectionView?.reloadData()
        })
    }
    
}











// FOr REFERENCE COOL COMPARAOTRS SWFIT
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedAscending
}

extension NSDate: Comparable{}