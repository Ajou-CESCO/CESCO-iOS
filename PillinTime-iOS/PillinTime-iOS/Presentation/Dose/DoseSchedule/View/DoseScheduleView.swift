//
//  DoseScheduleView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/14/24.
//

import SwiftUI

import LinkNavigator
import Factory
import Moya

struct DoseScheduleView: View {
    
    // MARK: - Properties
    
    @State private var selectedDays = Set<String>()
    @State private var selectedDate: Date = Date()
    @State var selectedClientId: Int?  // 선택된 Client
    @State var selectedClientName: String? // 선택된 Client의 이름, 찌르기 시에 활용
    @State var isUserPoked: Bool = false
    @State var showDoseInfoView: Bool = false
    
    let navigator: LinkNavigatorType
    
    @ObservedObject var doseScheduleViewModel = DoseScheduleViewModel()
    @ObservedObject var fcmViewModel = FcmViewModel(fcmService: FcmService(provider: MoyaProvider<FcmAPI>()))
    
    @ObservedObject var doseScheduleStatusViewModel = Container.shared.doseScheduleStatusViewModel.resolve()
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()
    @ObservedObject var doseAddViewModel = Container.shared.doseAddViewModel.resolve()
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Initializer
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }

    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                if (UserManager.shared.isManager ?? true) {
                    ClientListView(relationLists: doseScheduleViewModel.relationLists,
                                   selectedClientId: $selectedClientId)
                        .fadeIn(delay: 0.1)
                }
                
                CustomWeekCalendarHeaderView(selectedDate: $selectedDate)
                    .padding(.top, 25)
                    .fadeIn(delay: 0.2)
                    .frame(maxWidth: .infinity, 
                           minHeight: UserManager.shared.isManager ?? true ? 100 : 130,
                           maxHeight: UserManager.shared.isManager ?? true ? 100 : 130)
                    .background(UserManager.shared.isManager ?? true ? .clear : .white)
                    .padding(.bottom, 15)
                
                if (UserManager.shared.isManager ?? true) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            ForEach(doseScheduleViewModel.relationLists, id: \.memberID) { relation in
                                ScrollView(.vertical, showsIndicators: false) {
                                    VStack {
                                        ZStack(alignment: .topTrailing) {
                                            DoseScheduleSubView(takenStatus: 0,
                                                                memberId: relation.memberID,
                                                                isCabinetExist: relation.cabinetID != 0)
                                                .padding(.top, 10)
                                                .padding(.bottom, 20)
                                                .fadeIn(delay: 0.3)
                                            // 보호자일 때만 존재
                                            if (UserManager.shared.isManager ?? true) {
                                                Button(action: {
                                                    self.isUserPoked = true
                                                }, label: {
                                                    HStack {
                                                        if isUserPoked {
                                                            Text("찌르기 완료")
                                                                .font(.body2Medium)
                                                                .foregroundStyle(Color.gray70)
                                                                .padding(6)
                                                        } else {
                                                            Image("ic_poke")
                                                                .frame(width: 30, height: 30)
                                                            Text("찌르기")
                                                                .font(.body2Medium)
                                                                .foregroundColor(Color.gray70)
                                                                .padding(.trailing, 2)
                                                        }
                                                    }
                                                    .padding(5)
                                                    .background(Color.white)
                                                    .cornerRadius(8)
                                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color.gray10, lineWidth: 2)
                                                    )

                                                })
                                                .disabled(isUserPoked)
                                                .padding(.trailing, 25)
                                                .fadeIn(delay: 0.3)
                                            }
                                        }
                                        
                                        DoseScheduleSubView(takenStatus: 2,
                                                            memberId: relation.memberID,
                                                            isCabinetExist: relation.cabinetID != 0)
                                            .padding(.bottom, 20)
                                            .fadeIn(delay: 0.4)
                                        
                                        DoseScheduleSubView(takenStatus: 1,
                                                            memberId: relation.memberID,
                                                            isCabinetExist: relation.cabinetID != 0)
                                            .padding(.bottom, 20)
                                            .fadeIn(delay: 0.5)
                                        
                                        Spacer()
                                    }
                                    .containerRelativeFrame(.horizontal)
                                    
                                }
                                .refreshable {
                                    refresh()
                                }
                            }
                        }
                        .scrollTargetLayout(isEnabled: true)
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $selectedClientId)
                } else {
                    ScrollView {
                        DoseScheduleSubView(takenStatus: 0,
                                            memberId: UserManager.shared.memberId ?? 0,
                                            isCabinetExist: homeViewModel.clientCabnetId != 0)
                            .padding(.top, 20)
                            .fadeIn(delay: 0.3)
                        
                        DoseScheduleSubView(takenStatus: 2,
                                            memberId: UserManager.shared.memberId ?? 0,
                                            isCabinetExist: homeViewModel.clientCabnetId != 0)
                            .padding(.bottom, 20)
                            .fadeIn(delay: 0.3)
                        
                        DoseScheduleSubView(takenStatus: 1,
                                            memberId: UserManager.shared.memberId ?? 0,
                                            isCabinetExist: homeViewModel.clientCabnetId != 0)
                            .padding(.bottom, 20)
                            .fadeIn(delay: 0.3)
                    }
                    .refreshable {
                        refresh()
                    }
                }
                
            }
            .background(Color.gray5)
            
            Button(action: {
                self.doseAddViewModel.dosePlanInfoState.memberID = self.selectedClientId ?? 0
                self.navigator.next(paths: ["doseAdd"], items: [:], isAnimated: true)
            }, label: {
                HStack {
                    Image(systemName: "plus")
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color.white)
                        .padding(.leading, 20)
                    
                    Text("약 추가")
                        .font(.body1Bold)
                        .foregroundStyle(Color.white)
                        .padding(.trailing, 20)
                }
            })
            .padding([.top, .bottom], 15)
            .background(isSelectedMemberHasntPillCase() ? Color.gray70 :Color.primary60)
            .cornerRadius(30)
            .padding(.trailing, 20)
            .padding(.bottom, 25)
            .fadeIn(delay: 0.6)
            .disabled(isSelectedMemberHasntPillCase())
        }
        .onReceive(homeViewModel.$isDataReady) { _ in
            // 만약 피보호자라면
            if !(UserManager.shared.isManager ?? true) {
                selectedClientId = UserManager.shared.memberId
            } else {
                self.selectedClientId = homeViewModel.relationLists.first?.memberID
            }
        }
        .onReceive(doseScheduleStatusViewModel.$showDoseInfoView) { newValue in
            if newValue {
                self.showDoseInfoView = true
            }
        }
        .onAppear {
            refresh()
        }
        .onChange(of: selectedDate, {
            homeViewModel.$requestGetDoseLog.send((selectedClientId!, DateHelper.dateString(selectedDate)))
        })
        .onChange(of: isUserPoked, {
            if isUserPoked {
                fcmViewModel.requestPushAlarmToServer(selectedClientId ?? 0)
                toastManager.showToast(description: "\(selectedClientName ?? "노수인") 님을 콕 찔렀어요.")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.isUserPoked = false
                })
            }
        })
        .onChange(of: selectedClientId, {
            if homeViewModel.isDataReady {
                if selectedClientId == nil {
                    selectedClientId = homeViewModel.relationLists.first?.memberID
                    selectedClientName = homeViewModel.relationLists.first?.memberName
                }
                selectedClientName = homeViewModel.relationLists.first(where: { $0.memberID == selectedClientId})?.memberName ?? "null"
                UserManager.shared.selectedClientName = homeViewModel.relationLists.first(where: { $0.memberID == selectedClientId})?.memberName ?? "null"
                UserManager.shared.selectedClientId = selectedClientId
                homeViewModel.$requestGetDoseLog.send((selectedClientId ?? 0, DateHelper.dateString(selectedDate)))
            }
        })
        .fullScreenCover(isPresented: $showDoseInfoView, content: {
            SearchDoseElementByIdPopUpView()
        })
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
    }
    
    private func isSelectedMemberHasntPillCase() -> Bool {
        if UserManager.shared.isManager ?? true {
            homeViewModel.relationLists.contains { relation in
                relation.memberID == selectedClientId && relation.cabinetID == 0
            }
        } else {
            homeViewModel.clientCabnetId == 0
        }
    }
    
    private func refresh() {
        if !(UserManager.shared.isManager ?? true) {
            selectedClientId = UserManager.shared.memberId ?? 0
        }
        if selectedClientId == 0 && homeViewModel.isDataReady {
            selectedClientId = homeViewModel.relationLists.first?.memberID
            selectedClientName = homeViewModel.relationLists.first?.memberName
        }
        homeViewModel.$requestGetDoseLog.send(((selectedClientId ?? 0), DateHelper.dateString(selectedDate)))
    }
}

