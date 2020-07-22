//
//  ForgotEmailView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import Firebase

struct ForgotEmailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var email = ""
    @State var overlay = true
    
    @State var alert: Alert? = nil
    @State var showAlert = false
    
    var body: some View {
        VStack {
            Image(systemName: "chevron.compact.down")
                .font(.system(size: 30))
                .imageScale(.large)
            
            VStack {
                MyTextField(placeHolder: "Email", text: $email, overlay: true)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                Button(action: {
                    //: send reset password mail
                    if self.check() {
                        self.sendResetMail()
                    }
                }) {
                    MyButton(text: "Sıfırla", color: .mainColor)
                }
                .padding(.top, 24)
                .alert(isPresented: $showAlert, content: {
                    self.alert!
                })

            }
            .frame(maxHeight: .infinity)
            .padding([.leading, .trailing])
        }
    }
    
    func check() -> Bool {
        var r = true
        
        let mail = self.email.trimmingCharacters(in: .whitespaces)
        let m = mail.drop { (Character) -> Bool in
            Character != "@"
        }
        
        if m == "@itu.edu.tr" {
            r = true
        }
        else {
            r = false
            self.alert = Alert(title: Text("Hata"), message: Text("Lütfen geçerli bir mail giriniz."), dismissButton: .cancel(Text("Tamam")))
            self.showAlert = true
        }
        
        return r
    }
    
    func sendResetMail() {
        let mail = self.email.trimmingCharacters(in: .whitespaces)
        var message = ""
        
        Auth.auth().sendPasswordReset(withEmail: mail) { error in
            if let err = error {
                message = err.localizedDescription
                self.alert = Alert(title: Text("Hata"), message: Text(message), primaryButton: .default(Text("Tekrar Dene"), action: {
                    self.sendResetMail() //recursive call to try again
                }), secondaryButton: .cancel(Text("Vazgeç")))
                self.showAlert = true
            }
            else {
                message = "Hesabınıza gönderilen maili kullanarak şifrenizi değiştirebilirsiniz."
                self.alert = Alert(title: Text("Tebrikler"), message: Text(message), dismissButton: .cancel(Text("Tamam"), action: {
                    self.presentationMode.wrappedValue.dismiss()
                }))
                self.showAlert = true
            }
        }
    }
}

struct ForgotEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotEmailView()
    }
}
