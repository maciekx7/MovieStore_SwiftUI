//
//  SeenMoviesStats.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 02/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import SwiftUI

struct SeenSeriesStats: View {
    @FetchRequest(entity: Series.entity(), sortDescriptors: [], predicate: NSPredicate(format: "seen == %@", NSNumber(value: true))) var series: FetchedResults<Series>
    let genres = ["Sci-Fi","Fantasy", "Comedy", "Horror", "Thriller", "Criminal", "Kids", "Romance", "Drama"].sorted()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack{
                    Text("Seen: \(self.series.count)")
                    Text("Time of watching: \(self.wholeWatchingTime())h")
                    ForEach(self.whichGenres(array: self.genres), id:\.self) {genre in
                        HStack {
                            Text("\(self.howManySeen(genre: genre))")
                            Text(genre)
                            if self.howManySeen(genre: genre) == 1 {
                               Text("serie")
                            }
                            else {
                                Text("Series")
                            }
                        }
                    .frame(width: geometry.size.width-20, height: 40)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [.yellow, .green]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(40)
                    .padding()
                        
                    }
                }
            }
        }
        .navigationBarTitle(Text("Series"))
    }
    
    func whichGenres(array: [String]) -> [String] {
        let genres = array
        var goodArray = [String]()
        var number: Int = 0
        for genre in genres {
            for serie in series {
                if serie.genre == genre {
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
        
        for serie in series {
            if serie.genre == genre {
                howMany = howMany + 1
            }
        }
        return howMany
    }
    
    func wholeWatchingTime() -> String {
        var time: Float = 0
        for element in series {
            time = time + (Float(element.durationOfEpisode) * Float(element.episodes))
        }
        let Time = time/60
        if Time == Float(Int(Time)) {
            return String(Int(Time))
        }
        else {
            return String(Time)
        }
    }
}

