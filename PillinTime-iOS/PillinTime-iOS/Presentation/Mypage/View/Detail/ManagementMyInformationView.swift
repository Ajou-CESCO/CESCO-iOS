//
//  ManagementMyInformationView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import SwiftUI

import Moya
import Factory

// MARK: - ManagementMyInformationView

struct ManagementMyInformationView: View {
    
    // MARK: - Properties
    
    @State private var showToast: Bool = false

    @ObservedObject var myPageViewModel: MyPageViewModel = MyPageViewModel()
    @ObservedObject var managementMyInformationViewModel: ManagementMyInformationViewModel = ManagementMyInformationViewModel(caseService: CaseService(provider: MoyaProvider<CaseAPI>()))
    
    let userInfo: SelectedRelation
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            Color.white
            
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
                        .fadeIn(delay: 0.2)
                    }
                }
                .listStyle(.plain)
                .background(Color.clear)
                
                Spacer()
                
                if !(UserManager.shared.isManager ?? true) && (userInfo.cabinetId != 0) {
                    CustomButton(buttonSize: .regular,
                                 buttonStyle: .filled,
                                 action: {
                        self.managementMyInformationViewModel.$tapDeletePillCaseButton.send(userInfo.cabinetId)
                    }, content: {
                        Text("약통 해제하기")
                    }, isDisabled: self.managementMyInformationViewModel.isDeleteSucced)
                        .padding([.leading, .trailing], 33)
                }
            }
        }
    }
    
    /// 수정 전: 초기값 return func
    private func setTextInputData(element: UserProfile) -> String {
        switch element {
        case .name:
            return userInfo.name
        case .phoneNumber:
            return userInfo.phone
        case .ssn:
            return userInfo.ssn.prefix(8) + "●●●●●●"
        case .isPillCaseExist:
            return ""
        }
        
    }
}
