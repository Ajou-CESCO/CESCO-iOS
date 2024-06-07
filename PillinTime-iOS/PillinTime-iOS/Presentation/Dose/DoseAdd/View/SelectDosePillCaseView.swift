//
//  SelectDosePillCaseView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/19/24.
//

import SwiftUI

import Factory

// MARK: - SelectDosePillCaseView

struct SelectDosePillCaseView: View {
    
    @Binding var selectColorIndex: Int
    @State private var selectedColor: Color = .gray
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()
    
    let colors: [Color] = [.error60, .warning60, .success60, .primary40, .purple60]
    let colorToIndex: [Color: Int] = [.error60: 1, .warning60: 2, .success60: 3, .primary40: 4, .purple60: 5]
    @State private var errorMessage: String = "해당 칸은 이미 사용중입니다.\n다른 칸을 선택하거나, 복용 계획을 삭제해주세요."
    @State private var isError: Bool = false

    var body: some View {
        VStack {
            HStack {
                ForEach(colors.indices, id: \.self) { index in
                    let color = colors[index]
                    // homeviewmodel.occupiedcabinetIndex.contains
                    
                    let isOccupied = homeViewModel.occupiedCabinetIndex.contains(colorToIndex[color] ?? -1)
                    
                    Button(action: {
                        if !isOccupied {
                            self.isError = false
                            selectColorIndex = colorToIndex[color] ?? selectColorIndex
                        } else {
                            self.isError = true
                        }
                    }, label: {
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(selectColorIndex == colorToIndex[color] && !isOccupied ? Color.gray90 : Color.clear, lineWidth: 1)
                                    .frame(width: 50, height: 50)
                            )
                            .padding(10)
                    })
                }
            }
            .padding(.top, 20)
            
            if isError {
                Text(errorMessage)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(3)
                    .foregroundStyle(Color.error90)
                    .font(.body1Regular)
                    .opacity(!errorMessage.isEmpty ? 1.0 : 0.0)
                    .padding(.top, 10)
                    .padding(.leading, 32)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SelectDosePillCaseView(selectColorIndex: .constant(1))
}
