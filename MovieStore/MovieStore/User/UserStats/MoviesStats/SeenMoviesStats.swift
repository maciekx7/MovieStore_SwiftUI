//
//  SeenMoviesStats.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 02/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import SwiftUI

struct SeenMoviesStats: View {
    @FetchRequest(entity: Movie.entity(), sortDescriptors: [], predicate: NSPredicate(format: "seen == %@", NSNumber(value: true))) var movies: FetchedResults<Movie>
    let genres = ["Sci-Fi","Fantasy", "Comedy", "Horror", "Thriller", "Criminal", "Kids", "Romance", "Drama"].sorted()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack{
                    Text("Seen \(self.movies.count)")
                    ForEach(self.whichGenres(array: self.genres), id:\.self) {genre in
                        HStack {
                            Text("\(self.howManySeen(genre: genre))")
                            Text(genre)
                            if self.howManySeen(genre: genre) == 1 {
                               Text("movie")
                            }
                            else {
                                Text("Movies")
                            }
                        }
                    .frame(width: geometry.size.width-20, height: 40)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(40)
                    .padding()
                        
                    }
                }
            }
        }
        .navigationBarTitle(Text("Movies"))
    }
    
    func whichGenres(array: [String]) -> [String] {
        let genres = array
        var goodArray = [String]()
        var number: Int = 0
        for genre in genres {
            for movie in movies {
                if movie.genre == genre {
                    number = number + 1
                }
            }
            if number > 0 {
                goodArray.append(genre)
            }
            number = 0
        }
        return goodArray
    }
    
    func howManySeen(genre: String) -> Int {
        var howMany: Int = 0
        
        for movie in movies {
            if movie.genre == genre {
                howMany = howMany + 1
            }
        }
        return howMany
    }
}

struct SeenMoviesStats_Previews: PreviewProvider {
    static var previews: some View {
        SeenMoviesStats()
    }
}
