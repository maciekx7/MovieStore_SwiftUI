//
//  EditMovieVIew.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 11/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//

import SwiftUI
import CoreData

struct EditMovieView: View {
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        self._title = State(initialValue: movie.title ?? "")
        self._director = State(initialValue: movie.director ?? "")
        self._review = State(initialValue: movie.review ?? "")
        self._rating = State(initialValue: Int(movie.rating))
        self._genre = State(initialValue: movie.genre ?? "")
        self._productionYear = State(initialValue: String(movie.productionYear))
        self._wasSeen = State(initialValue: movie.seen)
    }
    
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @State private var title: String
    @State private var director: String
    @State private var review: String
    @State private var genre: String
    @State private var rating: Int
    @State private var productionYear: String
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
                        Text("Director:")
                            .foregroundColor(.gray)
                        Spacer()
                        TextField("Director", text: $director)
                    }
                    
                }
                
                
                Section {
                    HStack {
                        Text("Production Year")
                            .foregroundColor(.gray)
                        Spacer()
                        TextField("Production Year", text: $productionYear)
                            .keyboardType(.numberPad)
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
                    if pickedImage == nil && self.movie.isCustomImage == true && self.wantToDeletePhoto == false{
                        Image(uiImage: self.movie.getPhoto()!)
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
                
                Section {
                    RatingView(rating: $rating)
                    
                    
                }
            }
            .navigationBarTitle("Edit Movie")
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
            self.ShowingEmptyFieldsAlert = false && (Int(self.productionYear) != nil || self.productionYear == "")
            
            self.movie.title = self.title
            self.movie.director = self.director
            self.movie.genre = self.genre
            
            if self.wasSeen == true {
                 self.movie.rating = Int16(self.rating)
                 self.movie.review = self.review
             }
             else if self.wasSeen == false {
                 self.movie.rating = Int16(0)
                 self.movie.review = nil
             }
            
            self.movie.seen = self.wasSeen
            self.movie.productionYear = Int16(self.productionYear) ?? Int16(0)
            
            if self.wantToDeletePhoto == true {
                self.movie.deletePhoto()
            }
            
            if pickedImage != nil {
                self.movie.deletePhoto()
                self.movie.savePhoto(image: self.pickedImage!)
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
        if movie.isCustomImage == true {
            self.wantToDeletePhoto = true
        }
    }
    
}

struct EditMovieViewPreviews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let movie = Movie(context: moc)
        movie.title = "Test Movie"
        movie.director = "Test director"
        movie.genre = "Fantasy"
        movie.rating = 4
        movie.review = "Good movie"
        movie.productionYear = 2019
        
        return NavigationView {
            EditMovieView(movie: movie)
        }
    }
}
