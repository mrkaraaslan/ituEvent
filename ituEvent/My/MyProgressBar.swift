//
//  MyProgressBar.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 12.08.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct MyProgressBar: View {
    @Binding var progress: Double
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.5)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.mainColor)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(self.progress))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .frame(width: 70, height: 70)
                    .foregroundColor(.mainColor)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear)
                
                Text(String(format:"%% %.0f", self.progress * 100))
            }
        }
        .conditional(self.progress == 0.0, content: {
            AnyView(
                $0.hidden()
            )
        })
    }
}

struct MyProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        MyProgressBar(progress: .constant(0.33))
    }
}
