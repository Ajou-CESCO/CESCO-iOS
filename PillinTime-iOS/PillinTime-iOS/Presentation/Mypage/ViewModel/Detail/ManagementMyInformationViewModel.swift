//
//  ManagementMyInformationView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/2/24.
//

import Foundation
import Combine
import SwiftUI
import Factory

// MARK: - DeletePillCaseState

struct DeletePillCaseState {
    var failMessage: String = String()
}

// MARK: - ManagementMyInformationViewModel

class ManagementMyInformationViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.caseService) var caseService: CaseServiceType
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Input State

    @Subject var tapDeletePillCaseButton: Int = Int()
    
    // MARK: - Output State
    
    @Published var isNetworking: Bool = false
    @Published var isNetworkSucceed: Bool = false
    @Published var infoErrorState: DeletePillCaseState = DeletePillCaseState()
    @Published var isDeleteSucced: Bool = false
    
    // MARK: - Other Data

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
        $tapDeletePillCaseButton.sink { [weak self] cabinetId in
            self?.requestDeletePillCase(cabinetId)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Methods
    
    func requestDeletePillCase(_ cabinetId: Int) {
        print("약통 삭제 요청 시작")
        self.isNetworking = true
        caseService.deletePillCaseRequest(cabineId: cabinetId)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("약통 삭제 요청 완료")
                    self.isDeleteSucced = true
                case .failure(let error):
                    print("약통 삭제 요청 실패: \(error)")
                    self.isNetworking = false
                    self.infoErrorState.failMessage = error.localizedDescription
                    toastManager.showToast(description: "연결된 약통이 존재하지 않습니다.")
                }
            }, receiveValue: { [weak self] result in
                guard let result = self else { return }
                print(result)
            })
            .store(in: &cancellables)
    }
}
