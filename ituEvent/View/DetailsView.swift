//
//  DetailsView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 19.08.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import Firebase

struct DetailsView: View {
    
    @EnvironmentObject var current: UserClass
    
    var event: Event
    var type: Int // 1: search-details, 2: attended-detail
    
    var f: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    if event.image != nil {
                        event.image?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    }
                    else {
                        ZStack {
                            Image("itüevent")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                
                VStack {
                    Line(img: "music.mic", txt: event.talker)
                    Line(img: "alarm", txt: "\(f.string(from: event.start)) ~ \(f.string(from: event.finish))")
                    Line(img: "person.3", txt: event.maxParticipants != "" ? event.maxParticipants : "Sınırsız")
                    Line(img: "turkishlirasign.circle", txt: event.price != "" ? event.price : "Ücretsiz")
                    Line(img: "mappin.and.ellipse", txt: event.location)
                    Text(event.description)
                }.padding([.horizontal, .top])
            }
            
            if self.current.user.email != self.event.creator {
                HStack { //: Buttons
                    if current.user.aEvents.contains(event.id) {
                        MyImage(imageName: "hand.thumbsup", imageColor: .green)
                    }
                    if !current.user.aEvents.contains(event.id) || type == 2 {
                        Button(action: {
                            if self.type == 1 {
                                self.attend()
                            }
                            else {
                                self.leave()
                            }
                        }) {
                            HStack {
                                if self.type == 1 {
                                    MyImage(imageName: "calendar.badge.plus")
                                }
                                else {
                                    MyImage(imageName: "calendar.badge.minus")
                                }
                            }
                        }
                    }
                    Spacer()
                }.padding(.horizontal)
            }
        }
        .navigationBarTitle(event.name)
        .navigationBarItems(trailing:
            Button(action: {
                //: report --> do i need that?
            }) {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.red)
            }
        )
    }
    
    func attend() {
        if Auth.auth().currentUser != nil {
            let db = Firestore.firestore()
            db.collection("Users").document(self.current.user.email).updateData([
                AnyHashable("aEvents") : FieldValue.arrayUnion([event.id])
            ]){ error in
                if error == nil {
                    self.current.user.aEvents.append(self.event.id)
                    self.current.dump.append(self.event)
                }
            }
        }
    }
    
    func leave() {
        if Auth.auth().currentUser != nil {
            let db = Firestore.firestore()
            db.collection("Users").document(self.current.user.email).updateData([
                AnyHashable("aEvents") : FieldValue.arrayRemove([event.id])
            ]){ error in
                if error == nil {
                    var index = self.current.user.aEvents.firstIndex { (id) -> Bool in
                        id == self.event.id
                    }
                    if let i = index {
                        self.current.user.aEvents.remove(at: i)
                    }
                    
                    index = self.current.dump.firstIndex(where: { (Event) -> Bool in
                        Event.id == self.event.id
                    })
                    if let i = index {
                        self.current.dump.remove(at: i)
                    }
                }
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(event: Event(), type: 1).environmentObject(UserClass())
    }
}

struct Line: View {
    
    var img: String
    var txt: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                MyImage(imageName: img)
                Text(txt)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.placeholderText))
        }
    }
}

struct EventCell: View {
    
    @EnvironmentObject var current: UserClass
    var event: Event
    var type: Int
    
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
                    Image("itüevent")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
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
                    if event.creator == self.current.user.email {
                        MyImage(imageName: "star.fill")
                    }
                    else if self.current.user.aEvents.contains(event.id) {
                         MyImage(imageName: "hand.thumbsup.fill", imageColor: .green)
                    }
                    
                    Spacer()
                    NavigationLink(destination: DetailsView(event: event, type: type).environmentObject(self.current)) {
                         MyImage(imageName: "arrowshape.turn.up.right")
                    }
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 15).stroke(Color.gray)
        )
    }
}
