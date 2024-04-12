//
//  VerificationCodeInputView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/12/24.
//

import SwiftUI
import Combine

struct VerificationCodeInputView: View {
    
    // MARK: - Properties

    @Binding var text: String
    
    // MARK: - body
    
    var body: some View {
        
        CustomNavigationBar()
        
        VStack(alignment: .leading) {
            
            Text("문자로 발송된\n인증번호를 입력해 주세요")
                .font(.logo2ExtraBold)
                .foregroundStyle(Color.gray100)
            
            CustomTextInput(placeholder: "인증번호 입력",
                            text: $text,
                            errorMessage: "잘못",
                            textInputStyle: .verificationCode)
            
            Spacer()
            
            CustomButton(buttonSize: .regular,
                         buttonStyle: .filled,
                         action: {
                
            }, content: {
                Text("다음")
            }, isDisabled: true)

        }

        .padding([.leading, .trailing], 32)
        Spacer()
    }
}

#Preview {
    VerificationCodeInputView(text: .constant("012"))
}
