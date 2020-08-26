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
    @State var hot = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if self.current.searchEvents.count != 0 {
                        ForEach(self.current.searchEvents, id: \.id) { Event in
                            EventCell(event: Event, type: 1).environmentObject(self.current)
                        }
                    }
                    else {
                        VStack {
                            Image(systemName: "trash").font(.largeTitle).foregroundColor(.red)
                        }.frame(maxWidth: .infinity)
                    }
                }.padding()
            }
            .navigationBarTitle("Keşfet", displayMode: .inline)
            .navigationBarItems(trailing:
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.white)
                        .frame(width: 48, height: 28)
                        .offset(x: self.hot ? -24 : 24)
                    HStack(spacing: 0) {
                        Image(systemName: "flame")
                            .foregroundColor(.black)
                            .frame(width: 50, height: 30)
                        
                        Image(systemName: "alarm")
                            .foregroundColor(.black)
                            .frame(width: 50, height: 30)
                    }
                }
                .frame(width: 100, height: 30)
                .background(Color.init(.placeholderText))
                .cornerRadius(7.5)
                .onTapGesture {
                    withAnimation() {
                        self.hot.toggle()
                    }
                }
            )
        }
    }
}

struct SearchEventView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchEventView().environmentObject(UserClass())
            EventCell(event: Event(UUID().uuidString, "karaaslan18@itu.edu.tr", "itüEvent tanıtım günü...", Date(), Date(), "Mehmet Karaaslan", "", "", "İTÜ", "Katılımlarınızdan dolayı teşekkür ederiz."), type: 1).environmentObject(UserClass())
        }
    }
}
