//
//  ManagementDoseScheduleView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/26/24.
//

import SwiftUI

import Moya
import Factory

struct ManagementDoseScheduleView: View {
    
    // MARK: - Dependency
    
    @ObservedObject var homeViewModel: HomeViewModel = Container.shared.homeViewModel.resolve()
    @ObservedObject var managementDoseScheduleViewModel: ManagementDoseScheduleViewModel = ManagementDoseScheduleViewModel(planService: PlanService(provider: MoyaProvider<PlanAPI>()))
    @ObservedObject var doseScheduleStatusViewModel = Container.shared.doseScheduleStatusViewModel.resolve()
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    
    // MARK: - Properties
    
    @State var selectedClientId: Int?  // 선택된 Client
    @State var showDoseInfoView: Bool = false

    // MARK: - body
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            Color.white
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                if (UserManager.shared.isManager ?? true) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(homeViewModel.relationLists, id: \.memberID) { relation in
                                VStack {
                                    Text(relation.memberName)
                                        .font(.body1Medium)
                                        .foregroundStyle(selectedClientId == relation.memberID ? Color.gray90 : Color.gray50)
                                    
                                    Rectangle()
                                        .frame(width: 70, height: 2)
                                        .foregroundStyle(selectedClientId == relation.memberID ? Color.primary60 : Color.clear)
                                }
                                .onTapGesture {
                                    self.selectedClientId = relation.memberID
                                }
                            }
                        }
                    }
                    .fadeIn(delay: 0.1)
                    .padding([.leading, .trailing, .top], 16)
                }
                            
                Text.multiColoredText("등록된 약 \(managementDoseScheduleViewModel.dosePlanList.count)",
                                      coloredSubstrings: [("\(managementDoseScheduleViewModel.dosePlanList.count)", Color.primary60)])
                    .font(.body2Medium)
                    .foregroundStyle(Color.gray70)
                    .padding([.top, .bottom])
                    .fadeIn(delay: 0.2)
                    .padding(.leading, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    if UserManager.shared.isManager ?? true {
                        LazyHStack(spacing: 0) {
                            ForEach(homeViewModel.relationLists, id: \.memberID) { _ in
                                VStack {
                                    if managementDoseScheduleViewModel.isNetworking {
                                        LoadingView()
                                    } else if managementDoseScheduleViewModel.dosePlanList.isEmpty {
                                        CustomEmptyView(mainText: "등록된 복약 일정이 없습니다", subText: "복약 탭에서 일정을 추가하세요.")
                                    } else {
                                        ScrollView {
                                            ManagementDoseScheduleElementView(dosePlanList: $managementDoseScheduleViewModel.dosePlanList,
                                                                              selectedClientId: $selectedClientId,
                                                                              managementDoseScheduleViewModel: self.managementDoseScheduleViewModel)
                                            .padding(20)

                                        }
                                    }
                  
                                    Spacer()
                                }
                                .containerRelativeFrame(.horizontal)
                                .refreshable {
                                    requestDosePlanToServer()
                                }
                            }
                        }
                        .scrollTargetLayout(isEnabled: true)
                    } else {
                        VStack(alignment: .center) {
                            if managementDoseScheduleViewModel.isNetworking {
                                LoadingView()
                            } else if managementDoseScheduleViewModel.dosePlanList.isEmpty {
                                CustomEmptyView(mainText: "등록된 복약 일정이 없습니다", subText: "복약 탭에서 일정을 추가하세요.")
                                    .frame(width: UIScreen.main.bounds.width)
                            }
                            
                            ScrollView {
                                ManagementDoseScheduleElementView(dosePlanList: .constant(
                                    managementDoseScheduleViewModel.dosePlanList
                                ), selectedClientId: $selectedClientId,
                                    managementDoseScheduleViewModel: self.managementDoseScheduleViewModel)
                                .padding(20)
                            }
                            .frame(width: UIScreen.main.bounds.width)
                            
                            Spacer()
                        }
                    }
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $selectedClientId)
                .fadeIn(delay: 0.3)
            }
            
            if toastManager.show {
                ToastView(description: toastManager.description, show: $toastManager.show)
                    .zIndex(1)
                    .padding(.bottom, 60)
            }
        }
        .onReceive(doseScheduleStatusViewModel.$showDoseInfoView) { newValue in
            if newValue {
                self.showDoseInfoView = true
            }
        }
        .onAppear {
            if UserManager.shared.isManager ?? true {
                selectedClientId = homeViewModel.relationLists.first?.memberID
            } else {
                selectedClientId = UserManager.shared.memberId
            }
        }
        .onChange(of: selectedClientId, {
            requestDosePlanToServer()
        })
        .fullScreenCover(isPresented: $showDoseInfoView, content: {
            SearchDoseElementByIdPopUpView()
        })
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
    }
    
    private func requestDosePlanToServer() {
        managementDoseScheduleViewModel.$requestGetDosePlan.send(selectedClientId ?? 0)
    }
}

