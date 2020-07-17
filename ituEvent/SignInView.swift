//
//  SignInView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 16.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    
    @State var showForgotEmailSheet = false
    
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
                    
                    MyTextField(placeHolder: "Email", text: $email, overlay: false)
                    MySecureField(placeHolder: "Şifre", text: $password)
                    
                    Button(action: {
                        //: login and navigation
                        //: check email verification
                    }) {
                        MyButton(text: "Giriş")
                    }.padding(.top, 24)
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
                    //: navigation
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }.padding([.leading, .trailing])
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
