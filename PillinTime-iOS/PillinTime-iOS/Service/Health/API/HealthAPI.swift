//
//  HealthAPI.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/3/24.
//

import Foundation
import Moya

enum HealthAPI {
    case createHealthData(_ model: CreateHealthDataModel)
    case getHealthData(_ id: Int)
}

extension HealthAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .createHealthData:
            return "/api/health"
        case .getHealthData(let memberId):
            return "/api/health/\(String(memberId))"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createHealthData:
            return .post
        case .getHealthData:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createHealthData(let model):
            return .requestJSONEncodable(model)
        case .getHealthData:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
