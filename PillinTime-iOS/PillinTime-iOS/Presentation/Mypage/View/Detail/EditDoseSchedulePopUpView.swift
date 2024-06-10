//
//  EditDoseSchedulePopUpView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/10/24.
//

import SwiftUI

import Factory

// MARK: - EditDoseSchedulePopUpView

struct EditDoseSchedulePopUpView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedDays: Set<String> = Set<String>()
    @State private var selectedTimeStrings: [String] = []

    @ObservedObject var doseScheduleStatusViewModel = Container.shared.doseScheduleStatusViewModel.resolve()
    @ObservedObject var managementDoseScheduleViewModel: ManagementDoseScheduleViewModel

    let dayToInt: [String: Int] = ["월": 1, "화": 2, "수": 3, "목": 4, "금": 5, "토": 6, "일": 7]
    let intToDay: [Int: String] = [1: "월", 2: "화", 3: "수", 4: "목", 5: "금", 6: "토", 7: "일"]
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Button(action: {
                    self.dismiss()
                    self.doseScheduleStatusViewModel.showDoseInfoView = false
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.gray60)
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 10)
                
                ScrollView(showsIndicators: false) {
                    if self.doseScheduleStatusViewModel.isNetworking {
                        LoadingView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        Text("복약 계획 수정")
                            .font(.logo2ExtraBold)
                            .foregroundStyle(Color.gray90)
                            .frame(alignment: .leading)
                            .padding()
                        
                        Text("복용하는 요일을 선택해주세요")
                             .font(.body1Medium)
                             .foregroundStyle(Color.gray70)
                             .frame(maxWidth: .infinity, alignment: .leading)
                             .padding(.top, 50)
                             .fadeIn(delay: 0.1)
                         
                        CustomWeekCalendarView(isSelectDisabled: false,
                                               isDoseAdd: true,
                                               selectedDays: $selectedDays)
                            .onChange(of: selectedDays, {
                                managementDoseScheduleViewModel.patchInfoViewModelState.weekdayList = selectedDays.compactMap { dayToInt[$0] }.sorted()
                            })
                            .onAppear {
                                selectedDays = Set(managementDoseScheduleViewModel.patchInfoViewModelState.weekdayList.compactMap { intToDay[$0] })
                            }
                            .fadeIn(delay: 0.2)
                        
                        Text("복용하는 시간대를 선택해주세요")
                             .font(.body1Medium)
                             .foregroundStyle(Color.gray70)
                             .frame(maxWidth: .infinity, alignment: .leading)
                             .padding(.top, 30)
                             .fadeIn(delay: 0.1)

                        SelectDoseTimeView(selectedTimeStrings: $selectedTimeStrings)
                            .padding(.top, 8)
                            .padding([.leading, .trailing], 10)
                            .fadeIn(delay: 0.2)
                            .onChange(of: selectedTimeStrings, {
                                managementDoseScheduleViewModel.patchInfoViewModelState.timeList = selectedTimeStrings
                                print(managementDoseScheduleViewModel.patchInfoViewModelState.timeList)
                            })
                    }
                }
                
                CustomButton(buttonSize: .regular,
                             buttonStyle: .filled,
                             action: {
                    self.managementDoseScheduleViewModel.$requestPatchDosePlan.send()
                }, content: {
                    Text("수정 완료하기")
                }, isDisabled: self.selectedDays.isEmpty || self.selectedTimeStrings.isEmpty,
                  isLoading: self.managementDoseScheduleViewModel.isEditNetworking
                )
            }
            .padding([.leading, .trailing], 27)
            .padding(.top, 29)
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding()
        .scaleFadeIn(delay: 0.1)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .shadow(color: Color.gray60.opacity(0.2), radius: 10, x: 0, y: 4)
        .onReceive(managementDoseScheduleViewModel.$isEditNetworkSucced, perform: { _ in
            if managementDoseScheduleViewModel.isEditNetworkSucced {
                self.dismiss()
            }
        })
    }
}
