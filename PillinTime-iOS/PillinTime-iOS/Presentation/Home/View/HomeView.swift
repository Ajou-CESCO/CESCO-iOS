//
//  HomeView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/14/24.
//

import SwiftUI

import Moya
import Factory
import LinkNavigator

struct HomeView: View {
    
    // MARK: - Properties
    
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()
    @State var selectedClientId: Int?  // 선택된 Client
    @State var selectedClientName: String? // 선택된 Client의 이름, 찌르기 시에 활용
    @State private var showEncourageView: Bool = false
    @State private var showAddPillCaseView: Bool = false
    @State private var showRequestRelationListView: Bool = false
    @State private var sheetRequestRelationListView: Bool = false
    @State private var showHealthView: Bool = false
    @State private var isRefresh: Bool = false
    let navigator: LinkNavigatorType
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            if homeViewModel.isDataReady {
                /// 보호자일 경우
                if UserManager.shared.isManager ?? true {
                    ClientListView(relationLists: homeViewModel.relationLists,
                                   selectedClientId: $selectedClientId)
                    .padding(.bottom, 17)
                    .fadeIn(delay: 0.1)
                    
                    if homeViewModel.relationLists.isEmpty {
                        ManagerHasntClientView()
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            ForEach(homeViewModel.relationLists, id: \.memberID) { relation in
                                ScrollView {
                                    VStack(alignment: .leading) {
                                        Text.multiColoredText("오늘 \(relation.memberName) 님의 약속시간은?",
                                                              coloredSubstrings: [(relation.memberName, Color.primary60),
                                                                                  ("약", Color.primary60)])
                                        .foregroundStyle(Color.gray90)
                                        .font(.logo3Medium)
                                        .padding(.leading, 33)
                                        .fadeIn(delay: 0.2)
                                        
                                        DoseScheduleStatusView(memberId: relation.memberID,
                                                               isCabinetExist: relation.cabinetID != 0,
                                                               takenStatus: nil,
                                                               showAddPillCaseView: $showAddPillCaseView)
                                        .padding([.top, .bottom], 10)
                                        .padding([.leading, .trailing], 25)
                                        .fadeIn(delay: 0.3)
                                        
                                        HealthMainView(stepCount: $homeViewModel.state.stepCount)
                                            .fadeIn(delay: 0.4)
                                            .padding(.top, 10)
                                            .padding([.leading, .trailing], 25)
                                            .onTapGesture {
                                                if (homeViewModel.state.stepCount != "0보") {
                                                    self.showHealthView = true
                                                }
                                            }
                                        
                                        Spacer()
                                    }
                                    .containerRelativeFrame(.horizontal)

                                }
                                .refreshable {
                                    homeViewModel.$requestGetDoseLog.send((self.selectedClientId!, nil))
                                    homeViewModel.$requestGetHealthData.send(self.selectedClientId!)
                                    homeViewModel.$requestInitClient.send(true)
                                    self.isRefresh = true
                                }
                            }
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.7)
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.7)                            }
                        }
                        .scrollTargetLayout(isEnabled: true)

                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $selectedClientId)

                    /// 피보호자일 경우
                } else {
                    ScrollView {
                        
                        HStack {
                            Text.multiColoredText("\(UserManager.shared.name ?? "null") 님,\n오늘 하루도 화이팅이에요!",
                                                  coloredSubstrings: [(UserManager.shared.name ?? "null", Color.primary60)])
                                .foregroundStyle(Color.gray90)
                                .font(.logo3Medium)
                                .lineSpacing(3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .trailing], 33)
                                .padding(.top, 23)
                            
                            Button(action: {
                                self.sheetRequestRelationListView = true
                            }, label: {
                                Image("ic_alarm_filled")
                            })
                            .padding()
                        }
                        
                        /// 이후 수정
                        DoseScheduleStatusView(memberId: UserManager.shared.memberId ?? 0,
                                               isCabinetExist: homeViewModel.clientCabnetId != 0,
                                               takenStatus: nil,
                                               showAddPillCaseView: $showAddPillCaseView)
                        .padding([.top, .bottom], 18)
                        .padding([.leading, .trailing], 25)
                        .fadeIn(delay: 0.3)
                        
                        
                        HealthMainView(stepCount: $homeViewModel.state.stepCount)
                            .fadeIn(delay: 0.4)
                            .padding([.leading, .trailing], 25)
                            .onTapGesture {
                                if (homeViewModel.state.stepCount != "0보") {
                                    self.showHealthView = true
                                }
                            }
                        
                        Button(action: {
                            homeViewModel.$requestCreateHealthData.send()
                        }, label: {
                            HStack {
                                Image(systemName: "arrow.clockwise.circle")
                                    .foregroundStyle(Color.gray90)
                                
                                Text("건강 정보 다시 불러오기")
                                    .font(.body2Medium)
                                    .foregroundStyle(Color.gray90)
                            }
                            .padding()
                        })
                        .fadeIn(delay: 0.6)
                        
                        Spacer()
                    }
                    .refreshable {
                        homeViewModel.$requestGetDoseLog.send((UserManager.shared.memberId ?? 0, nil))
                        homeViewModel.$requestInitClient.send(true)
                        self.isRefresh = true
                    }
                }
            } else {
                LoadingView()
                    .background(Color.white)
            }
        }
        .background(Color.gray5)
        .onReceive(homeViewModel.$isDataReady) { _ in
            // 피보호자이고, 보호관계가 없을 경우 보호관계를 생성해야 함
            if !(UserManager.shared.isManager ?? true) {
                selectedClientId = UserManager.shared.memberId
            } 
            if !isRefresh {
                initSelectedRelationId()
            }
            
            checkReleationEmpty()

        }
        .onAppear {
            initSelectedRelationId()
            checkReleationEmpty()
            initClient()
            refresh()
            if !(UserManager.shared.isManager ?? false) {
                homeViewModel.$requestCreateHealthData.send()
            }
        }
        .onChange(of: selectedClientId, {
            if homeViewModel.isDataReady {
                if selectedClientId == nil {
                    initSelectedRelationId()
                }
                homeViewModel.$requestGetDoseLog.send((selectedClientId ?? 0, nil))
                homeViewModel.$requestGetHealthData.send(selectedClientId ?? 0)
                UserManager.shared.selectedClientName = homeViewModel.relationLists.first(where: { $0.memberID == selectedClientId})?.memberName ?? "null"
                UserManager.shared.selectedClientId = selectedClientId
            }
        })
        .sheet(isPresented: $showAddPillCaseView, content: {
            AddPillCaseView(selectedMemberId: selectedClientId ?? 0)
        })
        .sheet(isPresented: $sheetRequestRelationListView, content: {
            RelationRequestView()
        })
        .fullScreenCover(isPresented: $showRequestRelationListView, content: {
            RelationRequestView()
        })
        .fullScreenCover(isPresented: $showHealthView, content: {
            MyPageDetailView(navigator: navigator,
                             settingListElement: .todaysHealthState,
                             name: selectedClientName ?? "null")
        })
        .transaction { transaction in   // 모달 애니메이션 삭제
            transaction.disablesAnimations = true
        }
    }
    
    private func checkReleationEmpty() {
        if !(UserManager.shared.isManager ?? false) && homeViewModel.relationLists.isEmpty {
            self.showRequestRelationListView = true
        } else {
            self.showRequestRelationListView = false
        }
    }
    
    private func initSelectedRelationId() {
        if UserManager.shared.isManager ?? true {
            selectedClientId = homeViewModel.relationLists.first?.memberID
            selectedClientName = homeViewModel.relationLists.first?.memberName
        } else {
            selectedClientId = UserManager.shared.memberId
            selectedClientName = UserManager.shared.name
        }
    }
    
    private func initClient() {
        homeViewModel.$requestInitClient.send(true)
    }
    
    private func refresh() {
        if !(UserManager.shared.isManager ?? true) {
            selectedClientId = UserManager.shared.memberId
        }
        
        if selectedClientId == 0 && homeViewModel.isDataReady {
            selectedClientId = homeViewModel.relationLists.first?.memberID
        }
        homeViewModel.$requestGetDoseLog.send((selectedClientId ?? 0, nil))
        homeViewModel.$requestGetHealthData.send(selectedClientId ?? 0)
    }
}

