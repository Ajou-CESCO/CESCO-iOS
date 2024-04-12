//
//  ValidationServiceType.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import Foundation

/// 로그인 및 회원가입에 필요한 검증 로직 구현
protocol ValidationServiceType {
    
    /// 휴대폰 형식이 올바른지 검증
    ///
    /// - Parameters:
    ///     - phoneNumber: String 타입의 전화번호를 전달합니다.
    /// - Returns: 형식이 올바르면 true, 올바르지 않으면 false를 리턴합니다.
    func isValidPhoneNumberFormat(_ phoneNumber: String) -> Bool
}
