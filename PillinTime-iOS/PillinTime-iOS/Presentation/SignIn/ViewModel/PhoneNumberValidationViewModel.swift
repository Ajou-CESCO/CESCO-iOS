//
//  PhoneNumberValidationViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import Foundation
import Combine

import Factory

class PhoneNumberValidationViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.validationService) var validationService: ValidationServiceType
    var eventToRequestViewModel = PassthroughSubject<SignUpValidationViewModelEvent, Never>()
    var eventFromRequestViewModel: PassthroughSubject<SignUpRequestViewModelEvent, Never>? = nil
    
    // MARK: - Input State
    
    @Published var infoState: InfoState = InfoState()
    
    // MARK: - Output State
    
    @Published var infoErrorState: InfoErrorState = InfoErrorState()
    
    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    
    init(validationService: ValidationServiceType) {
        self.validationService = validationService
        self.bindState()
        self.bindEvent()
    }
    
    // MARK: - Method
    
    private func bindState() {
        $infoState.sink { [weak self] in
            guard let self = self else { return }
            
            // 형식 검사
            let isPhoneNumberValid = self.validationService.isValidPhoneNumberFormat($0.phoneNumber)
            
            // 모든 입력값이 형식 검사를 통과했음을 알림
            if isPhoneNumberValid {
                self.eventToRequestViewModel.send(.phoneNumberValid(phone: $0.phoneNumber))
            }
            
            // 빈 값일 때는 에러메세지를 띄우지 않음
            infoErrorState.phoneNumberErrorMessate = isPhoneNumberValid || $0.phoneNumber.isEmpty ? "" : ValidationErrorMessage.invalidPhoneNumber.description
        }.store(in: &cancellables)
    }
    
    func bindEvent() {
        eventFromRequestViewModel?.sink { [weak self] (event: SignUpRequestViewModelEvent) in
            guard let self = self else { return }
            switch event {
            case .signUp:
                self.eventToRequestViewModel.send(.sendInfoForSignUp(info: self.infoState))
                break
            }
        }.store(in: &cancellables)
    }
}
