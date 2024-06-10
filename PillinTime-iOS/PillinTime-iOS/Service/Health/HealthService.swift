//
//  HealthService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/3/24.
//

import Foundation
import Moya
import CombineMoya
import Combine

class HealthService: HealthServiceType {
    let provider: MoyaProvider<HealthAPI>
    var cancellables = Set<AnyCancellable>()
    
    init(provider: MoyaProvider<HealthAPI>, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.provider = provider
        self.cancellables = cancellables
    }
    
    // 건강 데이터 생성 요청
    func createHealthData(createHealthDataModel: CreateHealthDataModel) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError> {
        return provider.requestPublisher(.createHealthData(createHealthDataModel))
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
    
    // 건강 데이터 조회 요청
    func getHealthData(id: Int) -> AnyPublisher<GetHealthDateResponseModel, PillinTimeError> {
        return provider.requestPublisher(.getHealthData(id))
            .tryMap { response in
                print(response)
                let decodeData = try response.map(GetHealthDateResponseModel.self)
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
}
