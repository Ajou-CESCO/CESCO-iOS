//
//  PhoneNumberVerificationResponseModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/12/24.
//

import Foundation

/// 전화번호 인증 응답 형식입니다.
struct PhoneNumberVerificationResponseModel: Codable {
    let status: Int
    let message: String
    let result: PhoneNumberVerificationResponseModelResult
}

// MARK: - PhoneNumberVerificationResponseModelResult

struct PhoneNumberVerificationResponseModelResult: Codable {
    let code: String
}
