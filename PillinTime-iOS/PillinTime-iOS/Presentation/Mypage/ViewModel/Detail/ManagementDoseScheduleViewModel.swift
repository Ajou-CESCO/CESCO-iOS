//
//  ManagementDoseScheduleViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/26/24.
//

import SwiftUI
import Combine

import Factory

struct ManagementDoseScheduleState {
    var failMessage: String = String()
}

class ManagementDoseScheduleViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.planService) var planService: PlanServiceType
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Input State
    
    @Subject var requestGetDosePlan: Int = Int()
    
    // MARK: - Output State
    
    @Subject var managementDoseScheduleState: ManagementDoseScheduleState = ManagementDoseScheduleState()
    @Published var dosePlanList: [GetDosePlanResponseModelResult] = []
    
    // MARK: - Other Data
    
    @Published var isNetworking: Bool = false
    @Published var isNetworkSucceed: Bool = false

    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    
    init(planService: PlanService) {
        self.planService = planService
        bindState()
    }
    
    // MARK: - Bind Method

    private func bindState() {
        $requestGetDosePlan.sink { [weak self] id in
            self?.requestGetDosePlanToServer(id)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Method
    
    func requestGetDosePlanToServer(_ memberId: Int) {
        print("복약 일정 계획 조회 시작")
        self.isNetworking = true
        planService.getDosePlan(memberId: memberId)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isNetworking = false
                switch completion {
                case .finished:
                    print("복약 일정 계획 조회 요청 완료")
                case .failure(let error):
                    print("복약 일정 계획 조회 실패: \(error)")
                    self.managementDoseScheduleState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                print("복약 일정 계획 조회 성공: ", result)
                guard let self = self else { return }
                self.dosePlanList = result.result
            })
            .store(in: &cancellables)
    }
}
