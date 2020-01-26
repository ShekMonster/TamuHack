//
//  ViewController.swift
//  TamuHack
//
//  Created by Abhishek More on 1/25/20.
//  Copyright © 2020 Abhishek More. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var inText: UILabel!
    @IBOutlet var upText: UILabel!
    @IBOutlet var signInSwitchLabel: UIButton!
    @IBOutlet var signUpSwitchLabel: UIButton!
    @IBOutlet var password: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var arrow: UIImageView!
    
    var up = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upText.alpha = 0
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
       //logInUser(email: "user@gmail.com", password: "password")
        if let email = email.text {
            if let password = password.text {
                if validText() {
                    if up {
                        createUser(email: email, password: password)
                    } else {
                        logInUser(email: email, password: password)
                    }
                }
            }
        }
    }
    @IBAction func signUpSwitchPressed(_ sender: Any) {
        
        up = true
        
        UIView.animate(withDuration: 0.25){
            
            let angle = Double.pi / -2
            
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
            self.signUpSwitchLabel.center.x -= 375
            self.signInSwitchLabel.center.x -= 375
            self.signUpSwitchLabel.alpha = 0
            self.signInSwitchLabel.alpha = 1
            self.inText.center.y -= 42
            self.upText.center.y -= 42
            self.inText.alpha = 0
            self.upText.alpha = 1
        }
    }
    
    @IBAction func signInSwitchPressed(_ sender: Any) {
        
        up = false
        
        UIView.animate(withDuration: 0.25){
            
            let angle = 0
            
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
            self.signUpSwitchLabel.center.x += 375
            self.signInSwitchLabel.center.x += 375
            self.signUpSwitchLabel.alpha = 1
            self.signInSwitchLabel.alpha = 0
            self.inText.center.y += 42
            self.upText.center.y += 42
            self.inText.alpha = 1
            self.upText.alpha = 0
        }
        
    }
    
    func logInUser(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if user != nil && error == nil {
                print("Signed in successfully!")
                self!.performSegue(withIdentifier: "signInSegue", sender: self)
            } else {
                print("Sign in failed!")
            }
            
        }
        
        
    }
    
    func createUser(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if authResult != nil && error == nil {
                print("User created successfully!")
                self.performSegue(withIdentifier: "signInSegue", sender: self)
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
    
    func validText() -> Bool {
        if(email.text! != "" && password.text! != "") {
            return true
        } else {
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.3) {
            
            self.view.center.y -= 250
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.3) {
            
            self.view.center.y += 250
            
        }
    }
    
}

