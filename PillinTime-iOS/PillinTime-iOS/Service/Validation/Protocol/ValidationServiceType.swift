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
    
    /// 이름 형식이 맞는지 검증
    ///
    /// 이름은 영문과 한글을 혼용해서 사용할 수 없음
    ///
    /// - Parameters:
    ///     - name: String 타입의 이름을 전달합니다.
    /// - Returns: 형식이 올바르면 true, 올바르지 않으면 false를 리턴합니다.
    func isValidNameFormat(_ name: String) -> Bool
    
    /// 주민번호 형식이 맞는지 검증
    ///
    /// 주민번호는 7자리의 숫자 형태 (뒷자리 첫번째 숫자까지만 저장)
    /// e.g., 0101284
    func isValidSsnFormat(_ ssh: String) -> Bool
}
