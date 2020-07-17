//
//  FirstView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct SignView: View {
    
    @State var signIn = true
    
    var body: some View {
        VStack {
            if signIn {
                SignInView()
            }
            else {
                SignUpView()
            }
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        SignView()
    }
}
