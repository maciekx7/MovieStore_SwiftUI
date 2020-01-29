//
//  SeriesExtension.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 11/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import Foundation
import SwiftUI


extension Series {
    func containsWithLovercased(_ prefix: String) -> Bool{
        let title = self.title!.lowercased()
        if title.contains(prefix.lowercased()) {
            return true
        } else{
            if self.producent != nil {
                if self.producent!.lowercased().contains(prefix.lowercased()) {
                    return true
                }
            }
        }
        return false
    }
    
    func deletePhoto() {
        if self.isCustomImage {
            ImageToDirectory().deleteItemInDirectory(imageName: self.id!.uuidString)
            self.isCustomImage = false
        }
    }
    
    func savePhoto(image: UIImage) {
        ImageToDirectory().saveImageToDocumentDirectory(image: image, filename: self.id!.uuidString)
        self.isCustomImage = true
    }
    
    func getPhoto() -> UIImage? {
        if self.isCustomImage {
            return ImageToDirectory().getImage(imageName: self.id!.uuidString)
        } else {
            return nil
        }
    }
    
    func timeOfWatchingInString() -> String{
        let time: Double = Double(self.durationOfEpisode)
        let episodes: Int = Int(self.episodes)
        
        let howMuch: Double = Double(time / 60) * Double(episodes)
        
        if howMuch > 0
        {
            if howMuch == Double(Int(howMuch)) {
                return String(Int(howMuch))
            }
            else {
                return String(howMuch.roundTo(places: 2))
            }
        }
        else {
            return "-"
        }
    }
}
