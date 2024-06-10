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
    case relationRequestList
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
        case .requestRelation, .relationRequestList:
            return "/api/request"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestRelation:
            return .post
        case .relationRequestList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .requestRelation(let receiverPhone):
            return .requestJSONEncodable(["receiverPhone": receiverPhone])
        case .relationRequestList:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
