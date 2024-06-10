//
//  AnimationManager.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/29/24.
//

import SwiftUI
import Combine

struct FadeInEffect: ViewModifier {
    var delay: Double
    
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.4).delay(delay)) {
                    isVisible = true
                }
            }
    }
}

struct ScaleFadeInEffect: ViewModifier {
    var delay: Double
    
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isVisible ? 1 : 0.8)
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4).delay(delay)) {
                    isVisible = true
                }
            }
    }
}

struct PressableEffect: ViewModifier {
    @State private var scale: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .animation(.easeInOut(duration: 0.1), value: scale)
            .gesture(
                LongPressGesture(minimumDuration: 0.1)
                    .onChanged { _ in
                        self.scale = 1.05  // 눌리면 커짐
                    }
                    .onEnded { _ in
                        self.scale = 1.0  // 손을 떼면 원래대로 돌아감
                    }
            )
    }
}

extension View {
    /// 페이드인을 줄 수 있는 함수입니다.
    func fadeIn(delay: Double) -> some View {
        self.modifier(FadeInEffect(delay: delay))
    }
    
    /// 스케일이 커지면서 페이드인을 줄 수 있는 함수입니다.
    func scaleFadeIn(delay: Double) -> some View {
        self.modifier(ScaleFadeInEffect(delay: delay))
    }
    
    /// 눌렀을 때 객체의 스케일이 커지는 함수입니다.
    func pressable() -> some View {
        self.modifier(PressableEffect())
    }
}
