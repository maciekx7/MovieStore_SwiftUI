//
//  WantsToSeeHomeView.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 02/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import SwiftUI

struct WantsToSeeHomeView: View {
        @State private var selector = 0
    

        var body: some View {
            ScrollView {
                VStack() {
                    Picker(selection: $selector, label: Text("What is your favorite color?")) {
                        Text("Movie").tag(0)
                        Text("Book").tag(1)
                        Text("Serie").tag(2)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if self.selector == 0 {
                        MoviesWantsView()
                    }
                    else if self.selector == 1 {
                        BooksWantsView()
                    }
                    else if self.selector == 2{
                        SeriesWantsView()
                    }
                    Spacer()
                }
            }
        .navigationBarTitle(Text("Wnats to"))
        }
    }

struct WantsToSeeHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WantsToSeeHomeView()
    }
}
