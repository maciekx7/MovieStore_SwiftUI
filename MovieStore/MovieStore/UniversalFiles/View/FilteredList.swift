//
//  FilteredList.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 02/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, Content: View>: View {
    @Environment(\.managedObjectContext) var moc
    var fetchRequest: FetchRequest<T>
    var objects: FetchedResults<T> { fetchRequest.wrappedValue }
    var wasSeen: Bool
    let content: (T) -> Content
    
    init(filter: Bool, @ViewBuilder content: @escaping (T) -> Content) {
        let predicate = NSPredicate(format: "seen == %@", NSNumber(value: filter))
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [], predicate: predicate)
        self.wasSeen = filter
        self.content = content
    }
    
    var body: some View {
        List() {
            /*
            if self.wasSeen == true {
                HStack(alignment: .center) {
                    Spacer()
                    Text("You've spent \(wholeWatchingTime())h on watching series")
                    Spacer()
                }
            }*/
            ForEach(objects, id: \.self) { object in
                self.content(object)
                /*NavigationLink(destination: DetailSeriesView(series: serie)) {
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
                        Text("\(self.howMuchTime(serie: serie))h")
                            .foregroundColor(.secondary)
                    }
                }*/
                
            }
                
            .onDelete(perform: deleteSeries)
        }
    }
    
    func howMuchTime(serie: Series) -> String{
        let time: Float = Float(serie.durationOfEpisode)
        let episodes: Int = Int(serie.episodes)
        
        let howMuch: Float = Float(time / 60) * Float(episodes)
        
        if howMuch > 0
        {
            if howMuch == Float(Int(howMuch)) {
                return String(Int(howMuch))
            }
            else {
                return String(howMuch)
            }
        }
        else {
            return "-"
        }
    }
    
    func deleteSeries(at offsets: IndexSet) {
        for offset in offsets {
            
            let object = objects[offset]
            
            if ((object as? Movie) != nil) {
                ImageToDirectory().deleteItemInDirectory(imageName: (object as! Movie).id!.uuidString)
            } else {
                print("bazyleo")
            }
            /*if object.isCustomImage == true {
                ImageToDirectory().deleteItemInDirectory(imageName: object.id.uuidString)
            }*/
            
            moc.delete(object)
        }
        try? moc.save()
    }
    /*
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
    }*/
}


