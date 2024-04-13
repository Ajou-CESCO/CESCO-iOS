//
//  UserProfileValidationViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import Foundation
import Combine

import Factory

class UserProfileValidationViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.validationService) var validationService: ValidationServiceType
    var eventToRequestViewModel = PassthroughSubject<SignUpValidationViewModelEvent, Never>()
    var eventFromRequestViewModel: PassthroughSubject<SignUpRequestViewModelEvent, Never>?
    
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
            let isNameValid = self.validationService.isValidNameFormat($0.name)
            let isSsnValid = self.validationService.isValidSsnFormat($0.ssn)
            
            // 입력값이 형식 검사를 통과했음을 알림
            if isPhoneNumberValid {
                self.eventToRequestViewModel.send(.phoneNumberValid(phone: $0.phoneNumber))
            } 
            
            if isNameValid {
                self.eventToRequestViewModel.send(.nameValid(name: $0.name))
            }
            
            if isSsnValid {
                self.eventToRequestViewModel.send(.ssnValid(ssn: $0.ssn))
            }
            
            // 빈 값일 때는 에러메세지를 띄우지 않음
            infoErrorState.phoneNumberErrorMessage = isPhoneNumberValid || $0.phoneNumber.isEmpty ? "" : ValidationErrorMessage.invalidPhoneNumber.description
            infoErrorState.nameErrorMessage = isNameValid || $0.name.isEmpty ? "" : ValidationErrorMessage.invalidName.description
            infoErrorState.ssnErrorMessage = isSsnValid || $0.ssn.isEmpty ? "" : ValidationErrorMessage.invalidSsn.description
        }.store(in: &cancellables)
    }
    
    func bindEvent() {
        eventFromRequestViewModel?.sink { [weak self] (event: SignUpRequestViewModelEvent) in
            guard let self = self else { return }
            switch event {
            case .signUp:
                self.eventToRequestViewModel.send(.sendInfoForSignUp(info: self.infoState))
            }
        }.store(in: &cancellables)
    }
}
