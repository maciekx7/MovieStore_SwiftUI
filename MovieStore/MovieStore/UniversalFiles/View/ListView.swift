//
//  ListView.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 11/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//

import SwiftUI
import CoreData

struct ListView: View {
    @Environment(\.managedObjectContext) var moc
    @State var viewType: String
    
    @State private var showingAddMovieScreen = false
    @State private var showingAddBookScreen = false
    @State private var showingAddSeriesScreen = false
    @State private var isActionSheet = false
    @State private var isSheet = false
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    @State private var wasSeen:Bool  = true
    
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: self.$searchText, showCancelButton: self.$showCancelButton)
                
                Toggle(isOn: $wasSeen) {
                    if viewType == "Books" {
                        Text("Read")
                    } else {
                        Text("Seen")
                    }
                    
                }
                    .padding(.trailing)
                    .padding(.leading)
                
                if viewType == "Movies" {
                    FilteredMovies(filter: wasSeen, searchText: searchText)
                } else if viewType == "Books" {
                    FilteredBooks(filter: wasSeen, searchText: searchText)
                } else if viewType == "Series" {
                    FilteredSeries(filter: wasSeen, searchText: searchText)
                }
            }
            //.resignKeyboardOnDragGesture()
            .navigationBarTitle("\(viewType) Store")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.isActionSheet.toggle()
            }) {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .padding()
            })
                .actionSheet(isPresented: $isActionSheet, content: {
                    ActionSheet(title: Text("Add to liblary"), message: Text("Chose what do you want to add"), buttons: [
                        .default(Text("Add Movie"), action: {
                            self.showingAddBookScreen = false
                            self.showingAddMovieScreen = true
                            self.showingAddSeriesScreen = false
                            self.isSheet = true
                        }),
                        .default(Text("Add Book"), action: {
                            self.showingAddMovieScreen = false
                            self.showingAddBookScreen = true
                            self.showingAddSeriesScreen = false
                            self.isSheet = true
                        }),
                        .default(Text("Add Serie"), action: {
                            self.showingAddMovieScreen = false
                            self.showingAddBookScreen = false
                            self.showingAddSeriesScreen = true
                            self.isSheet = true
                        }),
                        .destructive(Text("Cancel"))
                    ])
                })
                
                .sheet(isPresented: $isSheet) {
                    if self.showingAddMovieScreen == true {
                        AddMovieView().environment(\.managedObjectContext, self.moc)
                    }
                    else if self.showingAddBookScreen == true {
                        AddBookView().environment(\.managedObjectContext, self.moc)
                    }
                    else if self.showingAddSeriesScreen == true {
                        AddSeriesView().environment(\.managedObjectContext, self.moc)
                    }
            }
        }
    }
}





