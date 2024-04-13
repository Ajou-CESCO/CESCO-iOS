//
//  CustomPopUpView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/13/24.
//

import SwiftUI

struct CustomPopUpView: View {
    
    // MARK: - Properties

    let mainText: String
    let subText: String
    let leftButtonText: String
    let rightButtonText: String
    
    private let desciption: String = "화면을 클릭하면 이전으로 돌아갈 수 있어요."
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                VStack(alignment: .leading) {
                    Text(mainText)
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
                            
                        }, content: {
                            Text(leftButtonText)
                        }, isDisabled: false)
                        .padding(.trailing, 7)
                        
                        CustomButton(buttonSize: .small,
                                     buttonStyle: .filled,
                                     action: {
                            
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
            .background(.white)
            .cornerRadius(12)
            .padding()
        }
    }
}

#Preview {
    CustomPopUpView(mainText: "아아아님을 보호자로\n수락하시겠어요?",
                    subText: "수락을 선택하면 아아아님이 회원님의\n약 복용 현황과 건강 상태를 관리할 수 있어요.",
                    leftButtonText: "거절할게요",
                    rightButtonText: "수락할게요")
}
