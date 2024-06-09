//
//  DoseAddView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/6/24.
//

import SwiftUI
import Combine

import Factory
import LinkNavigator
import Moya

struct DoseAddView: View {
    
    // MARK: - Properties
    
    @ObservedObject var doseAddViewModel = Container.shared.doseAddViewModel.resolve()
    @ObservedObject var homeViewModel = Container.shared.homeViewModel.resolve()
    @ObservedObject var toastManager = Container.shared.toastManager.resolve()

    let navigator: LinkNavigatorType
    
    @State private var isButtonDisabled: Bool = true
    @State private var selectedDays: Set<String> = Set<String>()
    @State private var startDate: Date = Date()  // 날짜 초기화
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    @State private var endDateExist: Bool = false
    @State private var selectedTimeStrings: [String] = []
    @State private var selectedColorIndex: Int = 0
    
    let dayToInt: [String: Int] = ["월": 1, "화": 2, "수": 3, "목": 4, "금": 5, "토": 6, "일": 7]
    let intToDay: [Int: String] = [1: "월", 2: "화", 3: "수", 4: "목", 5: "금", 6: "토", 7: "일"]
    
    var weekdayList: [Int] {
        return selectedDays.compactMap { dayToInt[$0] }.sorted()
    }

    // MARK: - Initializer
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            ProgressView(value: doseAddViewModel.progress)
                .tint(Color.primary60)
                .animation(.easeIn, value: doseAddViewModel.progress)

            CustomNavigationBar(previousAction: {
                if doseAddViewModel.step > 1 {
                    doseAddViewModel.previousStep()
                } else {
                    navigator.remove(paths: ["doseAdd"])
                    /// 복용 계획을 생성하고 나면, state 초기화
                    doseAddViewModel.dosePlanInfoState = AddDosePlanInfoState()
                    doseAddViewModel.searchDose = ""
                }
            })
            
            VStack(alignment: .leading) {
                Text(doseAddViewModel.mainText)
                    .font(.logo2ExtraBold)
                    .foregroundStyle(Color.gray100)
                    .padding(.bottom, 5)
                    .multilineTextAlignment(.leading)
                
                Text(doseAddViewModel.subText)
                    .font(.body1Regular)
                    .foregroundStyle(Color.gray70)
            }
            .padding([.leading, .trailing], 30)

            /// - 1: 의약품명 검색
            /// - 2: 복용 요일 선택
            /// - 3: 복용 시간 선택
            /// - 4: 복용 기간 선택
            /// - 5: 약통 인덱스 선택
            switch doseAddViewModel.step {
            case 1:
                SearchDoseView()
            case 2, 3:
                VStack {
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
                            doseAddViewModel.dosePlanInfoState.weekdayList = selectedDays.compactMap { dayToInt[$0] }.sorted()
                        })
                        .onAppear {
                            selectedDays = Set(doseAddViewModel.dosePlanInfoState.weekdayList.compactMap { intToDay[$0] })
                        }
                        .fadeIn(delay: 0.2)
                    
                    if doseAddViewModel.step == 3 {
                        Text("복용하는 시간대를 선택해주세요")
                             .font(.body1Medium)
                             .foregroundStyle(Color.gray70)
                             .frame(maxWidth: .infinity, alignment: .leading)
                             .padding(.top, 30)
                             .fadeIn(delay: 0.1)

                        SelectDoseTimeView(selectedTimeStrings: $selectedTimeStrings)
                            .padding(.top, 8)
                            .fadeIn(delay: 0.2)
                            .onChange(of: selectedTimeStrings, {
                                doseAddViewModel.dosePlanInfoState.timeList = selectedTimeStrings
                                print(doseAddViewModel.dosePlanInfoState.timeList)
                            })

                    }
                }
                .padding([.leading, .trailing], 30)
                
            case 4:
                SelectDosePeriodView(startDate: $startDate, endDate: $endDate, endDateExist: $endDateExist)
                    .padding([.leading, .trailing], 30)
                    .fadeIn(delay: 0.1)
                    .onAppear(perform: {
                        updatePeriod()
                    })
            case 5:
                SelectDosePillCaseView(selectColorIndex: $selectedColorIndex)
                    .fadeIn(delay: 0.3)
                    .onChange(of: selectedColorIndex, {
                        doseAddViewModel.dosePlanInfoState.cabinetIndex = selectedColorIndex
                    })
            default:
                EmptyView()
            }
            
            Spacer()
            
            CustomButton(buttonSize: .regular,
                         buttonStyle: .filled,
                         action: {
                self.isButtonDisabled = true
                if doseAddViewModel.step == 5 {
                    // 서버연결 시작
                    self.doseAddViewModel.$requestAddDosePlan.send(true)
                } else if doseAddViewModel.step == 4 {
                    updatePeriod()
                    self.doseAddViewModel.step += 1
                } else if doseAddViewModel.step == 1 {
                    self.doseAddViewModel.searchDose = self.doseAddViewModel.dosePlanInfoState.medicineName
                    if homeViewModel.occupiedCabinetIndex.count == 5 {
                        toastManager.showToast(description: "현재 모든 약통 칸이 사용 중입니다.\n기존 복용 계획을 삭제한 후 다시 이용해주세요.")
                    } else {
                        self.doseAddViewModel.step += 1
                    }
                } else {
                    self.doseAddViewModel.step += 1
                }
            }, content: {
                Text("다음")
            }, isDisabled: isButtonDisabled
            , isLoading: doseAddViewModel.isNetworking)
            .padding([.leading, .trailing], 32)

        }
        .onReceive(doseAddViewModel.$searchDose, perform: { _ in
            updateButtonState()
        })
        .onReceive(doseAddViewModel.$dosePlanInfoState, perform: { _ in
            updateButtonState()
        })
        .onChange(of: selectedDays, {
            if selectedDays.count >= 1 {
                doseAddViewModel.step = 3
                doseAddViewModel.dosePlanInfoState.weekdayList = weekdayList
            }
        })
        .onChange(of: doseAddViewModel.step, {
            updateButtonState()
        })
        .onChange(of: doseAddViewModel.isNetworkSucceed, {
            if doseAddViewModel.isNetworkSucceed {
                navigator.remove(paths: ["doseAdd"])
                self.toastManager.showToast(description: "복용 계획 등록을 완료했어요.")
                self.doseAddViewModel.step = 1
            }
        })
    }

    /// 버튼의 상태를 업데이트
    private func updateButtonState() {
        switch doseAddViewModel.step {
        case 1:
            /// medicineId나 textfield가 비어있을 경우, 버튼 disabled
            self.isButtonDisabled = (doseAddViewModel.dosePlanInfoState.medicineID.isEmpty || doseAddViewModel.searchDose.isEmpty ? true : false)
        case 2:
            self.isButtonDisabled = doseAddViewModel.dosePlanInfoState.weekdayList.isEmpty
        case 3:
            self.isButtonDisabled = doseAddViewModel.dosePlanInfoState.timeList.isEmpty
        case 5:
            self.isButtonDisabled = (self.selectedColorIndex == 0)
        default:
            self.isButtonDisabled = false
        }
    }
    
    /// 시작일과 종료일 view model에 저장
    private func updatePeriod() {
        doseAddViewModel.dosePlanInfoState.startAt = DateHelper.dateString(startDate)
        doseAddViewModel.dosePlanInfoState.endAt = DateHelper.dateString(endDate)
    }
}
