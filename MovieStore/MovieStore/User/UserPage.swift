//
//  UserPage.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 28/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//

import SwiftUI

struct UserPage: View {
    @FetchRequest(entity: Series.entity(), sortDescriptors: []) var series: FetchedResults<Series>
    @FetchRequest(entity: Book.entity(), sortDescriptors: []) var books: FetchedResults<Book>
    @FetchRequest(entity: Movie.entity(), sortDescriptors: []) var movies: FetchedResults<Movie>
    
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    
    @State private var stars = [1, 2, 3, 4, 5]
    @State private var image: UIImage?
    
    @State private var isPresented = false
    @State private var isDeleteAlertPresented = false
    
    
    func isUserThere() -> Bool {
        if user.isEmpty == true {
            return false
        }
        else {
            return true
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack{
                        Spacer()
                        if user.isEmpty == false {
                            Text("\(self.user[0].name!)")
                                .font(.system(size: 35))
                                .bold()
                        }
                        else {
                            Text("Name")
                                .font(.system(size: 35))
                                .bold()
                        }
                    }
                    
                    if user.isEmpty == false {
                        Image(uiImage: user[0].getPhoto())
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 330.0, height: 250.0)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 10)

                    }
                    else {
                        Circle()
                            .frame(width: 330.0, height: 250.0)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 10)
                    }
                    
                    VStack {
                        HStack {
                            Text("Age:")
                            Spacer()
                            Text("\(getAge())")
                        }
                    }
                    Spacer()
                    
                    if self.user.isEmpty == false {
                        VStack {
                            NavigationLink(destination: UserStatsView()) {
                                HStack {
                                    Image(systemName: "chart.bar.fill")
                                    Text("Stats")
                                }.frame(width: 200, height: 20)
                                
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(40)
                            .padding(.horizontal, 20)
                        }
                        
                    }
                    
                    
                }
            }
                
            .navigationBarTitle("You")
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        self.isPresented.toggle()
                    }) {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.large)
                            .padding()
                    }
                    .foregroundColor(.green)
                    
                    Button(action: {
                        if self.user.isEmpty == false {
                            self.isDeleteAlertPresented = true
                        }
                    }) {
                        Image(systemName: "trash")
                            .imageScale(.large)
                            .padding()
                    }
                    
                    
            })
                .sheet(isPresented: $isPresented) {
                    if self.user.isEmpty != false {
                        CreateUserView().environment(\.managedObjectContext, self.moc)
                    }
                    else {
                        EditUserView(user: self.user[0]).environment(\.managedObjectContext, self.moc)
                    }
            }
            .alert(isPresented: $isDeleteAlertPresented) {
                Alert(title: Text("Deleting User's info"), message: Text("Are you sure?"),primaryButton: .destructive(Text("Delete")) {
                    self.deleteUser()},
                      secondaryButton: .default(Text("Cancel")))
            }
        }
    }
    
    
    func deleteUser() {
        let keychain = KeychainSwift()
        keychain.delete("password")
        self.user[0].deletePhoto()
        self.moc.delete(self.user[0])
        try? self.moc.save()
    }
    
    func getAge() -> Int {
        if user.isEmpty == false {
            let yourYear: Int = Calendar.current.dateComponents([.year], from: user[0].birthday!).year!
            let yourMonth: Int = Calendar.current.dateComponents([.month], from: user[0].birthday!).month!
            let yourDay: Int = Calendar.current.dateComponents([.day], from: user[0].birthday!).day!


            let year: Int = Calendar.current.dateComponents([.year], from: Date()).year!
            let month: Int = Calendar.current.dateComponents([.month], from: Date()).month!
            let day: Int = Calendar.current.dateComponents([.day], from: Date()).day!
            
            var rYear = year - yourYear
            if yourMonth > month {
                rYear = rYear - 1
            } else if yourMonth == month {
                if yourDay > day {
                    rYear = rYear - 1
                }
            }
            return rYear
        }
        else {
            return 0
        }
    }
    
    func wholeWatchingSeriesTime() -> String {
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
    }
    
    func episodesOfSeriesWatched() -> Int {
        var episodes: Int = 0
        for element in series {
            episodes = episodes + Int(element.episodes)
        }
        return episodes
    }
    
    func allXStarEntertainment(stars: Int, serie: Bool = false, movie: Bool = false, book: Bool = false) -> Int {
        var maxStar: Int = 0
        if movie == false && book == false && serie == false {
            for element in series {
                if element.rating == stars {
                    maxStar = maxStar + 1
                }
            }
            for element in movies {
                if element.rating == stars {
                    maxStar = maxStar + 1
                }
            }
            for element in books {
                if element.rating == stars {
                    maxStar = maxStar + 1
                }
            }
        }
        else if serie != false {
            for element in series {
                if element.rating == stars {
                    maxStar = maxStar + 1
                }
            }
        }
        else if movie != false {
            for element in movies {
                if element.rating == stars {
                    maxStar = maxStar + 1
                }
            }
        }
        else if book != false {
            for element in books {
                if element.rating == stars {
                    maxStar = maxStar + 1
                }
            }
        }
        
        return maxStar
    }
}

struct UserPage_Previews: PreviewProvider {
    static var previews: some View {
        UserPage()
    }
}
