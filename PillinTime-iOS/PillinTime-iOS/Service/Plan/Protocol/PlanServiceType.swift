//
//  PlanServiceType.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation
import Combine
import Moya

/// 복약 일정 관련 API Service 입니다.
protocol PlanServiceType {
    
    /// 복약 일정 생성 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - AddDosePlanRequestModel: 복약 일정에 필요한 정보들을 담은 Model입니다.
    /// - Returns: BaseResponse
    func addDosePlan(addDosePlanModel: AddDosePlanRequestModel) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError>
    
    /// 복약 기록 조회 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - memberId: 복약 기록을 조회할 member의 id를 조회합니다.
    func getDoseLog(memberId: Int) -> AnyPublisher<GetDoseLogResponseModel, PillinTimeError>
    
    /// 복약 계획 조회 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - memberId: 복약 계획을 조회할 member의 id를 조회합니다.
    func getDosePlan(memberId: Int) -> AnyPublisher<GetDosePlanResponseModel, PillinTimeError>
    
    /// 복약 계획 삭제 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - memberId: 복약 계획을 삭제할 member의 id를 조회합니다.
    ///     - medicineId: 복약 계획을 삭제할 medicineId를 조회합니다.
    ///     - cabinetIndex: 복약 계획을 삭제할 cabinetIndex를 조회합니다.
    func deleteDosePlan(memberId: Int, medicineId: String, cabinetIndex: Int) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError>
}
