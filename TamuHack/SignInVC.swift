//
//  ViewController.swift
//  TamuHack
//
//  Created by Abhishek More on 1/25/20.
//  Copyright © 2020 Abhishek More. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        logInUser(email: "user@gmail.com", password: "password")
    }
    
    func logInUser(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if user != nil && error == nil {
                print("Signed in successfully!")
            } else {
                print("Sign in failed!")
            }
        }
        
    }
    
    func createUser(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print("User created successfully!")
            } else {
                print("Error creating user!")
            }
        }
        
    }
    
    func signOut() {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }


}

