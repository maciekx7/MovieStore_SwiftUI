//
//  UpdateUserView.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 28/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//

import SwiftUI

struct EditUserView: View {
    var user: User
    
    init(user: User) {
        self.user = user
        self._nick = State(initialValue: user.name ?? "")
        self._birthday = State(initialValue: user.birthday!)
        
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @State private var nick: String
    @State private var birthday: Date
    @State private var image: Image?
    @State private var pickedImage: UIImage?
    @State private var isCamera = false
    
    @State private var ShowingEmptyFieldsAlert = false
    @State private var isShowingImagePicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Circle()
                        .frame(width: 330.0, height: 250.0)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 10)
                    
                    if pickedImage == nil {
                        Image(uiImage: self.user.getPhoto())
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 330.0, height: 250.0)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 10)
                    }
                    else {
                        Image(uiImage: pickedImage!)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 330.0, height: 250.0)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 10)
                    }
                }
                HStack {
                    Button(action: {
                        self.isCamera = false
                        self.isShowingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("chose photo")
                        }
                        .foregroundColor(Color.red)
                    }
                    Button(action: {
                        self.isCamera = true
                        self.isShowingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "camera")
                            Text("take photo")
                        }
                        
                    }
                }
                
                
                Form {
                    Section {
                        VStack {
                            HStack {
                                Text("Nick:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                TextField("", text: $nick)
                            }
                        }

                    }
                    Section {
                        DatePicker("Your birthday", selection: $birthday, displayedComponents: .date)
                    }
                    
                    
                    .navigationBarTitle("User Editing")
                    .navigationBarItems(leading:
                        Button("Cancel") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.blue)
                        , trailing: Button("Save") {
                            self.saveItem()
                        } .alert(isPresented: $ShowingEmptyFieldsAlert) {
                            Alert(title: Text("Some field are empty"), message: Text("Fill them before saving!"), dismissButton: .default(Text("OK")))
                    })
                }
                .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                    ImagePicker(pickedPhoto: self.$pickedImage, isCamera: self.$isCamera)
                }
            }
        }
    }
    
    func saveItem() {
        if self.nick != ""{
            self.ShowingEmptyFieldsAlert = false

            self.user.name = self.nick
            self.user.birthday = self.birthday
            if self.pickedImage != nil {
                self.user.deletePhoto()
                self.user.savePhoto(image: self.pickedImage!)
            }
            
            try? self.moc.save()
            self.presentationMode.wrappedValue.dismiss()
        }
        else {
            self.ShowingEmptyFieldsAlert = true
        }
    }
    
    func loadImage() {
        guard let pickedImage = self.pickedImage else {return}
        self.image = Image(uiImage: pickedImage)
    }
    
}


