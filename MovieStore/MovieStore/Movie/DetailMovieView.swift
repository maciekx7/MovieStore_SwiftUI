//
//  DetailMovieView.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 11/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailMovieView: View {
    let movie: Movie
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    @State private var showingEditScreen = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    
                    HStack {
                        Text(self.movie.title ?? "Unknown Movie")
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            self.showingEditScreen.toggle()
                        }) {
                            Image(systemName: "pencil")
                                .imageScale(.large)
                                .padding()
                            
                        }
                        
                        Button(action: {
                            self.showingDeleteAlert = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(Color.red)
                        }
                    }
                    
                    
                    
                    ZStack(alignment: .bottomTrailing) {
                        if self.movie.isCustomImage == false {
                            Image(self.movie.genre ?? "Fantasy")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: geometry.size.width, height: 250.0)
                            .clipShape(Rectangle())
                            .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                            .shadow(radius: 10)
                        }
                        else {
                            Image(uiImage: self.movie.getPhoto()!)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: geometry.size.width, height: 250.0)
                            .clipShape(Rectangle())
                            .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                            .shadow(radius: 10)
                        }
                        
                        
                        Text(self.movie.genre?.uppercased() ?? "FANTASY")
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Capsule())
                            .offset(x: -5, y: -5)
                    }
                    
                    Text("Director: \(self.isThereDirector(director: self.movie.director ?? "Unknown director"))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Year of Production: \(self.YearOfProduction(year: self.movie.productionYear))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    
                    if self.movie.seen == true {
                        Text(self.movie.review ?? "No review")
                            .padding()
                        
                        RatingView(rating: .constant(Int(self.movie.rating)))
                            .font(.largeTitle)
                    }
                    
                    
                    Spacer()
                    
                    
                }
            }
            .alert(isPresented: self.$showingDeleteAlert) {
                Alert(title: Text("Delete Movie"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                    self.deleteMovie()
                    }, secondaryButton: .cancel()
                )
            }
        }
            .sheet(isPresented: $showingEditScreen) {
                EditMovieView(movie: self.movie).environment(\.managedObjectContext, self.moc)
        }
    }
    
    func deleteMovie() {
        movie.deletePhoto()
        moc.delete(movie)
        try? moc.save()
            
        presentationMode.wrappedValue.dismiss()
    }
    
    func YearOfProduction(year: Int16) -> String {
        if Int(year) != 0 {
            return String(year)
        }
        else {
            return "Unknown"
        }
    }
    
    func isThereDirector(director: String) -> String {
        if director != "" {
            return director
        }
        else {
            return "Unknown"
        }
    }
}

struct DetailMovieView_Previews: PreviewProvider {
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
            DetailMovieView(movie: movie)
        }
    }
}
