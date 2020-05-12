//
//  LoginVC.swift
//  DebateApp
//
//  Created by Jere Sher on 8/17/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    
    var userX: UserStruct!
    
    let utilities = Utilities()
    let userAuth = Auth.auth().currentUser
    let ref = Database.database().reference()
    let usersRef = Database.database().reference(withPath: "users")
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginDidTouch(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { user, error in
                
                let user = user?.user
                
                // Unsuccessful Login.
                if error != nil {
                    self.utilities.errorAlert(message: "Invalid email or password.", viewController: self)
                    //print(error!.localizedDescription)
                    return
                    
                // Successful Login.
                } else {
                    self.userX = UserStruct(authData: user!)
                    self.performSegue(withIdentifier: "loginToMain", sender: self.userX)
                }
            }
        }
    }
    
    // Transfers user from LoginVC -> MainScreenVC.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToMain" {
            let vc = segue.destination as? MainScreenVC
            vc?.userX = sender as? UserStruct
        }
    }

}
