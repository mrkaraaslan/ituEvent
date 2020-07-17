//
//  MyButton.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct MyButton: View {
    
    var text: String
    var color: Color = .white
    
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .foregroundColor(color)
            .overlay(
                RoundedRectangle(cornerRadius: 15).stroke(color)
            )
    }
}
