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
    
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        emailLabel.text = contact?.email
    }
    
    @IBAction func startChattingButtonTapped(sender: UIButton) {
        print("chat button tapped")
        let chatVC: ChatViewController = ChatViewController()
        chatVC.users = [contact!, PFUser.currentUser()!]
        print("in startChattingButtonTapped contact = \(contact)")
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}

