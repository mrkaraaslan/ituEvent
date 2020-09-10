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
    @Published var cEvents: [Event] // list of created events
    
    var dump: [Event] = []
    @Published var aEvents: [Event] //list of attended events
    
    @Published var hot = UserDefaults.standard.bool(forKey: "isHot") { // hot: new added, sort by date / clock: closest, sort by start
        didSet {
            self.getEvents()
        }
    }
    var dumpList: [Event] = []
    @Published var searchEvents: [Event]
    
    
    init() {
        self.user = User()
        self.isLoggedIn = KeychainWrapper.standard.bool(forKey: "isLoggedIn") ?? false
        self.cEvents = []
        self.aEvents = []
        self.searchEvents = []
    }
    
    func info() { //: get user info from firebase
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
            self.user.email = user.email!
            db.collection("Users").document(self.user.email).getDocument { (Document, Error) in
                if let doc = Document {
                    if let data = doc.data() {
                        self.user.name = data["name"] as? String
                        self.user.department = data["department"] as? String
                        self.user.level = data["level"] as? Int
                        self.user.cEvents = data["cEvents"] as? [String] ?? []
                        self.user.aEvents = data["aEvents"] as? [String] ?? []
                        self.getEvents()
                        self.getAttendedEvents()
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
    
    func getCreatedEvents() {
        let db = Firestore.firestore()
        if Auth.auth().currentUser != nil {
            cEvents = []
            for id in self.user.cEvents {
                db.collection("Events").document(id).getDocument { (Document, Error) in
                    if let doc = Document {
                        if let d = doc.data() {
                            let e = Event(id, d["creator"] as! String, d["name"] as! String, (d["start"] as! Timestamp).dateValue(), (d["finish"] as! Timestamp).dateValue(), d["talker"] as! String, d["maxParticipants"] as! String, d["price"] as! String, d["location"] as! String, d["description"] as! String)
                            self.cEvents.append(e) //: sort by event name or date?
                        }
                    }
                }
            }
        }//: what if else
    }
    
    var attendanceListener: ListenerRegistration? = nil {
        didSet {
            print("listen")
        }
    }
    func getAttendedEvents() {
        let db = Firestore.firestore()
        if Auth.auth().currentUser != nil {
            if self.user.aEvents != [] {
                self.dump = []
                if let l = attendanceListener {
                    l.remove()
                }
                attendanceListener = db.collection("Events").whereField("id", in: self.user.aEvents).addSnapshotListener { (DocumentSnapshot, Error) in
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
                    
                    self.aEvents = self.dump.sorted(by: { (E0, E1) -> Bool in
                        E0.start <= E1.start
                    })
                }
            }
            else {
                self.aEvents = []
            }
        }
        
        // MARK: snapshot functions
        func addEvent(with data: [String : Any]) {
            let ev = Event(data["id"] as! String, data["creator"] as! String, data["name"] as! String, (data["start"] as! Timestamp).dateValue(), (data["finish"] as! Timestamp).dateValue(), data["talker"] as! String, data["maxParticipants"] as! String, data["price"] as! String, data["location"] as! String, data["description"] as! String)
            self.dump.append(ev)
        }
        func updateEvent(with data: [String : Any]) { //: push notification
            let ev = Event(data["id"] as! String, data["creator"] as! String,
                           data["name"] as! String, (data["start"] as! Timestamp).dateValue(), (data["finish"] as! Timestamp).dateValue(), data["talker"] as! String, data["maxParticipants"] as! String, data["price"] as! String, data["location"] as! String, data["description"] as! String)
            let index = self.dump.firstIndex { (Event) -> Bool in
                Event.id == ev.id
            }
            if let i = index {
                self.dump[i] = ev
            }
        }
        func removeEvent(with id: String) {
            let index = self.dump.firstIndex { (Event) -> Bool in
                Event.id == id
            }
            if let i = index {
                self.dump.remove(at: i)
            }
            db.collection("Users").document(self.user.email).updateData([
                AnyHashable("aEvents") : FieldValue.arrayRemove([id])
            ])
        }
        
        func getImage() /*-> Image**/ {
            
        }
    }
    
    func getEvents() { // to search new events --> all events
        let db = Firestore.firestore()
        if Auth.auth().currentUser != nil {
            let ref = self.hot ? db.collection("Events").order(by: "date", descending: true) : db.collection("Events").whereField("start", isGreaterThan: Date()).order(by: "start")
            ref.limit(to: 10).getDocuments { (QuerySnapshot, Error) in
                if Error == nil {
                    if let snap = QuerySnapshot {
                        self.searchEvents.removeAll()
                        for doc in snap.documents {
                            addEvent(with: doc)
                        }
                        for index in self.searchEvents.indices {
                            let ref = Storage.storage().reference(withPath: "Events/\(self.searchEvents[index].id)/img.jpg")
                                ref.getData(maxSize: 4 * 1024 * 1024) { (Data, Error) in
                                    if let data = Data {
                                        let image = UIImage(data: data)
                                        self.searchEvents[index].image =  Image(uiImage: image!)
                                    }
                            }
                        }
                    }
                }
            }
        }
        //: what if else
        func addEvent(with doc: QueryDocumentSnapshot) {
            
            let ev = Event(doc["id"] as! String, doc["creator"] as! String, doc["name"] as! String, (doc["start"] as! Timestamp).dateValue(), (doc["finish"] as! Timestamp).dateValue(), doc["talker"] as! String, doc["maxParticipants"] as! String, doc["price"] as! String, doc["location"] as! String, doc["description"] as! String)
            
            self.searchEvents.append(ev)
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
