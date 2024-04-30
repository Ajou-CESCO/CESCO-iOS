//
//  CreateUserProfileView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/13/24.
//

import SwiftUI
import Combine
import Moya

struct CreateUserProfileView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss

    @State private var selectedRole: Int = 0
    @State private var fadeTrigger: Int = 0
    @State private var isButtonDisabled: Bool = false
    @ObservedObject var signUpRequestViewModel: SignUpRequestViewModel
    @ObservedObject var userProfileViewModel: CreateUserProfileViewModel    // view의 정보를 갖고 있는 view model
    @ObservedObject var validationViewModel: UserProfileValidationViewModel // 유효성 검사를 위한 view model
    
    // MARK: - Initializer

    init() {
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
        CustomNavigationBar(previousAction: {
            if userProfileViewModel.step > 1 {
                userProfileViewModel.previousStep()
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
                             isSelected: selectedRole == 2)
                    .onTapGesture {
                        selectedRole = 2
                        updateButtonState()
                    }
                    .fadeIn(delay: 0.4)
                
            default:    // 보호 관계 등록
                RelationRequestView()
            }
            
            Spacer()
            
            CustomButton(buttonSize: .regular,
                         buttonStyle: .filled,
                         action: {
                if userProfileViewModel.step == 4 {  // 가정: 3이 마지막 단계라고 가정
                    signUpRequestViewModel.$tapSignUpButton.send()
                } else {
                    
                    userProfileViewModel.step += 1
                }
            }, content: {
                Text("다음")
            }, isDisabled: isButtonDisabled)
        }
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
            isButtonDisabled = (selectedRole == 0)
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
                        CustomPopUpView(mainText: "아아아님을 보호자로\n수락하시겠어요?",
                                        subText: "수락을 선택하면 아아아님이 회원님의\n약 복용 현황과 건강 상태를 관리할 수 있어요.",
                                        leftButtonText: "거절할게요",
                                        rightButtonText: "수락할게요")
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
                }
                .padding(.bottom, 12)
            }
            .padding(.top, 30)
        }
    }
        
}

#Preview {
    CreateUserProfileView()
}
