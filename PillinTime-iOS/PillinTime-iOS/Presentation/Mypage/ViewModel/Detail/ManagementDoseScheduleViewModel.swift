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

struct DeleteDoseScheduleState {
    var memberId: Int = Int()
    var medicineId: String = String()
    var cabinetIndex: Int = Int()
}

class ManagementDoseScheduleViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.planService) var planService: PlanServiceType
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    @ObservedObject var homeViewModel: HomeViewModel = Container.shared.homeViewModel.resolve()
    
    // MARK: - Input State
    
    @Subject var requestGetDosePlan: Int = Int()
    @Subject var requestDeleteDosePlan: DeleteDoseScheduleState = DeleteDoseScheduleState()
    
    // MARK: - Output State
    
    @Subject var managementDoseScheduleState: ManagementDoseScheduleState = ManagementDoseScheduleState()
    @Published var dosePlanList: [GetDosePlanResponseModelResult] = []
    
    // MARK: - Other Data
    
    @Published var isNetworking: Bool = false
    @Published var isNetworkSucceed: Bool = false
    @Published var isDeleteSucceed: Bool = false

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
        
        $requestDeleteDosePlan.sink { [weak self] plan in
            self?.requestDeletePlanToServer(plan)
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
                    toastManager.showNetworkFailureToast()
                }
            }, receiveValue: { [weak self] result in
                print("복약 일정 계획 조회 성공: ", result)
                guard let self = self else { return }
                self.dosePlanList = result.result
                self.homeViewModel.occupiedCabinetIndex = dosePlanList.map { $0.cabinetIndex }
            })
            .store(in: &cancellables)
    }
    
    func requestDeletePlanToServer(_ plan: DeleteDoseScheduleState) {
        print("복약 일정 계획 삭제 시작")
        planService.deleteDosePlan(memberId: plan.memberId, medicineId: plan.medicineId, cabinetIndex: plan.cabinetIndex)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("복약 일정 계획 삭제 요청 완료")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isDeleteSucceed = true
                    }

                case .failure(let error):
                    print("복약 일정 계획 삭제 실패: \(error)")
                    self.managementDoseScheduleState.failMessage = error.localizedDescription
                    toastManager.showNetworkFailureToast()
                }
            }, receiveValue: { [weak self] result in
                print("복약 일정 계획 삭제 성공: ", result)
                guard let self = self else { return }
            })
            .store(in: &cancellables)
    }
}
