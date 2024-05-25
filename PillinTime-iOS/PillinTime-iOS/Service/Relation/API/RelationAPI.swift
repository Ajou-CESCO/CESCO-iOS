//
//  RelationAPI.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/25/24.
//

import Foundation
import Moya

enum RelationAPI {
    case createRelation(_ id: Int)
}

extension RelationAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .createRelation:
            return "/api/relation"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createRelation:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createRelation(let id):
            return .requestParameters(parameters: ["requestId": id],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
