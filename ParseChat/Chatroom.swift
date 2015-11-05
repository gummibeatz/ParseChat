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
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    init(users:[PFUser]) {
        super.init()
        self.users = users
    }

    
    static func parseClassName() -> String {
        return "Chatroom"
    }
}

