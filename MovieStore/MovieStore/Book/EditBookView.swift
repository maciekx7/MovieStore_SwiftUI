//
//  EditMovieVIew.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 11/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//

import SwiftUI
import CoreData

struct EditBookView: View {
    var book: Book
    
    init(book: Book) {
        self.book = book
        self._title = State(initialValue: book.title ?? "")
        self._author = State(initialValue: book.author ?? "")
        self._review = State(initialValue: book.review ?? "")
        self._rating = State(initialValue: Int(book.rating))
        self._genre = State(initialValue: book.genre ?? "")
        self._wasSeen = State(initialValue: book.seen)
    }
    
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @State private var title: String
    @State private var author: String
    @State private var review: String
    @State private var genre: String
    @State private var rating: Int
    @State private var wasSeen: Bool
    
    @State private var pickedImage: UIImage?
    @State private var isImagePickerShown = false
    @State private var isDeleteImage = false
    @State private var isCamera = false
    
    @State private var wantToDeletePhoto = false
    
    @State private var ShowingEmptyFieldsAlert = false
    
    
    let genres = ["Sci-Fi","Fantasy", "Comedy", "Horror", "Thriller", "Criminal", "Kids", "Romance", "Drama"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Title")
                            .foregroundColor(.gray)
                        Spacer()
                        TextField("Serie's title", text: $title)
                    }
                    HStack {
                        Text("Author:")
                            .foregroundColor(.gray)
                        Spacer()
                        TextField("Author", text: $author)
                    }
                    
                }
                Section {
                    HStack {
                        Toggle(isOn: $wasSeen) {
                            Text("Read")
                        }
                    }
                    if wasSeen == true {
                        
                        HStack() {
                            Text("review")
                                .foregroundColor(Color.gray)
                            Spacer()
                            TextField("Write a review", text: $review)
                        }
                        VStack {
                            RatingView(rating: $rating)
                        }
                    }
                    
                }

                
                Section {
                    if pickedImage == nil && self.book.isCustomImage == true && self.wantToDeletePhoto == false{
                        Image(uiImage: self.book.getPhoto()!)
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(0.75, contentMode: .fit)
                            .scaledToFill()
                        Button("Delete Image") {
                            self.isDeleteImage = true
                        }.foregroundColor(.red)
                    }
                    else if pickedImage != nil{
                        Image(uiImage: pickedImage!)
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(0.75, contentMode: .fit)
                        .scaledToFill()
                        Button("Delete Image") {
                            self.isDeleteImage = true
                        }.foregroundColor(.red)
                    }
                    
                    Button("Select Image") {
                        self.isImagePickerShown = true
                    }
                }
                
                
                
                Section {
                    Picker(selection: $genre, label: Text("Genre")) {
                        ForEach(genres, id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                }
            }
            .navigationBarTitle("Edit Book")
            .navigationBarItems(leading:
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
                , trailing:
                Button("Save") {
                    self.saveItem()
                }
                .alert(isPresented: $ShowingEmptyFieldsAlert) {
                    Alert(title: Text("Some field are empty"), message: Text("Fill them before saving!"), dismissButton: .default(Text("OK")))
            })
                .sheet(isPresented: self.$isImagePickerShown) {
                    ImagePicker(pickedPhoto: self.$pickedImage, isCamera: self.$isCamera)
            }
            .alert(isPresented: self.$isDeleteImage) {
                Alert(title: Text("Deleting image"), message: Text("Do you want to delete image?"), primaryButton: .destructive(Text("Delete")) {
                self.deleteImage()
                }, secondaryButton: .default(Text("Cancel"))
            )}
        }
        
    }
    
    func saveItem() {
        if self.title != "" && self.genre != "" {
            self.ShowingEmptyFieldsAlert = false
            self.book.title = self.title
            self.book.author = self.author
            self.book.genre = self.genre
            
            if self.wasSeen == true {
                self.book.rating = Int16(self.rating)
                self.book.review = self.review
            }
            else if self.wasSeen == false {
                self.book.rating = Int16(0)
                self.book.review = nil
            }
            
            self.book.seen = self.wasSeen
            
            if self.wantToDeletePhoto == true {
                self.book.deletePhoto()
            }
            
            if pickedImage != nil {
                self.book.deletePhoto()
                self.book.savePhoto(image: self.pickedImage!)
            }
            
            try? self.moc.save()
            
            self.presentationMode.wrappedValue.dismiss()
        }
        else {
            self.ShowingEmptyFieldsAlert = true
        }
    }
    
    func deleteImage() {
        if pickedImage != nil {
            pickedImage = nil
        }
        if book.isCustomImage == true {
            self.wantToDeletePhoto = true
        }
    }
}

struct EditBookViewPreviews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test Movie"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "Good movie"
        //book.productionYear = 2019
        
        return NavigationView {
            EditBookView(book: book)
        }
    }
}
