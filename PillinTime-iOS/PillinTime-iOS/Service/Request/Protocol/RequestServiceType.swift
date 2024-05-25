//
//  RequestServiceType.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import Foundation
import Combine
import Moya

/// 보호관계 요청 관련 API Service 입니다.
protocol RequestServiceType {
    
    /// 보호관계 요청 생성 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - receiverPhone: 보호관계 요청을 보낼 사용자의 휴대폰 번호입니다.
    /// - Returns: 이후 수정
    func relationRequest(receiverPhone: String) -> AnyPublisher<RequestRelationResponseModel, PillinTimeError>
    
    /// 나와 이루어져 있는 보호관계 목록 조회 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - 없음
    /// - Returns: 이후 수정
    func relationRequestList() -> AnyPublisher<RelationRequestListResponseModel, PillinTimeError>
}
