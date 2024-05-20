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

#Preview {
    LoadingView()
}
