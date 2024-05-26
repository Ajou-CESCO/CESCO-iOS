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
        VStack(alignment: .leading) {
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
                        
            Text.multiColoredText("등록된 약 \(managementDoseScheduleViewModel.dosePlanList.count)",
                                  coloredSubstrings: [("\(managementDoseScheduleViewModel.dosePlanList.count)", Color.primary60)])
                .font(.body2Medium)
                .foregroundStyle(Color.gray70)
                .padding([.top, .bottom])
                .fadeIn(delay: 0.2)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(homeViewModel.relationLists, id: \.memberID) { _ in
                        ScrollView {
                            VStack(alignment: .center) {
                                if managementDoseScheduleViewModel.isNetworking {
                                    LoadingView()
                                } else if managementDoseScheduleViewModel.dosePlanList.isEmpty {
                                    CustomEmptyView(mainText: "등록된 복약 일정이 없습니다", subText: "복약 탭에서 일정을 추가하세요.")
                                }

                                ManagementDoseScheduleElementView(dosePlanList: .constant(
                                    managementDoseScheduleViewModel.dosePlanList
                                ))
                            }
                            .containerRelativeFrame(.horizontal)
                        }
                    }
                }
                .scrollTargetLayout(isEnabled: true)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $selectedClientId)
            .fadeIn(delay: 0.3)
        }
        .padding(16)
        .onAppear {
            selectedClientId = homeViewModel.relationLists.first?.memberID
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
    
    // MARK: - body
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ForEach(dosePlanList, id: \.medicineID) { plan in
                HStack {
                    VStack(alignment: .leading) {
                        Text(plan.medicineName)
                            .multilineTextAlignment(.leading)
                            .font(.h5Bold)
                            .foregroundStyle(Color.gray90)
                            .padding(.top, 10)
                        
                        ManagementDoseScheduleElementDetailView(dosePlanList: plan)
                            .padding(.bottom, 10)
                    }
                    .padding(.leading, 20)

                }
                
                Divider()
            }
        }
    }
}

// MARK: - ManagementDoseScheduleElementDetailView

struct ManagementDoseScheduleElementDetailView: View {
    
    // MARK: - Properties
    
    @State var dosePlanList: GetDosePlanResponseModelResult
    let intToDay: [Int: String] = [1: "월", 2: "화", 3: "수", 4: "목", 5: "금", 6: "토", 7: "일"]
        
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
