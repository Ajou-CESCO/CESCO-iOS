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
    case getDoseLog(_ memberId: Int, _ date: String?)
    case getDosePlan(_ memberId: Int)
    case deleteDosePlan(memberId: Int, groupId: Int)
    case patchDosePlan(_ patchDosePlan: PatchDosePlanRequestModel)
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
        case .addDosePlan, .getDosePlan, .deleteDosePlan, .patchDosePlan:
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
        case .deleteDosePlan:
            return .delete
        case .patchDosePlan:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .addDosePlan(let addDosePlanModel):
            return .requestJSONEncodable(addDosePlanModel)
        case .patchDosePlan(let patchDosePlanModel):
            return .requestJSONEncodable(patchDosePlanModel)
        case .getDoseLog(let memberId, let date):
            var parameters: [String: Any] = ["memberId": memberId]
            if let date = date {
                parameters["date"] = date
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getDosePlan(let memberId):
            return .requestParameters(parameters: ["memberId": memberId],
                                      encoding: URLEncoding.queryString)
        case .deleteDosePlan(let memberId, let groupId):
            return .requestParameters(parameters: ["memberId": memberId, "groupId": groupId],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
