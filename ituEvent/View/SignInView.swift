//
//  SignInView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 16.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import Firebase
import SwiftKeychainWrapper

struct SignInView: View {
    
    @EnvironmentObject var current: UserClass
    @Binding var showSignInView: Bool
    
    @State var email = KeychainWrapper.standard.string(forKey: "userEmail") ?? ""
    @State var password = KeychainWrapper.standard.string(forKey: "userPassword") ?? ""
    
    @State var showForgotPasswordSheet = false
    
    @State var alert: Alert? = nil
    @State var showAlert = false
    
    @State var rememberMe = UserDefaults.standard.bool(forKey: "rememberMe")
    
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
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    MySecureField(placeHolder: "Şifreniz", text: $password)
                    
                    Toggle(isOn: $rememberMe) {
                        HStack {
                            Spacer()
                            Text("Beni Hatırla")
                                .foregroundColor(.white)
                        }
                    }
                    .onReceive([self.rememberMe].publisher ){ value in
                        UserDefaults.standard.set(value, forKey: "rememberMe")
                        if  !value {
                            KeychainWrapper.standard.set("", forKey: "userEmail")
                            KeychainWrapper.standard.set("", forKey: "userPassword")
                        }
                    }
                    .padding(.top, 24)
                    
                    Button(action: {
                        //: login and navigation
                        //: check email verification
                        if self.check() {
                            self.signIn()
                        }
                    }) {
                        MyButton(text: "Giriş")
                    }
                    .alert(isPresented: $showAlert, content: {
                        self.alert!
                    })
                }
                .frame(maxHeight: .infinity)
                
                HStack {
                    Text("Şifremi Unuttum")
                        .onTapGesture {
                            self.showForgotPasswordSheet = true
                        }
                    .sheet(isPresented: $showForgotPasswordSheet, content: {
                        ForgotPasswordView()
                    })
                    Text("  /  ")
                    Text("Kayıt Ol")
                        .onTapGesture {
                            withAnimation() {
                                self.showSignInView = false
                            }
                        }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }.padding()
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
        let email = self.email.trimmingCharacters(in: .whitespaces) //remove pre and post spaces
        var message = ""
        
        if let user = Auth.auth().currentUser {
            if user.isEmailVerified {
                KeychainWrapper.standard.set(true, forKey: "isLoggedIn")
                KeychainWrapper.standard.set(email, forKey: "userEmail")
                KeychainWrapper.standard.set(self.password, forKey: "userPassword")
                if self.rememberMe {
                    UserDefaults.standard.set(email, forKey: "savedEmail")
                }
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
