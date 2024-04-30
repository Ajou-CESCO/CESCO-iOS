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
    @UserDefaultWrapper<String>(key: "name") public var name
    @UserDefaultWrapper<String>(key: "phoneNumber") public var phoneNumber
    @UserDefaultWrapper<String>(key: "ssn") public var ssn
    @UserDefaultWrapper<String>(key: "userType") public var userType

    var hasAccessToken: Bool { return self.accessToken != nil }
    
    private init() {}
    
    func updateToken(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
