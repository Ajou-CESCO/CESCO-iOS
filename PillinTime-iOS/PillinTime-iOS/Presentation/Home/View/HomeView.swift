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
    @State private var showEncourageView: Bool = false
    @State private var showAddPillCaseView: Bool = false
    @State private var showRequestRelationListView: Bool = false
    @State private var showHealthView: Bool = false
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
                                        
                                        if showEncourageView {
                                            EncourageMainView()
                                                .transition(.move(edge: .top))
                                                .scaleFadeIn(delay: 0.4)
                                                .padding([.leading, .trailing], 25)
                                                .onTapGesture {
                                                    self.showHealthView = true
                                                }
                                        }
                                        
                                        HealthMainView(stepCount: $homeViewModel.state.stepCount)
                                            .padding(.top, showEncourageView ? 14 : 0) // EncourageMainView 표시에 따라 조정
                                            .fadeIn(delay: 0.5)
                                            .padding([.leading, .trailing], 25)
                                        
                                        Spacer()
                                    }
                                    .containerRelativeFrame(.horizontal)
                                }
                                .refreshable {
                                    homeViewModel.$requestGetDoseLog.send(self.selectedClientId!)
                                    homeViewModel.$requestInitClient.send(true)
                                }
                            }
                        }
                        .scrollTargetLayout(isEnabled: true)
                        
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $selectedClientId)
                    /// 피보호자일 경우
                } else {
                    HStack {
                        Text.multiColoredText("\(UserManager.shared.name ?? "null") 님,\n오늘 하루도 화이팅이에요!",
                                              coloredSubstrings: [(UserManager.shared.name ?? "null", Color.primary60)])
                        .foregroundStyle(Color.gray90)
                        .font(.logo3Medium)
                        .lineSpacing(3)
                        .frame(alignment: .leading)
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }, label: {
                            Image("ic_alarm_filled")    // 이후에 분기
                                .frame(width: 36, height: 36)
                        })
                    }
                    .padding([.leading, .trailing], 33)
                    .padding(.top, 23)
                    
                    /// 이후 수정
                    DoseScheduleStatusView(memberId: UserManager.shared.memberId ?? 0,
                                           isCabinetExist: homeViewModel.clientCabnetId != 0,
                                           takenStatus: nil,
                                           showAddPillCaseView: $showAddPillCaseView)
                    .padding([.top, .bottom], 18)
                    .padding([.leading, .trailing], 25)
                    .fadeIn(delay: 0.3)
                    
                    if showEncourageView {
                        EncourageMainView()
                            .transition(.move(edge: .top))
                            .scaleFadeIn(delay: 0.4)
                            .padding([.leading, .trailing], 25)
                    }
                    
                    HealthMainView(stepCount: $homeViewModel.state.stepCount)
                        .padding(.top, showEncourageView ? 17 : 0) // EncourageMainView 표시에 따라 조정
                        .fadeIn(delay: 0.5)
                        .padding([.leading, .trailing], 25)
                    
                    Spacer()
                }
            } else {
                LoadingView()
                    .background(Color.white)
            }
        }
        .background(Color.gray5)
        .onReceive(homeViewModel.$isDataReady) { _ in
            // 피보호자이고, 보호관계가 없을 경우 보호관계를 생성해야 함
            initSelectedRelationId()
            checkReleationEmpty()
            refresh()
        }
        .onAppear {
            initSelectedRelationId()
            checkReleationEmpty()
            homeViewModel.action.viewOnAppear.send()
            initClient()
            refresh()
        }
        .onChange(of: selectedClientId, {
            if homeViewModel.isDataReady {
                if selectedClientId == nil {
                    initSelectedRelationId()
                }
                homeViewModel.$requestGetDoseLog.send(selectedClientId ?? 0)
            }
        })
        .sheet(isPresented: $showAddPillCaseView, content: {
            AddPillCaseView(selectedManagerId: selectedClientId ?? 0)
        })
        .fullScreenCover(isPresented: $showRequestRelationListView, content: {
            RelationRequestView()
        })
        .fullScreenCover(isPresented: $showHealthView, content: {
            MyPageDetailView(navigator: navigator,
                             settingListElement: .todaysHealthState,
                             name: "zz")
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
        selectedClientId = homeViewModel.relationLists.first?.memberID
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
        homeViewModel.$requestGetDoseLog.send(selectedClientId ?? 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                self.showEncourageView = true
            }
        }
    }
}

// MARK: - HealthMainView

struct HealthMainView: View {
    
    // MARK: - Properties
    
    var mainText: [String] = ["걸음 수", "수면", "심장박동수", "활동량"]
    var subText: [String] = ["4,512보", "7시간", "89bpm", "435kcal"]
    @Binding var stepCount: String
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            Color.primary60
            
            HStack(spacing: 20) {
                ForEach(0..<4, id: \.self) { index in
                    VStack {
                        Text(mainText[index])
                            .font(.caption1Medium)
                            .foregroundStyle(Color.primary40)
                            .padding(.bottom, 2)
                        
                        Text(subText[index])
                            .font(.body1Bold)
                            .foregroundStyle(Color.white)
                    }
                }
            }
        }
        .cornerRadius(8)
        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
    }
}

// MARK: - EncourageMainView

struct EncourageMainView: View {
    
    // MARK: - Properties
    
    var mainTitle: String = "오늘 얼마나 걸으셨나요?"
    var subTitle: String = "권장량보다 2,488보 덜 걸으셨어요."
    
    // MARK: - body
    
    var body: some View {
        HStack {
            LottieView(lottieFile: "pie-chart", loopMode: .loop)
                .frame(width: 70, height: 70)
            
            VStack(alignment: .leading) {
                Text(mainTitle)
                    .font(.logo4Medium)
                    .foregroundStyle(Color.gray90)
                    .padding(.bottom, 1)
                
                Text(subTitle)
                    .font(.body2Medium)
                    .foregroundStyle(Color.gray50)
            }
            
            Image(systemName: "chevron.forward")
                .foregroundStyle(Color.gray60)
                .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 90, maxHeight: 90)
        .background(Color.white)
        .cornerRadius(8)
    }
}
