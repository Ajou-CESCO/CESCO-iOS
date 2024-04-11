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

struct CustomButton<Content>: View where Content: View {
    
    // MARK: - Properties
    
    let buttonSize: ControlSize
    var width: CGFloat?
    var height: CGFloat?
    let buttonStyle: CustomButtonStyle
    var tintColor: Color = .primary5
    var buttonColor: Color = .primary60
    var subject: Subjected<Void>? = nil
    
    let action: () -> Void
    @ViewBuilder let content: Content
    
    // MARK: - Body
    
    var body: some View {
        // 버튼 Style에 따른 분기
        switch buttonStyle {
        // 채워진 버튼
        case .filled:
            Button(action: {
                action()
                subject?.send() }) {
                    setLabel()
                }
                .background(buttonColor)
                .tint(tintColor)
                .cornerRadius(8)
        case .disabled:
            Button(action: {
                action()
                subject?.send() }) {
                    setLabel()
                }
                .background(Color.gray5)
                .tint(.gray50)
                .cornerRadius(8)
        }
    }
    
    @ViewBuilder
    func setLabel() -> some View {
        // 버튼 사이즈로 분기
        switch buttonSize {
        // 기본 버튼
        case .regular:
            content
                .padding()
                .font(.h5Medium)
                .frame(maxWidth: .infinity,
                       minHeight: 64,
                       maxHeight: 64)
        // 작은 버튼
        default:
            content
                .padding()
                .font(.body1Medium)
                .frame(maxWidth: width,
                       maxHeight: height)
        }
    }
}
