//
//  CreateUserRequestModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/18/24.
//

import Foundation

/// 회원가입 요청 body입니다.
struct CreateUserRequestModel {
    let name: String
    let phoneNumber: String
    let ssn: String
    let userType: Int // 0은 보호자, 1은 피보호자
}
