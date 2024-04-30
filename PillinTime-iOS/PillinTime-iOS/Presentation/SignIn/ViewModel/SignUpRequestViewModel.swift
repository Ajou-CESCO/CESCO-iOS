//
//  SignUpRequestViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import Foundation
import Combine

import Factory

class SignUpRequestViewModel: ObservableObject {
    
    // MARK: - Dependency
    
    @Injected(\.authService) var authService: AuthServiceType
    var eventToValidationViewModel = PassthroughSubject<SignUpRequestViewModelEvent, Never>()
    var eventFromValidationViewModel: PassthroughSubject<SignUpValidationViewModelEvent, Never>?
    
    // MARK: - Input State
    @Subject var tapSignUpButton: Void = ()
    
    // MARK: - Output State
    @Published var signUpState: SignUpState = SignUpState()
    
    // MARK: - Other Data
    
    // MARK: - Cancellable Bag
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructor
    
    init(authService: AuthService) {
        self.authService = authService
        self.bindState()
        self.bindEvent()
    }
    
    // MARK: - Bind Method
    
    private func bindState() {
        // 회원가입에 해당하는 버튼 (프로필 생성 후 마지막 다음 버튼을 누를 경우) input 정보를 받아오기 위해 ValidationViewModel에 요청 보내기
        $tapSignUpButton.sink { [weak self] in
            self?.eventToValidationViewModel.send(.signUp)
        }
        .store(in: &cancellables)
    }
    
    func bindEvent() {
        eventFromValidationViewModel?.sink { [weak self] (event: SignUpValidationViewModelEvent) in
            guard let self = self else { return }
            
            switch event {
            case .phoneNumberValid:
                return
            case .phoneNumberInvalid:
                return
            case .nameValid:
                return
            case .nameInvalid:
                return
            case .ssnValid:
                return
            case .ssnInvalid:
                return
            case .sendInfoForSignUp(let info):
                self.requestSignUp(SignUpRequestModel(name: info.name,
                                                      ssn: String(info.ssn.prefix(8)),
                                                      phone: info.phoneNumber,
                                                      userType: 0))
            }
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Request Method
    
    func requestSignUp(_ signUpModel: SignUpRequestModel) {
        print("회원가입 요청 시작: \(signUpModel)")
        authService.requestSignUp(signUpRequestModel: signUpModel)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("회원가입 요청 완료")
                case .failure(let error):
                    print("회원가입 요청 실패: \(error)")
                    self.signUpState.failMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] result in
                print("회원가입 성공", result)
                guard let self = self else { return }
                self.signUpState.failMessage = String()
            })
            .store(in: &cancellables)
    }
}
