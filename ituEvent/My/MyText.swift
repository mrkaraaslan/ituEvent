//
//  MyText.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 18.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct MyText: View {
    
    var info: String?
    var text: String?
    
    var body: some View {
        VStack {
            Text((self.info != nil) ? info! : "")
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
            VStack(spacing: 0) {
                Text((self.text != nil) ? text! : "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.mainColor)
            }
        }
    }
}
