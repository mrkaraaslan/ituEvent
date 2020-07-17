//
//  SignUpView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    @State var name = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    MyTextField(placeHolder: "İsim", text: $name, overlay: false)
                    MyTextField(placeHolder: "Email", text: $email, overlay: false)
                    MyTextField(placeHolder: "Şifre", text: $password, overlay: false)
                    
                    Button(action: {
                        //: sign up and navigation
                        //: send verification mail
                        //: show verifcation alert
                    }) {
                        MyButton(text: "Kayıt Ol")
                    }.padding(.top, 24)
                }.frame(maxHeight: .infinity)
                
                Text("Giriş Yap")
                    .foregroundColor(.white)
                    //: onTapGesture --> navigation
            }.padding([.leading, .trailing])
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
