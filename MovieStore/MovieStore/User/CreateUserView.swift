//
//  UpdateUserView.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 28/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//

import SwiftUI


struct CreateUserView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    
    @State private var nick: String = ""
    @State private var birthday = Date()
    @State private var image: Image?
    @State private var pickedImage: UIImage?
    @State private var password: String = ""
    @State private var repassword: String = ""
    
    
    @State private var ShowingEmptyFieldsAlert = false
    @State private var isShowingImagePicker = false
    @State private var isPasswordNotMatching = false
    @State private var isCamera = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Circle()
                        .frame(width: 330.0, height: 250.0)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 10)
                    
                    if image != nil {
                        image?
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
                            HStack {
                                Text("Password:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                SecureField("", text: $password)
                            }
                            HStack {
                                Text("re-password:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                SecureField("", text: $repassword)
                            }
                        }
                    }
                    Section {
                        DatePicker("Your birthday", selection: $birthday, in: ...Date(), displayedComponents: .date)
                    }
                        
                    .navigationBarTitle("User Editing")
                    .navigationBarItems(leading:
                        Button("Cancel") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.blue)
                        , trailing: Button("Save") {
                            self.saveItem()
                        }
                        .alert(isPresented: $ShowingEmptyFieldsAlert) {
                            Alert(title: Text("Some field are empty"), message: Text("Fill them before saving!"), dismissButton: .default(Text("OK")))
                        }
                    )
                }
                .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                    ImagePicker(pickedPhoto: self.$pickedImage, isCamera: self.$isCamera)
                }
            }
        }
        
    }
    
    func saveItem() {
        let keychain = KeychainSwift()
        if self.password != self.repassword {
            self.isPasswordNotMatching = true
        }
        
        if self.nick != "" && (self.pickedImage != nil) && self.password != ""  && self.repassword != ""{
            
            keychain.set(self.password, forKey: "password")
            self.ShowingEmptyFieldsAlert = false
            let imageName = "UserName.jpeg"
            
            let newUser = User(context: self.moc)
            newUser.name = self.nick
            newUser.birthday = self.birthday
            newUser.imageName = imageName
            newUser.savePhoto(image: self.pickedImage!)
            
            
            try? self.moc.save()
            self.presentationMode.wrappedValue.dismiss()
        }
        else {
            self.ShowingEmptyFieldsAlert = true
        }
    }
    
    func loadImage() {
        guard let pickedImage = pickedImage else {return}
        image = Image(uiImage: pickedImage)
    }
}


