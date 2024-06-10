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
    var groupId: Int = Int()
}

struct PatchDosePlanInfoState {
    var groupID: Int = Int()
    var memberID: Int = Int()
    var medicineID: String = String()
    var medicineName: String = String()
    var medicineSeries: String = String()
    var medicineAdverse: MedicineAdverse = MedicineAdverse(dosageCaution: nil,
                                                          ageSpecificContraindication: nil,
                                                          elderlyCaution: nil,
                                                          administrationPeriodCaution: nil,
                                                          pregnancyContraindication: nil,
                                                          duplicateEfficacyGroup: nil)
    var weekdayList: [Int] = []
    var timeList: [String] = []
    var startAt: String = String()
    var endAt: String = String()
    var cabinetIndex: Int = Int()
}

class ManagementDoseScheduleViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.planService) var planService: PlanServiceType
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Input State
    
    @Subject var requestGetDosePlan: Int = Int()
    @Subject var requestDeleteDosePlan: DeleteDoseScheduleState = DeleteDoseScheduleState()
    @Subject var requestPatchDosePlan: Void = ()
    
    // MARK: - Output State
    
    @Subject var managementDoseScheduleState: ManagementDoseScheduleState = ManagementDoseScheduleState()
    @Published var dosePlanList: [GetDosePlanResponseModelResult] = []
    @Subject var patchInfoViewModelState: PatchDosePlanInfoState = PatchDosePlanInfoState()  // 수정할 정보를 담아놓을 공간
    
    // MARK: - Other Data
    
    @Published var isNetworking: Bool = false
    @Published var isNetworkSucceed: Bool = false
    @Published var isDeleteSucceed: Bool = false
    
    @Published var isEditNetworking: Bool = false
    @Published var isEditNetworkSucced: Bool = false

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
        
        $requestPatchDosePlan.sink { [weak self] plan in
            self?.requestPatchDosePlanToServer()
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
            })
            .store(in: &cancellables)
    }
    
    func requestDeletePlanToServer(_ plan: DeleteDoseScheduleState) {
        print("복약 일정 계획 삭제 시작")
        self.isNetworking = true
        planService.deleteDosePlan(memberId: plan.memberId, groupId: plan.groupId)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isNetworking = false
                switch completion {
                case .finished:
                    print("복약 일정 계획 삭제 요청 완료")
                    self.isDeleteSucceed = true
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
    
    func requestPatchDosePlanToServer() {
        print("복약 일정 계획 수정 시작")
        self.isEditNetworking = true
        print(PatchDosePlanRequestModel(groupID: patchInfoViewModelState.groupID,
                                       memberID: patchInfoViewModelState.memberID,
                                       medicineID: patchInfoViewModelState.medicineID,
                                       medicineName: patchInfoViewModelState.medicineName,
                                       medicineSeries: patchInfoViewModelState.medicineSeries,
                                       medicineAdverse: patchInfoViewModelState.medicineAdverse,
                                       cabinetIndex: patchInfoViewModelState.cabinetIndex,
                                       weekdayList: patchInfoViewModelState.weekdayList,
                                       timeList: patchInfoViewModelState.timeList,
                                       startAt: patchInfoViewModelState.startAt))
        planService.patchDosePlan(patchdosePlanModel: PatchDosePlanRequestModel(groupID: patchInfoViewModelState.groupID,
                                                                                memberID: patchInfoViewModelState.memberID,
                                                                                medicineID: patchInfoViewModelState.medicineID,
                                                                                medicineName: patchInfoViewModelState.medicineName,
                                                                                medicineSeries: patchInfoViewModelState.medicineSeries,
                                                                                medicineAdverse: patchInfoViewModelState.medicineAdverse,
                                                                                cabinetIndex: patchInfoViewModelState.cabinetIndex,
                                                                                weekdayList: patchInfoViewModelState.weekdayList,
                                                                                timeList: patchInfoViewModelState.timeList,
                                                                                startAt: patchInfoViewModelState.startAt))

            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("복약 일정 계획 수정 요청 완료")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.isEditNetworking = false
                        self.isEditNetworkSucced = true
                    })
                case .failure(let error):
                    print("복약 일정 계획 수정 실패: \(error)")
                    self.managementDoseScheduleState.failMessage = error.localizedDescription
                    toastManager.showNetworkFailureToast()
                }
            }, receiveValue: { [weak self] result in
                print("복약 일정 계획 수정 성공: ", result)
                guard let self = self else { return }
            })
            .store(in: &cancellables)
    }
}
