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
    @State var limited = false
    @State var withMoney = false
    
    var body: some View {
        VStack {
            Form {
                Section {
                    MyTextField(placeHolder: "Etkinlik adı", text: $new.event.name, overlay: true)
                    MyTextField(placeHolder: "Konuşmacı", text: $new.event.talker, overlay: true)
                }
                Section {
                    DatePicker(selection: $new.event.start, in: Date()..., label: { Text("Başlangıç") })
                    DatePicker(selection: $new.event.finish, in: new.event.start..., label: { Text("Bitiş") })
                }
                Section {
                    Toggle("Sınırlı Katılım", isOn: $limited)
                    if limited {
                        MyTextField(placeHolder: "Katılımcı sınırı", text: $new.event.maxParticipants, overlay: true)
                            .keyboardType(.numbersAndPunctuation)
                    }
                    Toggle("Ücretli Katılım", isOn: $withMoney)
                    if withMoney {
                        MyTextField(placeHolder: "Katılım ücreti", text: $new.event.price, overlay: true)
                            .keyboardType(.numbersAndPunctuation)
                    }
                }
                Section {
                    MyTextField(placeHolder: "Adress", text: $new.event.location, overlay: true)
                }
                Section {
                    // multiline text field
                    MyTextView(text: $new.event.description, placeholder: "Açıklama", height: 200)
                }
            }
            VStack {
                Button(action: {
                    //: firebase actions
                }) {
                    MyButton(text: "Etkinlik Oluştur", color: .mainColor)
                }
            }.padding()
        }.navigationBarTitle("Etkinlik Oluştur", displayMode: .inline)
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView().environmentObject(UserClass())
    }
}
