//
//  HealthServiceType.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/3/24.
//

import Foundation
import Combine
import Moya

/// 건강 데이터 관련 API Service 입니다.
protocol HealthServiceType {
    
    /// 건강 데이터 생성 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - createHealthDataModel: 요청을 보낼 Model의 형태입니다.
    /// - Returns: BaseResponse
    func createHealthData(createHealthDataModel: CreateHealthDataModel) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError>
    
    /// 건강 데이터 조회 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - memberId: 건강 데이터를 받을 멤버의 id입니다.
    /// - Returns: GetHealthDateResponseModel
    func getHealthData(id: Int) -> AnyPublisher<GetHealthDateResponseModel, PillinTimeError>
}
