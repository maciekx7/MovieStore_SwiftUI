//
//  UserStatsView.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 29/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//

import SwiftUI

struct UserStatsView: View {
    @FetchRequest(entity: Series.entity(), sortDescriptors: []) var series: FetchedResults<Series>
    @FetchRequest(entity: Book.entity(), sortDescriptors: []) var books: FetchedResults<Book>
    @FetchRequest(entity: Movie.entity(), sortDescriptors: []) var movies: FetchedResults<Movie>
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    NavigationLink(destination: SeenMoviesStats()) {
                        VStack {
                            Text("Movies")
                                .font(.system(size: 35))
                                .bold()
                            HStack {
                                Text("Seen")
                                Text("\(self.seenMovies(seen: true))")
                                //.foregroundColor(Color.red)
                                Text("movies")
                            }
                        }
                        .frame(width: geometry.size.width/2 - 25, height: geometry.size.height/2 - 20)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(40)
                        .padding()
                    }
                    
                    
                    Spacer()
                    NavigationLink(destination: SeenSeriesStats()) {
                        VStack {
                            Text("Series")
                                .font(.system(size: 35))
                                .bold()
                            HStack {
                                Text("Seen")
                                Text("\(self.seenSeries(seen: true))")
                                //.foregroundColor(Color.red)
                                Text("series")
                            }
                        }
                        .frame(width: geometry.size.width/2 - 25, height: geometry.size.height/2 - 20)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [.yellow, .green]), startPoint: .top, endPoint: .bottom))
                            //.background(Color.blue)
                            .cornerRadius(40)
                            .padding()
                    }
                    
                    
                    
                }
                Spacer()
                
                HStack {
                    NavigationLink(destination: SeenBooksStats()) {
                        VStack {
                            Text("Books")
                                .font(.system(size: 35))
                                .bold()
                            HStack {
                                Text("Read")
                                Text("\(self.readBooks(seen: true))")
                                //.foregroundColor(Color.red)
                                Text("books")
                            }
                        }
                        .frame(width: geometry.size.width/2 - 25, height: geometry.size.height/2 - 20)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [.red, .yellow]), startPoint: .top, endPoint: .bottom))
                            //.background(Color.blue)
                            .cornerRadius(40)
                            .padding()
                    }
                    
                    
                    
                    Spacer()
                    NavigationLink(destination: WantsToSeeHomeView()) {
                        VStack {
                            Text("WANTS TO")
                                .font(.system(size: 35))
                                .bold()
                            HStack {
                                Text("See")
                                Text("\(self.seenMovies(seen: false))")
                                //.foregroundColor(Color.red)
                                Text("movies")
                            }
                            HStack {
                                Text("See")
                                Text("\(self.seenSeries(seen:false))")
                                //.foregroundColor(Color.red)
                                Text("series")
                            }
                            HStack {
                                Text("Read")
                                Text("\(self.readBooks(seen: false))")
                                //.foregroundColor(Color.red)
                                Text("books")
                            }
                        }
                        .frame(width: geometry.size.width/2 - 25, height: geometry.size.height/2 - 20)
                        .background(LinearGradient(gradient: Gradient(colors: [.blue, .gray]), startPoint: .top, endPoint: .bottom))
                        .foregroundColor(.white)
                            // .background(Color.blue)
                            .cornerRadius(40)
                            .padding()
                    }
                    
                    
                }
                .navigationBarTitle(Text("Stats"))
            }
            
        }
        
    }
    func seenSeries(seen: Bool) -> Int {
        var howManySeen: Int = 0
        for serie in series {
            if serie.seen == seen {
                howManySeen = howManySeen + 1
            }
        }
        return howManySeen
    }
    
    func seenMovies(seen: Bool) -> Int {
        var howManySeen: Int = 0
        for movie in movies {
            if movie.seen == seen {
                howManySeen = howManySeen + 1
            }
        }
        return howManySeen
    }
    
    func readBooks(seen: Bool) -> Int {
        var howManySeen: Int = 0
        for book in books {
            if book.seen == seen {
                howManySeen = howManySeen + 1
            }
        }
        return howManySeen
    }
    
    
}

struct UserStatsView_Previews: PreviewProvider {
    static var previews: some View {
        UserStatsView()
    }
}
