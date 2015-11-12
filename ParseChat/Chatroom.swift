//
//  ChatRoom.swift
//  ParseChat
//
//  Created by Max White on 11/4/15.
//  Copyright © 2015 Linus Liang. All rights reserved.
//

import Foundation
import Parse

protocol ChatroomDelegate {
    func didFinishLoading()
}

class Chatroom: PFObject, PFSubclassing{
    //pass in an array of users in the chatroom, perform query.  if it exists, load it; if not, create and save it.
    var users: [PFUser]?
    var messages: [PFObject]!
    var delegate: ChatroomDelegate?
    
    lazy var otherUsers: [PFUser] = {
        return self.users!.filter({$0 != PFUser.currentUser()!})
    }()
    
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
        self.setObject(users, forKey: "users")
        
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
                self.messages = []
                self.delegate?.didFinishLoading()
            } else {
                print("chat room already exists on server or in cache. load it.")
                self.messages = object!.objectForKey("messages") as! [PFObject]
                self.delegate?.didFinishLoading()
            }
        }
    }

    static func parseClassName() -> String {
        return "Chatroom"
    }
}

