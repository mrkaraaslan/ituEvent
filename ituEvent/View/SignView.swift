//
//  SignView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct SignView: View {
    
    @EnvironmentObject var current: UserClass
    @State var signIn = true
    
    var body: some View {
        VStack {
            if signIn {
                SignInView(signIn: $signIn).environmentObject(current)
                    .transition(.asymmetric(insertion: .slide, removal: .move(edge: .leading)))
            }
            else {
                SignUpView(signIn: $signIn)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .slide))
            }
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        SignView().environmentObject(UserClass())
    }
}
