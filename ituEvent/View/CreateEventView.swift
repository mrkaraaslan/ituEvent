//
//  CreateEventView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 23.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct CreateEventView: View {
    
    @EnvironmentObject var current: UserClass
    @ObservedObject var new = EventClass()
    @State var withMoney = false
    
    var body: some View {
        ScrollView {
            VStack {
                MyTextField(placeHolder: "Etkinlik adı", text: $new.event.name, overlay: true)
                MyTextField(placeHolder: "Konuşmacı", text: $new.event.talker, overlay: true)
                MyTextField(placeHolder: "Katılımcı sınırı", text: $new.event.maxParticipants, overlay: true)
                Toggle(isOn: $withMoney) {
                    Text("Ücretli Katılım")
                }
                if withMoney {
                    MyTextField(placeHolder: "Katılım ücreti", text: $new.event.price, overlay: true)
                }
                MyTextField(placeHolder: "Adress", text: $new.event.location, overlay: true)
                // multiline text field
                MyTextView(text: $new.event.description, placeholder: "Açıklama", height: 200)
            }.padding([.top, .leading, .trailing])
        }.navigationBarTitle("Etkinlik Oluştur", displayMode: .inline)
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView().environmentObject(UserClass())
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
