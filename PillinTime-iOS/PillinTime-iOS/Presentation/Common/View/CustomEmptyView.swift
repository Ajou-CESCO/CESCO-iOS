//
//  CustomEmptyView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/25/24.
//

import SwiftUI

struct CustomEmptyView: View {
    
    var mainText: String
    var subText: String
    
    var body: some View {
        VStack {
            Image("ic_empty")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            
            Text(mainText)
                .font(.caption1Bold)
                .foregroundStyle(Color.gray90)
                .padding(.bottom, 2)
            
            Text(subText)
                .font(.caption1Regular)
                .foregroundStyle(Color.gray90)
        }
        .padding()
    }
}
