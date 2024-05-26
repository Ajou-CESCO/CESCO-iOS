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
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(homeList[currentIndex])
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .transition(.opacity)
        }
        .ignoresSafeArea()
        .onTapGesture {
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
