//
//  User.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

class UserClass: ObservableObject  {
    @Published var user: User
    @Published var isLoggedIn: Bool
    //var cEvents: [Event] // list of created events
    //var aEvents: [EventAttendence] //list of event attendences
    
    
    init() {
        self.user = User()
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        //self.cEvents = []
        //self.aEvents = []
    }
    
    func info(){ //: get user info from firebase
        user.image = Image("p")
        //user.name = "Mehmet Karaaslan"
        user.email = "karaaslan18@itu.edu.tr"
        user.department = "Computer Engineering"
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
