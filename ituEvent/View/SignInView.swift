//
//  SignInView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 16.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import Firebase

struct SignInView: View {
    
    @EnvironmentObject var current: UserClass
    @Binding var showSignInView: Bool
    
    @State var email = ""
    @State var password = ""
    
    @State var showForgotEmailSheet = false
    
    @State var alert: Alert? = nil
    @State var showAlert = false
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                
            VStack {
                VStack {
                    Text("İTÜEVENT")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                    
                    MyTextField(placeHolder: "İTÜ mailiniz", text: $email, overlay: false)
                    MySecureField(placeHolder: "Şifreniz", text: $password)
                    
                    Button(action: {
                        //: login and navigation
                        //: check email verification
                        if self.check() {
                            self.signIn()
                        }
                    }) {
                        MyButton(text: "Giriş")
                    }
                    .padding(.top, 24)
                    .alert(isPresented: $showAlert, content: {
                        self.alert!
                    })
                }
                .frame(maxHeight: .infinity)
                
                HStack {
                    Text("Şifremi Unuttum")
                        .onTapGesture {
                            self.showForgotEmailSheet = true
                        }
                    .sheet(isPresented: $showForgotEmailSheet, content: {
                        ForgotEmailView()
                    })
                    Text("  /  ")
                    Text("Kayıt Ol")
                        .onTapGesture {
                            withAnimation() {
                                self.showSignInView = false
                            }
                        }
                    //: navigation
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }.padding([.leading, .trailing])
        }
    }
    
    func check() -> Bool {
        var r = true
        var message = ""
        
        if self.email == "" || self.password == "" {
            r = false
            message = "Lütfen tüm alanları doldurunuz."
            self.alert = Alert(title: Text("Hata"), message: Text(message), dismissButton: .cancel(Text("Tamam")))
            self.showAlert = true
        }
        
        return r
    }
    
    func signIn() {
        let email = self.email.trimmingCharacters(in: .whitespaces) //remove pre and post spaces
        var message = ""
        
        Auth.auth().signIn(withEmail: email, password: self.password) { (user, error) in
            
            if let err = error { //sign in error
                message = err.localizedDescription
                self.alert = Alert(title: Text("Hata"), message: Text(message), dismissButton: .cancel(Text("Tamam")))
                self.showAlert = true
            }
            else { //no error check verification
                self.verificate()
            }
        }
    }
    
    func verificate() {
        var message = ""
        
        if let user = Auth.auth().currentUser {
            if user.isEmailVerified {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                withAnimation(){self.current.isLoggedIn = true}
            }
            else {
                message = "Lütfen emailinizi doğrulayınız."
                self.alert = Alert(title: Text("Hata"), message: Text(message), primaryButton: .default(Text("Tekrar gönder"), action: {
                    self.sendVerificationMail()
                }), secondaryButton: .cancel(Text("Vazgeç")))
                self.showAlert = true
            }
        }
        else {
            message = "Giriş yapılamadı. Tekrar deneyin."
            self.alert = Alert(title: Text("Hata"), message: Text(message), dismissButton: .cancel(Text("Tamam")))
            self.showAlert = true
        }
    }
    
    func sendVerificationMail() {
        var message = ""
        Auth.auth().currentUser?.sendEmailVerification { (err) in
            if err != nil { //verification error
                message = "Doğrulama maili gönderilemedi."
                self.alert = Alert(
                    title: Text("HATA"),
                    message: Text(message),
                    primaryButton: .default(Text("Tekrar Dene"), action: {self.sendVerificationMail()}), //recursive call to try again
                    secondaryButton: .cancel(Text("Vazgeç")) //end
                )
                self.showAlert = true
            }
            else { //no error
                message = "Doğrulama maili gönderildi. Lütfen emailinizi doğrulayın."
                self.alert = Alert(
                    title: Text("Tebrikler"),
                    message: Text(message),
                    dismissButton: .cancel(Text("Tamam"))
                )
                self.showAlert = true
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(showSignInView: .constant(true)).environmentObject(UserClass())
    }
}
