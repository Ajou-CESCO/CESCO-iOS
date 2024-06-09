//
//  DoseScheduleStatusViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/9/24.
//

import SwiftUI
import Combine

import Moya
import Factory

struct DoseScheduleState {
    var failMessage: String = String()
}

struct SearchDoseResponseState {
    let id = UUID()
    var companyName: String = ""
    var medicineName: String = ""
    var medicineSeries: String = ""
    var medicineCode: String = ""
    var medicineImage: String = ""
    var medicineEffect: String = ""
    var useMethod: String = ""
    var useWarning: String = ""
    var useSideEffect: String = ""
    var depositMethod: String = ""
    var medicineAdverse: MedicineAdverse = MedicineAdverse(dosageCaution: "",
                                                           ageSpecificContraindication: "",
                                                           elderlyCaution: "",
                                                           administrationPeriodCaution: "",
                                                           pregnancyContraindication: "",
                                                           duplicateEfficacyGroup: "")
}

class DoseScheduleStatusViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.etcService) var etcService: EtcServiceType
    
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()

    // MARK: - Input State
    
    @Subject var requestGetDoseInfoById: String = String()
    
    // MARK: - Output State
    
    @Published var doseInfo: SearchDoseResponseState = SearchDoseResponseState()
    @Published var isNetworking: Bool = false
    @Published var showDoseInfoView: Bool = false {
        didSet {
            print("showDoseInfoView changed: \(showDoseInfoView)")
        }
    }
    
    // MARK: - Other Data
    
    @Published var doseScheduleState = DoseScheduleState()

    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    init(etcService: EtcService) {
        self.etcService = etcService
        bindState()
    }
    
    // MARK: - Bind Method
    
    private func bindState() {
        $requestGetDoseInfoById.sink { medicineId in
            self.requestGetDoseInfoByIdToServer(medicineId)
        }
        .store(in: &cancellables)
    }
    
    private func requestGetDoseInfoByIdToServer(_ medicineId: String) {
        print("약품 \(medicineId) 정보 요청 시작")
        self.isNetworking = true
        self.showDoseInfoView = true
        etcService.searchDoseById(medicineId: medicineId)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isNetworking = false
                switch completion {
                case .finished:
                    print("약품 \(medicineId) 정보 요청 완료")
                case .failure(let error):
                    print("약품 \(medicineId) 정보 요청 실패: \(error)")
                    self.doseScheduleState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.doseInfo = SearchDoseResponseState(companyName: result.result.companyName,
                                                        medicineName: result.result.medicineName,
                                                        medicineSeries: result.result.medicineSeries,
                                                        medicineCode: result.result.medicineCode,
                                                        medicineImage: result.result.medicineImage,
                                                        medicineEffect: result.result.medicineEffect,
                                                        useMethod: result.result.useMethod,
                                                        useWarning: result.result.useWarning,
                                                        useSideEffect: result.result.useSideEffect,
                                                        depositMethod: result.result.depositMethod,
                                                        medicineAdverse: result.result.medicineAdverse)
            })
            .store(in: &cancellables)
    }
}
