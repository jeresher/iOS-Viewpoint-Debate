//
//  MainPageVC.swift
//  DebateApp
//
//  Created by Jere Sher on 8/18/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import UIKit
import Firebase

class HomePageVC: UIViewController {

    
    var userX: UserStruct!
    let ref = Database.database().reference()
    let usersOnlineRef = Database.database().reference(withPath: "online")


    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        Auth.auth().addStateDidChangeListener() { auth, user in
            guard let user = user else { return }
            self.userX = UserStruct(authData: user)
            let currentUsersRef = self.usersOnlineRef.child(user.uid)
            currentUsersRef.setValue(self.userX.email)
            currentUsersRef.onDisconnectRemoveValue()
        }
        */
    }


    @IBAction func thisIsAButton(_ sender: UIButton) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
