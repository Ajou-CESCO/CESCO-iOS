//
//  ManagerHasntClientView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/26/24.
//


import SwiftUI

import Factory

// MARK: - ManagerHasntClientView

struct ManagerHasntClientView: View {
    
    @State private var showRequestRelationPopUpView: Bool = false
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    var body: some View {
        VStack(alignment: .center) {
                    
            Text("등록된 피보호자가 없어요")
                .font(.h5Bold)
                .foregroundStyle(Color.gray90)
                .padding(10)
                .fadeIn(delay: 0.2)
            
            Text("피보호자를 등록하고\n피보호자의 복약일정을 케어해보세요")
                .font(.caption1Regular)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.gray60)
                .lineSpacing(3)
                .padding(20)
                .fadeIn(delay: 0.3)
            
            Button(action: {
                self.showRequestRelationPopUpView = true
            }, label: {
                VStack {
                    Text("피보호자 등록 요청하기")
                        .font(.body1Medium)
                        .foregroundStyle(Color.primary90)
                }
                .frame(width: 238, height: 48)
                .background(Color.white)
                .cornerRadius(8)
            })
            .fadeIn(delay: 0.4)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $showRequestRelationPopUpView,
                         content: {
            RequestRelationPopUpView(onNetworkSuccess: {
                toastManager.showToast(description: "보호 관계를 요청했어요.")
            })
            .background(ClearBackgroundView())
            .background(Material.ultraThin)
        })
        .transaction { transaction in   // 모달 애니메이션 삭제
            transaction.disablesAnimations = true
        }
    }
}
