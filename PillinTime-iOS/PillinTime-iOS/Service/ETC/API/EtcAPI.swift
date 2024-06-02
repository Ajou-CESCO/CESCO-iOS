//
//  ETCAPI.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation
import Moya

enum EtcAPI {
    case searchDose(memberId: Int, name: String)
    case initClient
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
        case .initClient:
            return "/api/init"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchDose, .initClient:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchDose(let memberId, let name):
            print(memberId, name)
            return .requestParameters(parameters: ["memberId": memberId, "name": name],
                                      encoding: URLEncoding.queryString)
        case .initClient:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
