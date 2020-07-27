//
//  CreateEventView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 23.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import Firebase

struct CreateEventView: View {
    
    @EnvironmentObject var current: UserClass
    @ObservedObject var new = EventClass()
    @State var limited = false
    @State var withMoney = false
    
    @State var alert: Alert? = nil
    @State var showAlert = false

    let db = Firestore.firestore()
    
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
                    //: control before save
                    self.saveEvent()
                }) {
                    MyButton(text: "Etkinlik Oluştur", color: .mainColor)
                }
            }.padding()
        }
        .navigationBarTitle("Etkinlik Oluştur", displayMode: .inline)
        .alert(isPresented: $showAlert, content: {
            self.alert!
        })
    }
    func saveEvent() {
        func toUser() {
            db.collection("Users").document(self.current.user.email).setData([
                "cEvents" : self.current.user.cEvents as Any
            ], merge: true){ error in
                if let err = error {
                    let message = err.localizedDescription
                    self.alert = Alert(title: Text("HATA"), message: Text(message), primaryButton: .default(Text("Tekrar dene"), action: {toUser()}), secondaryButton: .cancel(Text("Vazgeç")))
                    self.showAlert = true
                }
                else {
                    toEvents()
                }
            }
        }
        func toEvents() {
            db.collection("Events").document(event.id).setData([
                "creator" : self.current.user.email,
                "name" : event.name,
                "talker" : event.talker,
                "start" : event.start,
                "finish" : event.finish,
                "maxParticipants" : Int(event.maxParticipants) ?? "NO",
                "price" : Int(event.price) ?? "NO",
                "location" : event.location,
                "description" : event.description
            ]){ error in
                if let err = error {
                    let message = err.localizedDescription
                    self.alert = Alert(title: Text("HATA"), message: Text(message), primaryButton: .default(Text("Tekrar dene"), action: {toEvents()}), secondaryButton: .cancel(Text("Vazgeç")))
                }
                else {
                    self.alert = Alert(title: Text("Etkinlik oluşturuldu"), dismissButton: .cancel(Text("Tamam")))
                }
                self.showAlert = true
            }
        }
        let event = self.new.event
        self.current.user.cEvents.append(event.id)
        toUser()
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView().environmentObject(UserClass())
    }
}
