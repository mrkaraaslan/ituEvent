//
//  SearchEventView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import Firebase

struct SearchEventView: View {
    
    @EnvironmentObject var current: UserClass
    @State var showDetail = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if self.current.searchEvents.count != 0 {
                        ForEach(self.current.searchEvents, id: \.id) { Event in
                            EventCell(event: Event).environmentObject(self.current)
                        }
                    }
                    else {
                        VStack {
                            Image(systemName: "trash").font(.largeTitle).foregroundColor(.red)
                        }.frame(maxWidth: .infinity)
                    }
                }.padding()
            }.navigationBarTitle("Keşfet", displayMode: .inline)
        }
    }
}

struct SearchEventView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchEventView().environmentObject(UserClass())
            EventCell(event: Event(UUID().uuidString, "itüEvent tanıtım günü...", Date(), Date(), "Mehmet Karaaslan", "", "", "İTÜ", "Katılımlarınızdan dolayı teşekkür ederiz.")).environmentObject(UserClass())
        }
    }
}

struct EventCell: View {
    
    @EnvironmentObject var current: UserClass
    var event: Event
    
    var body: some View {
        VStack {
            VStack {
                if event.image != nil {
                    event.image!
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                else {
                    //Image("itüevent")
                    Color.gray
                        //.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .background(Color.mainColor)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                HStack {
                    Text(event.name)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.horizontal, 7.5)
            }
            
            VStack(spacing: 0) {
                Divider()
                HStack { //: Buttons
                    Button(action: {
                        
                    }) {
                        MyImage(imageName: "calendar.badge.plus")
                    }
                    Spacer()
                    NavigationLink(destination: DetailsView(event: event).environmentObject(self.current)) {
                         MyImage(imageName: "arrowshape.turn.up.right")
                            .frame(width: 40, height: 40)
                    }
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 15).stroke(Color.gray)
        )
    }
}
