//
//  ProfileView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import Firebase
import SwiftKeychainWrapper

struct ProfileView: View {
    
    @EnvironmentObject var current: UserClass
    
    @State var showSettingSheet = false
    @State var logout = false
    
    @State var editProfile = false
    
    var body: some View {
        NavigationView {
            VStack {
                UserImage().environmentObject(current)
                
                VStack {
                    VStack {
                        Button(action: {
                            withAnimation(){
                                self.editProfile.toggle()
                            }
                        }) {
                            Text(editProfile ? "Vazgeç" : "Düzenle")
                        }
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                    if editProfile {
                        EditProfile(editProfile: self.$editProfile, name: self.current.user.name ?? "", department: self.current.user.department ?? "", level: self.current.user.level ?? 0)
                            .environmentObject(current)
                            .transition(.scale)
                            
                    } else {
                        ShowProfile()
                            .environmentObject(current)
                            .transition(.scale)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 32)
                .padding([.leading, .trailing])
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                leading:
                Button(action: {
                    self.showSettingSheet = true
                }) {
                    MyImage(imageName: "gear", imageColor: .mainColor)
                }.sheet(isPresented: $showSettingSheet, onDismiss: {
                    if self.logout {
                        self.current.clear()
                        KeychainWrapper.standard.set(false, forKey: "isLoggedIn")
                        self.current.isLoggedIn = false
                    }
                }, content: {
                    SettingsView(logout: self.$logout)
                })
            )
        }
    }
}

struct UserImage: View {
    
    @EnvironmentObject var current: UserClass
    
    @State var showImageSheet = false
    @State var showImagePicker = false
    @State var useCamera = false
    
    @State var alert: Alert? = nil
    @State var showAlert = false
    
    @State var image: UIImage? = nil
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if(self.current.user.image != nil){
                self.current.user.image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            }
            else {
                ZStack {
                    Color.gray
                        .frame(width: 150, height: 150)
                    Image(systemName: "camera").imageScale(.large)
                }.clipShape(Circle())
            }
            
            Button(action: {
                self.showImageSheet = true
            }) {
                MyImage(imageName: "person.crop.circle.badge.plus")
                    .background(Color.white)
                    .clipShape(Circle())
                    .actionSheet(isPresented: $showImageSheet){
                        ActionSheet(
                            title: Text("İşleminizi Seçiniz"),
                            buttons: self.current.user.image == nil ? [
                                .default(Text("Fotoğraf Çek"), action: {
                                    self.useCamera = true
                                    self.showImagePicker = true
                                }),
                                .default(Text("Galeriden Seç"), action: {
                                    self.useCamera = false
                                    self.showImagePicker = true
                                }),
                                .cancel(Text("Vazgeç"))
                                ]:[
                                    .default(Text("Fotoğraf Çek"), action: {
                                        self.useCamera = true
                                        self.showImagePicker = true
                                    }),
                                    .default(Text("Galeriden Seç"), action: {
                                        self.useCamera = false
                                        self.showImagePicker = true
                                    }),
                                    .destructive(Text("Fotoğrafı Kaldır"), action: {
                                        self.deleteUserImage()
                                    }),
                                    .cancel(Text("Vazgeç"))
                            ])
                }
            }.sheet(isPresented: $showImagePicker, onDismiss: {
                if self.image != nil { //got image -> upload
                    self.uploadUserImage()
                }
            }, content: {
                ImagePickerView(isShown: self.$showImagePicker, image: self.$image, useCamera: self.useCamera)
            })
        }
        .padding(.top)
        .alert(isPresented: $showAlert, content: {
            alert!
        })
        
    }
    
    func uploadUserImage() {
        let imgName =  self.current.user.email.dropLast(11) + ".jpg"
        let ref = Storage.storage().reference(withPath: "UserImages/\(imgName)")
        
        guard let imgData = self.image!.jpegData(compressionQuality: 0.75) else {
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
                                   primaryButton: .default(Text("Tekrar dene"), action: { self.uploadUserImage() }),
                                   secondaryButton: .cancel(Text("Vazgeç")))
                self.showAlert = true
            }
            else {
                self.current.user.image = Image(uiImage: self.image!)
            }
        }
    }
    
    func deleteUserImage() {
        let imgName = self.current.user.email.dropLast(11) + ".jpg"
        let ref = Storage.storage().reference(withPath: "UserImages/\(imgName)")
        
        ref.delete { (Error) in
            if let err = Error {
                let message = err.localizedDescription
                self.alert = Alert(title: Text("HATA"), message: Text(message),
                                   primaryButton: .default(Text("Tekrar dene"), action: { self.uploadUserImage() }),
                                   secondaryButton: .cancel(Text("Vazgeç")))
                self.showAlert = true
            }
            else {
                self.current.user.image = nil
            }
        }
    }
}

struct EditProfile: View {
    
    @EnvironmentObject var current: UserClass
    @Binding var editProfile: Bool
    
    @State var name = ""
    @State var department = ""
    @State var level = 0
    
    @State var alert: Alert? = nil
    @State var showAlert = false
    
    let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            MyTextField(placeHolder: "İsminiz", text: $name, overlay: true)
            MyTextField(placeHolder: "Bölümünüz", text: $department, overlay: true)
            Picker("", selection: $level, content: {
                Text("Lisans").tag(0)
                Text("Yüksek Lisans").tag(1)
                Text("Mezun").tag(2)
                Text("Akademisyen").tag(3)
            }).pickerStyle(SegmentedPickerStyle())
            Button(action: {
                self.save()
            }) {
                MyButton(text: "Kaydet", color: .mainColor)
            }.padding(.top)
        }.alert(isPresented: $showAlert, content: {
            alert!
        })
    }
    func save() {
        self.db.collection("Users").document(self.current.user.email).setData([
            "name" : self.name,
            "department" : self.department,
            "level" : self.level
        ], merge: true){ error in
            if let err = error {
                let message = err.localizedDescription
                self.alert = Alert(
                    title: Text("HATA"), message: Text(message),
                    primaryButton: .default(Text("Tekrar dene"), action: {
                        self.save() //recursive call to try again
                    }),
                    secondaryButton: .cancel(Text("Vazgeç"))
                )
            } else {
                self.current.user.name = self.name
                self.current.user.department = self.department
                self.current.user.level = self.level
                self.alert = Alert(
                    title: Text("Kaydedildi"), message: nil,
                    dismissButton: .cancel(Text("Tamam"), action: {
                        withAnimation() {
                            self.editProfile.toggle()
                        }
                    })
                )
            }
            self.showAlert = true
        }
    }
}

struct ShowProfile: View {
    
    @EnvironmentObject var current: UserClass
    @State var navigate = false
    
    var body: some View {
        VStack(spacing: 16) {
            MyText(info: "İsim", text: current.user.name)
            MyText(info: "Email", text: current.user.email)
            MyText(info: "Bölüm", text: current.user.department)
            MyText(info: "Eğitim durumu", text: current.user.leveller())
            Button(action: {
                self.current.getCreatedEvents()
                self.navigate = true
            }) {
                MyNavigationButton(text: "Etkinliklerim")
            }
            NavigationLink(destination: UserEventsView().environmentObject(current), isActive: $navigate, label: {EmptyView()})
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileView().environmentObject(UserClass())
            ProfileView(editProfile: true).environmentObject(UserClass())
        }
    }
}
