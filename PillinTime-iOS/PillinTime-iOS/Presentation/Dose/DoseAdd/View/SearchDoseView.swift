//
//  SearchDoseView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/18/24.
//

import SwiftUI

import Factory
import Moya

// MARK: - SearchDoseView

struct SearchDoseView: View {
    
    // MARK: - Properties

    @ObservedObject var doseAddViewModel = Container.shared.doseAddViewModel.resolve()
    @StateObject var searchDoseViewModel = SearchDoseRequestViewModel(etcService: EtcService(provider: MoyaProvider<EtcAPI>()))

    // MARK: - body
    
    var body: some View {
        VStack {
            CustomTextInput(placeholder: "의약품명 검색",
                            text: $doseAddViewModel.searchDose,
                            isError: .constant(false),
                            errorMessage: "",
                            textInputStyle: .search,
                            searchButtonAction: {
                                hideKeyboard()
                                searchDoseViewModel.$tapSearchButton.send(doseAddViewModel.searchDose)
                            }, onSubmit: {
                                searchDoseViewModel.$tapSearchButton.send(doseAddViewModel.searchDose)
                            })
            
            if (searchDoseViewModel.isNetworking) {
                SearchDoseLoadingView()
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    if (searchDoseViewModel.isNetworkSucceed) {
                        ForEach(searchDoseViewModel.searchResults, id: \.medicineCode) { result in
                            SearchDoseElementView(doseAddViewModel: doseAddViewModel,
                                                  searchDoseResponseModelResult: .constant(result),
                                                  isDoseSelected: Binding<Bool>(
                                                          get: { doseAddViewModel.dosePlanInfoState.medicineID == result.medicineCode },
                                                          set: { isSelected in
                                                              if isSelected {
                                                                  doseAddViewModel.dosePlanInfoState.medicineID = result.medicineCode
                                                              }
                                                           }
                                                  ), isUserHasSideEffect: .constant(!isAdverseMapSafe(medicineAdverse: result.medicineAdverse)))
                        }
                    }
                    
                    if (searchDoseViewModel.isResultEmpty) {
                        CustomEmptyView(mainText: "검색어를 다시 확인해주세요", subText: "검색 결과가 없습니다.")
                    }
                }
            }

        }
        .padding([.leading, .trailing], 33)
        .onTapGesture {
            hideKeyboard()
        }
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

// MARK: - SearchDoseElementView

struct SearchDoseElementView: View {
    
    // MARK: - Properties
    
    @ObservedObject var doseAddViewModel = Container.shared.doseAddViewModel.resolve()
    @Binding var searchDoseResponseModelResult: SearchDoseResponseModelResult
    @State var showDoseElementDetail: Bool = false
    @Binding var isDoseSelected: Bool
    @Binding var isUserHasSideEffect: Bool

    // MARK: - body
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(searchDoseResponseModelResult.medicineName)
                        .multilineTextAlignment(.leading)
                        .font(.h5Bold)
                        .foregroundStyle(Color.gray90)
                        .padding(.top, 10)
                        .padding(.leading, 5)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            MedicineSideEffectView(isUserHasSideEffect: $isUserHasSideEffect)
                            MedicineEffectView(text: searchDoseResponseModelResult.medicineEffect)
                        }
                    }
                    .padding(.bottom, 10)
                    .padding(.leading, 5)
                }
                                
                Image(isDoseSelected ? "ic_dose_selected" : "ic_dose_unselected")
                    .padding()
            }
            
            Divider()
        }
        .fullScreenCover(isPresented: $showDoseElementDetail,
                         content: {
            SearchDoseElementDetailPopUpView(viewModel: $searchDoseResponseModelResult,
                                             leftButtonAction: {},
                                             rightButtonAction: {
                self.doseAddViewModel.isDoseSelected = true
                self.doseAddViewModel.dosePlanInfoState.medicineID = searchDoseResponseModelResult.medicineCode
                self.doseAddViewModel.dosePlanInfoState.medicineName = searchDoseResponseModelResult.medicineName
                self.doseAddViewModel.dosePlanInfoState.medicineSeries = searchDoseResponseModelResult.medicineSeries
                self.doseAddViewModel.dosePlanInfoState.medicineAdverse = searchDoseResponseModelResult.medicineAdverse
            })
                .background(ClearBackgroundView())
                .background(Material.ultraThin)
        })
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
        .onTapGesture {
            self.showDoseElementDetail.toggle()
        }
    }
}

// MARK: - MedicineEffectView

struct MedicineEffectView: View {
    
    let text: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ForEach(splitText(), id: \.self) { word in
                Text(word)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .font(.caption2Medium)
                    .background(Color.gray10)
                    .foregroundColor(Color.gray80)
                    .cornerRadius(6)
            }
        }
        .padding(.trailing, 5)
    }
    
    func splitText() -> [String] {
        return text.components(separatedBy: ", ")
    }
}

// MARK: - MedicineSideEffectView

struct MedicineSideEffectView: View {
    
    @Binding var isUserHasSideEffect: Bool
    
    var body: some View {
        Text(isUserHasSideEffect ? "부작용 주의": "부작용 안전")
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .font(.caption2Medium)
            .background(isUserHasSideEffect ? Color.warning60: Color.success60)
            .foregroundColor(Color.white)
            .cornerRadius(6)
    }
}
