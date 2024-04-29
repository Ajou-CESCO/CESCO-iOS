//
//  UserServiceType.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/18/24.
//

import Foundation
import Combine
import Moya

/// 유저 정보 관련 API Service 입니다.
protocol UserServiceType {
    
    /// 회원가입 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - createUserRequestModel: 회원가입에 필요한 정보들을 담은 Model입니다.
    /// - Returns: 이후 수정
    func createUser(createUserModel: CreateUserRequestModel) -> Bool
    
    /// 특정 사용자의 정보를 조회합니다.
    /// - Parameters:
    ///     - uuid
    /// - Returns: 이후 수정
    func getUserById(uuid: String) -> Bool
    
    /// 사용자와 보호 관계를 맺고 있는 모든 사용자를 조회합니다.
    /// - Parameters:
    ///     - 없음
    /// - Returns: 이후 수정
    func getUserList() -> Bool
    
    /// 특정 사용자의 정보를 업데이트합니다.
    ///
    /// - Parameters:
    ///     - uuid
    /// - Returns: 이후 수정
    func updateUserById(uuid: String) -> Bool
    
    /// 회원탈퇴 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - 없음
    /// - Returns: 이후 수정
    func deleteUserById() -> Bool
}
