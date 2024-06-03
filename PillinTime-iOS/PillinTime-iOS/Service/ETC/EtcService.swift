//
//  EtcService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation
import Moya
import CombineMoya
import Combine

class EtcService: EtcServiceType {
    let provider: MoyaProvider<EtcAPI>
    var cancellables = Set<AnyCancellable>()
    
    init(provider: MoyaProvider<EtcAPI>, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.provider = provider
        self.cancellables = cancellables
    }
    
    /// 약물 검색 요청
    func searchDose(memberId: Int, name: String) -> AnyPublisher<SearchDoseResponseModel, PillinTimeError> {
        return provider.requestPublisher(.searchDose(memberId: memberId, name: name))
            .tryMap { response in
                let decodeData = try response.map(SearchDoseResponseModel.self)
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
    
    /// 사용자 초기 정보
    func initClient() -> AnyPublisher<InitResponseModel, PillinTimeError> {
        return provider.requestPublisher(.initClient)
            .tryMap { response in
                let decodeData = try response.map(InitResponseModel.self)
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
    
    func bugReport(body: String) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError> {
        return provider.requestPublisher(.bugReport(body))
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
