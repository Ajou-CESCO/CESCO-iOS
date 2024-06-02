//
//  CaseAPI.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/16/24.
//

import Foundation
import Moya

enum CaseAPI {
    case createCase(_ createPillCaseRequestModel: CreatePillCaseRequestModel)
    case deleteCase(_ cabinetId: String)
}

extension CaseAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .createCase, .deleteCase:
            return "/api/cabinet"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createCase:
            return .post
        case .deleteCase:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createCase(let createPillCaseRequestModel):
            return .requestJSONEncodable(createPillCaseRequestModel)
        case .deleteCase(let cabinetId):
            return .requestParameters(parameters: ["cabinetId": cabinetId], 
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
