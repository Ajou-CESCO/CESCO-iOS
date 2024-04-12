//
//  PhoneNumberInputView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import SwiftUI
import Combine

struct PhoneNumberInputView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var validationViewModel: PhoneNumberValidationViewModel

    init() {
        let validationService = ValidationService() // ValidationService를 초기화
        self.validationViewModel = PhoneNumberValidationViewModel(validationService: ValidationService())
        self.validationViewModel.bindEvent()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("휴대폰 본인 인증")
                .font(.logo2ExtraBold)
                .foregroundStyle(Color.gray100)
                .padding(.top, 69)
            
            Text("본인 명의의 휴대폰 번호를 입력해주세요.")
                .font(.body1Regular)
                .foregroundStyle(Color.gray70)
            
            CustomTextInput(placeholder: "휴대폰 번호 입력",
                            text: $validationViewModel.infoState.phoneNumber,
                            errorMessage: validationViewModel.infoErrorState.phoneNumberErrorMessate)
            
            Spacer()
            
            CustomButton(buttonSize: .regular,
                         buttonStyle: .filled, 
                         action: {
                
            }, content: {
                Text("다음")
            }, isDisabled: !validationViewModel.infoErrorState.phoneNumberErrorMessate.isEmpty || validationViewModel.infoState.phoneNumber.isEmpty)

        }
        .onTapGesture {
            hideKeyboard()
        }
        .padding(.leading, 32)
        .padding(.trailing, 32)
        Spacer()
    }
}

#Preview {
    PhoneNumberInputView()
}
