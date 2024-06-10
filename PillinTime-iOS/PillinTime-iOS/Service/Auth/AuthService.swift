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
    
    /// 로그인 요청
    func requestSignIn(signInRequestModel: SignInRequestModel) -> AnyPublisher<SignInResponseModel, AuthError> {
        return provider.requestPublisher(.signIn(signInRequestModel))
            .tryMap { response in
                let decodedData = try response.map(SignInResponseModel.self)
                if decodedData.status == 404 {
                    throw AuthError.signIn(.userNotFound)
                }
                return decodedData
            }
            .mapError { error in
                print("error:", error)
                if error is MoyaError {
                    return AuthError.signIn(.userNotFound)
                } else {
                    return error as! AuthError
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// 회원가입 요청
    func requestSignUp(signUpRequestModel: SignUpRequestModel) -> AnyPublisher<SignUpResponseModel, AuthError> {
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
                if error is MoyaError {
                    return AuthError.signUp(.userNotFound)
                } else {
                    return error as! AuthError
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// 전화번호 인증 요청
    func requestPhoneNumberConfirm(phoneNumber: String) -> AnyPublisher<PhoneNumberVerificationResponseModel, AuthError> {
        return provider.requestPublisher(.requestPhoneNumberConfirm(phoneNumber))
            .tryMap { response in
                let decodedData = try response.map(PhoneNumberVerificationResponseModel.self)
                return decodedData
            }
            .mapError { error in
                print("error:", error)
                if error is MoyaError {
                    return AuthError.phoneNumberVerification(.sendPhoneNumberConfirmFailed)
                } else {
                    return error as! AuthError
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// 로그아웃 요청
    func logout() -> AnyPublisher<BaseResponse<BlankData>, PillinTimeError> {
        return provider.requestPublisher(.logout)
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
