//
//  ETCAPI.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation
import Moya

enum EtcAPI {
    case searchDose(_ name: String)
}

extension EtcAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .searchDose:
            return "/api/medicine"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchDose:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchDose(let name):
            return .requestParameters(parameters: ["name": name],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
