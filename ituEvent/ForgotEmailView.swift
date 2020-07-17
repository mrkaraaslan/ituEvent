//
//  ForgotEmailView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct ForgotEmailView: View {
    
    @State var email = ""
    @State var overlay = true
    
    var body: some View {
        VStack {
            Image(systemName: "chevron.compact.down")
                .font(.system(size: 30))
                .imageScale(.large)
            
            VStack {
                MyTextField(placeHolder: "Email", text: $email, overlay: true)
                
                Button(action: {
                    //: send reset email mail
                }) {
                    MyButton(text: "Sıfırla", color: .mainColor)
                }.padding(.top, 24)

            }
            .frame(maxHeight: .infinity)
            .padding([.leading, .trailing])
        }
    }
}

struct ForgotEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotEmailView()
    }
}
