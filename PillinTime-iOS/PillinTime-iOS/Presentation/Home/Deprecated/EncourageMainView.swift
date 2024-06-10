//
//  EncourageMainView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/5/24.
//

import SwiftUI

import Factory

// MARK: - EncourageMainView

struct EncourageMainView: View {
    
    // MARK: - Properties
    
    var mainTitle: String = "오늘 얼마나 걸으셨나요?"
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()
    
    // MARK: - body
    
    var body: some View {
        HStack {
            
            if (homeViewModel.healthData?.stepsMessage != nil) {
                LottieView(lottieFile: "pie-chart", loopMode: .loop)
                    .frame(width: 70, height: 70)
                
                VStack(alignment: .leading) {
                    Text(mainTitle)
                        .font(.logo4Medium)
                        .foregroundStyle(Color.gray90)
                        .padding(.bottom, 1)
                    
                    Text(homeViewModel.healthData?.stepsMessage ?? "아직 걸음 데이터가 없어요.")
                        .font(.body2Medium)
                        .foregroundStyle(Color.gray50)
                }
                
                Image(systemName: "chevron.forward")
                    .foregroundStyle(Color.gray60)
                    .padding()
            } else {
                VStack {
                    Text("건강 데이터가 없어요.")
                        .font(.logo4Medium)
                        .foregroundStyle(Color.gray90)
                        .padding(.bottom, 1)
                    
                    Text("건강 데이터 자료가 없어서, 통계를 내지 못했어요.")
                        .font(.body2Medium)
                        .foregroundStyle(Color.gray50)
                }
            }
            
        }
        .frame(maxWidth: .infinity, minHeight: 90, maxHeight: 90)
        .background(Color.white)
        .cornerRadius(8)
    }
}
