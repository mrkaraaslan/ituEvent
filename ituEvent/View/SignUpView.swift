//
//  SignUpView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    
    @Binding var showSignInView: Bool
    @State var email = ""
    @State var password = ""
    @State var passCheck = ""
    
    @State var alert: Alert? = nil
    @State var showAlert = false
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    MyTextField(placeHolder: "İTÜ mailiniz", text: $email, overlay: false)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    MySecureField(placeHolder: "Şifreniz", text: $password)
                    MySecureField(placeHolder: "Şifre Tekrarı", text: $passCheck)
                    
                    Button(action: {
                        // sign up and navigation
                        // send verification mail
                        // show verifcation alert
                        if self.check() {
                            self.signUp()
                        }
                    }) {
                        MyButton(text: "Kayıt Ol")
                    }
                    .padding(.top, 24)
                    .alert(isPresented: $showAlert, content: {
                        self.alert!
                    })
                }.frame(maxHeight: .infinity)
                
                Text("Giriş Yap")
                    .foregroundColor(.white)
                    .onTapGesture {
                        withAnimation(){
                            self.showSignInView = true
                        }
                    }
            }.padding([.leading, .trailing])
        }
    }
    
    func check() -> Bool{
        
        var r = false
        var message = ""
        
        if self.email == "" || self.password == "" || self.passCheck == "" {
            message = "Lütfen tüm alanları doldurunuz"
            self.alert = Alert(title: Text("Hata"), message: Text(message), dismissButton: .cancel(Text("Tamam")))
            self.showAlert = true
            r = false
        }
        else {
            let email = self.email.trimmingCharacters(in: .whitespaces) //remove pre and post spaces
            let m = email.drop { (Character) -> Bool in
                Character != "@"
            } // m must be @itu.edu.tr
            
            if m == "@itu.edu.tr" && self.password == self.passCheck {
                r = true
            }
            else { //invalid email or passwords does not match
                message = "Geçersiz email veya şifreler aynı değil"
                self.alert = Alert(title: Text("Hata"), message: Text(message), dismissButton: .cancel(Text("Tamam")))
                self.showAlert = true
            }
        }
        
        return r
    }
    
    func signUp() {
        let email = self.email.trimmingCharacters(in: .whitespaces) //remove pre and post spaces
        var message = ""
        
        Auth.auth().createUser(withEmail: email, password: self.password) { authResult, err in
            if let error = err { //authentication error
                message = error.localizedDescription
                self.alert = Alert(
                    title: Text("Hata"),
                    message: Text(message),
                    dismissButton: .cancel(Text("Tamam"))
                )
                self.showAlert = true
            }
            else { //no error send verification email
                self.verificate()
            }
        }
    }
    
    func verificate(){
        var message = ""
        Auth.auth().currentUser?.sendEmailVerification { (err) in
            if err != nil { //verification error
                message = "Hesabınız Oluşturuldu. Doğrulama maili gönderilemedi."
                self.alert = Alert(
                    title: Text("HATA"),
                    message: Text(message),
                    primaryButton: .default(Text("Tekrar Dene"), action: {self.verificate()}), //recursive call to try again
                    secondaryButton: .cancel(Text("Vazgeç")) //end
                )
                self.showAlert = true
            }
            else { //no error
                message = "Doğrulama maili gönderildi. Lütfen emailinizi doğrulayın."
                self.alert = Alert(
                    title: Text("Tebrikler"),
                    message: Text(message),
                    dismissButton: .cancel(Text("Tamam"), action: {withAnimation(){self.showSignInView = true}})
                )
                self.showAlert = true
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(showSignInView: .constant(false))
    }
}
