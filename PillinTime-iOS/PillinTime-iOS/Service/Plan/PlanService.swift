//
//  PlanService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import Foundation
import Moya
import CombineMoya
import Combine

class PlanService: PlanServiceType {
    let provider: MoyaProvider<PlanAPI>
    var cancellables = Set<AnyCancellable>()
    
    init(provider: MoyaProvider<PlanAPI>, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.provider = provider
        self.cancellables = cancellables
    }
    
    /// 약물 일정 등록 요청
    func addDosePlan(addDosePlanModel: AddDosePlanRequestModel) -> Bool {
        return true
    }
}
