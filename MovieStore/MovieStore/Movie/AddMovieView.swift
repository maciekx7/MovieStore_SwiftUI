
import SwiftUI

struct AddMovieView: View {
    init() {
        self._genre = State(initialValue: "Fantasy")
        self._rating = State(initialValue: 3)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    
    @State private var title = ""
    @State private var director = ""
    @State private var review = ""
    @State private var genre = ""
    @State private var rating: Int
    @State private var productionYear = ""
    @State private var currentYear = Int(Calendar.current.component(.year, from: Date()))
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
                    TextField("Name of movie", text: $title) 
                    TextField("Director's name", text: $director)
                }
                Section {
                    TextField("Production Year", text: $productionYear)
                        .keyboardType(.numberPad)
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
            .navigationBarTitle("Add Movie")
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
            self.ShowingEmptyFieldsAlert = false && (Int(self.productionYear) != nil || self.productionYear == "")
            
            let newMovie = Movie(context: self.moc)
            newMovie.id = UUID()
            newMovie.title = self.title
            newMovie.director = self.director
            if self.wasSeen == true {
                newMovie.rating = Int16(self.rating)
            } else if self.wasSeen == false{
                newMovie.rating = Int16(0)
            }
            newMovie.seen = self.wasSeen
            newMovie.review = self.review
            newMovie.genre = self.genre
            newMovie.productionYear = Int16(self.productionYear) ?? Int16(0)
            newMovie.addingDate = Date()
            
            if image != nil {
                newMovie.savePhoto(image: self.image!)
            }
            
            try? self.moc.save()
            self.presentationMode.wrappedValue.dismiss()
        }
        else {
            self.ShowingEmptyFieldsAlert = true
        }
    }
}

struct AddMovieView_Previews: PreviewProvider {
    static var previews: some View {
        AddMovieView()
    }
}
