//
//  ProfileView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import SwiftKeychainWrapper

struct ProfileView: View {
    
    @EnvironmentObject var current: UserClass
    
    @State var showImageSheet = false
    @State var showImagePicker = false
    @State var useCamera = false
    
    @State var showSettingSheet = false
    @State var logout = false
    
    var body: some View {
        NavigationView {
            VStack {
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
                                            self.current.user.image = nil
                                        }),
                                        .cancel(Text("Vazgeç"))
                                ])
                        }
                    }.sheet(isPresented: $showImagePicker, content: {
                        ImagePickerView(isShown: self.$showImagePicker, image: self.$current.user.image, useCamera: self.$useCamera)
                    })
                }.padding(.top)
                // user image ends
                
                VStack(spacing: 16) {
                    MyText(info: "İsim", text: current.user.name)
                    MyText(info: "Email", text: current.user.email)
                    MyText(info: "Bölüm", text: current.user.department)
                    MyText(info: "Durum", text: current.leveller())
                    NavigationLink(destination: UserEventsView().environmentObject(current), label: {
                        MyNavigationButton(text: "Etkinliklerim")
                    })
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(UserClass())
    }
}
