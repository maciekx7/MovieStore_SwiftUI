//
//  FilteredMovies.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 05/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import SwiftUI

struct FilteredMovies: View {
    @Environment(\.managedObjectContext) var moc
    var searchText: String
    var fetchRequest: FetchRequest<Movie>
    var movies: FetchedResults<Movie> { fetchRequest.wrappedValue }
    var wasSeen: Bool
    
    init(filter: Bool, searchText: String) {
        let predicate = NSPredicate(format: "seen == %@", NSNumber(value: filter))
        fetchRequest = FetchRequest<Movie>(entity: Movie.entity(), sortDescriptors: [], predicate: predicate)
        self.wasSeen = filter
        self.searchText = searchText
    }
    var body: some View {
        List {
            ForEach(movies.filter{$0.containsWithLovercased(searchText) || searchText == ""}, id: \.self) { movie in
                NavigationLink(destination: DetailMovieView(movie: movie)) {
                    EmojiRatingView(rating: movie.rating)
                        .font(.largeTitle)
                    VStack(alignment: .leading) {
                        Text(movie.title ?? "Unknown Title")
                            .font(.headline)
                        Text(movie.director ?? "Unknown Director")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onDelete(perform: deleteMovie)
        }
    }
    
    func deleteMovie(at offsets: IndexSet) {
        for offset in offsets {
            
            let movie = movies[offset]
            
            movie.deletePhoto()
            
            moc.delete(movie)
        }
        try? moc.save()
    }
}


