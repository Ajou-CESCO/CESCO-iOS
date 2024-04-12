//
//  AuthServiceType.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/12/24.
//

import Foundation
import Combine
import Moya

/// 로그인, 회원가입 관련 Service 입니다.
protocol AuthServiceType {
    /// 인증코드를 담은 메일을 발송하는 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - phoneNumber: String 타입의 전화번호를 전달합니다.
    /// - Returns: 요청에 성공할 시, 사용자 전화번호로 보내진 인증코드를 받습니다. 실패 시 AuthError를 throw합니다.
    func requestPhoneNumberConfirm(phoneNumber: String) -> AnyPublisher<PhoneNumberVerificationResponseModel, AuthError>
}
