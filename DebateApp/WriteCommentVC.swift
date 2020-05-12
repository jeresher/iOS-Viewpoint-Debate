//
//  WriteCommentVC.swift
//  DebateApp
//
//  Created by Jere Sher on 10/21/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import UIKit
import Firebase

class WriteCommentVC: UIViewController, UITextViewDelegate {
    
    var userX: UserStruct!
    var question: QuestionItem!
    var userXandQuestion = Array<Any>()
    
    let utilities = Utilities()
    let keyboardToolbar = UIToolbar()
    let ref = Database.database().reference()
    let questionsRef = Database.database().reference(withPath: "questions")
    let questionDetailRef = Database.database().reference(withPath: "questionDetail")
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Opens keyboard on load.
        self.textView.becomeFirstResponder()
        
        questionsRef.child(question.identification!).observe(.value, with: { snapshot in
            self.question = QuestionItem(snapshot: snapshot)
        })
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func yesSubmitButton(_ sender: UIButton) {
        guard let text = textView.text else { return }
        if utilities.commentChecker(text) == true {
            // Edits/adds questions.
            let comment = CommentItem(text: text, addedByUser: userX.name, voteDecision: "Yes", postedDate: ServerValue.timestamp())
            let specificQuestionDetailRef = questionDetailRef.child(question.identification!)
            let commentRef = specificQuestionDetailRef.child(userX.uid)
            commentRef.setValue(comment.toAnyObject())
            
            // Edits questions.
            questionsRef.child(question.identification!).updateChildValues([
                "yesVotes": question.yesVotes + 1,
                "voteAmount": question.voteAmount + 1
                ])
            
            // Segue.
            userXandQuestion = [userX, question]
            self.performSegue(withIdentifier: "CommentToInformation", sender: userXandQuestion)
            
        }
        else {
            let alertController = UIAlertController(title: "Error", message:
                "Comments can not contain any banned words.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }

    }
    
    
    @IBAction func noSubmitButton(_ sender: UIButton) {
        guard let text = textView.text else { return }
        if utilities.commentChecker(text) == true {
            // Edits/adds questions.
            let comment = CommentItem(text: text, addedByUser: userX.name, voteDecision: "No", postedDate: ServerValue.timestamp())
            let specificQuestionDetailRef = questionDetailRef.child(question.identification!)
            let commentRef = specificQuestionDetailRef.child(userX.uid)
            commentRef.setValue(comment.toAnyObject())
            
            // Edits questions.
            questionsRef.child(question.identification!).updateChildValues([
                "voteAmount": question.voteAmount + 1
                ])
            
            // Segue.
            userXandQuestion = [userX, question]
            self.performSegue(withIdentifier: "CommentToInformation", sender: userXandQuestion)
            
        }
        else {
            let alertController = UIAlertController(title: "Error", message:
                "Comments can not contain any banned words.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func exitButton(_ sender: UIButton) {
        userXandQuestion = [userX, question]
        self.performSegue(withIdentifier: "CommentToInformation", sender: userXandQuestion)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentToInformation" {
            let vc = segue.destination as? QuestionInformationVC
            vc?.userX = userXandQuestion[0] as! UserStruct
            vc?.question = userXandQuestion[1] as! QuestionItem
        }
    }
}
