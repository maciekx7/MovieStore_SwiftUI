//
//  UserExtensions.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 11/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import Foundation
import SwiftUI

extension User {
    func savePhoto(image: UIImage) {
        ImageToDirectory().saveImageToDocumentDirectory(image: image, filename: self.imageName!)
    }
    
    func deletePhoto() {
        ImageToDirectory().deleteItemInDirectory(imageName: self.imageName!)
    }
    
    func getPhoto() -> UIImage {
        return ImageToDirectory().getImage(imageName: self.imageName!)
    }
}
