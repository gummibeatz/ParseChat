//
//  userLoginViewController.swift
//  ParseChat
//
//  Created by Linus Liang on 11/3/15.
//  Copyright © 2015 Linus Liang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class userLoginController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.tag = 0
        passwordTextField.tag = 1
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
}

extension userLoginController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag+1
        let nextResponder = textField.superview?.viewWithTag(nextTag)
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
}