//
//  FcmService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/26/24.
//

import Foundation
import Moya
import CombineMoya
import Combine

class FcmService: FcmServiceType {
    let provider: MoyaProvider<FcmAPI>
    var cancellables = Set<AnyCancellable>()
    
    init(provider: MoyaProvider<FcmAPI>, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.provider = provider
        self.cancellables = cancellables
    }
    
    /// fcm token 등록
    func registerToken(fcmToken: String) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError> {
        return provider.requestPublisher(.registerToken(fcmToken))
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
    
    /// 푸시 알람 요청
    func requestPushAlarm(targetId: Int) -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError> {
        return provider.requestPublisher(.requestPushAlarm(targetId))
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
}
