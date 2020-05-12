//
//  Utilities.swift
//  DebateApp
//
//  Created by Jere Sher on 8/19/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    let bannedWords = ["anal","anus","arse","ass","ballsack","balls","bastard","bitch","biatch","bloody","blowjob","blow job","bollock","bollok","boner","boob","bugger","bum","butt","buttplug","clitoris","cock","coon","crap","cunt","damn","dick","dildo","dyke","fag","feck","fellate","fellatio","felching","fuck","fudgepacker","flange","Goddamn","hell","homo","jerk","jizz","knobend","knobend","labia","muff","nigger","nigga","omg","penis","piss","poop","prick","pube","pussy","queer","scrotum","sex","shit","sh1t","slut","smegma","spunk","tit","tosser","turd","twat","vagina","wank","whore","wtf"]
    
    let redColor = UIColor(red: 232.0/255.0, green: 86.0/255.0, blue: 52.0/255.0, alpha: 1)
    
    func errorAlert(message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: "Viewpoint", message:
            message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }

    func displayNameChecker(_ name: String) -> Bool {
        let name = name.lowercased()
        // If the name is greater than 20 digits.
        if name.count > 20 || name.count < 3 {
            return false
        }
        // If there are any special characters: return false.
        let specialCharacters = CharacterSet(charactersIn: " !#$%&'()*+,-./:;<=>?@[]^_`{|}~")
        if name.rangeOfCharacter(from: specialCharacters) != nil {
            return false
        }
        
        // If there are any banned words present: return false.
        for i in bannedWords {
            if name.range(of: i) != nil {
                return false
            }
        }
        return true
    }
    
    
    
    func questionChecker(_ question: String) -> Bool {
        let question = question.lowercased()
        // If the question is less than 10 characters and greater than 250 characters: return false.
        if question.count < 10 || question.count > 250 {
            return false
        }
        
        // If there are any banned words present: return false.
        for i in bannedWords {
            if question.range(of: i) != nil {
                return false
            }
        }
        return true
    }
    
    
    
    func commentChecker(_ comment: String) -> Bool {
        let comment = comment.lowercased()
        // If the question is less than 10 characters and greater than 140 characters: return false.
        if comment.count > 200 {
            return false
        }
        
        // If there are any banned words present: return false.
        for i in bannedWords {
            if comment.range(of: i) != nil {
                return false
            }
        }
        return true
    }
    
    // This function creates a unique ID to be used on Firebase.
    func questionIDcreator(text: String, addedByUser: String) -> String {
        let newText = String(text.filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")) != nil })
        let randomValue = arc4random_uniform(1000)
        let final = ("\(newText):\(addedByUser):\(randomValue)")
        return final
    }
}
