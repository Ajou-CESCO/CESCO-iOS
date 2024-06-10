//
//  LogoutView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/4/24.
//

import SwiftUI

import Moya
import LinkNavigator

// MARK: - LogoutView

struct LogoutView: View {
    
    // MARK: - Properties
    
    @State private var showPopUpView: Bool = false
    @ObservedObject var logoutViewModel: LogoutViewModel = LogoutViewModel(authService: AuthService(provider: MoyaProvider<AuthAPI>()))
    
    let navigator: LinkNavigatorType
    
    // MARK: - Initializer
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("로그아웃하시겠어요?")
                    .font(.logo2ExtraBold)
                    .foregroundStyle(Color.gray100)
                    .padding(.top, 50)
                
                Text("언제든지 다시 로그인 할 수 있어요.")
                    .font(.body2Regular)
                    .foregroundStyle(Color.gray70)
                    .padding(.top, 12)
                    .lineSpacing(5)
            }
            .padding([.leading, .trailing], 33)
            
            Spacer()
            
            CustomButton(buttonSize: .regular,
                         buttonStyle: .filled,
                         action: {
                self.logoutViewModel.$requestLogout.send()
            }, content: {
                Text("로그아웃하기")
            }, isDisabled: false)
            .padding([.leading, .trailing], 32)
        }
        .onChange(of: self.logoutViewModel.isLogoutSucced, {
            if self.logoutViewModel.isLogoutSucced {
                logout()
            }
        })
    }
    
    private func popUpSubText() -> String {
        return UserManager.shared.isManager ?? true ? "로그아웃하면 피보호자는 나의 관리를 받지 못해요.": "로그아웃하면 보호자가 나를 관리하지 못해요."
    }
    
    private func logout() {
        UserManager.shared.accessToken = nil
        UserManager.shared.fcmToken = nil
        navigator.replace(paths: ["content"], items: [:], isAnimated: true)
    }
}
