//
//  UserManager.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/29/24.
//

import Foundation

enum PillinTimeError: Error {
    case networkFail
    case etc
}

final class UserManager {
    static let shared = UserManager()
    
    @UserDefaultWrapper<String>(key: "accessToken") public var accessToken
    @UserDefaultWrapper<String>(key: "refreshToken") public var refreshToken
    @UserDefaultWrapper<Int>(key: "memberId") public var memberId   // 자기 자신의 id
    @UserDefaultWrapper<String>(key: "name") public var name
    @UserDefaultWrapper<String>(key: "phoneNumber") public var phoneNumber
    @UserDefaultWrapper<String>(key: "ssn") public var ssn
    @UserDefaultWrapper<Bool>(key: "isManager") public var isManager
    @UserDefaultWrapper<String>(key: "fcmToken") public var fcmToken
    @UserDefaultWrapper<String>(key: "selectedClientName") public var selectedClientName    // 선택한 보호자의 이름
    @UserDefaultWrapper<Int>(key: "selectedClientId") public var selectedClientId  // 선택한 보호자의 memberId

    var hasAccessToken: Bool { return self.accessToken != nil }
    
    private init() {}
    
    func updateToken(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
