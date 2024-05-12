//
//  DoseAddViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/7/24.
//

import Foundation
import Combine

import Factory

class DoseAddViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.planService) var planService: PlanServiceType
    
    // MARK: - Input State
    
    /// 검색하고자 하는 약물
    @Published var searchDose: String = String()
    /// 추가하고자 하는 복약 일정
    @Published var dosePlan: AddDosePlanRequestModel = AddDosePlanRequestModel()
    
    // MARK: - Output State
    
    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    
    init(planService: PlanService) {
        self.planService = planService
    }
    
    // MARK: - Other Data
    
    /// 사용자 입력 단계를 추적하는 변수
    ///
    /// - 1: 의약품명 검색
    /// - 2: 복용 요일 선택
    /// - 3: 복용 시간 선택
    @Published var step: Int = 1
    
    @Published var isDoseSelected: Bool = false

    /// 각 단계에서의 텍스트
    var mainText: String {
        switch step {
        case 1:
            return "의약품명을 검색해주세요"
        default:
            return "복용 주기가 어떻게 되나요?"
        }
    }
    
    var subText: String {
        switch step {
        case 1:
            return "검색 결과를 통해 해당하는 의약품을 선택해주세요."
        default:
            return ""
        }
    }
    
    // MARK: - Methods
    
    /// 다음 단계로 이동하는 함수
    func nextStep() {
        if step < 2 {
            step += 1
        }
    }
    
    /// 이전 단계로 돌아가는 함수
    func previousStep() {
        if step > 1 {
            step -= 1
        }
    }
}
