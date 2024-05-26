//
//  CustomPopUpView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/13/24.
//

import SwiftUI

struct CustomPopUpView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss

    let mainText: String
    let subText: String
    let leftButtonText: String
    let rightButtonText: String

    let leftButtonAction: () -> Void
    let rightButtonAction: () -> Void
    
    var multiColorText: String = String() // 색상을 변경해야 할 경우
    
    // MARK: - body
    
    var body: some View {
        ZStack {
                VStack(alignment: .leading) {
                    
                    Text.multiColoredText(mainText, coloredSubstrings: [(multiColorText, Color.primary60)])
                        .font(.h4Bold)
                        .foregroundStyle(Color.gray90)
                        .lineSpacing(5)
                        .padding(.bottom, 14)
                    
                    Text(subText)
                        .font(.body2Medium)
                        .foregroundStyle(Color.gray70)
                        .lineSpacing(3)
                        .padding(.bottom, 27)
                    
                    HStack {
                        CustomButton(buttonSize: .small,
                                     buttonStyle: .disabled,
                                     action: {
                            leftButtonAction()
                            dismiss()
                        }, content: {
                            Text(leftButtonText)
                        }, isDisabled: false)
                        .padding(.trailing, 7)
                        
                        CustomButton(buttonSize: .small,
                                     buttonStyle: .filled,
                                     action: {
                            rightButtonAction()
                            dismiss()
                        }, content: {
                            Text(rightButtonText)
                        }, isDisabled: false)
                        .padding(.leading, 7)
                        
                    }
                }
                .padding([.leading, .trailing], 27)
                .padding(.top, 29)
                .padding(.bottom, 20)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding()
        .scaleFadeIn(delay: 0.1)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .shadow(color: Color.gray60.opacity(0.2), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    CustomPopUpView(mainText: "아아아님을 보호자로\n수락하시겠어요?",
                    subText: "수락을 선택하면 아아아님이 회원님의\n약 복용 현황과 건강 상태를 관리할 수 있어요.",
                    leftButtonText: "거절할게요",
                    rightButtonText: "수락할게요", 
                    leftButtonAction: {}, rightButtonAction: {})
}
