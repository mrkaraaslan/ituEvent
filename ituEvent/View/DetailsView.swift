//
//  DetailsView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 19.08.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct DetailsView: View {
    
    var event: Event
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
            
            HStack { //: Buttons
                Button(action: {
                    
                }) {
                    HStack {
                        MyImage(imageName: "calendar.badge.plus")
                        Spacer()
                    }
                }
            }.padding(.horizontal)
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
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(event: Event()).environmentObject(UserClass())
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
