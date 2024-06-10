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
    ///     - date: 복약 기록을 조회할 날짜를 선택합니다. (적지 않을 경우, 오늘 날짜를 받음)
    func getDoseLog(memberId: Int, date: String?) -> AnyPublisher<GetDoseLogResponseModel, PillinTimeError>
    
    /// 복약 계획 조회 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - memberId: 복약 계획을 조회할 member의 id를 조회합니다.
    func getDosePlan(memberId: Int) -> AnyPublisher<GetDosePlanResponseModel, PillinTimeError>
    
    /// 복약 계획 삭제 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - memberId: 복약 계획을 삭제할 member의 id를 조회합니다.
    ///     - groupId: 복약 계획을 삭제할 groupId를 조회합니다.
    func deleteDosePlan(memberId: Int, groupId: Int) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError>
    
    /// 복약 일정 수정 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - GetDosePlanResponseModel: 복약 일정에 필요한 정보들을 담은 Model입니다.
    /// - Returns: BaseResponse
    func patchDosePlan(patchdosePlanModel: PatchDosePlanRequestModel) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError>
}
