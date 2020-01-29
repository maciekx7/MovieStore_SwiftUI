//
//  MovieExtension.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 11/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import Foundation
import SwiftUI


extension Movie {
    func containsWithLovercased(_ string: String) -> Bool{
        let title = self.title!.lowercased()
        if title.contains(string.lowercased()) {
            return true
        } else{
            if self.director != nil {
                if self.director!.lowercased().contains(string.lowercased()) {
                    return true
                }
            }
        }
        return false
    }
    
    func savePhoto(image: UIImage) {
        ImageToDirectory().saveImageToDocumentDirectory(image: image, filename: self.id!.uuidString)
        self.isCustomImage = true
    }
    
    func deletePhoto() {
        if self.isCustomImage {
            ImageToDirectory().deleteItemInDirectory(imageName: self.id!.uuidString)
            self.isCustomImage = false
        }
    }
    
    func getPhoto() -> UIImage? {
        if self.isCustomImage {
            return ImageToDirectory().getImage(imageName: self.id!.uuidString)
        } else {
            return nil
        }
    }
}
