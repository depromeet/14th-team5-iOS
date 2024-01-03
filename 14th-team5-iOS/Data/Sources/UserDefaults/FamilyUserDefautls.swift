//
//  FamilyDataRepository.swift
//  Core
//
//  Created by 마경미 on 02.01.24.
//

import Foundation
import Domain

import RxSwift
import RxCocoa

public class FamilyUserDefaults {
    /// familyIdKey - familyId 저장
    /// familyId - memberId를 배열로 저장
    /// 각 memberId - familymember 객체 저장

    private let familyIdKey = "familyId"
    private static let myMemberIdKey = "myMemberId"
    private static let memberIdsKey = "memberIds"

    public static func checkIsMyMemberId(memberId: String) -> Bool {
        return memberId == UserDefaults.standard.string(forKey: myMemberIdKey)
    }

    func removeFamilyMembers() {
         UserDefaults.standard.removeObject(forKey: familyIdKey)
     }
    
    static func getMyMemberId() -> String {
        return UserDefaults.standard.string(forKey: myMemberIdKey) ?? ""
    }
    
    public static func getMemberCount() -> Int {
        return UserDefaults.standard.stringArray(forKey: memberIdsKey)?.count ?? 0
    }
    
    public static func saveFamilyMembers(_ familyMembers: [ProfileData]) {
        saveMemberIdToUserDefaults(memberIds: familyMembers.map { $0.memberId })
        familyMembers.forEach {
            saveMemberToUserDefaults(familyMember: $0)
        }
    }
    
    public static func loadMemberFromUserDefaults(memberId: String) -> ProfileData? {
        if let data = UserDefaults.standard.data(forKey: memberId) {
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(ProfileData.self, from: data)
                return person
            } catch {
                print("Error decoding person: \(error.localizedDescription)")
            }
        }
        return nil
    }
}

extension FamilyUserDefaults {
    private static func saveMemberToUserDefaults(familyMember: ProfileData) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(familyMember)

            UserDefaults.standard.set(data, forKey: familyMember.memberId)
        } catch {
            print("Error encoding person: \(error.localizedDescription)")
        }
    }
    
    private static func saveMemberIdToUserDefaults(memberIds: [String]) {
        UserDefaults.standard.setValue(memberIds, forKey: memberIdsKey)
    }

    private func loadMembersFromUserDefaults(memberIds: [String]) -> [ProfileData] {
        var datas: [ProfileData] = []
        memberIds.forEach {
            if let data = UserDefaults.standard.data(forKey: $0) {
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(ProfileData.self, from: data)
                    return datas.append(data)
                } catch {
                    print("Error decoding person: \(error.localizedDescription)")
                }
            }
        }
        return datas
    }
}
