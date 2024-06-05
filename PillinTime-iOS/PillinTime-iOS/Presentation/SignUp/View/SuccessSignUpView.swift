//
//  SuccessSignUpView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import SwiftUI

import LinkNavigator

// MARK: - SuccessSignUpView

/// 회원가입을 성공적으로 마치면 띄워줄 화면입니다.
struct SuccessSignUpView: View {

    let navigator: LinkNavigatorType
    @Environment(\.dismiss) private var dismiss
    var name: String = (UserManager.shared.name) ?? "null"
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }
    
    var body: some View {
        ZStack {
            LottieView(lottieFile: "background")
                .ignoresSafeArea()
                        
            VStack {
                LottieView(lottieFile: "signup")
                    .frame(width: 250, height: 250)
                    .fadeIn(delay: 0.4)
                    .padding()
                
                Text("로그인 완료!")
                    .font(.h5Bold)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .foregroundStyle(Color.gray70)
                    .frame(alignment: .center)
                    .padding(.bottom, 10)
                    .fadeIn(delay: 0.6)
                
                Text("\(self.name) 님,\n만나서 반갑습니다!")
                    .font(.logo2ExtraBold)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .foregroundStyle(Color.gray90)
                    .frame(alignment: .center)
                    .fadeIn(delay: 0.8)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                navigator.next(paths: ["content"], items: [:], isAnimated: true)
                if !(UserManager.shared.isManager ?? false) {
                    HKAuthorizationHelper.shared.setAuthorization()
                }
            }
        }
    }
    
}
