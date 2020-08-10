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
    @State var addPhoto = false
    
    var body: some View {
        VStack {
            if addPhoto {
                AddPhoto(eventId: new.event.id)
                    .transition(.move(edge: .bottom))
            }
            else {
                AddInfo(addPhoto: $addPhoto, new: new).environmentObject(current)
                    .transition(.move(edge: .top))
            }
        }
    }
}

struct AddInfo: View {
    
    @Environment(\.presentationMode) var view: Binding<PresentationMode>
    @EnvironmentObject var current: UserClass
    
    @State var limited = false
    @State var withMoney = false
    
    @State var alert: Alert? = nil
    @State var showAlert = false
    
    @Binding var addPhoto: Bool
    @ObservedObject var new: EventClass

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
                    if isConnected() {
                        self.saveEvent()
                    }
                    else {
                        self.alert = Alert(title: Text("İnternet bağlantınızı kontrol ediniz"))
                        self.showAlert = true
                    }
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
        
        let event = self.new.event
        
        func toUser() {
            db.collection("Users").document(self.current.user.email).updateData([
                AnyHashable("cEvents") : FieldValue.arrayUnion([event.id])
            ]){ error in
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
                "maxParticipants" : event.maxParticipants,
                "price" : event.price,
                "location" : event.location,
                "description" : event.description
            ], merge: true){ error in
                if let err = error {
                    let message = err.localizedDescription
                    self.alert = Alert(title: Text("HATA"), message: Text(message), primaryButton: .default(Text("Tekrar dene"), action: {toEvents()}), secondaryButton: .cancel(Text("Vazgeç")))
                }
                else {
                    self.current.user.cEvents.append(event.id)
                    self.current.cEvents.append(event)
                    
                    self.alert = Alert(title: Text("Etkinlik oluşturuldu"), primaryButton: .default(Text("Fotoğraf ekle"), action: {
                        withAnimation() {
                            self.addPhoto = true
                        }
                    }), secondaryButton: .cancel(Text("Vazgeç"), action: {
                        self.view.wrappedValue.dismiss()
                    }))
                }
                self.showAlert = true
            }
        }
        toUser()
    }
}


struct AddPhoto: View {
    
    @Environment(\.presentationMode) var view: Binding<PresentationMode>
    var eventId: String
    
    @State var img: UIImage? = nil
    @State var showImageSheet = false
    @State var showImagePicker = false
    @State var useCamera = false
    
    @State var alert: Alert? = nil
    @State var showAlert = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                VStack {
                    if self.img != nil {
                        Image(uiImage: self.img!)
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
                            Image(systemName: "photo.on.rectangle").imageScale(.large)
                        }
                    }
                }
                
                HStack {
                    if self.img != nil {
                        Button(action: {
                            self.img = nil
                        }) {
                            MyImage(imageName: "minus", imageColor: .red)
                                .background(Color.white.cornerRadius(15))
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        self.showImageSheet = true
                    }) {
                        MyImage(imageName: "plus")
                            .background(Color.white.cornerRadius(15))
                    }
                    .actionSheet(isPresented: $showImageSheet){
                        ActionSheet(
                            title: Text("İşleminizi Seçiniz"),
                            buttons: [
                            .default(Text("Fotoğraf Çek"), action: {
                                self.useCamera = true
                                self.showImagePicker = true
                            }),
                            .default(Text("Galeriden Seç"), action: {
                                self.useCamera = false
                                self.showImagePicker = true
                            }),
                            .cancel(Text("Vazgeç"))
                        ])
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .sheet(isPresented: $showImagePicker, content: {
                ImagePickerView(isShown: self.$showImagePicker, image: self.$img, useCamera: self.useCamera)
            })
            
            VStack {
                Button(action: {
                    self.uploadPhoto()
                }) {
                    MyButton(text: "Fotoğrafı Yükle.", color: .mainColor)
                }
            }
        }
        .padding()
        .alert(isPresented: $showAlert, content: {
            alert!
        })
    }
    func uploadPhoto() {
        //: firebase upload event photo
        let ref = Storage.storage().reference(withPath: "Events/\(self.eventId)/img.jpg")
        
        guard let imgData = self.img?.jpegData(compressionQuality: 0.75) else {
            self.alert = Alert(title: Text("Desteklemeyen fotoğraf biçimi"), message: nil, dismissButton: .cancel(Text("Tamam")))
            self.showAlert = true
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        ref.putData(imgData, metadata: metaData) { (StorageMetadata, Error) in
            if let err = Error {
                let message = err.localizedDescription
                self.alert = Alert(title: Text("HATA"), message: Text(message),
                                   primaryButton: .default(Text("Tekrar dene"), action: { self.uploadPhoto() }),
                                   secondaryButton: .cancel(Text("Vazgeç")))
                self.showAlert = true
            }
            else {
                self.alert = Alert(title: Text("Fotoğraf yüklendi"), message: nil, dismissButton: .cancel(Text("Tamam"), action: {
                    self.view.wrappedValue.dismiss()
                }))
                self.showAlert = true
            }
        }
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreateEventView().environmentObject(UserClass())
            CreateEventView(addPhoto: true).environmentObject(UserClass())
        }
    }
}

