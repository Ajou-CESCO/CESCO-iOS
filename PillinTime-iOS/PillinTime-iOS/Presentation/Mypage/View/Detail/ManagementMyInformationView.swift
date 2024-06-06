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
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showToast: Bool = false
    @State private var showDeletePillCasePopUpView: Bool = false
    @State private var showDeleteRelationPopUpView: Bool = false

    @ObservedObject var myPageViewModel: MyPageViewModel = MyPageViewModel()
    @ObservedObject var managementMyInformationViewModel: ManagementMyInformationViewModel = ManagementMyInformationViewModel(caseService: CaseService(provider: MoyaProvider<CaseAPI>()))    
    @ObservedObject var clientManageViewModel: ClientManageViewModel
    
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
                
                if (userInfo.cabinetId != 0) {
                    CustomButton(buttonSize: .regular,
                                 buttonStyle: .filled,
                                 action: {
                        self.showDeletePillCasePopUpView = true
                    }, content: {
                        Text("약통 해제하기")
                    }, isDisabled: self.managementMyInformationViewModel.isDeleteSucced)
                        .padding([.leading, .trailing], 33)
                        .fadeIn(delay: 0.3)
                }
                
                if userInfo.phone != UserManager.shared.phoneNumber {
                    CustomButton(buttonSize: .regular,
                                 buttonStyle: .filled,
                                 action: {
                        self.showDeleteRelationPopUpView = true
                    }, content: {
                        Text("보호 관계 삭제하기")
                    }, isDisabled: false)
                    .padding([.leading, .trailing], 33)
                    .padding(.bottom, 5)
                    .fadeIn(delay: 0.3)
                }
            }
        }
        .fullScreenCover(isPresented: $showDeleteRelationPopUpView, content: {
            CustomPopUpView(mainText: "\(userInfo.name) 님을\n삭제하시겠어요?",
                            subText: popUpSubText(name: userInfo.name),
                            leftButtonText: "취소할래요",
                            rightButtonText: "삭제할래요",
                            leftButtonAction: {},
                            rightButtonAction: {
                requestToDelete(userInfo.relationId)
                self.dismiss()
            })
            .background(ClearBackgroundView())
            .background(Material.ultraThin)
        })
        .fullScreenCover(isPresented: $showDeletePillCasePopUpView,
                         content: {
            CustomPopUpView(mainText: "약통을 해제하시겠어요?",
                            subText: "약통을 해제하면 \(userInfo.name) 님은 더 이상 서비스에서 복약 관리를 받을 수 없어요.",
                            leftButtonText: "해제할게요",
                            rightButtonText: "취소할게요",
                            leftButtonAction: {},
                            rightButtonAction: {
                self.managementMyInformationViewModel.$tapDeletePillCaseButton.send(userInfo.cabinetId)
            })
            .background(ClearBackgroundView())
            .background(Material.ultraThin)
        })
        .transaction { transaction in   // 모달 애니메이션 삭제
            transaction.disablesAnimations = true
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
    
    private func requestToDelete(_ id: Int) {
        self.clientManageViewModel.$requestDeleteRelation.send(id)
    }
    
    private func popUpSubText(name: String) -> String {
        return (UserManager.shared.isManager ?? true) ? "삭제하면 \(name) 님은 새로운 보호자가 케어를\n요청할 때까지 서비스를 이용할 수 없어요." : "삭제하면 \(name) 님은 \n\(UserManager.shared.name ?? "null") 님을 케어할 수 없어요. 신중하게 삭제해주세요."
    }
}
