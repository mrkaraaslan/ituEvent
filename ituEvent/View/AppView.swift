//
//  AppView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    @EnvironmentObject var current: UserClass
    
    var body: some View {
        TabView {
            SearchEventView().environmentObject(current)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Etkinlik Ara")
            }
            
            EventsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Etkinlikler")
            }
            
            ProfileView().environmentObject(current)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profil")
            }
        }.onAppear() {
            self.current.info()
            self.current.getEvents()
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView().environmentObject(UserClass())
    }
}
