//
//  FilteredBooks.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 05/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import SwiftUI

struct FilteredBooks: View {
    @Environment(\.managedObjectContext) var moc
    var searchText: String
    var fetchRequest: FetchRequest<Book>
    var books: FetchedResults<Book> { fetchRequest.wrappedValue }
    var wasSeen: Bool
    
    init(filter: Bool, searchText: String) {
        let predicate = NSPredicate(format: "seen == %@", NSNumber(value: filter))
        fetchRequest = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [], predicate: predicate)
        self.wasSeen = filter
        self.searchText = searchText
    }
    
    
    var body: some View {
        List {
            ForEach(books.filter{$0.containsWithLovercased(searchText) || searchText == ""}, id: \.self) { book in
                NavigationLink(destination: DetailBookView(book: book)) {
                    EmojiRatingView(rating: book.rating)
                        .font(.largeTitle)
                    VStack(alignment: .leading) {
                        Text(book.title ?? "Unknown Title")
                            .font(.headline)
                        Text(book.author ?? "Unknown Author")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onDelete(perform: deleteBook)
        }
    }
    
    func deleteBook(at offsets: IndexSet) {
        for offset in offsets {
            
            let book = books[offset]
            
            book.deletePhoto()
            
            moc.delete(book)
        }
        try? moc.save()
    }
}




