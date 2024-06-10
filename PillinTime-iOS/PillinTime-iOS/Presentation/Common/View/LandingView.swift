//
//  LandingView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/26/24.
//

import SwiftUI

struct LandingView: View {
    
    let homeList: [String] = ["img_landing_home_1", "img_landing_home_2"]
    
    @State private var currentIndex = 0
    @Environment(\.dismiss) var dismiss
    @State private var isUserHasTapGesture: Bool = true
    @State private var showLottieView: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(homeList[currentIndex])
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .transition(.opacity)
            
            VStack {
                LottieView(lottieFile: "click-gesture", loopMode: .loop)
                    .frame(width: 100, height: 100)
                    .padding()
                
                Text("화면을 터치하며 사용법을 확인하세요.")
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .font(.body1Medium)
                    .foregroundStyle(Color.white)
                    .padding()
            }
            .background(Color.gray60)
            .cornerRadius(10)
            .opacity(0.5)
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3,
                                          execute: {
                self.showLottieView = !isUserHasTapGesture
            })
        }
        .onTapGesture {
            self.isUserHasTapGesture = true
            withAnimation(.easeInOut(duration: 0.5)) {
                if currentIndex < homeList.count - 1 {
                    currentIndex += 1
                } else {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    LandingView()
}
