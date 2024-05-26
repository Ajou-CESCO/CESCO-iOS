//
//  DoseScheduleView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/14/24.
//

import SwiftUI

import LinkNavigator
import Factory

struct DoseScheduleView: View {
    
    // MARK: - Properties
    
    @State private var selectedDays = Set<String>()
    @State var selectedClientId: Int?  // 선택된 Client
    @State var isUserPoked: Bool = false
    let navigator: LinkNavigatorType
    @ObservedObject var doseScheduleViewModel = DoseScheduleViewModel()
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()
    @ObservedObject var doseAddViewModel = Container.shared.doseAddViewModel.resolve()
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                
                if (UserManager.shared.isManager ?? true) {
                    ClientListView(relationLists: doseScheduleViewModel.relationLists,
                                   selectedClientId: $selectedClientId)
                        .fadeIn(delay: 0.1)
                }
                
                CustomWeekCalendarView(selectedDays: $selectedDays)
                    .padding(.top, 17)
                    .fadeIn(delay: 0.2)
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
                    .background(UserManager.shared.isManager ?? true ? .clear : .white)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(doseScheduleViewModel.relationLists, id: \.memberID) { relation in
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack {
                                    ZStack(alignment: .topTrailing) {
                                        DoseScheduleSubView(takenStatus: 0,
                                                            memberId: relation.memberID,
                                                            isCabinetExist: relation.cabinetID != 0)
                                            .padding(.top, UserManager.shared.isManager ?? true ? 10 : 20)
                                            .padding(.bottom, 20)
                                            .fadeIn(delay: 0.3)
                                        // 보호자일 때만 존재
                                        if (UserManager.shared.isManager ?? true) {
                                            Button(action: {
                                                self.isUserPoked = true
                                                print(self.isUserPoked)
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
                
                if isUserPoked {
                    ToastView(description: "김철수 님을 콕 찔렀어요.",
                              show: $isUserPoked)
                        .padding(.bottom, 20)
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
        .onAppear {
            refresh()
        }
        .onChange(of: selectedClientId, {
            if homeViewModel.isDataReady {
                if selectedClientId == nil {
                    selectedClientId = homeViewModel.relationLists.first?.memberID
                }
                homeViewModel.$requestGetDoseLog.send(selectedClientId!)
            }
        })
    }
    
    private func isSelectedMemberHasntPillCase() -> Bool {
        homeViewModel.relationLists.contains { relation in
            relation.memberID == selectedClientId && relation.cabinetID == 0
        }
    }
    
    private func refresh() {
        if !(UserManager.shared.isManager ?? true) {
            selectedClientId = UserManager.shared.memberId ?? 0
        }
        if selectedClientId == 0 && homeViewModel.isDataReady {
            selectedClientId = homeViewModel.relationLists.first?.memberID
        }
        homeViewModel.$requestGetDoseLog.send(selectedClientId ?? 0)
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
            AddPillCaseView(selectedManagerId: memberId)
        })
    }
}
