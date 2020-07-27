//
//  User.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import Firebase

class UserClass: ObservableObject  {
    @Published var user: User
    @Published var isLoggedIn: Bool
    //var cEvents: [Event] // list of created events
    //var aEvents: [EventAttendence] //list of event attendences
    
    
    init() {
        self.user = User()
        self.isLoggedIn = false
        //self.cEvents = []
        //self.aEvents = []
    }
    
    func info() { //: get user info from firebase
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
            self.user.email = user.email!
            self.user.name = user.displayName
            db.collection("Users").document(self.user.email).getDocument { (Document, Error) in
                if let doc = Document {
                    if let data = doc.data() {
                        self.user.name = data["name"] as? String
                        self.user.department = data["department"] as? String
                        self.user.level = data["level"] as? Int
                    }
                }
            }
        }
    }
    
    func leveller() -> String {
        var text = ""
        if let level = user.level {
            switch level {
                case 0:
                    text = "Lisans"
                case 1:
                    text = "Yüksek Lisans"
                case 2:
                    text = "Mezun"
                case 3:
                    text = "Akademisyen"
                default:
                    text = "ERROR"
            }
        }
        return text
    }
}

struct User {
    var image: Image?
    var name: String?
    var email: String
    var department: String?
    var level: Int?
    var cEvents: [String]? // list of created  events' ids
    var aEvents: [String]? // list of event attendences' ids
    
    init() {
        //other properties will be nil so no need to write them
        email = ""
    }
}
