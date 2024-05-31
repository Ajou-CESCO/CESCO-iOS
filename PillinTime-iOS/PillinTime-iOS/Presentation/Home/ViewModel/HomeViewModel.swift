//
//  HomeViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import SwiftUI
import Combine

import Factory

struct HomeState {
    var failMessage: String = String()
}

struct HealthInfoAction {
    var viewOnAppear = Subjected<Void>()
}

struct HealthInfoState {
    var stepCount: String = ""
    var burnCalories: String = ""
    var sleepTotal: String = ""
    var collectionDate: String = ""
}

class HomeViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.etcService) var etcService: EtcServiceType
    @Injected(\.planService) var planService: PlanServiceType
    @Injected(\.hkService) var hkService: HKServiceProtocol
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Input State
    
    @Subject var requestInitClient: Bool = false
    @Subject var requestGetDoseLog: Int = 0
    @Published var action = HealthInfoAction()
    
    // MARK: - Output State
    
    @Published var homeState: HomeState = HomeState()
    @Published var isNetworking: Bool = false
    @Published var isDataReady: Bool = false
    @Published var relationLists: [RelationList] = []
    @Published var doseLog: [GetDoseLogResponseModelResult] = []
    @Published var clientCabnetId: Int = 0
    @Published var state = HealthInfoState()

    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    
    init(etcService: EtcService, planService: PlanService) {
        self.etcService = etcService
        self.planService = planService
        bind()
        bindState()
    }
    
    // MARK: - Bind Method
    
    private func bind() {
        
        action
            .viewOnAppear
            .flatMap {
                self.hkService.getStepCount(date: DateHelper().getYesterdayStartAM(Date()))
                    .replaceError(with: 0)
                    .map { "\(Int($0)) 걸음"}
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.state.stepCount, on: self)
            .store(in: &cancellables)
    }
    
    private func bindState() {
        $requestInitClient.sink { _ in
            self.requestInitClientToServer()
        }
        .store(in: &cancellables)
        
        $requestGetDoseLog.sink { memberId in
            self.requestGetDoseLogToServer(memberId: memberId)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Method

    private func requestInitClientToServer() {
        print("사용자 초기 정보 요청 시작")
        self.isNetworking = true
        etcService.initClient()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isNetworking = false
                switch completion {
                case .finished:
                    print("사용자 초기 정보 요청 완료")
                case .failure(let error):
                    print("사용자 초기 정보 요청 실패: \(error)")
                    self.homeState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                UserManager.shared.memberId = result.result.memberID
                UserManager.shared.isManager = result.result.isManager
                self.clientCabnetId = result.result.cabinetID
                // relationList UserDefault에 저장
                UserDefaults.standard.set(try? PropertyListEncoder().encode(result.result.relationList), forKey: "relationLists")
                // relationList UserDefault 읽어오기
                if let data = UserDefaults.standard.value(forKey: "relationLists") as? Data {
                    let result = try? PropertyListDecoder().decode([RelationList].self, from: data)
                    print(result)
                }
                self.relationLists = result.result.relationList
                self.isDataReady = true
                
            })
            .store(in: &cancellables)
    }
    
    private func requestGetDoseLogToServer(memberId: Int) {
        print("memberId \(memberId) 복약 기록 요청 시작")
        planService.getDoseLog(memberId: memberId)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("memberId \(memberId) 복약 기록 요청 완료")
                case .failure(let error):
                    print("memberId \(memberId) 복약 기록 요청 실패: \(error)")
                    self.homeState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.doseLog = result.result
                print(self.doseLog)
            })
            .store(in: &cancellables)
    }
    
    func countLogs(filteringBy status: Int?) -> Int {
        guard let status = status else {
            return doseLog.count
        }
        return doseLog.filter { $0.takenStatus == status }.count
    }
}
