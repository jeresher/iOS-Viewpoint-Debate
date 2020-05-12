//
//  Question.swift
//  DebateApp
//
//  Created by Jere Sher on 8/23/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import Foundation
import Firebase

struct QuestionItem {
    
    let ref: DatabaseReference?
    let addedByUser: String!
    let text: String!
    var identification: String?
    var yesVotes = 0
    var voteAmount = 0
    var postedDate: Any!

    init(text: String, addedByUser: String, postedDate: [AnyHashable: Any]) {
        self.text = text
        self.addedByUser = addedByUser
        self.yesVotes = 0
        self.voteAmount = 0
        self.postedDate = postedDate
        self.ref = nil
        self.identification = nil
    }
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        identification = snapshotValue["identification"] as? String
        text = snapshotValue["text"] as? String
        addedByUser = snapshotValue["addedByUser"] as? String
        yesVotes = snapshotValue["yesVotes"] as! Int
        voteAmount = snapshotValue["voteAmount"] as! Int
        postedDate = snapshotValue["postedDate"]
        ref = snapshot.ref
    }
    
    // Simply converts all variables and constants in this struct into a dictionary.
    func toAnyObject() -> Any {
        return [
        "identification": identification!,
        "text": text,
        "addedByUser": addedByUser,
        "yesVotes": yesVotes,
        "voteAmount": voteAmount,
        "postedDate": postedDate,
        ]
    }
}
