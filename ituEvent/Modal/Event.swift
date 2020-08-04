//
//  Event.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct EventAttendence {
    var event: Event
    var attendence: Int // 0: declined | 1: accepted | else: not answered
}

class EventClass: ObservableObject { //will use o create new events
    @Published var event = Event()
}

struct Event {
    var id = UUID().uuidString
    var creator: String // creator email
    var name: String
    var start: Date {
        willSet { //newValue
            if newValue > finish {
                finish = newValue
            }
        }
    }
    var finish: Date
    var talker: String
    var maxParticipants: String {
        didSet { //oldValue
            if Int(maxParticipants) == nil && maxParticipants != "" {
                maxParticipants = oldValue
            }
            else if Int(maxParticipants) == 0 {
                maxParticipants = ""
            }
        }
    }
    var price: String {
        didSet { //oldValue
            if Int(price) == nil && price != "" {
                price = oldValue
            }
            else if Int(price) == 0 {
                price = ""
            }
        }
    }
    var location: String
    var description: String
    
    init() {
        creator = ""
        name = ""
        start = Date()
        finish = Date()
        talker = ""
        maxParticipants = ""
        price = ""
        location = ""
        description = ""
    }
    
    init(_ id: String,_ name: String, _ start: Date, _ finish: Date, _ talker: String, _ max: String, _ price: String, _ location: String, _ description: String) {
        self.creator = ""
        self.id = id
        self.name = name
        self.start = start
        self.finish = finish
        self.talker = talker
        self.maxParticipants = max
        self.price = price
        self.location = location
        self.description = description
    }
}
