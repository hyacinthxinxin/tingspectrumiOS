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
    private enum FileErrors:ErrorType {
        case JsonNotSerialized
        case FileNotSaved
        case ImageNotConvertedToData
        case FileNotRead
        case FileNotFound
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
    private let directory:NSSearchPathDirectory
    private let directoryPath: String
    private let fileManager = NSFileManager.defaultManager()
    private let fileName:String
    private let fileExtension:FileExtension
    private let filePath:String
    private let fullyQualifiedPath:String
    private let subDirectory:String
    
    var fileExists:Bool {
        get {
            return fileManager.fileExistsAtPath(fullyQualifiedPath)
        }
    }
    
    var directoryExists:Bool {
        get {
            var isDir = ObjCBool(true)
            return fileManager.fileExistsAtPath(filePath, isDirectory: &isDir )
        }
    }
    
    init(fileName:String, fileExtension:FileExtension, subDirectory:String, directory:NSSearchPathDirectory) {
        self.fileExtension = fileExtension
        self.fileName = fileName + fileExtension.rawValue
        self.subDirectory = "/\(subDirectory)"
        self.directory = directory
        self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .UserDomainMask, true).first!
        self.filePath = directoryPath + self.subDirectory
        self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
        //        print(self.fullyQualifiedPath)
        createDirectory()
    }
    
    convenience init(fileName:String, fileExtension:FileExtension, subDirectory:String){
        self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:subDirectory, directory:.DocumentDirectory)
    }
    
    convenience init(fileName:String, fileExtension:FileExtension){
        self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:"", directory:.DocumentDirectory)
    }
    
    private func createDirectory(){
        if !directoryExists {
            do {
                try fileManager.createDirectoryAtPath(filePath, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print("An Error was generated creating directory")
            }
        }
    }
    
    func saveFile<T>(file: T) throws {
        do {
            if let str = file as? String{
                try str.writeToFile(fullyQualifiedPath, atomically: true, encoding: NSUTF8StringEncoding)
            } else if let data = file as? NSData {
                if !fileManager.createFileAtPath(fullyQualifiedPath, contents: data, attributes: nil) {
                    throw FileErrors.FileNotSaved
                }
            } else if let image = file as? UIImage {
                if let data = UIImageJPEGRepresentation(image, 1.0) {
                    if !fileManager.createFileAtPath(fullyQualifiedPath, contents: data, attributes: nil){
                        throw FileErrors.FileNotSaved
                    }
                } else if let data = UIImagePNGRepresentation(image) {
                    if !fileManager.createFileAtPath(fullyQualifiedPath, contents: data, attributes: nil){
                        throw FileErrors.FileNotSaved
                    }
                }
            } else if let dictionary = file as? NSDictionary {
                dictionary.writeToFile(fullyQualifiedPath, atomically: true)
            } else if let array = file as? NSArray {
                array.writeToFile(fullyQualifiedPath, atomically: true)
            }
        } catch {
            throw error
        }
    }
    
    private func convertObjectToData(data:AnyObject) throws -> NSData {
        do {
            let newData = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
            return newData
        }
        catch {
            print("Error writing data: \(error)")
        }
        throw FileErrors.JsonNotSerialized
    }
    
    func getContentsOfFile<T>() throws -> T? {
        guard fileExists else {
            throw FileErrors.FileNotFound
        }
        
        var data: T?
        do {
            switch fileExtension {
            case .TXT:
                data = try String(contentsOfFile: fullyQualifiedPath, encoding: NSUTF8StringEncoding) as? T
                return data
            case .JSON:
                data = try NSData(contentsOfFile: fullyQualifiedPath, options: NSDataReadingOptions.DataReadingMappedIfSafe) as? T
                return data
            case .JPG, .JPEG, .PNG:
                guard let image = UIImage(contentsOfFile: fullyQualifiedPath) else {
                    throw FileErrors.FileNotRead
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
            throw FileErrors.FileNotRead
        }
    }
}