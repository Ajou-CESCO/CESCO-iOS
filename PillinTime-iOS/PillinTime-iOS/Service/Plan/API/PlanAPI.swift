//
//  PlanAPI.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation
import Moya

enum PlanAPI {
    case addDosePlan(_ addDosePlanModel: AddDosePlanRequestModel)
    case getDoseLog(_ memberId: Int)
    case getDosePlan(_ memberId: Int)
}

extension PlanAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .addDosePlan, .getDosePlan:
            return "/api/dose/plan"
        case .getDoseLog:
            return "/api/dose/log"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addDosePlan:
            return .post
        case .getDoseLog, .getDosePlan:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .addDosePlan(let addDosePlanModel):
            return .requestJSONEncodable(addDosePlanModel)
        case .getDoseLog(let memberId), .getDosePlan(let memberId):
            return .requestParameters(parameters: ["memberId": memberId],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
