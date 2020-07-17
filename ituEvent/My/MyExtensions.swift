//
//  MyExtensions.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 16.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

extension Color {
    static let mainColor = Color(red: 3/255, green: 39/255, blue: 104/255)
    static let secondaryColor = Color(red: 58/255, green: 140/255, blue: 233/255)
    static let thirdColor = Color(red: 120/255, green: 160/255, blue: 210/255)
}

extension View {
    func conditional(_ condition: Bool, content: (AnyView) -> AnyView) -> AnyView {
        if condition {
            return content(AnyView(self))
        }
        else {
            return AnyView(self)
        }
    }
}
