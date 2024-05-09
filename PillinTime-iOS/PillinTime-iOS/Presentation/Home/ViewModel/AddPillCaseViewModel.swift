//
//  AddPillCaseViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/9/24.
//

import Foundation
import Combine
import SwiftUI

// MARK: - PillCaseInfoState

struct PillCaseInfoState {
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
    case sendInfoForAddPillCase
}

// MARK: - AddPillCaseViewModel

class AddPillCaseViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    var addPillCaseEventModel = PassthroughSubject<AddPillCaseEventModel, Never>()
    
    // MARK: - Properties

    let mainText: String = "약통의 시리얼 넘버"
    let subText: String = "약통에 적힌 시리얼 넘버를 입력해주세요."
    let placeholder: String = "시리얼 넘버 입력 (ex. 000000)"
    
    // MARK: - Input State

    @Published var infoState: PillCaseInfoState = PillCaseInfoState()
    @Subject var tapAddPillCaseButton: Void = ()
    
    // MARK: - Output State
    
    @Published var infoErrorState: PillCaseInfoErrorState = PillCaseInfoErrorState()
    
    // MARK: - Other Data
    
//    @State var isAddButtonEnabled: Bool = true
    @Published var isAddSucced: Bool = false
    
    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init() {
        self.bindState()
        self.bindEvent()
    }
    
    // MARK: - Methods
    
    private func bindState() {
        /// 약통 등록 요청
        $tapAddPillCaseButton.sink { [weak self] in
            self?.addPillCaseEventModel.send(.sendInfoForAddPillCase)
        }
        .store(in: &cancellables)
        
        /// 버튼 활성화 여부
//        $infoState.sink { [weak self] state in
//            guard let self = self else { return }
//            
//            if state.serialNumber.isEmpty {
//                self.isAddButtonEnabled = false
//            }
//        }
//        .store(in: &cancellables)
    }
    
    private func bindEvent() {
        addPillCaseEventModel.sink { [weak self] (event: AddPillCaseEventModel) in
            guard let self = self else { return }
            
            switch event {
            case .pillCaseInvalid:
                
                return
            case .sendInfoForAddPillCase:
                return requestAddPillCase()
            }
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Methods
    
    func requestAddPillCase() {
        // MARK: - TODO
        print("서버 요청")
    }
}
