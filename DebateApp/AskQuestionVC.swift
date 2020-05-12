//
//  AskQuestionVC.swift
//  DebateApp
//
//  Created by Jere Sher on 8/24/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import UIKit
import Firebase

class AskQuestionVC: UIViewController, UITextViewDelegate {
    
    var displayName: String?
    var userX: UserStruct!
    
    let utilities = Utilities()
    let ref = Database.database().reference()
    let questionsRef = Database.database().reference(withPath: "questions")
    
    let keyboardToolbar = UIToolbar()
    
    
    @IBOutlet weak var textView: UITextView!
    
    // Adds question to Database.
    @IBAction func submitQuestionButton(_ sender: UIButton) {
        guard let text = textView.text else { return }
        if utilities.questionChecker(text) == true {
            // Creates a question object...
            var question = QuestionItem(text: text, addedByUser: userX.name, postedDate: ServerValue.timestamp())
            // Label who created the question object...
            question.identification = utilities.questionIDcreator(text: text, addedByUser: userX.name)
            // Add the question object to the database...
            let questionRef = questionsRef.child(question.identification!)
            questionRef.setValue(question.toAnyObject())
            self.performSegue(withIdentifier: "AskToMain", sender: self.userX)
        }
        else {
            let alertController = UIAlertController(title: "Error", message:
                "Questions can not contain less than 10 characters and/or any banned words.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func exitQuestionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "AskToMain", sender: self.userX)
    }
    
    // Transfers userX from AskQuestionVC -> MainScreenVC.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AskToMain" {
            let vc = segue.destination as? MainScreenVC
            vc?.userX = self.userX
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Opens keyboard on load.
        self.textView.becomeFirstResponder()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 250
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
