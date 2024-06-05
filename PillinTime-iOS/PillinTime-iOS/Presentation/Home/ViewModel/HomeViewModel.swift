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

struct HealthInfoState {
    var stepCount: String = "-보"
    var sleepTotal: String = "-시간"
    var heartRate: String = "-BPM"
    var burnCalories: String = "-kcal"
    
    func asDictionary() -> [String: String] {
        return [
            "걸음 수": stepCount,
            "수면": sleepTotal,
            "심장박동수": heartRate,
            "활동량": burnCalories
        ]
    }
}

/// 서버에 전송하기 위해서 RawData로 저장
struct HealthInfoRawDataState {
    var stepCount: Int = 0
    var sleepTotal: Int = 0
    var heartRate: Int = 0
    var burnCalories: Int = 0
}

class HomeViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.etcService) var etcService: EtcServiceType
    @Injected(\.planService) var planService: PlanServiceType
    @Injected(\.hkService) var hkService: HKServiceProtocol
    @Injected(\.healthService) var healthService: HealthServiceType
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Input State
    
    @Subject var requestInitClient: Bool = false
    @Subject var requestGetDoseLog: Int = 0
    @Subject var requestGetHealthData: Int = 0
    @Subject var requestCreateHealthData: Void = ()
    
    // MARK: - Output State
    
    @Published var homeState: HomeState = HomeState()
    @Published var healthInfoState: HealthInfoState = HealthInfoState()
    @Published var isNetworking: Bool = false
    @Published var isDataReady: Bool = false
    @Published var relationLists: [RelationList] = []
    @Published var doseLog: [GetDoseLogResponseModelResult] = []
    @Published var healthData: GetHealthDateResponseModelResult?
    @Published var clientCabnetId: Int = 0
    @Published var occupiedCabinetIndex: [Int] = []
    
    @Published var state = HealthInfoState()
    @Published var rawDataState = HealthInfoRawDataState()
    
    // MARK: - Other Data
    var requestToHK: Bool = false    // HK에게 요청 한 번만 하기 위해서

    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    
    init(etcService: EtcService, planService: PlanService, healthService: HealthService) {
        self.etcService = etcService
        self.planService = planService
        self.healthService = healthService
        bindState()
    }
    
    // MARK: - Bind Method
    
    private func bindState() {
        $requestInitClient.sink { _ in
            self.requestInitClientToServer()
        }
        .store(in: &cancellables)
        
        $requestGetDoseLog.sink { memberId in
            self.requestGetDoseLogToServer(memberId: memberId)
        }
        .store(in: &cancellables)
        
        $requestGetHealthData.sink { memberId in
            self.requestGetHealthDataToServer(memberId: memberId)
        }
        .store(in: &cancellables)
        
        $requestCreateHealthData.sink { _ in
            self.requestHealthDataToHK()
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
    
    private func requestHealthDataToHK() {
        let stepCountPublisher = self.hkService.getStepCount(date: DateHelper().getYesterdayStartAM(Date()))
            .replaceError(with: 0)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] stepCount in
                guard let self = self else { return }
                self.state.stepCount = "\(Int(stepCount))보"
                self.rawDataState.stepCount = Int(stepCount)
            })
            .eraseToAnyPublisher()
        
        let sleepRecordPublisher = self.hkService.getSleepRecord(date: self.yesterday)
            .replaceError(with: 0)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] sleepTotal in
                guard let self = self else { return }
                self.state.sleepTotal = "\(Int(sleepTotal / 60))시간"
                self.rawDataState.sleepTotal = Int(sleepTotal / 60)
            })
            .eraseToAnyPublisher()
        
        let energyPublisher = self.hkService.getEnergy(date: self.yesterday)
            .replaceError(with: 0)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] burnCalories in
                guard let self = self else { return }
                self.state.burnCalories = "\(Int(burnCalories))kcal"
                self.rawDataState.burnCalories = Int(burnCalories)
            })
            .eraseToAnyPublisher()
        
        let heartRatePublisher = self.hkService.getHeartRate(date: self.yesterday)
            .replaceError(with: [0])
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] heartRates in
                guard let self = self else { return }
                let averageHeartRate = heartRates.reduce(0, +) / Double(heartRates.count)
                self.state.heartRate = "\(Int(averageHeartRate))BPM"
                self.rawDataState.heartRate = Int(averageHeartRate)
            })
            .eraseToAnyPublisher()
        
        /// 한 번 데이터 수집을 시작하면 true
        self.requestToHK = true
        
        /// 데이터를 전부 수집해야지만 서버로 요청
        Publishers.Zip4(stepCountPublisher, sleepRecordPublisher, energyPublisher, heartRatePublisher)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("모든 데이터 수집 완료")
                case .failure(let error):
                    print("데이터수집 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] (_, _, _, _) in
                guard let self = self else { return }
                self.createHealthDataToServer()
            })
            .store(in: &cancellables)
    }
    
    private func requestGetHealthDataToServer(memberId: Int) {
        print("memberId \(memberId) 건강 데이터 요청 시작")
        healthService.getHealthData(id: memberId)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("memberId \(memberId) 건강 데이터 요청 완료")
                case .failure(let error):
                    print("memberId \(memberId) 건강 데이터 요청 실패: \(error)")
                    self.homeState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.healthData = result.result
                self.state = HealthInfoState(stepCount: "\(String(result.result?.steps ?? 0))보",
                                           sleepTotal: "\(String(result.result?.sleepTime ?? 0))시간",
                                           heartRate: "\(String(result.result?.heartRate ?? 0))BPM",
                                           burnCalories: "\(String(result.result?.calorie ?? 0))kcal")
                print(self.healthInfoState)
                // healthData가 빈 값일 때만 bindHealth() 함수들 실행
                if (self.healthData?.isEmpty ?? true) && (!(UserManager.shared.isManager ?? false)) && !self.requestToHK {
                    self.requestHealthDataToHK()
                }
            })
            .store(in: &cancellables)
    }
    
    private func createHealthDataToServer() {
        print("건강 데이터 생성 요청 시작")
        healthService.createHealthData(createHealthDataModel: CreateHealthDataModel(steps: rawDataState.stepCount,
                                                                                    sleepTime: rawDataState.sleepTotal,
                                                                                    calorie: rawDataState.burnCalories,
                                                                                    heartRate: rawDataState.heartRate))
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("건강 데이터 생성 요청 완료")
                case .failure(let error):
                    print("건강 데이터 생성 요청 실패: \(error)")
                    self.homeState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                // 건강 데이터를 생성했으므로 그 결과를 받아야 함
                self.requestGetHealthDataToServer(memberId: UserManager.shared.memberId ?? 0)
            })
            .store(in: &cancellables)
    }

    // MARK: - Methods
    
    func countLogs(filteringBy status: Int?) -> Int {
        guard let status = status else {
            return doseLog.count
        }
        return doseLog.filter { $0.takenStatus == status }.count
    }
    
    var yesterday: Date {
        DateHelper
            .subtractDays(from: Date(), days: 1)
    }
}
