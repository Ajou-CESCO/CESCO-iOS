//
//  WithdrawalView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import SwiftUI

import Moya
import LinkNavigator

// MARK: - WithdrawalView

struct WithdrawalView: View {
    
    // MARK: - Properties

    @ObservedObject var withdrawalViewModel: WithdrawalViewModel = WithdrawalViewModel(userService: UserService(provider: MoyaProvider<UserAPI>()))
    @State private var showPopUpView: Bool = false
    
    let navigator: LinkNavigatorType
    
    // MARK: - Initializer
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading){
                Text("정말 탈퇴하시겠어요?")
                    .font(.logo2ExtraBold)
                    .foregroundStyle(Color.gray100)
                    .padding(.top, 50)
                
                Text("계정을 삭제하는 경우\n - 피보호자와의 케어 내역이 영구적으로 삭제되며\n - 동일한 사용자 이름으로 가입하거나 해당 사용자 이름을 다른 계정에 추가할 수 없습니다.")
                    .font(.body2Regular)
                    .foregroundStyle(Color.gray70)
                    .padding(.top, 12)
                    .lineSpacing(5)
                
                Text("약속시간을 사용하신 경험이 도움이 되셨길 바랍니다.\n감사합니다.")
                    .font(.body2Regular)
                    .foregroundStyle(Color.gray70)
                    .padding(.top, 12)
                    .lineSpacing(5)
            }
            .padding([.leading, .trailing], 33)
                
            Spacer()
            
            CustomButton(buttonSize: .regular,
                         buttonStyle: .disabled,
                         action: {
                self.showPopUpView = true
            }, content: {
                Text("탈퇴하기")
            }, isDisabled: false)
            .padding([.leading, .trailing], 32)
        }
        .fullScreenCover(isPresented: $showPopUpView, content: {
            CustomPopUpView(mainText: "정말로 탈퇴하시겠습니까?",
                            subText: "탈퇴 안 하면 안될까요? 🥹",
                            leftButtonText: "취소하기",
                            rightButtonText: "그래도 탈퇴하기", leftButtonAction: {},
                            rightButtonAction: {
                requestDeleteUser()
            })
            .background(ClearBackgroundView())
            .background(Material.ultraThin)
        })
        .transaction { transaction in   // 모달 애니메이션 삭제
            transaction.disablesAnimations = true
        }
        .onChange(of: withdrawalViewModel.isNetworkSucceed, {
            if withdrawalViewModel.isNetworkSucceed {
                navigator.next(paths: ["content"], items: [:], isAnimated: true)
            }
        })
    }
    
    private func requestDeleteUser() {
        self.withdrawalViewModel.$requestDeleteUser.send()
    }
}
