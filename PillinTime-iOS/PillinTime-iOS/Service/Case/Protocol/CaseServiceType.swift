//
//  CaseServiceType.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation
import Combine
import Moya

/// 약통 관련 API Service 입니다.
protocol CaseServiceType {
    
    /// 약통 생성 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - createUserRequestModel: 회원가입에 필요한 정보들을 담은 Model입니다.
    /// - Returns: 이후 수정
    func createPillCaseRequest(addDosePlanModel: AddDosePlanRequestModel) -> Bool
}
