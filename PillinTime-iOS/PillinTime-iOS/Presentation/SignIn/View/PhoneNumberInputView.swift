//
//  PhoneNumberInputView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import SwiftUI
import Combine

struct PhoneNumberInputView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var validationViewModel: UserProfileValidationViewModel

    @State private var navigateToVerificationCodeInputView = false
    
    // MARK: - Initializer

    init() {
        let validationService = ValidationService() // ValidationService를 초기화
        self.validationViewModel = UserProfileValidationViewModel(validationService: ValidationService())
        self.validationViewModel.bindEvent()
    }
    
    // MARK: - body
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("휴대폰 본인 인증")
                    .font(.logo2ExtraBold)
                    .foregroundStyle(Color.gray100)
                    .padding(.top, 69)
                    .padding(.bottom, 5)
                
                Text("본인 명의의 휴대폰 번호를 입력해주세요.")
                    .font(.body1Regular)
                    .foregroundStyle(Color.gray70)
                    .padding(.bottom, 15)
                
                CustomTextInput(placeholder: "휴대폰 번호 입력",
                                text: $validationViewModel.infoState.phoneNumber,
                                isError: .isErrorBinding(for: $validationViewModel.infoErrorState.phoneNumberErrorMessage),
                                errorMessage: validationViewModel.infoErrorState.phoneNumberErrorMessage,
                                textInputStyle: .phoneNumber)
                
                Spacer()
                
                CustomButton(buttonSize: .regular,
                             buttonStyle: .filled,
                             action: {
                    navigateToVerificationCodeInputView = true
                }, content: {
                    Text("다음")
                }, isDisabled: !validationViewModel.infoErrorState.phoneNumberErrorMessage.isEmpty || validationViewModel.infoState.phoneNumber.isEmpty)
                
                NavigationLink(destination: VerificationCodeInputView(text: $validationViewModel.infoState.phoneNumber, 
                                                                      isError: .isErrorBinding(for: $validationViewModel.infoErrorState.phoneNumberErrorMessage))
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true),
                               isActive: $navigateToVerificationCodeInputView) {
                    EmptyView()
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .padding([.leading, .trailing], 32)
            Spacer()
        }
    }
}

#Preview {
    PhoneNumberInputView()
}
