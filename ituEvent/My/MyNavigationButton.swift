//
//  MyNavigationButton.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 23.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct MyNavigationButton: View {
    
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
            Image(systemName: "arrowshape.turn.up.right")
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .foregroundColor(.mainColor)
        .overlay(
            RoundedRectangle(cornerRadius: 10).stroke(Color.mainColor)
        )
    }
}
