//
//  EventDetailsView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 30.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import Firebase

struct EventDetailsView: View {
    
    @Environment(\.presentationMode) var view: Binding<PresentationMode> //to dismiss view
    @EnvironmentObject var current: UserClass
    
    var event: Event
    var f: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    @State var alert: Alert? = nil
    @State var showAlert = false
    
    var body: some View {
        VStack {
            Form {
                MyText(info: "Etkinlik adı", text: event.name)
                MyText(info: "Konuşmacı", text: event.talker)
                MyText(info: "Başlangıç", text: f.string(from: event.start))
                MyText(info: "Bitiş", text: f.string(from: event.finish))
                MyText(info: "Katılımcı sınırı", text: event.maxParticipants != "" ? event.maxParticipants : "Sınırsız")
                MyText(info: "Katılım ücreti", text: event.price != "" ? event.price : "Ücretsiz")
                MyText(info: "Adress", text: event.location)
                MyText(info: "Açıklama", text: event.description)
            }
            VStack {
                Button(action: {
                    self.deleteEvent()
                }) {
                    MyButton(text: "Etkinliği sil", color: .red)
                }
            }.padding()
        }
        .navigationBarTitle(event.name)
    }
    
    func deleteEvent() {
        let db = Firestore.firestore()
        
        db.collection("Events").document(event.id).delete { (Error) in
            if let err = Error {
                let m = err.localizedDescription
                self.alert = Alert(title: Text("HATA"), message: Text(m),
                                   primaryButton: .default(Text("Tekrar dene"), action: { self.deleteEvent() }),
                                   secondaryButton: .cancel(Text("Vazgeç")))
            }
            else {
                let eventIndex = self.current.cEvents.firstIndex { (Event) -> Bool in
                    Event.id == self.event.id
                }
                self.current.cEvents.remove(at: eventIndex!)
                
                let idIndex = self.current.user.cEvents.firstIndex { (id) -> Bool in
                    id == self.event.id
                }
                self.current.user.cEvents.remove(at: idIndex!)
                
                db.collection("Users").document(self.current.user.email).updateData([
                    AnyHashable("cEvents") : FieldValue.arrayRemove([self.event.id])
                ])
                
                self.view.wrappedValue.dismiss()
            }
        }
    }
}

struct EventDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailsView(event: Event()).environmentObject(UserClass())
    }
}
