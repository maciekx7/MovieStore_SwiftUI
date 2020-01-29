//
//  DetailMovieView.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 11/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailBookView: View {
    let book: Book
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    @State private var showingEditScreen = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    
                    HStack {
                        Text(self.book.title ?? "Unknown Movie")
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
                        if self.book.isCustomImage == false {
                            Image(self.book.genre ?? "Fantasy")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: geometry.size.width, height: 250.0)
                            .clipShape(Rectangle())
                            .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                            .shadow(radius: 10)
                        }
                        else {
                            Image(uiImage: self.book.getPhoto()!)
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: geometry.size.width, height: 250.0)
                                .clipShape(Rectangle())
                                .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                                .shadow(radius: 10)
                        }
                        
                        
                        Text(self.book.genre?.uppercased() ?? "FANTASY")
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Capsule())
                            .offset(x: -5, y: -5)
                    }
                    
                    Text("Author: \(self.isThereAuthor(author: self.book.author ?? "Unknown director"))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if self.book.seen == true {
                        Text(self.book.review ?? "No review")
                            .padding()
                        
                        RatingView(rating: .constant(Int(self.book.rating)))
                            .font(.largeTitle)
                    }
                    
                    Spacer()
                }
            }
            .alert(isPresented: self.$showingDeleteAlert) {
                Alert(title: Text("Delete Movie"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                    self.deleteBook()
                    }, secondaryButton: .cancel()
                )
            }
        }
            
            .sheet(isPresented: $showingEditScreen) {
                EditBookView(book: self.book).environment(\.managedObjectContext, self.moc)
        }
    }
    
    func deleteBook() {
        book.deletePhoto()
        moc.delete(book)
        try? moc.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    func isThereAuthor(author: String) -> String {
        if author != "" {
            return author
        }
        else {
            return "Unknown"
        }
    }
}

struct DetailBookView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test Movie"
        book.author = "Test director"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "Good movie"
        //book.productionYear = 2019
        
        return NavigationView {
            DetailBookView(book: book)
        }
    }
}
