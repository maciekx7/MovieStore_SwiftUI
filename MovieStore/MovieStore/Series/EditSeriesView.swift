//
//  EditMovieVIew.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 11/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//

import SwiftUI
import CoreData

struct EditSeriesView: View {
    var series: Series
    
    init(series: Series) {
        self.series = series
        self._title = State(initialValue: series.title ?? "")
        self._producent = State(initialValue: series.producent ?? "")
        self._review = State(initialValue: series.review ?? "")
        self._rating = State(initialValue: Int(series.rating))
        self._genre = State(initialValue: series.genre ?? "")
        self._episodes = State(initialValue: String(series.episodes))
        self._durationOfEpisode = State(initialValue: String(series.durationOfEpisode))
        self._wasSeen = State(initialValue: series.seen)
    }
    
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @State private var title: String
    @State private var producent: String
    @State private var review: String
    @State private var genre: String
    @State private var rating: Int
    @State private var episodes: String
    @State private var durationOfEpisode: String
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
                        Text("Producnet:")
                            .foregroundColor(.gray)
                        Spacer()
                        TextField("Producent", text: $producent)
                    }
                    
                }
                Section {
                    VStack(alignment: .leading) {
                        Text("Number of episodes in series:")
                            .foregroundColor(Color.gray)
                        TextField("Number of episodes in series", text: $episodes)
                            .keyboardType(.numberPad)
                        Text("Aproximate duration of one episode (min):")
                            .foregroundColor(Color.gray)
                        TextField("Aproximate duration of one episode (min)", text: $durationOfEpisode)
                            .keyboardType(.numberPad)
                    }
                }
                Section {
                    HStack {
                        Toggle(isOn: $wasSeen) {
                            Text("Seen")
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
                    if pickedImage == nil {
                        if self.series.isCustomImage == true && self.wantToDeletePhoto == false{
                            Image(uiImage: self.series.getPhoto()!)
                                .resizable()
                                .renderingMode(.original)
                                .aspectRatio(0.75, contentMode: .fit)
                                .scaledToFill()
                            Button("Delete Image") {
                                self.isDeleteImage = true
                            }.foregroundColor(.red)
                        }
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
            .navigationBarTitle("Edit Series")
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
        if self.title != "" && self.genre != "" && self.episodes != "" &&  self.durationOfEpisode != "" && Int(self.durationOfEpisode) != nil && Int(self.episodes) != nil && self.rating != 0{
            
            self.ShowingEmptyFieldsAlert = false
            
            self.series.title = self.title
            self.series.producent = self.producent
            if self.wasSeen == true {
                self.series.rating = Int16(self.rating)
                self.series.review = self.review
            }
            else if self.wasSeen == false {
                self.series.rating = Int16(0)
                self.series.review = nil
            }
           
            self.series.seen = self.wasSeen
            self.series.genre = self.genre
            
            self.series.episodes = Int16(self.episodes) ?? Int16(0)
            self.series.durationOfEpisode = Int16(self.durationOfEpisode) ?? Int16(0)
            
            if self.wantToDeletePhoto == true {
                self.series.deletePhoto()
            }
            
            if pickedImage != nil {
                self.series.deletePhoto()
                self.series.savePhoto(image: self.pickedImage!)
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
        if series.isCustomImage == true {
            self.wantToDeletePhoto = true
        }
    }
}

struct EditSeriesViewPreviews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let series = Series(context: moc)
        series.title = "Test Movie"
        series.producent = "Netflix"
        series.genre = "Fantasy"
        series.rating = 4
        series.review = "Good series"
        series.episodes = 8
        series.durationOfEpisode = 60
        
        return NavigationView {
            EditSeriesView(series: series)
        }
    }
}
