//
//  Comment.swift
//  DebateApp
//
//  Created by Jere Sher on 10/21/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import Foundation
import Firebase

struct CommentItem {
    
    let ref: DatabaseReference?
    let text: String!
    let addedByUser: String!
    let voteDecision: String!
    let postedDate: Any!
    
    init(text: String, addedByUser: String, voteDecision: String, postedDate: [AnyHashable: Any]) {
        self.text = text
        self.addedByUser = addedByUser
        self.voteDecision = voteDecision
        self.postedDate = postedDate
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        text = snapshotValue["text"] as? String
        addedByUser = snapshotValue["addedByUser"] as? String
        voteDecision = snapshotValue["voteDecision"] as? String
        postedDate = snapshotValue["postedDate"]
        ref = snapshot.ref
    }
    // Simply converts all variables and constants in this struct into a dictionary.
    func toAnyObject() -> Any {
        return [
            "text": text,
            "addedByUser": addedByUser,
            "voteDecision": voteDecision,
            "postedDate": postedDate
        ]
    }
}
