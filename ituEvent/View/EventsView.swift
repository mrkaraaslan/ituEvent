//
//  EventsView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct EventsView: View {
    
    @EnvironmentObject var current: UserClass
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if self.current.aEvents.count != 0 {
                        ForEach(self.current.aEvents, id: \.id) { Event in
                            EventCell(event: Event, type: 2).environmentObject(self.current)
                        }
                    }
                    else {
                        VStack {
                            Image(systemName: "trash").font(.largeTitle).foregroundColor(.red)
                        }.frame(maxWidth: .infinity)
                    }
                }.padding()
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView().environmentObject(UserClass())
    }
}
