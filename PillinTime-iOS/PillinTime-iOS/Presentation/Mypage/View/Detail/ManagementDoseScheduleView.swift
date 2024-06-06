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
    
    // MARK: - Properties
    
    @State var selectedClientId: Int?  // 선택된 Client

    // MARK: - body
    
    var body: some View {
        
        ZStack {
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
                }
                            
                Text.multiColoredText("등록된 약 \(managementDoseScheduleViewModel.dosePlanList.count)",
                                      coloredSubstrings: [("\(managementDoseScheduleViewModel.dosePlanList.count)", Color.primary60)])
                    .font(.body2Medium)
                    .foregroundStyle(Color.gray70)
                    .padding([.top, .bottom])
                    .fadeIn(delay: 0.2)
                
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
                                        ManagementDoseScheduleElementView(dosePlanList: $managementDoseScheduleViewModel.dosePlanList,
                                                                          selectedClientId: $selectedClientId,
                                        managementDoseScheduleViewModel: self.managementDoseScheduleViewModel)
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
                            
                            ManagementDoseScheduleElementView(dosePlanList: .constant(
                                managementDoseScheduleViewModel.dosePlanList
                            ), selectedClientId: $selectedClientId,
                                managementDoseScheduleViewModel: self.managementDoseScheduleViewModel)
                            
                            Spacer()
                        }
                    }
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $selectedClientId)
                .fadeIn(delay: 0.3)
            }
            .padding(16)
        }
        .onReceive(managementDoseScheduleViewModel.$dosePlanList, perform: {_ in
            print("changed doseplanlist", managementDoseScheduleViewModel.dosePlanList)
        })
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
    @ObservedObject var managementDoseScheduleViewModel: ManagementDoseScheduleViewModel
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()

    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(dosePlanList, id: \.medicineID) { plan in
                HStack {
                    VStack(alignment: .leading) {
                        Text(plan.medicineName)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(width: 250)
                            .font(.h5Bold)
                            .foregroundStyle(Color.gray90)
                            .padding(.top, 10)
                        
                        ManagementDoseScheduleElementDetailView(dosePlanList: plan, 
                                                                isUserHasSideEffect: .constant(!isAdverseMapSafe(medicineAdverse: plan.medicineAdverse)))
                            .padding(.bottom, 10)
                    }
                    .padding(.leading, 20)
                    
                    Button(action: {
                        self.selectedDosePlan = plan
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(Color.gray90)
                    })
                    .padding()
                }
                
                Divider()
            }
        }
        .fullScreenCover(item: $selectedDosePlan, content: { _ in
            CustomPopUpView(mainText: "선택한 일정을 삭제하시겠습니까?",
                            subText: "삭제하면 해당 일정에 대해 관리하지 못해요.",
                            leftButtonText: "취소하기", rightButtonText: "삭제하기", leftButtonAction: {}, rightButtonAction: {
                requestServer()
            })
            .background(ClearBackgroundView())
            .background(Material.ultraThin)
        })
        .transaction { transaction in   // 모달 애니메이션 삭제
            transaction.disablesAnimations = true
        }
        .onChange(of: managementDoseScheduleViewModel.isDeleteSucceed, {
            self.toastManager.showToast(description: "일정 삭제를 완료했어요.")
        })
    }
    
    private func requestServer() {
        self.managementDoseScheduleViewModel.requestDeletePlanToServer(DeleteDoseScheduleState(memberId: self.selectedClientId ?? 0,
                                                                                               medicineId: self.selectedDosePlan?.medicineID ?? "",
                                                                                               cabinetIndex: self.selectedDosePlan?.cabinetIndex ?? 0))
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
                MedicineSideEffectView(isUserHasSideEffect: $isUserHasSideEffect)

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
