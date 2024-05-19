//
//  ManagementMyInformationView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import SwiftUI

// MARK: - ManagementMyInformationView

struct ManagementMyInformationView: View {
    
    // MARK: - Properties
    
    @State private var showToast: Bool = false

    @ObservedObject var myPageViewModel: MyPageViewModel = MyPageViewModel()
    
    var name: String
    var phoneNumber: String
    var ssn: String
    
    // MARK: - body
    
    var body: some View {
        VStack {
            Text("기본 정보")
                .font(.h5Bold)
                .foregroundStyle(Color.gray90)
                .padding(.leading, 33)
                .padding(.top, 30)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            
            List {
                ForEach(UserProfile.allCases, id: \.self) { element in
                    HStack {
                        Text(element.description)
                            .font(.body2Medium)
                            .foregroundStyle(Color.gray70)
                            .frame(width: 100,
                                   alignment: .leading)
                        
                        Text(setTextInputData(element: element))
                            .font(.h5Medium)
                            .foregroundStyle(Color.gray90)
                    }
                    .padding()
                }
            }
            .listStyle(.plain)
            .background(Color.clear)
        }
    }
    
    /// 수정 전: 초기값 return func
    private func setTextInputData(element: UserProfile) -> String {
        switch element {
        case .name:
            return self.name
        case .phoneNumber:
            return self.phoneNumber
        case .ssn:
            return self.ssn.prefix(8) + "●●●●●●"
        }
        
    }
}
