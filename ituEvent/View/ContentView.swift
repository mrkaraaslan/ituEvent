//
//  ContentView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 16.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var current: UserClass
    
    var body: some View {
        VStack {
            if current.isLoggedIn {
                AppView().environmentObject(current)
            }
            else {
                SignView().environmentObject(current)
                    .transition(.move(edge: .leading))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserClass())
    }
}
