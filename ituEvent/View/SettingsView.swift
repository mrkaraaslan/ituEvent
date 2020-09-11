//
//  SettingsView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import Firebase
import SwiftKeychainWrapper

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var logout: Bool
    
    @State var isNotification = true
    @State var lang = 1
    
    @State var showAlert = false
    @State var alert: Alert? = nil
    
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
                                self.signOut()
                            }) {
                                HStack {
                                    Text("Çıkış yap").foregroundColor(.black)
                                    MyImage(imageName: "power", imageColor: .red)
                                }
                            }
                            .alert(isPresented: $showAlert, content: {
                                self.alert!
                            })
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
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.logout = true
            self.presentationMode.wrappedValue.dismiss()
        } catch let Error as NSError {
            let message = Error.localizedDescription
            self.alert = Alert(title: Text("Çıkış Yapılamadı"), message: Text(message), primaryButton: .default(Text("Tekrar dene"), action: {
                self.signOut()
            }), secondaryButton: .cancel(Text("Vazgeç")))
            self.showAlert = true
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(logout: .constant(false))
    }
}
