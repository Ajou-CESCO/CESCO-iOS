//
//  DoseAddViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/7/24.
//

import SwiftUI
import Combine

import Factory

struct AddDosePlanInfoState {
    var memberID: Int = Int()
    var medicineID: String = String()
    var weekdayList: [Int] = []
    var timeList: [String] = []
    var startAt: String = String()
    var endAt: String = String()
    var cabinetIndex: Int = Int()
}

struct RequestAddDosePlanState {
    var failMessage: String = String()
}

class DoseAddViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.planService) var planService: PlanServiceType
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Input State
    
    /// 검색하고자 하는 약물
    @Published var searchDose: String = ""
    /// 추가하고자 하는 복약 일정
    @Published var dosePlanInfoState: AddDosePlanInfoState = AddDosePlanInfoState()
    
    @Subject var requestAddDosePlan: Bool = false
    
    // MARK: - Output State
    
    @Published var requestAddDosePlanState: RequestAddDosePlanState = RequestAddDosePlanState()
    @Published var isNetworking: Bool = false
    @Published var isNetworkSucceed: Bool = false
    
    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    
    init(planService: PlanService) {
        self.planService = planService
        bindState()
    }
    
    // MARK: - Other Data
    
    /// 사용자 입력 단계를 추적하는 변수
    ///
    /// - 1: 의약품명 검색
    /// - 2: 복용 요일 선택
    /// - 3: 복용 시간 선택
    /// - 4: 복용 기간 선택
    @Published var step: Int = 1
    
    @Published var isDoseSelected: Bool = false

    /// 각 단계에서의 텍스트
    var mainText: String {
        switch step {
        case 1:
            return "의약품명을 검색해주세요"
        case 2, 3:
            return "복용 주기가 어떻게 되나요?"
        case 4:
            return "언제까지 복용하나요?"
        default:
            return "약통 칸을 선택해주세요"
        }
    }
    
    var subText: String {
        switch step {
        case 1:
            return "검색 결과를 통해 해당하는 의약품을 선택해주세요"
        case 2, 3:
            return ""
        case 4:
            return "시작일과 종료일을 선택해주세요"
        default:
            return "약을 담을 칸의 색상을 선택해주세요"
        }
    }
    
    var progress: Float {
        switch step {
        case 1:
            return 0.2
        case 2:
            return 0.4
        case 3:
            return 0.6
        case 4:
            return 0.8
        default:
            return 1
        }
    }
    
    // MARK: - Bind Method
    
    private func bindState() {
        $requestAddDosePlan.sink { _ in
            self.requestAddDosePlanToServer(AddDosePlanRequestModel(memberID: self.dosePlanInfoState.memberID,
                                                                    medicineID: self.dosePlanInfoState.medicineID,
                                                                    weekdayList: self.dosePlanInfoState.weekdayList,
                                                                    timeList: self.dosePlanInfoState.timeList,
                                                                    startAt: self.dosePlanInfoState.startAt,
                                                                    endAt: self.dosePlanInfoState.endAt,
                                                                    cabinetIndex: self.dosePlanInfoState.cabinetIndex))
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Method
    
    private func requestAddDosePlanToServer(_ addDosePlanModel: AddDosePlanRequestModel) {
        print("복용 계획 생성 요청 시작")
        print(addDosePlanModel)
        self.isNetworking = true
        planService.addDosePlan(addDosePlanModel: addDosePlanModel)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("복용 계획 생성 요청 완료")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        self.isNetworking = false
                        self.isNetworkSucceed = true
                    }
                case .failure(let error):
                    print("복용 계획 생성 요청 요청 실패: \(error)")
                    self.toastManager.showToast(description: "복용 계획 생성 요청 실패")
                    self.requestAddDosePlanState.failMessage = error.localizedDescription
                    self.isNetworking = false

                }
            }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
            })
            .store(in: &cancellables)
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
