//
//  EventDetailsView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 30.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct EventDetailsView: View {
    
    var event: Event
    var f: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack {
            Form {
                MyText(info: "Etkinlik adı", text: event.name)
                MyText(info: "Konuşmacı", text: event.talker)
                MyText(info: "Başlangıç", text: f.string(from: event.start))
                MyText(info: "Bitiş", text: f.string(from: event.finish))
                MyText(info: "Katılımcı sınırı", text: event.maxParticipants != "0" ? event.maxParticipants : "Sınırsız")
                MyText(info: "Katılım ücreti", text: event.price != "0" ? event.price : "Ücretsiz")
                MyText(info: "Adress", text: event.location)
                MyText(info: "Açıklama", text: event.description)
            }
            VStack {
                Button(action: {
                    //: delete event action
                }) {
                    MyButton(text: "Etkinliği sil", color: .red)
                }
            }.padding()
        }
        .navigationBarTitle(event.name)
    }
}

struct EventDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailsView(event: Event())
    }
}
