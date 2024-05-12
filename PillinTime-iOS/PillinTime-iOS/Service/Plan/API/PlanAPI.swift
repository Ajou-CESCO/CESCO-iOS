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
}

extension PlanAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .addDosePlan(let addDosePlanModel):
            return .requestJSONEncodable(addDosePlanModel)
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
