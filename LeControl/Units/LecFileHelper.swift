//
//  LecFileHelper.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import UIKit

class LecFileHelper {
    //1
    // MARK:- Error Types
    fileprivate enum FileErrors:Error {
        case jsonNotSerialized
        case fileNotSaved
        case imageNotConvertedToData
        case fileNotRead
        case fileNotFound
    }
    
    //2
    // MARK:- File Extension Types
    enum FileExtension:String {
        case TXT = ".txt"
        case JSON = ".json"
        case JPG = ".jpg"
        case JPEG = ".jpeg"
        case PNG = ".png"
        case PLIST = ".plist"
    }
    
    //3
    // MARK:- Private Properties
    fileprivate let directory:FileManager.SearchPathDirectory
    fileprivate let directoryPath: String
    fileprivate let fileManager = FileManager.default
    fileprivate let fileName:String
    fileprivate let fileExtension:FileExtension
    fileprivate let filePath:String
    fileprivate let fullyQualifiedPath:String
    fileprivate let subDirectory:String
    
    var fileExists:Bool {
        get {
            return fileManager.fileExists(atPath: fullyQualifiedPath)
        }
    }
    
    var directoryExists:Bool {
        get {
            var isDir = ObjCBool(true)
            return fileManager.fileExists(atPath: filePath, isDirectory: &isDir )
        }
    }
    
    init(fileName:String, fileExtension:FileExtension, subDirectory:String, directory:FileManager.SearchPathDirectory) {
        self.fileExtension = fileExtension
        self.fileName = fileName + fileExtension.rawValue
        self.subDirectory = "/\(subDirectory)"
        self.directory = directory
        self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first!
        self.filePath = directoryPath + self.subDirectory
        self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
        createDirectory()
    }
    
    convenience init(fileName:String, fileExtension:FileExtension, subDirectory:String){
        self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:subDirectory, directory:.documentDirectory)
    }
    
    convenience init(fileName:String, fileExtension:FileExtension){
        self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:"", directory:.documentDirectory)
    }
    
    fileprivate func createDirectory(){
        if !directoryExists {
            do {
                try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print("An Error was generated creating directory")
            }
        }
    }
    
    func saveFile<T>(_ file: T) throws {
        do {
            if let str = file as? String{
                try str.write(toFile: fullyQualifiedPath, atomically: true, encoding: String.Encoding.utf8)
            } else if let data = file as? Data {
                if !fileManager.createFile(atPath: fullyQualifiedPath, contents: data, attributes: nil) {
                    throw FileErrors.fileNotSaved
                }
            } else if let image = file as? UIImage {
                if let data = UIImageJPEGRepresentation(image, 1.0) {
                    if !fileManager.createFile(atPath: fullyQualifiedPath, contents: data, attributes: nil){
                        throw FileErrors.fileNotSaved
                    }
                } else if let data = UIImagePNGRepresentation(image) {
                    if !fileManager.createFile(atPath: fullyQualifiedPath, contents: data, attributes: nil){
                        throw FileErrors.fileNotSaved
                    }
                }
            } else if let dictionary = file as? NSDictionary {
                dictionary.write(toFile: fullyQualifiedPath, atomically: true)
            } else if let array = file as? NSArray {
                array.write(toFile: fullyQualifiedPath, atomically: true)
            }
        } catch {
            throw error
        }
    }
    
    fileprivate func convertObjectToData(_ data:AnyObject) throws -> Data {
        do {
            let newData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return newData
        }
        catch {
            print("Error writing data: \(error)")
        }
        throw FileErrors.jsonNotSerialized
    }
    
    func getContentsOfFile<T>() throws -> T? {
        guard fileExists else {
            throw FileErrors.fileNotFound
        }
        
        var data: T?
        do {
            switch fileExtension {
            case .TXT:
                data = try String(contentsOfFile: fullyQualifiedPath, encoding: String.Encoding.utf8) as? T
                return data
            case .JSON:
                data = try Data(contentsOf: URL(fileURLWithPath: fullyQualifiedPath), options: NSData.ReadingOptions.mappedIfSafe) as? T
                return data
            case .JPG, .JPEG, .PNG:
                guard let image = UIImage(contentsOfFile: fullyQualifiedPath) else {
                    throw FileErrors.fileNotRead
                }
                return image as? T
            case .PLIST:
                if let d = NSDictionary(contentsOfFile: fullyQualifiedPath) as? T {
                    data = d
                } else if let a = NSArray(contentsOfFile: fullyQualifiedPath) as? T {
                    data = a
                }
                return data
            }
        } catch {
            throw FileErrors.fileNotRead
        }
    }
}
