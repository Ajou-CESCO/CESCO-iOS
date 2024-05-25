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
    case getRelation
    case deleteRelation(_ id: Int)
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
        case .createRelation, .deleteRelation, .getRelation:
            return "/api/relation"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createRelation:
            return .post
        case .getRelation:
            return .get
        case .deleteRelation:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createRelation(let id):
            return .requestParameters(parameters: ["requestId": id],
                                      encoding: URLEncoding.queryString)
        case .getRelation:
            return .requestPlain
        case .deleteRelation(let id):
            return .requestParameters(parameters: ["relationId": id],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
