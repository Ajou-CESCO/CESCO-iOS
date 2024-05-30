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
    @State private var showPopUpView: Bool = false
    
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
            CustomNavigationBar(isBackButtonHidden: self.userProfileViewModel.step == 1,
                                previousAction: {
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
                    
                    if signUpRequestViewModel.isNetworkSucceed {
                        Text("인증코드 유효 시간: \(timeString(time: signUpRequestViewModel.timeRemaining))")
                            .font(.body1Bold)
                            .foregroundStyle(Color.primary60)
                            .padding(5)
                            .onAppear {
                                signUpRequestViewModel.startTimer()
                            }
                            .onDisappear {
                                signUpRequestViewModel.timer?.cancel()
                            }
                    }
                case 3: // 이름
                    CustomTextInput(placeholder: "본명 입력 (ex. 홍길동)",
                                    text: $validationViewModel.infoState.name,
                                    isError: .isErrorBinding(for: $validationViewModel.infoErrorState.nameErrorMessage),
                                    errorMessage: validationViewModel.infoErrorState.nameErrorMessage,
                                    textInputStyle: .text,
                                    maxLength: 4)
                case 4: // 주민등록번호
                    CustomTextInput(placeholder: "주민번호 입력",
                                    text: $validationViewModel.infoState.ssn,
                                    isError: .isErrorBinding(for: $validationViewModel.infoErrorState.ssnErrorMessage),
                                    errorMessage: validationViewModel.infoErrorState.ssnErrorMessage,
                                    textInputStyle: .ssn)
                default: // 피보호자, 보호자 선택
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
                            userProfileViewModel.step += 1
                        case 2:
                            signUpRequestViewModel.compareToVerificationCode()
                            if signUpRequestViewModel.isVerificationSucced {
                                userProfileViewModel.step += 1
                            }
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
                            // userType 수정 불가능 경고
                            self.showPopUpView = true
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
            .onReceive(signUpRequestViewModel.$inputVerificationCode) { _ in
                updateButtonState()
            }
            .padding([.leading, .trailing], 32)
            
            Spacer()
        }
        .fullScreenCover(isPresented: $showPopUpView, content: {
            CustomPopUpView(mainText: "나의 역할을\n\(selectedRole == 0 ? "누군가를 보호하는 보호자" : "누군가의 보호를 받는 피보호자")로\n결정하시겠어요?",
                            subText: "나의 역할은 한 번 선택하면 변경하지 못해요.\n신중하게 선택해주세요.",
                            leftButtonText: "다시 정하기",
                            rightButtonText: "확정하기",
                            leftButtonAction: {
                
            }, rightButtonAction: {
                // 회원가입 요청
                signUpRequestViewModel.$tapSignUpButton.send()
            }, multiColorText: "\(selectedRole == 0 ? "누군가를 보호하는 보호자" : "누군가의 보호를 받는 피보호자")")
            .background(ClearBackgroundView())
            .background(Material.ultraThin)
        })
        .transaction { transaction in   // 모달 애니메이션 삭제
            transaction.disablesAnimations = true
        }
    }
    
    /// isButtonDisabled: 버튼의 상태를 업데이트
    private func updateButtonState() {
        switch userProfileViewModel.step {
        case 1:
            isButtonDisabled = !validationViewModel.infoErrorState.phoneNumberErrorMessage.isEmpty || validationViewModel.infoState.phoneNumber.isEmpty
        case 2:
            if signUpRequestViewModel.inputVerificationCode.isEmpty {
                isButtonDisabled = true
                if signUpRequestViewModel.isVerificationSucced {
                    isButtonDisabled = false
                    
                } else {
                    isButtonDisabled = true
                }
            } else {
                isButtonDisabled = false
            }
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
    
    /// 시간을 문자열로 바꿔주는 메서드
    private func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d분 %02d초", minutes, seconds)
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
