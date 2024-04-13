//
//  CreateUserProfileView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/13/24.
//

import SwiftUI
import Combine

struct CreateUserProfileView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss

    @State private var selectedRole: Int = 0
    @State private var isButtonDisabled: Bool = false
    @ObservedObject var userProfileViewModel: CreateUserProfileViewModel    // view의 정보를 갖고 있는 view model
    @ObservedObject var validationViewModel: UserProfileValidationViewModel // 유효성 검사를 위한 view model
    
    // MARK: - Initializer

    init() {
        self.userProfileViewModel = CreateUserProfileViewModel()
        self.validationViewModel = UserProfileValidationViewModel(validationService: ValidationService())
        self.validationViewModel.bindEvent()
    }
    
    // MARK: - body
    
    var body: some View {
        CustomNavigationBar()
        
        VStack(alignment: .leading) {
            
            Text(userProfileViewModel.mainText)
                .font(.logo2ExtraBold)
                .foregroundStyle(Color.gray100)
                .padding(.bottom, 5)

            Text(userProfileViewModel.subText)
                .font(.body1Regular)
                .foregroundStyle(Color.gray70)
            
            switch userProfileViewModel.step {
            case 1: // 피보호자, 보호자 선택
                UserRoleView(role: "피보호자",
                             description: "약 복용 및 건강 관리를 받아요.",
                             isSelected: selectedRole == 1)
                    .onTapGesture {
                        selectedRole = 1
                        updateButtonState()
                    }
                    .padding(.bottom, 10)
                    .padding(.top, 71)
                
                UserRoleView(role: "보호자",
                             description: "피보호자의 건강 상태를 관리해요.",
                             isSelected: selectedRole == 2)
                    .onTapGesture {
                        selectedRole = 2
                        updateButtonState()
                    }
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
            default:
                EmptyView()
            }
            
            Spacer()
            
            CustomButton(buttonSize: .regular,
                         buttonStyle: .filled,
                         action: {
                userProfileViewModel.step += 1
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
            isButtonDisabled = (selectedRole == 0)
        case 2:
            isButtonDisabled = !validationViewModel.infoErrorState.nameErrorMessage.isEmpty || validationViewModel.infoState.name.isEmpty
        case 3:
            isButtonDisabled = !validationViewModel.infoErrorState.ssnErrorMessage.isEmpty || validationViewModel.infoState.ssn.isEmpty
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

#Preview {
    CreateUserProfileView()
}
