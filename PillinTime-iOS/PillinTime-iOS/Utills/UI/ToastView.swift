//
//  ToastView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/29/24.
//

import SwiftUI

struct ToastView: View {
    
    // MARK: - Properties

    var description: String
    @Binding var show: Bool
    
    // MARK: - body
    
    var body: some View {
        VStack {
            Text(description)
                .foregroundStyle(Color.primary5)
                .font(.body1Medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
        }
        .frame(maxWidth: .infinity,
               minHeight: 56, maxHeight: 56)
        .background(Color.gray90)
        .cornerRadius(10)
        .opacity(0.9)
        .padding([.leading, .trailing], 33)
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.show = false
                }
            }
        })
    }
}

#Preview {
    ToastView(description: "복약 일정이 삭제되었어요.", show: .constant(true))
}