// MARK: - DoseScheduleSubView

struct DoseScheduleSubView: View {
    
    // MARK: - body
    
    let takenStatus: Int
    let memberId: Int
    let isCabinetExist: Bool
    @State private var showAddPillCaseView: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                switch takenStatus {
                case 1:
                    Image("ic_dose_blue")
                        .frame(width: 20, height: 20)
                        .padding(.leading, 25)
                        .padding(.trailing, 1)
                    
                    Text("완료한 약속시간")
                        .font(.body2Medium)
                        .foregroundStyle(Color.gray70)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                case 2:
                    Image("ic_dose_red")
                        .frame(width: 20, height: 20)
                        .padding(.leading, 25)
                        .padding(.trailing, 1)

                    Text("미완료한 약속시간")
                        .font(.body2Medium)
                        .foregroundStyle(Color.gray70)
                        .frame(maxWidth: .infinity, alignment: .leading)

                case 0:
                    Image("ic_dose_gray")
                        .frame(width: 20, height: 20)
                        .padding(.leading, 25)
                        .padding(.trailing, 1)
                    
                    Text("예정된 약속시간")
                        .font(.body2Medium)
                        .foregroundStyle(Color.gray70)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                default:
                    EmptyView()
                }
            }
            
            DoseScheduleStatusView(memberId: memberId,
                                   isCabinetExist: isCabinetExist,
                                   takenStatus: takenStatus,
                                   showAddPillCaseView: $showAddPillCaseView)
                .padding([.top, .bottom], 15)
                .padding([.leading, .trailing], 25)
        }
        .sheet(isPresented: $showAddPillCaseView, content: {
            AddPillCaseView(selectedMemberId: memberId)
        })
    }
}
