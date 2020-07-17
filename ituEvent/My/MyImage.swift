//
//  MyImage.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct MyImage: View {
    
    var imageName: String
    var imageColor: Color = .mainColor
    
    var body: some View {
        Image(systemName: imageName)
            .imageScale(.large)
            .frame(width: 40, height: 40, alignment: .center)
            .foregroundColor(imageColor)
    }
}
