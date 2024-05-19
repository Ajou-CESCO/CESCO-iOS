//
//  SelectDosePillCaseView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/19/24.
//

import SwiftUI

// MARK: - SelectDosePillCaseView

struct SelectDosePillCaseView: View {
    
    @Binding var selectColorIndex: Int
    @State private var selectedColor: Color = .gray
    
    let colors: [Color] = [.error60, .warning60, .success60, .primary40, .purple60]
    let colorToIndex: [Color: Int] = [.error60: 1, .warning60: 2, .success60: 3, .primary40: 4, .purple60: 5]

    var body: some View {
        VStack {
            HStack {
                ForEach(colors.indices, id: \.self) { index in
                    let color = colors[index]
                    
                    Button(action: {
                        selectColorIndex = colorToIndex[color] ?? selectColorIndex
                    }, label: {
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(selectColorIndex == colorToIndex[color] ? Color.gray90 : Color.clear, lineWidth: 1)
                                    .frame(width: 50, height: 50)
                            )
                            .padding(10)
                    })
                }
            }
        }
        .frame(maxWidth: .infinity, 
               minHeight: 100,
               maxHeight: 100)
    }
}

#Preview {
    SelectDosePillCaseView(selectColorIndex: .constant(1))
}
