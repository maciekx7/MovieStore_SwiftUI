//
//  DetailMovieView.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 11/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailSeriesView: View {
    let series: Series
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    @State private var showingEditScreen = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    
                    HStack {
                        Text(self.series.title ?? "Unknown Title")
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
                        if self.series.isCustomImage == false {
                            Image(self.series.genre ?? "Fantasy")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: geometry.size.width, height: 250.0)
                            .clipShape(Rectangle())
                            .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                            .shadow(radius: 10)
                        }
                        else {
                            Image(uiImage: self.series.getPhoto()!)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: geometry.size.width, height: 250.0)
                            .clipShape(Rectangle())
                            .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                            .shadow(radius: 10)
                        }
                        
                        
                        Text(self.series.genre?.uppercased() ?? "FANTASY")
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Capsule())
                            .offset(x: -5, y: -5)
                    }
                    
                    Text("Producent: \(self.isThereProducent(producent: self.series.producent ?? "Unknown producent"))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    VStack {
                        Text("Number of episodes: \(Int(self.series.episodes))")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        Text("Duration of one episode: \(Int(self.series.durationOfEpisode))")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Text("")
                        
                        
                    }
                    if self.series.seen == true {
                        Text("You've spent \(self.series.timeOfWatchingInString())h on watching \(self.series.title ?? "Unknown")")
                        
                        VStack {
                            Text("reviev:")
                                .foregroundColor(.secondary)
                                .font(.caption)
                                .padding(.top, 15.0)
                            Text(self.series.review ?? "No review")
                                .padding(.bottom, 5.0)
                        }
                        RatingView(rating: .constant(Int(self.series.rating)))
                        .font(.largeTitle)
                    }
                    Spacer()
                    
                    
                }
            }
            .alert(isPresented: self.$showingDeleteAlert) {
                Alert(title: Text("Delete Series"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                    self.deleteSeries()
                    }, secondaryButton: .cancel()
                )
            }
        }
            .sheet(isPresented: $showingEditScreen) {
                EditSeriesView(series: self.series).environment(\.managedObjectContext, self.moc)
        }
    }
    
    func deleteSeries() {
        series.deletePhoto()
        moc.delete(series)
        try? moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
    
    
    func isThereProducent(producent: String) -> String {
        if producent != "" {
            return producent
        }
        else {
            return "Unknown"
        }
    }
}

struct DetailSeriesView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let series = Series(context: moc)
        series.title = "Test Movie"
        series.producent = "Test producent"
        series.genre = "Fantasy"
        series.rating = 4
        series.review = "Good movie"
        //series.productionYear = 2019
        series.episodes = 8
        series.durationOfEpisode = 60
        
        return NavigationView {
            DetailSeriesView(series: series)
        }
    }
}
