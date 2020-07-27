//
//  User.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import Firebase
import SwiftKeychainWrapper

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
        user.image = Image("p")
        if let user = Auth.auth().currentUser {
            print("info")
            self.user.name = user.displayName
            self.user.department = user.value(forKey: "department") as? String ?? nil
            self.user.level = user.value(forKey: "level") as? Int ?? nil
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
    var id: String?
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
