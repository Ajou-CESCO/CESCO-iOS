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
    func searchDose(name: String) -> AnyPublisher<SearchDoseResponseModel, PillinTimeError> {
        return provider.requestPublisher(.searchDose(name))
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
}
