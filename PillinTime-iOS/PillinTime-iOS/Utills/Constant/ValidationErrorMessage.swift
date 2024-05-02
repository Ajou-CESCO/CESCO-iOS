//
//  ValidationErrorMessage.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import Foundation

enum ValidationErrorMessage {
    case invalidPhoneNumber
    case invalidName
    case invalidSsn
    
    var description: String {
        switch self {
        case .invalidPhoneNumber:
            return "전화번호 형식이 올바르지 않습니다."
        case .invalidName:
            return "이름 형식이 올바르지 않습니다."
        case .invalidSsn:
            return "주민등록번호 형식이 올바르지 않습니다."
        }
    }
}
