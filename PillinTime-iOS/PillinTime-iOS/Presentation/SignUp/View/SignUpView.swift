//
//  SignUpView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/1/24.
//

import SwiftUI
import Combine

import Moya
import LinkNavigator

struct SignUpView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    let navigator: LinkNavigatorType

    @State private var selectedRole: Int = 2
    @State private var isButtonDisabled: Bool = false
    @State private var isAuthSuccessed: Bool = false
    
    @ObservedObject var signUpRequestViewModel: SignUpRequestViewModel      // 회원가입 request
    @ObservedObject var userProfileViewModel: CreateUserProfileViewModel    // view의 정보를 갖고 있는 view model
    @ObservedObject var validationViewModel: UserProfileValidationViewModel // 유효성 검사를 위한 view model
    
    // MARK: - Initializer
        
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator

        self.userProfileViewModel = CreateUserProfileViewModel()
        self.validationViewModel = UserProfileValidationViewModel(validationService: ValidationService())
        self.signUpRequestViewModel = SignUpRequestViewModel(authService: AuthService(provider: MoyaProvider<AuthAPI>()))
        
        self.validationViewModel.eventFromRequestViewModel = self.signUpRequestViewModel.eventToValidationViewModel
        self.signUpRequestViewModel.eventFromValidationViewModel = self.validationViewModel.eventToRequestViewModel
        
        self.signUpRequestViewModel.bindEvent()
        self.validationViewModel.bindEvent()
    }
    
    // MARK: - body
    
    var body: some View {
        VStack {
            CustomNavigationBar(previousAction: {
                if userProfileViewModel.step > 1 {
                    userProfileViewModel.previousStep()
                } else {
                    dismiss()
                }
            })
            
            VStack(alignment: .leading) {
                Text(userProfileViewModel.mainText)
                    .font(.logo2ExtraBold)
                    .foregroundStyle(Color.gray100)
                    .padding(.bottom, 5)
                    .fadeIn(delay: 0.1)
                
                Text(userProfileViewModel.subText)
                    .font(.body1Regular)
                    .foregroundStyle(Color.gray70)
                    .fadeIn(delay: 0.2)

                /// - 1: 전화번호
                /// - 2: 6자리 인증코드 입력
                /// - 3: 이름 입력
                /// - 4: 주민번호
                /// - 5: 보호자, 피보호자 선택
                /// 여기까지 회원가입 완료
                switch userProfileViewModel.step {
                case 1: // 전화번호
                    CustomTextInput(placeholder: "휴대폰 번호 입력",
                                    text: $validationViewModel.infoState.phoneNumber,
                                    isError: .isErrorBinding(for: $validationViewModel.infoErrorState.phoneNumberErrorMessage),
                                    errorMessage: validationViewModel.infoErrorState.phoneNumberErrorMessage,
                                    textInputStyle: .phoneNumber)
                case 2: // 인증코드 입력
                    CustomTextInput(placeholder: "인증번호 입력 (ex. 000000)",
                                    text: $signUpRequestViewModel.inputVerificationCode,
                                    isError: .isErrorBinding(for: $signUpRequestViewModel.signUpState.failMessage),
                                    errorMessage: signUpRequestViewModel.phoneNumberVerificationErrorState,
                                    textInputStyle: .verificationCode)
                    
                case 3: // 이름
                    CustomTextInput(placeholder: "본명 입력 (ex. 홍길동)",
                                    text: $validationViewModel.infoState.name,
                                    isError: .isErrorBinding(for: $validationViewModel.infoErrorState.nameErrorMessage),
                                    errorMessage: validationViewModel.infoErrorState.nameErrorMessage,
                                    textInputStyle: .text)
                case 4: // 주민등록번호
                    CustomTextInput(placeholder: "주민번호 입력",
                                    text: $validationViewModel.infoState.ssn,
                                    isError: .isErrorBinding(for: $validationViewModel.infoErrorState.ssnErrorMessage),
                                    errorMessage: validationViewModel.infoErrorState.ssnErrorMessage,
                                    textInputStyle: .ssn)
                case 5: // 피보호자, 보호자 선택
                    UserRoleView(role: "피보호자",
                                 description: "약 복용 및 건강 관리를 받아요.",
                                 isSelected: selectedRole == 1)
                        .onTapGesture {
                            selectedRole = 1
                            updateButtonState()
                        }
                        .padding(.bottom, 10)
                        .padding(.top, 71)
                        .fadeIn(delay: 0.3)
                    
                    UserRoleView(role: "보호자",
                                 description: "피보호자의 건강 상태를 관리해요.",
                                 isSelected: selectedRole == 0)
                        .onTapGesture {
                            selectedRole = 0
                            updateButtonState()
                        }
                        .fadeIn(delay: 0.4)
                default:    // 보호 관계 신청 목록
                    if (self.selectedRole == 0) {   // 보호자라면
                        EmptyView()
                    } else {    // 피보호자라면
                        RelationRequestView(finishSelectRelation: {
                            self.isAuthSuccessed = true
                        })
                    }
                }
                
                Spacer()
                
                if (userProfileViewModel.step == 7) {
                    EmptyView()
                } else {
                    CustomButton(buttonSize: .regular,
                                 buttonStyle: .filled,
                                 action: {
                        switch userProfileViewModel.step {
                        case 1: // 전화번호
                            signUpRequestViewModel.$tapPhoneNumberVerificationButton.send()
                        case 2:
                            signUpRequestViewModel.compareToVerificationCode()
                        case 4:
                            // 로그인 요청
                            signUpRequestViewModel.$tapSignInButton.send()
                        case 5:
                            // userType 로컬에 저장
                            if selectedRole == 0 {
                                UserManager.shared.isManager = true
                            } else if selectedRole == 1 {
                                UserManager.shared.isManager = false
                            }
                            // 회원가입 요청
                            signUpRequestViewModel.$tapSignUpButton.send()
                            // 만약 보호자라면
                            if self.selectedRole == 0 {
                                self.isAuthSuccessed = true
                            // 만약 피보호자라면
                            } else {
                                userProfileViewModel.step += 1
                            }
                        default:
                            userProfileViewModel.step += 1
                        }
                    }, content: {
                        Text("다음")
                    }, isDisabled: isButtonDisabled, 
                    isLoading: signUpRequestViewModel.isNetworking)
                }
                
            } // Todo: ViewModel로 분리할 것
            .onReceive(userProfileViewModel.$step) { _ in
                updateButtonState()
            }
            .onReceive(signUpRequestViewModel.$isVerificationSucced, perform: { _ in
                updateButtonState()
            })
            .onReceive(validationViewModel.$infoState) { _ in
                updateButtonState()
            }
            .onReceive(validationViewModel.$infoErrorState) { _ in
                updateButtonState()
            }
            .onReceive(signUpRequestViewModel.$isLoginSucced) { isSucceeded in
                if isSucceeded {
                    navigator.next(paths: ["successSignUp"], items: [:], isAnimated: true)
                }
            }
            .onReceive(signUpRequestViewModel.$isLoginFailed) { isLoginFailed in
                if isLoginFailed {
                    // 만약 로그인이 성공적으로 이루어졌다면
                    userProfileViewModel.step += 1
                }
            }
            .padding([.leading, .trailing], 32)
            
            Spacer()
        }
    }
    
    /// isButtonDisabled: 버튼의 상태를 업데이트
    private func updateButtonState() {
        switch userProfileViewModel.step {
        case 1:
            isButtonDisabled = !validationViewModel.infoErrorState.phoneNumberErrorMessage.isEmpty || validationViewModel.infoState.phoneNumber.isEmpty
        case 2:
            isButtonDisabled = !signUpRequestViewModel.isVerificationSucced
        case 3:
            isButtonDisabled = !validationViewModel.infoErrorState.nameErrorMessage.isEmpty || validationViewModel.infoState.name.isEmpty
        case 4:
            isButtonDisabled = !validationViewModel.infoErrorState.ssnErrorMessage.isEmpty || validationViewModel.infoState.ssn.isEmpty
        case 5:
            isButtonDisabled = (selectedRole == 2)
        default:
            isButtonDisabled = true
        }
    }
}

// MARK: - UserRoleView

struct UserRoleView: View {
    var role: String
    var description: String
    var isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(description)
                .font(.body2Medium)
                .foregroundStyle(isSelected ? Color.primary40 : Color.gray70)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 0.1)
            Text(role)
                .font(.h5Bold)
                .foregroundStyle(isSelected ? Color.white : Color.gray90)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity,
               minHeight: 100,
               maxHeight: 100)
        .padding(.leading, 22)
        .background(isSelected ? Color.primary60 : Color.primary5)
        .cornerRadius(15)
    }
}
