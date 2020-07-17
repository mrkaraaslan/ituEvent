//
//  ProfileView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 17.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @State var userImage: Image? = nil
    
    @State var showImageSheet = false
    @State var showImagePicker = false
    @State var useCamera = false
    
    var body: some View {
        VStack {
            
            ZStack(alignment: .bottomTrailing) {
                if(self.userImage != nil){
                    self.userImage?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                }
                else {
                    ZStack {
                        Color.gray
                            .frame(width: 150, height: 150)
                                            
                        Image(systemName: "camera").imageScale(.large)

                    }.clipShape(Circle())
                }
                
                Button(action: {
                    self.showImageSheet = true
                }) {
                    MyImage(imageName: "person.crop.circle.badge.plus")
                        .background(Color.white)
                        .clipShape(Circle())
                        .actionSheet(isPresented: $showImageSheet){
                            ActionSheet(
                                title: Text("İşleminizi Seçiniz"),
                                buttons: self.userImage == nil ? [
                                    .default(Text("Fotoğraf Çek"), action: {
                                        self.useCamera = true
                                        self.showImagePicker = true
                                    }),
                                    .default(Text("Galeriden Seç"), action: {
                                        self.useCamera = false
                                        self.showImagePicker = true
                                    }),
                                    .cancel(Text("Vazgeç"))
                                ]:[
                                    .default(Text("Fotoğraf Çek"), action: {
                                        self.useCamera = true
                                        self.showImagePicker = true
                                    }),
                                    .default(Text("Galeriden Seç"), action: {
                                        self.useCamera = false
                                        self.showImagePicker = true
                                    }),
                                    .destructive(Text("Fotoğrafı Kaldır"), action: {
                                        self.userImage = nil
                                    }),
                                    .cancel(Text("Vazgeç"))
                            ])
                    }
                }.sheet(isPresented: $showImagePicker, content: {
                    ImagePickerView(isShown: self.$showImagePicker, image: self.$userImage, useCamera: self.$useCamera)
                })
            }.padding(.top)
            // user image ends
            
            
            Text("Profile View")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
