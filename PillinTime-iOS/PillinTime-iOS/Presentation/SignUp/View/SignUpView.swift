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
                /// - 2: 이름
                /// - 3: 주민번호
                /// - 4: 보호자, 피보호자 선택
                /// 여기까지 회원가입 완료
                switch userProfileViewModel.step {
                case 1: // 전화번호
                    CustomTextInput(placeholder: "휴대폰 번호 입력",
                                    text: $validationViewModel.infoState.phoneNumber,
                                    isError: .isErrorBinding(for: $validationViewModel.infoErrorState.phoneNumberErrorMessage),
                                    errorMessage: validationViewModel.infoErrorState.phoneNumberErrorMessage,
                                    textInputStyle: .phoneNumber)
                    
                case 2: // 이름
                    CustomTextInput(placeholder: "본명 입력 (ex. 홍길동)",
                                    text: $validationViewModel.infoState.name,
                                    isError: .isErrorBinding(for: $validationViewModel.infoErrorState.nameErrorMessage),
                                    errorMessage: validationViewModel.infoErrorState.nameErrorMessage,
                                    textInputStyle: .text)
                case 3: // 주민등록번호
                    CustomTextInput(placeholder: "주민번호 입력",
                                    text: $validationViewModel.infoState.ssn,
                                    isError: .isErrorBinding(for: $validationViewModel.infoErrorState.ssnErrorMessage),
                                    errorMessage: validationViewModel.infoErrorState.ssnErrorMessage,
                                    textInputStyle: .ssn)
                case 4: // 피보호자, 보호자 선택
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
                
                if (userProfileViewModel.step == 5) {
                    EmptyView()
                } else {
                    CustomButton(buttonSize: .regular,
                                 buttonStyle: .filled,
                                 action: {
                        switch userProfileViewModel.step {
                        case 3:
                            // 로그인 요청
                            signUpRequestViewModel.$tapSignInButton.send()
                            // 만약 로그인이 성공적으로 이루어졌다면
                            if signUpRequestViewModel.isLoginSucced == true {
                                self.isAuthSuccessed = true
                            }
                            userProfileViewModel.step += 1
                        case 4:
                            // userType 로컬에 저장
                            UserManager.shared.userType = self.selectedRole
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
                    }, isDisabled: isButtonDisabled)
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
            .padding([.leading, .trailing], 32)
            
            Spacer()
        }
        .fullScreenCover(isPresented: $isAuthSuccessed) {
            SuccessSignUpView(onDismiss: {
                navigator.close(isAnimated: false) {
                    print("finished sign up")
                }
            })
        }
    }
    
    /// isButtonDisabled: 버튼의 상태를 업데이트
    private func updateButtonState() {
        switch userProfileViewModel.step {
        case 1:
            isButtonDisabled = !validationViewModel.infoErrorState.phoneNumberErrorMessage.isEmpty || validationViewModel.infoState.phoneNumber.isEmpty
        case 2:
            isButtonDisabled = !validationViewModel.infoErrorState.nameErrorMessage.isEmpty || validationViewModel.infoState.name.isEmpty
        case 3:
            isButtonDisabled = !validationViewModel.infoErrorState.ssnErrorMessage.isEmpty || validationViewModel.infoState.ssn.isEmpty
        case 4:
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

// MARK: - RelationRequestView

struct RelationRequestView: View {
    
    // MARK: - Properties
    
    @State private var isModalPresented = false
    @State private var selectedIndex: Int = 0
    @State private var isClinetSelectedRelation: Bool = false
    var finishSelectRelation: () -> Void
    
    let mockData: [RequestList] = [
        RequestList(requestId: 1, name: "이재현", phoneNumber: "0001"),
        RequestList(requestId: 2, name: "김서영", phoneNumber: "0002"),
        RequestList(requestId: 3, name: "박준호", phoneNumber: "0003"),
        RequestList(requestId: 4, name: "최윤아", phoneNumber: "0004"),
        RequestList(requestId: 5, name: "정다빈", phoneNumber: "0005"),
        RequestList(requestId: 6, name: "한지수", phoneNumber: "0006"),
        RequestList(requestId: 7, name: "유현석", phoneNumber: "0007"),
        RequestList(requestId: 8, name: "송민재", phoneNumber: "0008"),
        RequestList(requestId: 9, name: "김태희", phoneNumber: "0009"),
        RequestList(requestId: 10, name: "정우성", phoneNumber: "0010")
    ]
    
    // MARK: - body
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<mockData.count, id: \.self) { index in
                    Button(action: {
                        self.selectedIndex = index
                        self.isModalPresented = true
                        print(self.selectedIndex)
                        print(index)
                        print(mockData[selectedIndex].name)
                    }, label: {
                        HStack {
                            Text(mockData[index].name)
                                .font(.h4Bold)
                                .foregroundStyle(Color.gray90)
                                .padding(.leading, 22)
                            
                            Spacer()
                            
                            Text(mockData[index].phoneNumber)
                                .font(.h5Regular)
                                .foregroundStyle(Color.gray70)
                                .padding(.trailing, 22)
                        }
                        
                    })
                    .frame(maxWidth: .infinity,
                           minHeight: 73, maxHeight: 73)
                    .background(Color.primary5)
                    .cornerRadius(15)
                    .fadeIn(delay: Double(index) * 0.1)
                    .padding(.bottom, 3)
                    .fullScreenCover(isPresented: $isModalPresented,
                                     content: {
                        CustomPopUpView(mainText: "\(mockData[selectedIndex].name) 님을 보호자로\n수락하시겠어요?",
                                        subText: "수락을 선택하면 \(mockData[selectedIndex].name) 님이 회원님의\n약 복용 현황과 건강 상태를 관리할 수 있어요.",
                                        leftButtonText: "거절할게요",
                                        rightButtonText: "수락할게요", 
                                        leftButtonAction: { self.isModalPresented = false },
                                        rightButtonAction: { 
                                            finishSelectRelation() })
                        .background(ClearBackgroundView())
                        .background(Material.ultraThin)
                        
                    })
                    .transaction { transaction in   // 모달 애니메이션 삭제
                        transaction.disablesAnimations = true
                    }
                }
                .padding(.bottom, 12)
            }
            .padding(.top, 30)
        }
    }
}

// MARK: - SuccessSignUpView

/// 회원가입을 성공적으로 마치면 띄워줄 화면입니다.
struct SuccessSignUpView: View {

    @Environment(\.dismiss) private var dismiss
    var name: String = (UserManager.shared.name) ?? "null"
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                LottieView(lottieFile: "signup")
                    .frame(width: 200, height: 200)
                
                Text("\(self.name) 님,\n만나서 반갑습니다!")
                    .font(.logo2ExtraBold)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .foregroundStyle(Color.gray100)
                    .frame(alignment: .center)
                    .fadeIn(delay: 0.7)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                dismiss()
                onDismiss()
            }
        }
    }
    
}

#Preview {
        SuccessSignUpView(onDismiss: {})
}