// MARK: - HealthMainView

struct HealthMainView: View {
    
    // MARK: - Properties
    
    @Binding var stepCount: String
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            Color.primary60
            
            if (homeViewModel.state.stepCount == "0보") {
                VStack {
                    Text("건강 데이터가 없어요.")
                        .font(.logo4Medium)
                        .foregroundStyle(Color.white)
                        .padding(.bottom, 1)
                    
                    Text("건강 데이터 자료가 없어서, 통계를 내지 못했어요.")
                        .font(.body2Medium)
                        .foregroundStyle(Color.white)
                }
            } else {
                VStack {
                    HStack {
                        Spacer()
                        
                        Text("통계 보러가기")
                            .foregroundStyle(Color.white)
                            .font(.body2Medium)
                        
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(Color.white)
                    }
                    .padding(.bottom, 10)
                    
                    HStack(spacing: 20) {
                        ForEach(homeViewModel.state.asDictionary().sorted(by: <), id: \.key) { key, value in
                            VStack {
                                Text("\(key)")
                                    .font(.caption1Medium)
                                    .foregroundStyle(Color.primary40)
                                    .padding(.bottom, 2)
                                
                                Text("\(value)")
                                    .font(.body1Bold)
                                    .foregroundStyle(Color.white)
                            }
                        }
                    }
                    
                }
                .padding()
            }
        }
        .cornerRadius(8)
        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
    }
}
