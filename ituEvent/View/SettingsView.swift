//
//  SettingsView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import SwiftKeychainWrapper

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var logout: Bool
    
    @State var isNotification = true
    @State var lang = 1
    
    var body: some View {
        VStack {
            Image(systemName: "chevron.compact.down")
                .font(.system(size: 30))
                .imageScale(.large)
            
            NavigationView {
                VStack {
                    Form {
                        Section {
                            Button(action: {
                                KeychainWrapper.standard.set(false, forKey: "isLoggedIn")
                                self.logout = true
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Text("Çıkış yap").foregroundColor(.black)
                                    MyImage(imageName: "power", imageColor: .red)
                                }
                            }
                        }.frame(maxWidth: .infinity, alignment: .center)
                        
                        Section {
                            Toggle(isOn: $isNotification) {
                                Text("Bildirimler")
                            }
                            Text("Şifremi değiştir")
                            Text("Uygulamayı paylaş")
                            Text("Hata Bildir")
                            Text("Bize Ulaşın")
                            Picker(selection: $lang, label: Text("Dil")) {
                                Text("Türkçe").tag(1)
                                Text("English").tag(2)
                            }
                        }
                        
                        Section {
                            Text("Hesabımı Sil")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Text("Sürüm: 1.0")
                }.navigationBarTitle(Text("Ayarlar"), displayMode: .inline)
            }
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(logout: .constant(false))
    }
}
