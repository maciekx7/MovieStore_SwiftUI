//
//  SeriesWantsView.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 03/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import SwiftUI

struct SeriesWantsView: View {
    @FetchRequest(entity: Series.entity(), sortDescriptors: [], predicate: NSPredicate(format: "seen == %@", NSNumber(value: false))) var series: FetchedResults<Series>
    let genres = ["Sci-Fi","Fantasy", "Comedy", "Horror", "Thriller", "Criminal", "Kids", "Romance", "Drama"].sorted()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Wants to see \(self.series.count) series")
                    .font(.system(size: 28))
                    .bold()
                    .padding()
                Text("It will take you \(self.howMutchTime(genre: nil))h")
                    .font(.system(size: 24))
                    .bold()
                    .padding()
                
                    ForEach(self.whichGenres(array: self.genres), id:\.self) {genre in
                        HStack {
                            Text("\(self.howManySeen(genre: genre))")
                            Text(genre)
                            Text("series")
                            }
                        .frame(width: geometry.size.width-20, height: 40)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [.blue, .gray]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(40)
                        .padding()
                        
                    }
            }
        }
    }
    
    func howManySeen(genre: String) -> Int {
        var howMany: Int = 0
            
            for movie in series {
                if movie.genre == genre {
                    howMany = howMany + 1
                }
            }
            return howMany
    }
    
    func howMutchTime(genre: String?) -> Float {
        var time: Float = 0
        var tmp: Float = 0
        for serie in series {
            if genre == nil {
                tmp = Float(serie.durationOfEpisode)/60 * Float(serie.episodes)
                time = time + tmp
            }
            else {
                if serie.genre == genre {
                    tmp = Float(serie.durationOfEpisode) * Float(serie.episodes)
                    time = time + tmp
                }
            }
        }
        if time == Float(Int(time)) {
            return Float(Int(time))
        } else {
            return time
        }
    }
    func howMutchOfGenre(genre: String) -> Int {
        var howMany: Int = 0
        
        for serie in series {
            if serie.genre == genre {
                howMany = howMany + 1
            }
        }
        return howMany
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
    
}
struct SeriesWantsView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesWantsView()
    }
}
