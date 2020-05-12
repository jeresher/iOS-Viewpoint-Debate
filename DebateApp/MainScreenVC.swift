//
//  MainScreenVC.swift
//  DebateApp
//
//  Created by Jere Sher on 8/19/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainScreenVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var displayName:String?
    var userX: UserStruct!
    var userXandQuestion = Array<Any>()

    let userAuth = Auth.auth().currentUser
    let ref = Database.database().reference()
    let usersRef = Database.database().reference(withPath: "users")
    let questionsRef = Database.database().reference(withPath: "questions")

    
    @IBOutlet weak var tableView: UITableView!
    
    var questions: [QuestionItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Display Name information.
        usersRef.child((userAuth?.uid)!).observeSingleEvent(of: .value, with: { snapshot in
            if self.displayName == nil {
                let userDict = snapshot.value as! [String: Any]
                self.displayName = (userDict["name"] as! String)
                self.userX.name = self.displayName!
            }
        })
        
        // Retrieves and presents questions from Database.
        questionsRef.queryOrdered(byChild: "postedDate").observe(.value, with: { snapshot in
            var newQuestions: [QuestionItem] = []
            for question in snapshot.children {
                let questionItem = QuestionItem(snapshot: question as! DataSnapshot)
                newQuestions.insert(questionItem, at: 0)

            }
            self.questions = newQuestions
            self.tableView.reloadData()
        })
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "QuestionCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let question = questions[indexPath.row]
        
        if let nameLabel = cell.viewWithTag(50) as? UILabel {
            nameLabel.text = question.addedByUser
        }
        if let questionLabel = cell.viewWithTag(100) as? UILabel {
            questionLabel.text = question.text
        }
        
        if let percentageSlider = cell.viewWithTag(150) as? UISlider {
            let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
            let trackLeftImage = UIImage(named: "miniSliderTrackLeft")!
            let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
            percentageSlider.setMinimumTrackImage(trackLeftResizable, for: .normal)
            let trackRightImage = UIImage(named: "miniSliderTrackRight")!
            let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
            percentageSlider.setMaximumTrackImage(trackRightResizable, for: .normal)
            percentageSlider.setValue((Float(self.percentageCalculator(yesVotes: question.yesVotes, voteAmount: question.voteAmount)/100.0)), animated: false)
        }
        
        return cell

    }
    
    // Once the row has been selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) != nil else { return }
        
        let question = questions[indexPath.row]
        
        userXandQuestion = [userX, question]
        
        self.performSegue(withIdentifier: "MainToInformation", sender: userXandQuestion)

    }
    
    @IBAction func askButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "MainToAsk", sender: self.userX)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //1. MainToAsk : Sends userX data.
        if segue.identifier == "MainToAsk" {
            let vc = segue.destination as? AskQuestionVC
            vc?.userX = self.userX
        }
        else if segue.identifier == "MainToInformation" {
            let vc = segue.destination as? QuestionInformationVC
            vc?.userX = userXandQuestion[0] as! UserStruct
            vc?.question = userXandQuestion[1] as! QuestionItem
        }
    }
    
    func percentageCalculator(yesVotes: Int, voteAmount: Int) -> Double {
        if voteAmount != 0 {
            return ((Double(yesVotes)/Double(voteAmount))*100.0)
        }
        else {
            return 50.0
        }
    }
}
