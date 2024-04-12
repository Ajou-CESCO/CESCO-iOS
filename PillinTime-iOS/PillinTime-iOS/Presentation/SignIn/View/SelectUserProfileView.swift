//
//  SelectUserProfileView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/13/24.
//

import SwiftUI
import Combine

struct SelectUserProfileView: View {
    
    // MARK: - Properties

    @State private var selectedRole: Int = 0
    
    // MARK: - body
    
    var body: some View {
        CustomNavigationBar()
        
        VStack(alignment: .leading) {
            
            Text("회원님은 어떤 사람인가요?")
                .font(.logo2ExtraBold)
                .foregroundStyle(Color.gray100)
                .padding(.bottom, 5)

            Text("본인에 대한 간단한 정보를 알려주세요.")
                .font(.body1Regular)
                .foregroundStyle(Color.gray70)
                .padding(.bottom, 71)
            
            UserRoleView(role: "피보호자",
                         description: "약 복용 및 건강 관리를 받아요.",
                         isSelected: selectedRole == 1)
                .onTapGesture {
                    selectedRole = 1
                }
                .padding(.bottom, 10)
            
            UserRoleView(role: "보호자",
                         description: "피보호자의 건강 상태를 관리해요.",
                         isSelected: selectedRole == 2)
                .onTapGesture {
                    selectedRole = 2
                }
                
            Spacer()
            
            CustomButton(buttonSize: .regular,
                         buttonStyle: .filled,
                         action: {
                
            }, content: {
                Text("다음")
            }, isDisabled: (selectedRole == 0))
        }

        .padding([.leading, .trailing], 32)
        Spacer()
    }
}

// MARK: - UserRoleView

struct UserRoleView: View {
    var role: String
    var description: String
    var isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(description)
                .font(.body2Medium)
                .foregroundStyle(isSelected ? Color.primary40 : Color.gray70)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 0.1)
            Text(role)
                .font(.h5Bold)
                .foregroundStyle(isSelected ? Color.white : Color.gray90)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity,
               minHeight: 100,
               maxHeight: 100)
        .padding(.leading, 22)
        .background(isSelected ? Color.primary60 : Color.primary5)
        .cornerRadius(15)
    }
}

#Preview {
    SelectUserProfileView()
}
