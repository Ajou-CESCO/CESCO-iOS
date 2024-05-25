//
//  RelationServiceType.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/25/24.
//

import Foundation
import Combine
import Moya

/// 보호관계 관련 API Service 입니다.
protocol RelationServiceType {
    
    /// 보호관계 생성 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - id: 보호관계의 id입니다.
    /// - Returns: BaseResponse
    func createRelation(id: Int) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError>
}
