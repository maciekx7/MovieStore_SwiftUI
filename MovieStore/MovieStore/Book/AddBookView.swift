
import SwiftUI

struct AddBookView: View {
    init() {
        self._genre = State(initialValue: "Fantasy")
        self._rating = State(initialValue: 3)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    
    @State private var title = ""
    @State private var author = ""
    @State private var review = ""
    @State private var genre = ""
    @State private var rating: Int
    @State private var wasSeen = true
    
    @State private var image: UIImage?
    @State private var isImagePickerShown = false
    @State private var isCamera = false

    @State private var ShowingEmptyFieldsAlert = false
    
    let genres = ["Sci-Fi","Fantasy", "Comedy", "Horror", "Thriller", "Criminal", "Kids", "Romance", "Drama"]
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title of book", text: $title)
                    TextField("Author's name", text: $author)
                }
                Section {
                    HStack {
                        Toggle(isOn: $wasSeen) {
                            Text("Read")
                        }
                    }
                    if wasSeen == true {
                        
                        HStack() {
                            Text("review")
                                .foregroundColor(Color.gray)
                            Spacer()
                            TextField("Write a review", text: $review)
                        }
                        VStack {
                            RatingView(rating: $rating)
                        }
                    }
                    
                }
                
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(0.75, contentMode: .fit)
                        .scaledToFill()
                        //.frame(width: 250, height: 250.0)
                }
                Button("Select Image") {
                    self.isImagePickerShown = true
                }
                
                Section {
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .navigationBarTitle("Add Book")
            .navigationBarItems(leading:
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
                , trailing: Button("Save") {
                    self.saveItem()
                }
                .alert(isPresented: $ShowingEmptyFieldsAlert) {
                    Alert(title: Text("Some field are empty"), message: Text("Fill them before saving!"), dismissButton: .default(Text("OK")))
            })
            .sheet(isPresented: $isImagePickerShown) {
                ImagePicker(pickedPhoto: self.$image, isCamera: self.$isCamera)
            }
        }
    }
    
    func saveItem() {
        if self.title != "" && self.genre != "" {
            self.ShowingEmptyFieldsAlert = false
            
            let newBook = Book(context: self.moc)
            newBook.id = UUID()
            newBook.title = self.title
            newBook.author = self.author
            if self.wasSeen == true {
                newBook.rating = Int16(self.rating)
            } else if self.wasSeen == false{
                newBook.rating = Int16(0)
            }
            newBook.seen = self.wasSeen
            newBook.genre = self.genre
            newBook.review = self.review
            newBook.addingDate = Date()
            
            if image != nil {
                newBook.savePhoto(image: self.image!)
                //ImageToDirectory().saveImageToDocumentDirectory(image: self.image!, filename: imageName)
                //newBook.isCustomImage = true
            }
            
            try? self.moc.save()
            self.presentationMode.wrappedValue.dismiss()
        }
        else {
            self.ShowingEmptyFieldsAlert = true
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
