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
    @Published var cEvents: [Event] // list of created events
    //var aEvents: [EventAttendence] //list of event attendences
    
    
    init() {
        self.user = User()
        self.isLoggedIn = false
        self.cEvents = []
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
                        self.user.cEvents = data["cEvents"] as?  [String] ?? []
                    }
                }
            }
            
            let imgName = self.user.email.dropLast(11) + ".jpg"
            let ref = Storage.storage().reference(withPath: "UserImages/\(imgName)")
            
            ref.getData(maxSize: 4 * 1024 * 1024) { (Data, Error) in
                if let data = Data {
                    let image = UIImage(data: data)
                    self.user.image = Image(uiImage: image!)
                }
            }
        }//: what if else?
    }
    
    func getCreatedEvents(){
        let db = Firestore.firestore()
        if Auth.auth().currentUser != nil {
            cEvents = []
            for id in self.user.cEvents {
                db.collection("Events").document(id).getDocument { (Document, Error) in
                    if let doc = Document {
                        if let d = doc.data() {
                            let e = Event(id, d["name"] as! String, (d["start"] as! Timestamp).dateValue(), (d["finish"] as! Timestamp).dateValue(), d["talker"] as! String, d["maxParticipants"] as! String, d["price"] as! String, d["location"] as! String, d["description"] as! String)
                            self.cEvents.append(e) //: sort by event name or date?
                        }
                    }
                }
            }
        }//: what if else
    }
}

struct User {
    var image: Image?
    var name: String?
    var email: String = ""
    var department: String?
    var level: Int?
    var cEvents: [String] = [] // list of created  events' ids
    var aEvents: [String] = [] // list of event attendences' ids
    
    func leveller() -> String {
        var text = ""
        if let level = self.level {
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
