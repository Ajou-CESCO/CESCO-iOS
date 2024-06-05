//
//  RelationRequestView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/19/24.
//

import SwiftUI

import Moya

// MARK: - RelationRequestView

struct RelationRequestView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    @State private var isModalPresented = false
    @State private var selectedIndex: Int = 0
    @State private var isClinetSelectedRelation: Bool = false
    
    @ObservedObject var relationRequestViewModel = RelationRequestViewModel(requestService: RequestService(provider: MoyaProvider<RequestAPI>()),
                                                                            relationService: RelationService(provider: MoyaProvider<RelationAPI>()))
    
    // MARK: - body
    
    var body: some View {
        
        VStack {
            Text("보호자들이 \n회원님을 기다리고 있어요")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.logo2ExtraBold)
                .foregroundStyle(Color.gray100)
                .padding(.top, 33)
                .padding(.bottom, 5)
                .fadeIn(delay: 0.1)
            
            Text("단 한 명의 보호자만 선택할 수 있어요")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.body1Regular)
                .foregroundStyle(Color.gray70)
                .fadeIn(delay: 0.2)
            
            ScrollView {
                if relationRequestViewModel.relationRequestList.isEmpty {
                    CustomEmptyView(mainText: "요청을 다시 확인해주세요", subText: "보호관계 요청 결과가 없습니다.")
                        .padding(.top, 100)
                }
                
                VStack {
                    ForEach(relationRequestViewModel.relationRequestList, id: \.senderID) { request in
                        Button(action: {
                            self.isModalPresented = true
                        }, label: {
                            HStack {
                                Text(request.senderName)
                                    .font(.h4Bold)
                                    .foregroundStyle(Color.gray90)
                                    .padding(.leading, 22)
                                
                                Spacer()
                                
                                Text(request.senderPhone.suffix(4))
                                    .font(.h5Regular)
                                    .foregroundStyle(Color.gray70)
                                    .padding(.trailing, 22)
                            }
                            
                        })
                        .frame(maxWidth: .infinity,
                               minHeight: 73, maxHeight: 73)
                        .background(Color.primary5)
                        .cornerRadius(15)
                        .padding(.bottom, 3)
                        .fadeIn(delay: 0.1)
                        .fullScreenCover(isPresented: $isModalPresented,
                                         content: {
                            CustomPopUpView(mainText: "\(request.senderName) 님을 보호자로\n수락하시겠어요?",
                                            subText: "수락을 선택하면 \(request.senderName) 님이 회원님의\n약 복용 현황과 건강 상태를 관리할 수 있어요.",
                                            leftButtonText: "거절할게요",
                                            rightButtonText: "수락할게요",
                                            leftButtonAction: { self.isModalPresented = false },
                                            rightButtonAction: {
                                relationRequestViewModel.$requestCreateRelation.send(request.id)
                                self.isModalPresented = true
                            })
                            .background(ClearBackgroundView())
                            .background(Material.ultraThin)
                        })
                        .transaction { transaction in   // 모달 애니메이션 삭제
                            transaction.disablesAnimations = true
                        }
                    }
                    .padding(.bottom, 12)
                }
                .padding(.top, 30)
                .refreshable {
                    requestToServer()
                }
            }
            
            Spacer()
            
            CustomButton(buttonSize: .regular,
                         buttonStyle: .filled, action: {
                requestToServer()
            }, content: {
                HStack {
                    Text("새로고침")
                    Image(systemName: "arrow.clockwise")
                }
            }, isDisabled: false)
            
        }
        .frame(maxWidth: .infinity)
        .padding(33)
        .onAppear(perform: {
            requestToServer()
        })
        .onChange(of: relationRequestViewModel.isCreateRelationSucced, {
            // 보호관계가 생성되었다는 신호를 받으면 dismiss
            dismiss()
        })
    }
    
    private func requestToServer() {
        relationRequestViewModel.$requestRelationRequestList.send()
    }
}
