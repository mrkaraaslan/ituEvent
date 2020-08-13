//
//  SearchEventView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI
import Firebase

struct SearchEventView: View {
    
    @EnvironmentObject var current: UserClass
    
    var body: some View {
        VStack {
            ForEach(self.current.searchEvents, id: \.id) { event in
                Text(event.name)
            }
            Button(action: {
                print("search: \(self.current.searchEvents.count)")
            }) {
                Text("Button")
            }
        }
    }
}

struct SearchEventView_Previews: PreviewProvider {
    static var previews: some View {
        SearchEventView()
    }
}
