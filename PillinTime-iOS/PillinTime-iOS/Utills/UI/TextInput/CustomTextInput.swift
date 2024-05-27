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
    case phoneNumber        // 전화번호 입력
    case verificationCode   // 인증코드 입력
    case ssn                // 주민번호 입력
    case text               // 일반 입력
    case search             // 찾기
}

struct CustomTextInput: View {
    
    // MARK: - Properties

    let placeholder: String
    @Binding var text: String
    var disabled: Bool = false
    @Binding var isError: Bool
    var errorMessage: String
    var textInputStyle: CustomTextInputStyle
    
    var onFocusOut: PassthroughSubject<String, Never>?
    var searchButtonAction: (() -> Void)?
    var maxLength: Int?
    
    @FocusState private var isFocused: Bool
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            customTextField()
                
            Text(errorMessage)
                .foregroundStyle(Color.error90)
                .font(.body1Regular)
                .opacity(!errorMessage.isEmpty ? 1.0 : 0.0)
                .lineSpacing(3)
                .animation(.easeInOut(duration: 0.1),
                           value: isFocused)
        }
    }
}

// MARK: - Methods

extension CustomTextInput {
    /// 공통적으로 쓰이는 TextField
    private func customTextField() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            isError ? Color.error90 : Color.primary60,
                            lineWidth: 1
                        )
                        .background(Color.white)
                        .animation(.easeInOut(duration: 0.1), value: isFocused)
                )
            .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 64)
            
            HStack {
               TextField(placeholder, text: $text)
                   .frame(maxWidth: .infinity,
                          minHeight: 64,
                          maxHeight: 64)
                   .focused($isFocused)
                   .padding(7)
                   .padding(.leading, 10)
                   .onSubmit {
                       onFocusOut?.send(text)
                   }
                   .disabled(disabled)
                   .font(.h5Medium)
                   .foregroundColor(.gray90)
                   .keyboardType({
                       switch textInputStyle {
                       case .phoneNumber, .ssn, .verificationCode:
                           return .numberPad
                       case .text, .search:
                           return .default
                       }
                   }())
                   .onChange(of: text, perform: { newValue in
                       if let maxLength = maxLength, newValue.count > maxLength {
                          text = String(newValue.prefix(maxLength))
                       }
                       
                       switch textInputStyle {
                       case .phoneNumber:
                           text = formatPhoneNumber(phoneNumber: newValue)
                       case .ssn:
                           text = formatSsn(ssn: newValue)
                       case .verificationCode:
                           text = formatVerificationCode(verificationCode: newValue)
                       default:
                           break
                       }
                   })
                   .onAppear {
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                           self.isFocused = true
                       }
                   }
                
                Spacer()
                
                switch textInputStyle {
                case .search:
                    Button(action: {
                        guard let searchButtonAction = searchButtonAction else { return }
                        searchButtonAction()
                    }, label: {
                        Image("ic_search")
                            .frame(width: 30, height: 30)
                            .padding()
                    })
                default:
                    /// 텍스트 필드가 비어있지 않을 경우, clear 버튼 추가
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
        }
    }

    // MARK: - ETC. Methods
        
    mutating func disabled(_ disabled: Bool) -> Self {
        self.disabled = true
        return self
    }
    
    /// 전화번호 형식을 포맷해 리턴해주는 함수
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
    
    /// 주민번호 형식을 포맷해 리턴해주는 함수
    func formatSsn(ssn: String) -> String {
        let digits = ssn.filter { $0.isNumber }
        let mask = "XXXXXX-X"
        
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
        
        if digits.count == 7 {
            result.append("●●●●●●")
        }
        
        return result
    }
    
    /// 인증코드 형식을 포맷해 리턴해주는 함수
    func formatVerificationCode(verificationCode: String) -> String {
        let digits = verificationCode.filter { $0.isNumber }
        return String(digits.prefix(6))
    }
}

extension Binding {
    static func isErrorBinding(for error: Binding<String>) -> Binding<Bool> {
        Binding<Bool>(
            get: { !error.wrappedValue.isEmpty },
            set: { _ in }
        )
    }
}

#Preview {
    CustomTextInput(placeholder: "인증번호 입력",
                    text: .constant("010128"),
                    isError: .constant(true),
                    errorMessage: "인증에 실패했어요",
                    textInputStyle: .ssn)
}
