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
        case .createCase:
            return "/api/cabinet"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createCase:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createCase(let createPillCaseRequestModel):
            return .requestJSONEncodable(createPillCaseRequestModel)
        }
    }
    
    var headers: [String: String]? {
        return Config.headerWithAccessToken
    }
}
