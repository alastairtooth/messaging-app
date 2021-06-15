//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text { //comma seperated both properties to apply the 'if let' optional chaining to two optionals
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error { //this code basically is saying 'if error is not nil then print the error, otherwise...'
                    print(e.localizedDescription) //this 'localisedDescription property converts the error to the language that the iphone is set to, and also removes jargon
                } else {
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
            
        }
        
    }
}



