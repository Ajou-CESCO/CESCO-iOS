//
//  UserAPI.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/26/24.
//

import Foundation
import Moya

enum UserAPI {
    case deleteUser
}

extension UserAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .deleteUser:
            return "/api/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .deleteUser:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .deleteUser:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
