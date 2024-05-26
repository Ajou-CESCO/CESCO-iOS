//
//  FcmAPI.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/26/24.
//

import Foundation
import Moya

enum FcmAPI {
    case registerToken(_ fcmToken: String)
    case requestPushAlarm(_ targetId: Int)
}

extension FcmAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .registerToken:
            return "/api/fcm/token"
        case .requestPushAlarm:
            return "/api/fcm/push"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerToken, .requestPushAlarm:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .registerToken(let token):
            return .requestJSONEncodable(["fcmToken": token])
        case .requestPushAlarm(let id):
            return .requestJSONEncodable(["targetId": id])
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