// MARK: - ManagementDoseScheduleElementView

struct ManagementDoseScheduleElementView: View {
    
    // MARK: - Properties
    
    @Binding var dosePlanList: [GetDosePlanResponseModelResult]
    @Binding var selectedClientId: Int?
    @State var selectedDosePlan: GetDosePlanResponseModelResult?  // 삭제할 dose plan
    @State var showSelectDetailView = [String: Bool]()
    @State var showDeleteView: Bool = false
    @State var showEditView: Bool = false
    
    @ObservedObject var managementDoseScheduleViewModel: ManagementDoseScheduleViewModel
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()
    @ObservedObject var doseScheduleStatusViewModel = Container.shared.doseScheduleStatusViewModel.resolve()
    
    let colors: [Color] = [.error60, .warning60, .success60, .primary40, .purple60]
    let colorToIndex: [Color: Int] = [.error60: 1, .warning60: 2, .success60: 3, .primary40: 4, .purple60: 5]

    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(managementDoseScheduleViewModel.dosePlanList, id: \.medicineID) { plan in
                ZStack(alignment: .topTrailing) {
                    HStack {
                        VStack(alignment: .leading) {
                            let color = colors[plan.cabinetIndex - 1]
                            
                            HStack {
                                Circle()
                                    .fill(color)
                                    .frame(width: 20, height: 20)
                                
                                Text(plan.medicineName)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .frame(width: 200, alignment: .leading)
                                    .font(.h5Bold)
                                    .foregroundStyle(Color.gray90)
                            }

                            MedicineSideEffectView(isUserHasSideEffect: .constant(!isAdverseMapSafe(medicineAdverse: plan.medicineAdverse)))
                            
                            ManagementDoseScheduleElementDetailView(dosePlanList: plan,
                                                                    isUserHasSideEffect: .constant(!isAdverseMapSafe(medicineAdverse: plan.medicineAdverse)))
                        }
                        .padding(20)
                        
                        VStack {
                            Button(action: {
                                toggleSelectDetailView(for: plan.medicineID)
                            }, label: {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(Color.gray90)
                                    .padding(25)
                            })
                            
                            Spacer()
                        }

                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.bottom, 20)
                    .scaleFadeIn(delay: 0.1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .shadow(color: Color.gray60.opacity(0.2), radius: 10, x: 0, y: 0)

                    if showSelectDetailView[plan.medicineID] == true {
                        VStack {
                            Button(action: {
                                self.showDeleteView = true
                                self.selectedDosePlan = plan
                            }, label: {
                                HStack {
                                    Text("삭제하기")
                                        .font(.body2Medium)
                                        .foregroundStyle(Color.gray90)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "xmark.circle")
                                        .foregroundStyle(Color.gray90)
                                    
                                }
                                .padding(2)
                            })
                            
                            Divider()
                                                        
                            Button(action: {

                            }, label: {
                                HStack {
                                    Text("수정하기")
                                        .font(.body2Medium)
                                        .foregroundStyle(Color.gray90)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "highlighter")
                                        .foregroundStyle(Color.gray90)
                                }
                                .padding(2)
                            })
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .scaleFadeIn(delay: 0.1)
                        .frame(width: 150, height: 30)
                        .padding(.top, 18)
                        .padding(.trailing, 20)
                        .shadow(color: Color.gray60.opacity(0.2), radius: 5, x: 0, y: 0)
                    }
                }
                .onTapGesture {
                    showSelectDetailView[plan.medicineID] = false
                }
            }
        }
        .fullScreenCover(item: $selectedDosePlan, content: { _ in
            CustomPopUpView(mainText: "선택한 일정을 삭제하시겠습니까?",
                            subText: "삭제하면 해당 일정에 대해 관리하지 못해요.",
                            leftButtonText: "취소하기", rightButtonText: "삭제하기", leftButtonAction: {}, rightButtonAction: {
                managementDoseScheduleViewModel.isNetworking = true
                requestDeleteDoseScheduleToServer()
            })
            .background(ClearBackgroundView())
            .background(Material.ultraThin)
        })
        .transaction { transaction in   // 모달 애니메이션 삭제
            transaction.disablesAnimations = true
        }
        .onChange(of: managementDoseScheduleViewModel.isDeleteSucceed, {
            if managementDoseScheduleViewModel.isDeleteSucceed {
                self.toastManager.showToast(description: "일정 삭제를 완료했어요.")
                self.requestDosePlanToServer()
            }
        })

    }
  
    // MARK: - Methods
    
    private func toggleSelectDetailView(for medicineID: String) {
        if showSelectDetailView[medicineID] == nil {
            showSelectDetailView[medicineID] = true
        } else {
            showSelectDetailView[medicineID]?.toggle()
        }
    }
    
    private func requestDeleteDoseScheduleToServer() {
        self.managementDoseScheduleViewModel.requestDeletePlanToServer(DeleteDoseScheduleState(memberId: self.selectedClientId ?? 0,
                                                                                               groupId: self.selectedDosePlan?.groupId ?? 0))
    }
    
    private func requestDosePlanToServer() {
        managementDoseScheduleViewModel.$requestGetDosePlan.send(selectedClientId ?? 0)
    }
    
    private func isAdverseMapSafe(medicineAdverse: MedicineAdverse) -> Bool {
        return medicineAdverse.dosageCaution == nil &&
        medicineAdverse.ageSpecificContraindication == nil &&
        medicineAdverse.elderlyCaution == nil &&
        medicineAdverse.administrationPeriodCaution == nil &&
        medicineAdverse.pregnancyContraindication == nil &&
        medicineAdverse.duplicateEfficacyGroup == nil
    }
}

// MARK: - ManagementDoseScheduleElementDetailView

struct ManagementDoseScheduleElementDetailView: View {
    
    // MARK: - Properties
    
    @State var dosePlanList: GetDosePlanResponseModelResult
    let intToDay: [Int: String] = [1: "월", 2: "화", 3: "수", 4: "목", 5: "금", 6: "토", 7: "일"]
    @Binding var isUserHasSideEffect: Bool
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 10) {
                Text(convertIntArrayToDays(dosePlanList.weekdayList))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .font(.caption2Medium)
                    .background(Color.gray10)
                    .foregroundColor(Color.gray80)
                    .cornerRadius(6)
                
                Text(DateHelper.convertTimeStrings(dosePlanList.timeList))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .font(.caption2Medium)
                    .background(Color.gray10)
                    .foregroundColor(Color.gray80)
                    .cornerRadius(6)
            }
            .padding(.trailing, 5)
        }
    }
    
    private func convertIntArrayToDays(_ intArray: [Int]) -> String {
        let days = intArray.compactMap { intToDay[$0] }
        return days.joined(separator: ", ")
    }
}
