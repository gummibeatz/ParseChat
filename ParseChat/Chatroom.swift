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
//    var users: [PFUser]?
    @NSManaged var users: [PFUser]
    @NSManaged var messages: [PFObject]!
    
    lazy var otherUsers: [PFUser] = {
        return self.users.filter({$0 != PFUser.currentUser()!})
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
   
    init(users:[PFUser], messages: [PFObject]) {
        super.init()
        self.users = users
        self.messages = messages
    }

    static func parseClassName() -> String {
        return "Chatroom"
    }
   
    override class func query() -> PFQuery? {
        let query = PFQuery(className: self.parseClassName())
        query.includeKey("users")
        query.includeKey("messages")
        return query
    }
}

