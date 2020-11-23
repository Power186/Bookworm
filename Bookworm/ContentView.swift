//
//  ContentView.swift
//  Bookworm
//
//  Created by Scott on 11/21/20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Book.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true),NSSortDescriptor(keyPath: \Book.author, ascending: true)])
    var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)
                        
                        VStack(alignment: .leading) {
                            Text(book.title ?? "Unknown title")
                                .font(.headline)
                            Text(book.author ?? "Unknown author")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Bookworm")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                showingAddScreen.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddScreen, content: {
                AddBookView().environment(\.managedObjectContext, moc)
            })
        }
        
    } // body
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in the fetch request
            let book = books[offset]
            
            // delete it from the context
            moc.delete(book)
            
            // save the context
            try? moc.save()
        }
    }
    
} // struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
