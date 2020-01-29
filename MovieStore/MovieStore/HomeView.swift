//
//  HomeView.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 16/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//
import LocalAuthentication
import SwiftUI

struct HomeView: View {
    @State private var isUnlocked: Bool = false
    
    var body: some View {
        VStack {
            if self.isUnlocked {
                ApplicationAfterLogin()
            } else {
                LoginPage(isUnlocked: self.$isUnlocked)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
