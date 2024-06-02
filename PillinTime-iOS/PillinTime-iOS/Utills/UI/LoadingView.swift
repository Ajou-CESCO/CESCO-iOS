//
//  LoadingView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/12/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        LottieView(lottieFile: "dots-loading", loopMode: .loop)
            .frame(width: 200, height: 200)
            .background(Color.clear)
    }
}

struct SearchDoseLoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            
            LottieView(lottieFile: "search-dose", loopMode: .loop)
                .frame(width: 300, height: 0)
                .background(Color.clear)
            
            Text("약품과 부작용을 조회하고 있어요")
                .font(.caption1Bold)
                .foregroundStyle(Color.gray90)
                .padding(.bottom, 2)
            
            Text("잠시만 기다려주세요...")
                .font(.caption1Regular)
                .foregroundStyle(Color.gray90)
            
            Spacer()
        }
    }
}

#Preview {
    LoadingView()
}
