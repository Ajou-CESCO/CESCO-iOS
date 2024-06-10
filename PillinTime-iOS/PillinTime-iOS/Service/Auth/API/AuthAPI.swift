//
//  AuthAPI.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/30/24.
//

import Foundation
import Moya

enum AuthAPI {
    case signIn(_ signInModel: SignInRequestModel)
    case signUp(_ signUpModel: SignUpRequestModel)
    case requestPhoneNumberConfirm(_ phoneNumber: String)
    case logout
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "/api/auth"
        case .signUp:
            return "/api/user"
        case.requestPhoneNumberConfirm:
            return "/api/auth/sms"
        case .logout:
            return "/api/auth/logout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .signIn, .requestPhoneNumberConfirm:
            return .post
        case .logout:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signIn(let signInModel):
            return .requestJSONEncodable(signInModel)
        case .signUp(let signUpModel):
            return .requestJSONEncodable(signUpModel)
        case .requestPhoneNumberConfirm(let phoneNumber):
            return .requestJSONEncodable(["phone": phoneNumber])
        case .logout:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .logout:
            return Config.headerWithAccessToken
        case .requestPhoneNumberConfirm, .signIn, .signUp:
            return Config.defaultHeader
        }
    }
}
