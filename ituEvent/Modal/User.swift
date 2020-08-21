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
    
    var dumpList: [Event] = []
    @Published var searchEvents: [Event]
    
    
    init() {
        self.user = User()
        self.isLoggedIn = false
        self.cEvents = []
        //self.aEvents = []
        self.searchEvents = []
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
                        self.user.cEvents = data["cEvents"] as? [String] ?? []
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
    
    func getEvents() { // to search new events --> all events
        let db = Firestore.firestore()
        if Auth.auth().currentUser != nil {
            db.collection("Events").addSnapshotListener { (DocumentSnapshot, Error) in
                guard let snapshot = DocumentSnapshot else {return}
                
                snapshot.documentChanges.forEach { diff in
                    let data = diff.document.data()
                    
                    if (diff.type == .added) {
                        addEvent(with: data)
                    }
                    if (diff.type == .modified) {
                        updateEvent(with: data)
                    }
                    if (diff.type == .removed) {
                        let id = data["id"] as! String
                        removeEvent(with: id)
                    }
                }
                self.searchEvents = self.dumpList.sorted(by: { (E0, E1) -> Bool in
                    E0.start <= E1.start
                })
            }
        }
        //: what if else
        
        // MARK: snapshot functions
        func addEvent(with data: [String : Any]) {
            let ev = Event(data["id"] as! String, data["name"] as! String, (data["start"] as! Timestamp).dateValue(), (data["finish"] as! Timestamp).dateValue(), data["talker"] as! String, data["maxParticipants"] as! String, data["price"] as! String, data["location"] as! String, data["description"] as! String)
            self.dumpList.append(ev)
        }
        func updateEvent(with data: [String : Any]) {
            let ev = Event(data["id"] as! String, data["name"] as! String, (data["start"] as! Timestamp).dateValue(), (data["finish"] as! Timestamp).dateValue(), data["talker"] as! String, data["maxParticipants"] as! String, data["price"] as! String, data["location"] as! String, data["description"] as! String)
            let index = self.dumpList.firstIndex { (Event) -> Bool in
                Event.id == ev.id
            }
            if let i = index {
                self.dumpList[i] = ev
            }
        }
        func removeEvent(with id: String) {
            let index = self.dumpList.firstIndex { (Event) -> Bool in
                Event.id == id
            }
            if let i = index {
                self.dumpList.remove(at: i)
            }
        }
        
        func getImage() /*-> Image**/ {
            
        }
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
