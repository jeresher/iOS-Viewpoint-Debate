//
//  PrivacyPolicyVC.swift
//  DebateApp
//
//  Created by Jere Sher on 10/26/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import UIKit

class PrivacyPolicyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBOutlet weak var privacyPolicyOutlet: UIButton!
    
    @IBAction func privacyPolicyButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBAction func continueButton(_ sender: UIButton) {
        if privacyPolicyOutlet.isSelected {
            performSegue(withIdentifier: "privacyToSignUp", sender: nil)
        }
        if !privacyPolicyOutlet.isSelected {
            performSegue(withIdentifier: "privacyToStarting", sender: nil)
        }
    }
    
}
