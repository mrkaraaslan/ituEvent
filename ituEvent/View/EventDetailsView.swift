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
    
    @State var eventImage: Image? = nil
    @State var downloadProgress = 0.0
    
    @State var alert: Alert? = nil
    @State var showAlert = false
    
    var body: some View {
        VStack {
            Form {
                Section {
                    VStack {
                        if eventImage != nil {
                            eventImage?
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        else {
                            ZStack {
                                Color.gray
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                MyProgressBar(progress: $downloadProgress)
                            }
                        }
                    }
                }
                Section {
                    MyText(info: "Etkinlik adı", text: event.name)
                    MyText(info: "Konuşmacı", text: event.talker)
                }
                Section {
                    MyText(info: "Başlangıç", text: f.string(from: event.start))
                    MyText(info: "Bitiş", text: f.string(from: event.finish))
                }
                Section {
                    MyText(info: "Katılımcı sınırı", text: event.maxParticipants != "" ? event.maxParticipants : "Sınırsız")
                    MyText(info: "Katılım ücreti", text: event.price != "" ? event.price : "Ücretsiz")
                }
                Section {
                    MyText(info: "Adress", text: event.location)
                }
                Section {
                    MyText(info: "Açıklama", text: event.description)
                }
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
        .onAppear() {
            if self.event.image == nil {
                self.getImage()
            }
            else {
                self.eventImage = self.event.image
            }
        }
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
                
                let ref = Storage.storage().reference(withPath: "Events/\(self.event.id)/img.jpg")
                ref.delete()
                
                self.view.wrappedValue.dismiss()
            }
        }
    }
    
    func getImage() {
        let ref = Storage.storage().reference(withPath: "Events/\(event.id)/img.jpg")
        let task = ref.getData(maxSize: 4 * 1024 * 1024) { (Data, Error) in
            
            let eventIndex = self.current.cEvents.firstIndex { (Event) -> Bool in
                Event.id == self.event.id
            }
            
            if let data = Data {
                let image = UIImage(data: data)
                self.eventImage = Image(uiImage: image!)
                if let i = eventIndex {
                    self.current.cEvents[i].image = Image(uiImage: image!)
                }
            }
            else {
                self.eventImage = Image("itüevent")
                if let i = eventIndex {
                    self.current.cEvents[i].image = Image("itüevent")
                }
            }
        }
        
        task.observe(.progress) { (snapshot) in
            guard let progress = snapshot.progress?.fractionCompleted else {return}
            self.downloadProgress = progress
        }
    }
}

struct EventDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailsView(event: Event()).environmentObject(UserClass())
    }
}
