//
//  PaymentServiceType.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/10/24.
//

import Foundation
import Combine
import Moya

/// 결제 요청 관련 API Service 입니다.
protocol PaymentServiceType {
    
    /// 결제 요청 관련 정보 조회를 보냅니다.
    ///
    /// - Parameters:
    ///     - memberId: 결제 정보를 요청할 memberId입니다.
    /// - Returns: 이후 수정
    func requestPaymentInfo(memberId: Int) -> AnyPublisher<RequestPaymentInfoResponseModel, PillinTimeError>
    
    /// 나와 이루어져 있는 보호관계 목록 조회 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - paymentKey: String, orderId: String, amount: Int
    /// - Returns: 이후 수정
    func requestSuccessPayment(paymentKey: String, orderId: String, amount: Int) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError>
}
