//
//  MySecureField.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct MySecureField: View {
    
    var placeHolder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeHolder, text: $text)
            .padding(.leading)
            .frame(height: 60)
            .background(Color.white)
            .cornerRadius(15)
    }
}
