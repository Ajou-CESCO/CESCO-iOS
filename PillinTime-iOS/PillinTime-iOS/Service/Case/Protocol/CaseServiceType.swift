//
//  CaseServiceType.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation
import Combine
import Moya

/// 약통 관련 API Service 입니다.
protocol CaseServiceType {
    
    /// 약통 생성 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - createPillCaseRequestModel: 약통 생성에 필요한 정보들을 담은 Model입니다.
    /// - Returns: BaseResponse
    func createPillCaseRequest(createPillCaseRequestModel: CreatePillCaseRequestModel) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError>
    
    /// 약통 해제 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - cabinetId: 해제할 약통의 id입니다.
    /// - Returns: BaseResponse
    func deletePillCaseRequest(cabineId: String) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError>
    
}
