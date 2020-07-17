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

struct Event {
    var id = UUID().uuidString
    var creator: String // creatorId
    var name: String
    var start: Date
    var finish: Date
    var talker: String
    var maxParticipants: Int
    var price: String
    var location: String
    var description: String
}
