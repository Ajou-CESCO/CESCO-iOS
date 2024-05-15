//
//  RequestAPI.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import Foundation
import Moya

enum RequestAPI {
    case requestRelation(_ receiverPhone: String)
}

extension RequestAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .requestRelation:
            return "/api/request"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestRelation:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .requestRelation(let receiverPhone):
            return .requestJSONEncodable(["receiverPhone": receiverPhone])
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
