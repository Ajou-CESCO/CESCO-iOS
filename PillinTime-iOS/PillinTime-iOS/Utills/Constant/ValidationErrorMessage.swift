//
//  ValidationErrorMessage.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import Foundation

enum ValidationErrorMessage {
    case invalidPhoneNumber
    
    var description: String {
        switch self {
        case .invalidPhoneNumber:
            return "전화번호 형식이 올바르지 않습니다."
        }
    }
}
