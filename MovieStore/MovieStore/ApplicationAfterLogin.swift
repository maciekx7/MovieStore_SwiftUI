//
//  ApplicationAfterLogin.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 11/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import SwiftUI

struct ApplicationAfterLogin: View {
    @State private var viewType = ["Movies", "Books", "Series", "You"]
    @State private var selected = 1
    
    var body: some View {
        TabView(selection: self.$selected) {
            
            ListView(viewType: viewType[selected])
                .tabItem {
                    Text(viewType[0])
                    if selected == 0 {
                        Image(systemName: "film.fill")
                    } else {
                        Image(systemName: "film")
                    }
                    
            }.tag(0)
            
            ListView(viewType: viewType[selected])
                .tabItem {
                    Text(viewType[1])
                    if selected == 1 {
                        Image(systemName: "book.fill")
                    } else {
                        Image(systemName: "book")
                    }
                    
            }.tag(1)
            
            ListView(viewType: viewType[selected])
                .tabItem {
                    Text(viewType[2])
                    if selected == 2 {
                        Image(systemName: "rectangle.stack.fill")
                    } else {
                        Image(systemName: "rectangle.stack")
                    }
                    
            }.tag(2)
            
            UserPage()
                .tabItem {
                    Text(viewType[3])
                    if selected == 3 {
                        Image(systemName: "person.circle.fill")
                    } else {
                        Image(systemName: "person.circle")
                    }
            }.tag(3)
        }.accentColor(.red)
    }
}

struct ApplicationAfterLogin_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationAfterLogin()
    }
}
