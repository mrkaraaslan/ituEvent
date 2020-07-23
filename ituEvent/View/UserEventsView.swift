//
//  UserEventsView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 22.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct UserEventsView: View {
    
    @EnvironmentObject var current: UserClass
    
    var body: some View {
        VStack {
            
            //form to show created events
            
            NavigationLink(destination: CreateEventView().environmentObject(current), label: {
                MyNavigationButton(text: "Etkinlik Oluştur")
            })
        }
        .padding([.leading, .trailing])
        .navigationBarTitle("Etkinliklerim", displayMode: .inline)
    }
}

struct UserEventsView_Previews: PreviewProvider {
    static var previews: some View {
        UserEventsView().environmentObject(UserClass())
    }
}

/*
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
 */
