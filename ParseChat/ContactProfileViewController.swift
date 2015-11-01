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
    
    @IBAction func startChattingButtonTapped(sender: UIButton) {
        var newVC = JSQMessagesViewController()
        newVC.senderDisplayName = user?.email
        newVC.senderId = user?.objectId
        self.presentViewController(newVC, animated: true, completion: nil)
        self.didMoveToParentViewController(self)
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: PFUser?
    
    override func viewDidLoad() {
        emailLabel.text = user?.email
    }
    
}
