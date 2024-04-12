//
//  CustomTextInput.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import SwiftUI
import Combine

@frozen
enum CustomTextInputStyle {
    case phoneNumber    // 전화번호 입력
}

struct CustomTextInput: View {
    
    // MARK: - Properties

    let placeholder: String
    @Binding var text: String
    var disabled: Bool = false
    var errorMessage: String
    
    var onFocusOut: PassthroughSubject<String, Never>? = nil
    
    @FocusState private var isFocused: Bool
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(
                                Color.primary60,
                                lineWidth: 1
                            )
                            .background(Color.white)
                            .animation(.easeInOut(duration: 0.1), value: isFocused)
                    )
                    .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 64)
                
                HStack {
                    TextField(placeholder,
                              text: $text)
                        .frame(maxWidth: .infinity,
                               minHeight: 64,
                               maxHeight: 64)
                        .focused($isFocused)
                        .padding()
                        .onSubmit {
                            onFocusOut?.send(text)
                        }
                        .disabled(disabled)
                        .font(.h5Medium)
                        .foregroundColor(.gray90)
                        .keyboardType(.phonePad)
                        .onChange(of: text, perform: { newValue in
                            // MARK: - TODO: 다른 텍스트필드일 경우 분기 처리
                            text = formatPhoneNumber(phoneNumber: newValue)
                        })
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.isFocused = true
                            }
                    }
                    
                    Spacer()
                    
                    // 텍스트 필드가 비어있지 않을 경우, clear 버튼 추가
                    if !text.isEmpty {
                        Button(action: {
                            self.text = String()
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color.gray70)
                                .padding()
                        })
                    }
                }
            }
            .onTapGesture {
                isFocused = true
            }
            
            Text(errorMessage)
                .foregroundStyle(Color.error90)
                .font(.body1Regular)
                .opacity(!errorMessage.isEmpty ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.1),
                           value: isFocused)
                .frame(height: 10)
        }
    }
}

extension CustomTextInput {
    mutating func disabled(_ disabled: Bool) -> Self {
        self.disabled = true
        return self
    }
    
    /// 전화번호 형식을 포맷해 리턴해주는 함수입니다.
    func formatPhoneNumber(phoneNumber: String) -> String {
        let digits = phoneNumber.filter { $0.isNumber }
        let mask = "XXX-XXXX-XXXX"
        
        var result = String()
        var index = digits.startIndex
        
        for ch in mask where index < digits.endIndex {
            if ch == "X" {
                result.append(digits[index])
                index = digits.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        return result
    }
}

#Preview {
    CustomTextInput(placeholder: "인증번호 입력",
                    text: .constant("01064290056"),
                    errorMessage: "인증에 실패했어요")
}
