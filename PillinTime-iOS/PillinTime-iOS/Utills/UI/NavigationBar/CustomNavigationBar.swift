//
//  CustomNavigationBar.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/12/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var title: String = String()
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("ic_arrow_back")
                        .accessibilityHidden(true)
                        .padding(.leading, 16)
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
