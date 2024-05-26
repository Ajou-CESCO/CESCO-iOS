//
//  CustomNavigationBar.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/12/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    @State var isBackButtonHidden: Bool = false
    var title: String = String()
    var previousAction: (() -> Void)?   // 이전 동작을 설정하고 싶다면 사용
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    // 이전 동작을 설정했다면 그대로, 아니면 dismiss
                    self.previousAction?() ?? presentationMode.wrappedValue.dismiss()
                }, label: {
                    if !isBackButtonHidden {
                        Image("ic_arrow_back")
                            .accessibilityHidden(true)
                            .padding(.leading, 16)
                    }
                })
                
                Spacer()
            }
            .frame(maxWidth: .infinity,
                   minHeight: 60, maxHeight: 60)
            
            if !title.isEmpty {
                Text(title)
                    .font(.body1Medium)
                    .foregroundStyle(Color.gray70)
            }
        }
    }
}
