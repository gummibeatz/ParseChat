//
//  ChatRoom.swift
//  ParseChat
//
//  Created by Max White on 11/4/15.
//  Copyright © 2015 Linus Liang. All rights reserved.
//

import Foundation
import Parse

class Chatroom: PFObject, PFSubclassing{
    //pass in an array of users in the chatroom, perform query.  if it exists, load it; if not, create and save it.
    @NSManaged var users: [PFUser]?
    var otherUsers: [PFUser]!
    var messages: [PFObject]!

    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    override init() {
        super.init()
    }
   
    init(users:[PFUser]) {
        super.init()
        self.users = users
        let query = PFQuery(className: "Chatroom")
        
        query.whereKey("users", containsAllObjectsInArray: users)
        query.includeKey("messages")
        query.includeKey("users")
        query.cachePolicy = .CacheThenNetwork
        if (query.hasCachedResult()) {
            print("cached chatroom exists")
        } else {
            print("cached chatroom doesn't exist")
        }
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("no chatroom found on server or cache")
                let chatroom = PFObject(className: "Chatroom")
                self.messages = []
            } else {
                print("chat room already exists on server or in cache. load it.")
                self.messages = object!.objectForKey("messages") as! [PFObject]
            }
        }
    }

    static func parseClassName() -> String {
        return "Chatroom"
    }
}

