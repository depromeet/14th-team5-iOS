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

@available(*, deprecated, renamed: "FamilyInfoUserDefaults", message: "FamilyInfoUserDefaults!!!!!!!!!!!! 쓰세요")
public class FamilyUserDefaults {
    /// familyIdKey - familyId 저장
    /// familyId - memberId를 배열로 저장
    /// 각 memberId - familymember 객체 저장

    private static let familyIdKey = "familyId"
    private static let familyEditorIdKey = "familyEditorId"
    private static let myMemberIdKey = "memberId"
    private static let memberIdsKey = "memberIds"
    private static let dayOfBirths = "dayOfBirths"
    
    private static var userDefaults: UserDefaults {
        UserDefaults.standard
    }

    public static func checkIsMyMemberId(memberId: String) -> Bool {
        return memberId == UserDefaults.standard.string(forKey: myMemberIdKey)
    }
    
    public static func returnMyMemberId() -> String {
        return UserDefaults.standard.string(forKey: myMemberIdKey) ?? ""
    }

    public static func removeFamilyMembers() {
        UserDefaults.standard.stringArray(forKey: memberIdsKey)?.forEach {
            UserDefaults.standard.removeObject(forKey: $0)
            print($0)
        }
        
         UserDefaults.standard.removeObject(forKey: memberIdsKey)
     }
    
    public static func saveMyMemberId(memberId: String) {
        UserDefaults.standard.setValue(memberId, forKey: myMemberIdKey)
    }
    
    public static func saveFamilyEditorId(familyEditorId: String) {
        UserDefaults.standard.setValue(familyEditorId, forKey: familyEditorIdKey)
    }
    
    public static func getMyMemberId() -> String {
        return UserDefaults.standard.string(forKey: myMemberIdKey) ?? ""
    }
    
    public static func getDateOfBirths() -> [Date] {
        guard let dateOfBirths = userDefaults.array(
            forKey: dayOfBirths
        ) as? [Date] else {
            return []
        }
        return dateOfBirths
    }
    
    public static func getMemberCount() -> Int {
        return UserDefaults.standard.stringArray(forKey: myMemberIdKey)?.count ?? 0
    }
    
    public static func saveFamilyMembers(_ familyMembers: [FamilyMemberProfileEntity]) {
        removeFamilyMembers()
        saveMemberIdToUserDefaults(memberIds: familyMembers.map { $0.memberId })
        saveDayOfBirths(dateOfBirths: familyMembers.map { $0.dayOfBirth ?? Date() })
        familyMembers.forEach { saveMemberToUserDefaults(familyMember: $0) }
    }
    
    public static func load(memberId: String) -> FamilyMemberProfileEntity? {
        if let data = UserDefaults.standard.data(forKey: memberId) {
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(FamilyMemberProfileEntity.self, from: data)
                return person
            } catch {
                print("Error decoding person: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    public static func loadMemberIds() -> [String] {
        return userDefaults.array(forKey: memberIdsKey) as! [String]
    }
    
    public static func loadFamilyNameEditorId() -> String {
        return userDefaults.string(forKey: familyEditorIdKey) ?? ""
    }
}

extension FamilyUserDefaults {
    public static func saveMemberToUserDefaults(familyMember: FamilyMemberProfileEntity) {
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
    
    private static func saveDayOfBirths(dateOfBirths: [Date]) {
        userDefaults.setValue(dateOfBirths, forKey: self.dayOfBirths)
    }

    static func loadMembersFromUserDefaults(memberIds: [String]) -> [FamilyMemberProfileEntity] {
        var datas: [FamilyMemberProfileEntity] = []
        memberIds.forEach {
            if let data = UserDefaults.standard.data(forKey: $0) {
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(FamilyMemberProfileEntity.self, from: data)
                    return datas.append(data)
                } catch {
                    print("Error decoding person: \(error.localizedDescription)")
                }
            }
        }
        return datas
    }
}
