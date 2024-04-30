//
//  AuthService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/18/24.
//

import Foundation
import Moya
import CombineMoya
import Combine

class AuthService: AuthServiceType {
    
    let provider: MoyaProvider<AuthAPI>
    var cancellables = Set<AnyCancellable>()
    
    init(provider: MoyaProvider<AuthAPI>, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.provider = provider
        self.cancellables = cancellables
    }
    
    /// 회원가입 요청
    func requestSignUp(signUpRequestModel: SignUpRequestModel) -> AnyPublisher<SignUpResponseModel, PillinTimeError> {
        return provider.requestPublisher(.signUp(signUpRequestModel))
            .tryMap { response in
                let decodedData = try response.map(SignUpResponseModel.self)
                if decodedData.message == "Internal Server Error" {
                    throw PillinTimeError.networkFail
                }
                return decodedData
            }
            .mapError { error in
                print("error:", error)
                return error as! PillinTimeError
            }
            .eraseToAnyPublisher()
    }
}
