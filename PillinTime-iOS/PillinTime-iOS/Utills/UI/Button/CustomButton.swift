//
//  CustomButton.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/11/24.
//

import Foundation
import SwiftUI
import Combine

@frozen
enum CustomButtonStyle {
    case filled
    case disabled
}

@frozen
enum ControlSize {
    case regular
    case small
}

struct CustomButton<Content>: View where Content: View {
    
    // MARK: - Properties
    
    let buttonSize: ControlSize
    var width: CGFloat?
    var height: CGFloat?
    var buttonStyle: CustomButtonStyle
    var tintColor: Color = .primary5
    var buttonColor: Color = .primary60
    var subject: Subjected<Void>?
    
    let action: () -> Void
    @ViewBuilder let content: Content
    
    var isDisabled: Bool
    var isLoading: Bool = false // 로딩 상태일 때
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            if !isDisabled {
                action()
                subject?.send()
            }
        }) {
            if isLoading {
                // 로딩 이미지 표시
                
                ZStack {
                    Rectangle()
                        .padding()
                        .frame(maxWidth: width ?? .infinity, minHeight: height ?? 64, maxHeight: height ?? 64)
                        .background(Color.gray5)
                        .foregroundColor(.clear)
                        .cornerRadius(8)

                    LottieView(lottieFile: "dots-loading-flatten")
                        .frame(width: 70, height: 20)
                }
                .frame(maxWidth: .infinity, minHeight: height ?? 64, maxHeight: height ?? 64)
            } else {
                content
                    .padding()
                    .font(buttonSize == .regular ? .h5Medium : .body1Medium)
                    .frame(maxWidth: width ?? .infinity, minHeight: height ?? 64, maxHeight: height ?? 64)
                    .background(buttonStyle == .disabled || isDisabled ? Color.gray5 : buttonColor)
                    .foregroundColor(buttonStyle == .disabled || isDisabled ? .gray50 : tintColor)
                    .cornerRadius(8)
            }
        }
        .disabled(isDisabled)
        .pressable()
    }
}
