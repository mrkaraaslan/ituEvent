//
//  MyTextField.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct MyTextField: View {
    
    var placeHolder: String
    @Binding var text: String
    var overlay: Bool
    
    var body: some View {
        TextField(placeHolder, text: $text)
            .padding(.leading)
            .frame(height: 60)
            .conditional(!overlay, content: {
                AnyView($0
                    .background(Color.white)
                    .cornerRadius(15)
                )
            })
            .conditional(overlay, content: {
                AnyView($0
                    .overlay(
                        RoundedRectangle(cornerRadius: 15).stroke(Color.mainColor)
                    )
                )
            })
    }
}
