//
//  AddPillCaseViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/9/24.
//

import Foundation
import Combine
import SwiftUI
import Factory

// MARK: - PillCaseInfoState

struct PillCaseInfoState {
    var ownerId: Int = Int()
    var serialNumber: String = String()
}

// MARK: - PillCaseInfoErrorState

struct PillCaseInfoErrorState {
    var serialNumberErrorMessage: String = String()
}

// MARK: - AddPillCaseEventModel

@frozen
enum AddPillCaseEventModel {
    case pillCaseInvalid
    case sendInfoForAddPillCase(_ info: PillCaseInfoState)
}

// MARK: - AddPillCaseViewModel

class AddPillCaseViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.caseService) var caseService: CaseServiceType
    var addPillCaseEventModel = PassthroughSubject<AddPillCaseEventModel, Never>()
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Properties

    let mainText: String = "약통의 시리얼 넘버"
    let subText: String = "약통에 적힌 시리얼 넘버 16자리를 입력해주세요."
    let placeholder: String = "시리얼 넘버 입력 (ex. 000000)"
    
    // MARK: - Input State

    @Published var infoState: PillCaseInfoState = PillCaseInfoState()
    @Subject var tapAddPillCaseButton: PillCaseInfoState = PillCaseInfoState()
    
    // MARK: - Output State
    
    @Published var isNetworking: Bool = false
    @Published var isNetworkSucceed: Bool = false
    @Published var infoErrorState: PillCaseInfoErrorState = PillCaseInfoErrorState()
    
    // MARK: - Other Data
    
//    @State var isAddButtonEnabled: Bool = true
    @Published var isAddSucced: Bool = false
    
    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(caseService: CaseService) {
        self.caseService = caseService
        self.bindState()
    }
    
    // MARK: - Methods
    
    private func bindState() {
        /// 약통 등록 요청
        $tapAddPillCaseButton.sink { [weak self] info in
            self?.requestAddPillCase(CreatePillCaseRequestModel(serial: info.serialNumber,
                                                                ownerID: info.ownerId))
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Methods
    
    func requestAddPillCase(_ createPillCaseModel: CreatePillCaseRequestModel) {
        print("약통 생성 요청 시작")
        print(createPillCaseModel)
        self.isNetworking = true
        caseService.createPillCaseRequest(createPillCaseRequestModel: createPillCaseModel)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("약통 생성 요청 완료")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isNetworking = false
                        self.isNetworkSucceed = true
                    }
                case .failure(let error):
                    print("--------------------")
                    print("약통 생성 요청 실패: \(error)")
                    self.isNetworking = false
                    self.infoErrorState.serialNumberErrorMessage = error.localizedDescription
                    toastManager.showNetworkFailureToast()
                }
            }, receiveValue: { [weak self] result in
                guard let result = self else { return }
                print(result)
            })
            .store(in: &cancellables)
        
    }
}
