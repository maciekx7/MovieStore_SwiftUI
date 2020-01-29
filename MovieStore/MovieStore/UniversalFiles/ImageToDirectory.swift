//
//  ImageToDirectory.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 29/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//

import SwiftUI

class ImageToDirectory {
    
    ///function which returns size of our documents directory. We can see by using that func if we're deleting properly out image data
    func directorySize(url: URL) -> Int64 {
        let contents: [URL]
        do {
            contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey])
        } catch {
            return 0
        }
        
        
        var size: Int64 = 0
        
        for url in contents {
            let isDirectoryResourceValue: URLResourceValues
            do {
                isDirectoryResourceValue = try url.resourceValues(forKeys: [.isDirectoryKey])
            } catch {
                continue
            }
            
            if isDirectoryResourceValue.isDirectory == true {
                size += directorySize(url: url)
            } else {
                let fileSizeResourceValue: URLResourceValues
                do {
                    fileSizeResourceValue = try url.resourceValues(forKeys: [.fileSizeKey])
                } catch {
                    continue
                }
                
                size += Int64(fileSizeResourceValue.fileSize ?? 0)
            }
        }
        return size
    }
    
    
    func getDirectoryPath() -> URL {
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath =  tDocumentDirectory.appendingPathComponent("MY_TEMP")
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    NSLog("Couldn't create folder in document directory")
                    NSLog("==> Document directory is: \(filePath)")
                    return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                }
            }
            
            NSLog("==> Document directory is: \(filePath)")
            return filePath
        }
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
    }
    
    
    func saveImageToDocumentDirectory(image: UIImage, filename: String) {
        let fileManager = FileManager.default
        let paths = getDirectoryPath().appendingPathComponent(filename)
        let imageData = image.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: paths.path as String, contents: imageData, attributes: nil)
    }
    
    func getImage(imageName : String)-> UIImage{
        let fileManager = FileManager.default
        let imagePath = getDirectoryPath().appendingPathComponent(imageName)
        FileManager.default.clearTmpDirectory()
        if fileManager.fileExists(atPath: imagePath.path){
            return UIImage(contentsOfFile: imagePath.path)!
        }else{
            print("No Image available")
            return UIImage.init(named: "placeholder.png")! ///if we don't have that image
        }
        
    }
    
    func deleteItemInDirectory(imageName: String) {
        let fileManager = FileManager.default
        let imagePath = getDirectoryPath().appendingPathComponent(imageName)
        print("\(imagePath)")
        do {
            if fileManager.fileExists(atPath: imagePath.path) {
                try fileManager.removeItem(atPath: imagePath.path)
                print("Confirmed")
                
            }
            else {
                print("nie usunalem")
            }
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        FileManager.default.clearTmpDirectory()
    }
    
    
}

///extension which provide to clean tmp directory folder. When we're picking image from camera/Liblary, a copy of it is created in tmp folder. We have to clear that folder manually
extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}
