//
//  PlanService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation
import Moya
import CombineMoya
import Combine

class PlanService: PlanServiceType {

    let provider: MoyaProvider<PlanAPI>
    var cancellables = Set<AnyCancellable>()
    
    init(provider: MoyaProvider<PlanAPI>, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.provider = provider
        self.cancellables = cancellables
    }
    
    /// 약물 일정 등록 요청
    func addDosePlan(addDosePlanModel: AddDosePlanRequestModel) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError> {
        return provider.requestPublisher(.addDosePlan(addDosePlanModel))
            .tryMap { response in
                guard let httpResponse = response.response, httpResponse.statusCode == 200 else {
                    let errorResponse = try response.map(BaseResponse<BlankData>.self)
                    throw PillinTimeError.networkFail
                }
                return try response.map(BaseResponse<BlankData>.self)
            }
            .mapError { error in
                print("error:", error)
                if error is MoyaError {
                    return PillinTimeError.networkFail
                } else {
                    return error as! PillinTimeError
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// 약물 복용 기록 조회
    func getDoseLog(memberId: Int) -> AnyPublisher<GetDoseLogResponseModel, PillinTimeError> {
        return provider.requestPublisher(.getDoseLog(memberId))
            .tryMap { response in
                let decodeData = try response.map(GetDoseLogResponseModel.self)
                return decodeData
            }
            .mapError { error in
                print("error:", error)
                if error is MoyaError {
                    return PillinTimeError.networkFail
                } else {
                    return error as! PillinTimeError
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// 약물 복용 계획 조회
    func getDosePlan(memberId: Int) -> AnyPublisher<GetDosePlanResponseModel, PillinTimeError> {
        return provider.requestPublisher(.getDosePlan(memberId))
            .tryMap { response in
                let decodeData = try response.map(GetDosePlanResponseModel.self)
                return decodeData
            }
            .mapError { error in
                print("error:", error)
                if error is MoyaError {
                    return PillinTimeError.networkFail
                } else {
                    return error as! PillinTimeError
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// 약물 복용 계획 삭제
    func deleteDosePlan(memberId: Int, medicineId: String, cabinetIndex: Int) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError> {
        return provider.requestPublisher(.deleteDosePlan(memberId: memberId, medicineId: medicineId, cabinetIndex: cabinetIndex))
            .tryMap { response in
                print(response)
                guard let httpResponse = response.response, httpResponse.statusCode == 200 else {
                    let errorResponse = try response.map(BaseResponse<BlankData>.self)
                    throw PillinTimeError.networkFail
                }
                return try response.map(BaseResponse<BlankData>.self)
            }
            .mapError { error in
                print("error:", error)
                if error is MoyaError {
                    return PillinTimeError.networkFail
                } else {
                    return error as! PillinTimeError
                }
            }
            .eraseToAnyPublisher()
    }
}

