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
    var creator: String // creatorId
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
    var maxParticipants: String
    var price: String
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
}
