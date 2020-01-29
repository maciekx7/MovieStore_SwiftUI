//
//  FilteredSeriesList.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 02/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import SwiftUI

struct FilteredSeries: View {
    @Environment(\.managedObjectContext) var moc
    var searchText: String
    var fetchRequest: FetchRequest<Series>
    var series: FetchedResults<Series> { fetchRequest.wrappedValue }
    var wasSeen: Bool
    
    init(filter: Bool, searchText: String) {
        let predicate = NSPredicate(format: "seen == %@", NSNumber(value: filter))
        fetchRequest = FetchRequest<Series>(entity: Series.entity(), sortDescriptors: [], predicate: predicate)
        self.wasSeen = filter
        self.searchText = searchText
    }
    
    var body: some View {
        List() {
            ForEach(series.filter{$0.containsWithLovercased(searchText) || searchText == ""}, id: \.self) { serie in
                NavigationLink(destination: DetailSeriesView(series: serie)) {
                    Button(action: {
                        print("link tapped")
                        
                    }) {
                        HStack {
                            EmojiRatingView(rating: serie.rating)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(serie.title ?? "Unknown Title")
                                    .font(.headline)
                                Text(serie.producent ?? "Unknown Producent")
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("\(serie.timeOfWatchingInString())h")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                }
                
            }
                
            .onDelete(perform: deleteSeries)
            
        }
        
    }
    
    
    
    func deleteSeries(at offsets: IndexSet) {
        for offset in offsets {
            
            let serie = series[offset]
            
            serie.deletePhoto()
            
            moc.delete(serie)
        }
        try? moc.save()
    }
}


