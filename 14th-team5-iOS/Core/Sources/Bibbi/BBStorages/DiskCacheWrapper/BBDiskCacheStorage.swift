//
//  BBDiskCacheStorage.swift
//  Core
//
//  Created by 김도현 on 1/28/25.
//

import Foundation

import RxSwift

public final class BBDiskCacheStorage<Key: Hashable, Value> {
    public let filemanager: FileManager
    private var cacheURL: URL
    private let expriedDate: Date
    private(set) var directoryName: String = "BibbiCache"
    
    
    public init(filemanager: FileManager = FileManager.default, expriedDate: Date = Date().addingTimeInterval(7 * 24 * 60 * 60)) {
        self.filemanager = filemanager
        self.expriedDate = expriedDate
        if let directoryURL = filemanager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            self.cacheURL = directoryURL.appendingPathComponent(directoryName, isDirectory: true)
            if !filemanager.fileExists(atPath: cacheURL.path) {
                try? filemanager.createDirectory(at: cacheURL, withIntermediateDirectories: true)
            }
        } else {
            fatalError(BBDiskCacheStroageError.cannotCreateDirectory.localizedDescription)
        }
    }
    
    public func setObject(_ object: Value, for key: Key) throws {
        guard let buffer = object as? Data else {
            throw BBDiskCacheStroageError.cannotConvertToData
        }
        
        let filePath = makeFilePath(forkey: key)
        if filemanager.fileExists(atPath: filePath.path) {
            return
        }
        
        if !filemanager.createFile(atPath: filePath.path, contents: buffer) {
            throw BBDiskCacheStroageError.cannotCreateCacheFile
        }
        
        try filemanager.setAttributes([.modificationDate: expriedDate], ofItemAtPath: filePath.path)
    }
    
    public func object(forKey key: Key) throws -> Observable<Data> {
        let filePath = makeFilePath(forkey: key)
        guard let buffer = filemanager.contents(atPath: filePath.path) else {
            return .error(BBDiskCacheStroageError.cannotConvertToData)
        }
        return .just(buffer)
    }
    
    public func removeObject(forKey key: Key) throws {
        let filePath = makeFilePath(forkey: key)
        if filemanager.fileExists(atPath: filePath.path) {
            try filemanager.removeItem(at: filePath)
        }
    }
    
    public func removeAll() throws {
        try filemanager.removeItem(at: cacheURL)
        try filemanager.createDirectory(at: cacheURL, withIntermediateDirectories: true)
    }
    
    public func isCacheEmpty() -> Bool {
        do {
            let files = try filemanager.contentsOfDirectory(atPath: cacheURL.path)
            return files.isEmpty
        } catch {
            return false
        }
    }
}



public extension BBDiskCacheStorage  {
    func makeFilePath(forkey key: Key) -> URL {
        let fileName = Self.makeFileName(forkey: key)
        return cacheURL.appendingPathComponent(fileName).appendingPathExtension("m4a")
    }
    
    
    static func makeFileName(forkey key: Key) -> String {
        guard let key = key as? String else { return "" }
           
           let trimmedKey = key.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
           let fileName = trimmedKey.MD5()
           let fileExtensions = (key as NSString).pathExtension
           
           return fileExtensions.isEmpty ? fileName : "\(fileName).\(fileExtensions)"
    }
}


public extension BBDiskCacheStorage {
    
    static func read(forkey key: Key, filemanager: FileManager = FileManager.default, directoryName: String = "BibbiCache") -> URL? {
        if let directoryURL = filemanager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let cacheURL = directoryURL.appendingPathComponent(directoryName, isDirectory: true)
            let fileName = makeFileName(forkey: key)
            let filePath = cacheURL.appendingPathComponent(fileName).appendingPathExtension("m4a")
            if filemanager.fileExists(atPath: filePath.path) {
                return filePath
            }
        }
        return nil
    }
}
