
import SwiftUI
import UIKit


struct AddSeriesView: View {
    init() {
        self._genre = State(initialValue: "Fantasy")
        self._rating = State(initialValue: 3)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
   // @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    
    @State private var title = ""
    @State private var producent = ""
    @State private var review = ""
    @State private var genre = ""
    @State private var rating: Int
    @State private var durationOfEpisode = ""
    @State private var episodes = ""
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
                    TextField("Serie's title", text: $title)
                    
                    TextField("Producent", text: $producent)
                    
                    TextField("Number of episodes in series", text: $episodes)
                        .keyboardType(.numberPad)
                    TextField("Aproximate duration of one episode (min)", text: $durationOfEpisode)
                        .keyboardType(.numberPad)
                }
                Section {
                    HStack {
                        Toggle(isOn: $wasSeen) {
                            Text("Seen")
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
            .navigationBarTitle("Add Series")
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
        if self.title != "" && self.genre != "" && self.episodes != "" &&  self.durationOfEpisode != "" && Int(self.durationOfEpisode) != nil && Int(self.episodes) != nil{
            
            self.ShowingEmptyFieldsAlert = false
            
            let newSeries = Series(context: self.moc)
            newSeries.id = UUID()
            //let imageName = newSeries.id!.uuidString
            newSeries.title = self.title
            newSeries.producent = self.producent
            if self.wasSeen == true {
                newSeries.rating = Int16(self.rating)
            } else if self.wasSeen == false{
                newSeries.rating = Int16(0)
            }
            
            newSeries.addingDate = Date()
            newSeries.seen = self.wasSeen
            newSeries.review = self.review
            newSeries.genre = self.genre
            newSeries.episodes = Int16(self.episodes) ?? Int16(0)
            newSeries.durationOfEpisode = Int16(self.durationOfEpisode) ?? Int16(0)
            
            if image != nil {
                newSeries.savePhoto(image: self.image!)
                /*
                ImageToDirectory().saveImageToDocumentDirectory(image: self.image!, filename: imageName)
                newSeries.isCustomImage = true
                 */
            }
            
            
            
            try? self.moc.save()
            self.presentationMode.wrappedValue.dismiss()
        }
        else {
            self.ShowingEmptyFieldsAlert = true
        }
    }
}

struct AddSeriesView_Previews: PreviewProvider {
    static var previews: some View {
        AddSeriesView()
    }
}
