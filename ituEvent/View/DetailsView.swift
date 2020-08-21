//
//  DetailsView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 19.08.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct DetailsView: View {
    
    var event: Event
    var f: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    if event.image != nil {
                        event.image?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    else {
                        ZStack {
                            Image("itüevent")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                }.padding()
                
                VStack {
                    MyText(info: "Konuşmacı", text: event.talker)
                    MyText(info: "Başlangıç", text: f.string(from: event.start))
                    MyText(info: "Bitiş", text: f.string(from: event.finish))
                    MyText(info: "Katılımcı sınırı", text: event.maxParticipants != "" ? event.maxParticipants : "Sınırsız")
                    MyText(info: "Katılım ücreti", text: event.price != "" ? event.price : "Ücretsiz")
                    MyText(info: "Adress", text: event.location)
                    MyText(info: "Açıklama", text: event.description)
                }.padding()
            }
            .navigationBarTitle(event.name)
            
            HStack { //: Buttons
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(event: Event()).environmentObject(UserClass())
    }
}
