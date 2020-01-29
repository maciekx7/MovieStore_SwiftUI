//
//  LoginPage.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 07/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct LoginPage: View {
    @Binding var isUnlocked: Bool
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
    @State private var login: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            
            Text("Login").bold().font(.title)
            
            Text("Let's see what we have here")
                .font(.subheadline)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 70, trailing: 0))
            
            
            TextField("Login", text: $login)
                .padding()
                .background(Color("flash-white"))
                .cornerRadius(4.0)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            
            
            
            SecureField("password", text: $password)
                .padding()
                .background(Color("flash-white"))
                .cornerRadius(4.0)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            
            
            
            Button(action: self.loginFunc) {
                
                Text("Log in")
            }
            .padding()
            .background(Color.green)
            .cornerRadius(4.0)
            .foregroundColor(Color.white)
            
            Button(action: self.authenticate) {
                
                Image(systemName: "faceid")
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(4.0)
            .foregroundColor(Color.white)
        }.onAppear(perform: ispPorpouseToLogin)
    }
    
    func ispPorpouseToLogin() {
        if user.isEmpty {
            NSLog("There was no porpouse to login, becouse there is no user created")
            isUnlocked = true
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        NSLog("Button biometrics clicked")
        
        if !self.user.isEmpty {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "We need to unlock your data."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            NSLog("Device unlocked")
                            self.isUnlocked = true
                        } else {
                            NSLog("There was a problem with biometrics")
                        }
                    }
                }
            } else {
                NSLog("Device don't have activated or acccepted biometrics")
            }
        } else {
            NSLog("There is no user")
            self.isUnlocked = true
        }
        
    }
    
    func loginFunc() {
        NSLog("button login clicked")
        let keychain = KeychainSwift()
        if !self.user.isEmpty {
            let stringPassword = String(decoding: keychain.getData("password")!, as: UTF8.self)
            if  stringPassword != ""{
                if self.login == user[0].name && self.password == stringPassword {
                    self.isUnlocked = true
                }
            }
        }
        else {
            self.isUnlocked = false
        }
    }
}


