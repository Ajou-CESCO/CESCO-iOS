//
//  PhoneNumberVerificationResponseModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/12/24.
//

import Foundation

/// 전화번호 인증 응답 형식입니다.
struct PhoneNumberVerificationResponseModel: Codable {
    let verificationCode: String
    
    // TODO: - 명세서 확정 시 변경
    enum CodingKeys: String, CodingKey {
        case verificationCode = "verificationCode"
    }
}
