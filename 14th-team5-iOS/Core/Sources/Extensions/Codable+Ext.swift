//
//  Codable+Ext.swift
//  Data
//
//  Created by geonhui Yu on 12/18/23.
//

import Foundation

import Alamofire
import RxSwift

// TODO: - Extension을 파일 별로 쪼개기



// MARK: Data Decodable (Data to Decodable)
public extension Data {
    
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let jsonString = String(data: data, encoding: .utf8) else { return nil }
        return jsonString
    }
    
    func decode<T>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> T? where T: Decodable {
        
        let decoder = decoder ?? JSONDecoder()
        
        var res: T? = nil
        do {
            res = try decoder.decode(type, from: self)
        } catch {
            debugPrint("\(T.self) Data Parsing Error: \(error)")
        }
        
        return res
    }
}

// MARK: String Decodable (String to Decodable)
public extension String {
    func decode<T>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> T? where T: Decodable {
        
        return self.data(using: .utf8)?.decode(type, using: decoder)
    }
}

// MARK: Dictionary([String : Any]) Decodable
public extension Dictionary where Key == String {
    func decode<T>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> T? where T: Decodable {
        
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: [.fragmentsAllowed]) else {
            return nil
        }
        
        return data.decode(type, using: decoder)
    }
}

public extension Encodable {
    func encodeData(using encoder: JSONEncoder? = nil) -> Data? {
        
        let encoder = encoder ?? JSONEncoder()
        return try? encoder.encode(self)
    }
    
    func encode(using encoder: JSONEncoder? = nil) -> String? {
        
        guard let data = self.encodeData(using: encoder) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}

// MARK: Alamofire Decodable (Observable<(HTTPURLResponse, Data)> -> Decodable)
public extension ObservableType where Element == (HTTPURLResponse, Data) {
    
    func map<T: Decodable>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> Observable<T?> {
        return self.map { response -> T? in
            let decoder = decoder ?? JSONDecoder()
            
            var res: T? = nil
            do {
                res = try decoder.decode(type, from: response.1)
            } catch {
                debugPrint("Parsing error: \(error)")
            }
            
            return res
        }
    }
}

// MARK: Alamofire Decodable (Single<(HTTPURLResponse, Data)> -> Decodable)
public extension PrimitiveSequenceType where Trait == SingleTrait, Element == (HTTPURLResponse, Data) {
    
    func map<T: Decodable>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> PrimitiveSequence<Trait, T?> {
        return self.map { response -> T? in
            let decoder = decoder ?? JSONDecoder()
            
            var res: T? = nil
            do {
                res = try decoder.decode(type, from: response.1)
            } catch {
                debugPrint("Parsing error: \(error)")
            }
            
            return res
        }
    }
}

public extension Encodable {
    
    func asDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return nil }
            
            return dict
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func asArray() throws -> [AnyObject] {
        let data = try JSONEncoder().encode(self)
        guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject] else {
            throw NSError()
        }
        return dict
    }
}

