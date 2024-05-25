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
                            })
            
            if (searchDoseViewModel.isNetworking) {
                LoadingView()
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
                                                      ))
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
}

// MARK: - SearchDoseElementView

struct SearchDoseElementView: View {
    
    // MARK: - Properties
    
    @ObservedObject var doseAddViewModel = Container.shared.doseAddViewModel.resolve()
    @Binding var searchDoseResponseModelResult: SearchDoseResponseModelResult
    @State var showDoseElementDetail: Bool = false
    @Binding var isDoseSelected: Bool

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
                    
                    MedicineEffectView(text: searchDoseResponseModelResult.medicineEffect)
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
        ScrollView(.horizontal, showsIndicators: false) {
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
    }
    
    func splitText() -> [String] {
        return text.components(separatedBy: ", ")
    }
}
