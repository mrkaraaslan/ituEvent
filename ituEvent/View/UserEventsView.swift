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
            Form {
                if self.current.cEvents.count != 0 {
                    ForEach(current.cEvents, id: \.id) { event in
                        VStack {
                            NavigationLink(destination: EventDetailsView(event: event), label: {
                                Text(event.name)
                            })
                        }
                    }
                }
                else {
                    Text("Etkinlik oluşturmadınız.")
                }
            }
            
            VStack {
                NavigationLink(destination: CreateEventView().environmentObject(current), label: {
                    MyNavigationButton(text: "Etkinlik Oluştur")
                })
            }.padding()
        }
        .navigationBarTitle("Etkinliklerim", displayMode: .inline)
    }
}

struct UserEventsView_Previews: PreviewProvider {
    static var previews: some View {
        UserEventsView().environmentObject(UserClass())
    }
}
