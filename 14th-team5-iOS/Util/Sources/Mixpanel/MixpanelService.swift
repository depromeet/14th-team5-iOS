//
//  MixpanelService.swift
//  Core
//
//  Created by geonhui Yu on 1/20/24.
//

import Foundation
import Mixpanel
import Core

// MARK: Mixpanel Protocol
protocol MixpanelTrackable {
    func track(with properties: Encodable?)
}

public typealias MP = Mixpanel
public typealias MPEvent = MixpanelService.Event
public enum MixpanelService {
    static var distinctId: String {
        return MP.mainInstance().distinctId
    }
    public enum Event {
        // 추후 계정정보 관련 필요한 경우 추가예정
        static func setPeople(with token: AccessToken?) {
            guard let t = token else {
                if token?.accessToken == nil {
                    return
                }
                
                if MP.mainInstance().userId == nil {
                    MP.mainInstance().reset()
                }
                debugPrint("[Bibbi - Mixpanel - reset")
                return
            }
        }
    }
}

extension MPEvent {}

// MARK: Mixpanel Properties
extension MPEvent {
    enum Property {
        struct People: Codable {
            var nickname: String?
            enum CodingKeys: String, CodingKey {
                case nickname = "$nickname"
            }
        }
        
        enum Account {
            struct SignedIn: Codable {
                var type: String?
            }
            
            struct SignedUp: Codable {
                var type: String?
            }
        }
    }
}

// MARK: Extensions
//extension Encodable {
//    func asDictionary() -> [String: Any]? {
//        do {
//            let data = try JSONEncoder().encode(self)
//            guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return nil }
//            
//            return dict
//        } catch let error {
//            print(error)
//            return nil
//        }
//    }
//}

extension Encodable {
    func asMixpanelDictionary() -> [String: MixpanelType]? {
        return self.asDictionary() as? [String: MixpanelType]
    }
}
