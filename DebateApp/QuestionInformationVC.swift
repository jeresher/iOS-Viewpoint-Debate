//
//  QuestionInformationVC.swift
//  DebateApp
//
//  Created by Jere Sher on 10/14/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import UIKit
import Firebase

class QuestionInformationVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userX: UserStruct!
    var question: QuestionItem!
    var userXandQuestion = Array<Any>()
    
    var comments: [CommentItem] = []
    
    let utilities = Utilities()
    let ref = Database.database().reference()
    let questionsRef = Database.database().reference(withPath: "questions")
    let questionDetailRef = Database.database().reference(withPath: "questionDetail")
    let reportedRef = Database.database().reference(withPath: "reported")


    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var agreePercentageLabel: UILabel!
    @IBOutlet weak var disagreePercentageLabel: UILabel!
    @IBOutlet weak var percentageSlider: UISlider!
    
    @IBOutlet weak var tableView: UITableView!
    
    func percentageCalculator(yesVotes: Int, voteAmount: Int) -> Double {
        if voteAmount != 0 {
            return ((Double(yesVotes)/Double(voteAmount))*100.0)
        }
        else {
            return 50.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionText.text = question.text

        // Monitors/Retrieves Comments.
        questionDetailRef.child(question.identification!).queryOrdered(byChild: "postedDate").observe(.value, with: { snapshot in
            var newComments: [CommentItem] = []
            for comment in snapshot.children {
                let commentItem = CommentItem(snapshot: comment as! DataSnapshot)
                newComments.insert(commentItem, at: 0)
            }
    
            self.comments = newComments
            self.tableView.reloadData()
        })
        
        // Monitors/Retrieves Percentage Label.
        questionsRef.child(question.identification!).observe(.value, with: { snapshot in
            
            self.question = QuestionItem(snapshot: snapshot)
            
            self.agreePercentageLabel.text = String(Int(self.percentageCalculator(yesVotes: self.question.yesVotes, voteAmount: self.question.voteAmount))) + "%"
            self.disagreePercentageLabel.text = String(100-(Int(self.percentageCalculator(yesVotes: self.question.yesVotes, voteAmount: self.question.voteAmount)))) + "%"
            self.percentageSlider.setValue((Float(self.percentageCalculator(yesVotes: self.question.yesVotes, voteAmount: self.question.voteAmount)/100.0)), animated: false)
            
            self.tableView.reloadData()
        })
        
        // Programmatically edits slider image.
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        let trackLeftImage = UIImage(named: "SliderTrackLeft")!
        let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
        percentageSlider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        let trackRightImage = UIImage(named: "SliderTrackRight")!
        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
        percentageSlider.setMaximumTrackImage(trackRightResizable, for: .normal)
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CommentCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let comment = comments[indexPath.row]
        
        if let nameLabel = cell.viewWithTag(10) as? UILabel {
            nameLabel.text = comment.addedByUser
            if comment.voteDecision == "No" {
                nameLabel.textColor = utilities.redColor
            }
        }
        if let commentLabel = cell.viewWithTag(5) as? UILabel {
            commentLabel.text = comment.text
        }
        
        return cell
        
    }
    
    @IBAction func reportButton(_ sender: UIButton) {
        let reportQuestionRef = reportedRef.child(question.identification!)
        reportQuestionRef.setValue(userX.name)
        utilities.errorAlert(message: "This question has been reported.", viewController: self)
    }
    
    @IBAction func yesButton(_ sender: UIButton) {
        userXandQuestion = [userX, question]
        questionDetailRef.child(question.identification!).observeSingleEvent(of: .value, with: { snapshot in
            // If you've already voted, present an alert. Otherwise, segue to voting screen.
            if snapshot.hasChild(self.userX.uid) {
                let alertController = UIAlertController(title: "Error", message:
                    "You have already voted.", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                self.performSegue(withIdentifier: "InformationToComment", sender: self.userXandQuestion)
            }
        })
    }
    
    
    @IBAction func noButton(_ sender: UIButton) {
        userXandQuestion = [userX, question]
        questionDetailRef.child(question.identification!).observeSingleEvent(of: .value, with: { snapshot in
            // If you've already voted, present an alert. Otherwise, segue to voting screen.
            if snapshot.hasChild(self.userX.uid) {
                let alertController = UIAlertController(title: "Error", message:
                    "You have already voted.", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                self.performSegue(withIdentifier: "InformationToComment", sender: self.userXandQuestion)
            }
        })
    }
    
    
    @IBAction func InformationToMain(_ sender: UIButton) {
        self.performSegue(withIdentifier: "InformationToMain", sender: userX)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InformationToComment" {
            let vc = segue.destination as? WriteCommentVC
            vc?.userX = userXandQuestion[0] as! UserStruct
            vc?.question = userXandQuestion[1] as! QuestionItem
        }
        if segue.identifier == "InformationToMain" {
            let vc = segue.destination as? MainScreenVC
            vc?.userX = sender as? UserStruct
        }
    }
}
