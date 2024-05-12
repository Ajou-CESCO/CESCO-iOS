//
//  DoseAddView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/6/24.
//

import SwiftUI
import Combine

import Moya
import LinkNavigator

struct DoseAddView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    let navigator: LinkNavigatorType
    
    @ObservedObject var doseAddViewModel: DoseAddViewModel
    
    // MARK: - Initializer
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
        self.doseAddViewModel = DoseAddViewModel()
    }
    
    // MARK: - body
    
    var body: some View {
        VStack {
            ProgressView(value: Float(doseAddViewModel.step / 3))
                .tint(Color.primary60)

            CustomNavigationBar(previousAction: {
                if doseAddViewModel.step > 1 {
                    doseAddViewModel.previousStep()
                } else {
                    dismiss()
                }
            })
            
            VStack(alignment: .leading) {
                Text(doseAddViewModel.mainText)
                    .font(.logo2ExtraBold)
                    .foregroundStyle(Color.gray100)
                    .padding(.bottom, 5)
                    .fadeIn(delay: 0.1)
                
                Text(doseAddViewModel.subText)
                    .font(.body1Regular)
                    .foregroundStyle(Color.gray70)
                    .fadeIn(delay: 0.2)
            }
                        
            /// - 1: 의약품명 검색
            /// - 2: 복용 요일 선택
            /// - 3: 복용 시간 선택
            switch doseAddViewModel.step {
            case 1:
                SearchDoseView()
            case 2:
               Text("복용하는 요일을 선택해주세요.")
                    .font(.body1Medium)
                    .foregroundStyle(Color.gray70)
                    .frame(alignment: .leading)
                
                CustomWeekCalendarView(isSelectDisabled: false)
            default:
                Text("복용하는 시간대를 선택해주세요.")
                     .font(.body1Medium)
                     .foregroundStyle(Color.gray70)
                     .frame(alignment: .leading)
            }
            
            Spacer()
            
            CustomButton(buttonSize: .regular,
                         buttonStyle: .filled,
                         action: {
                self.doseAddViewModel.step += 1
            }, content: {
                Text("다음")
            }, isDisabled: false)
            .padding([.leading, .trailing], 32)
        }
    }
}

// MARK: - SearchDoseView

struct SearchDoseView: View {
    
    // MARK: - Properties

    @ObservedObject var doseAddViewModel: DoseAddViewModel
    @ObservedObject var searchDoseViewModel: SearchDoseRequestViewModel
    
    // MARK: - Initializer
    
    init() {
        self.doseAddViewModel = DoseAddViewModel()
        self.searchDoseViewModel = SearchDoseRequestViewModel(etcService: EtcService(provider: MoyaProvider<EtcAPI>()))
    }
    
    // MARK: - body
    
    var body: some View {
        VStack {
            CustomTextInput(placeholder: "의약품명 검색",
                            text: $doseAddViewModel.searchDose,
                            isError: .constant(false),
                            errorMessage: "",
                            textInputStyle: .search,
                            searchButtonAction: { searchDoseViewModel.$tapSearchButton.send(doseAddViewModel.searchDose)
                            })
            .fadeIn(delay: 0.3)
            
            if (searchDoseViewModel.isNetworking) {
                LoadingView()
            }
            
            ScrollView {
                if (searchDoseViewModel.isNetworkSucceed) {
                    ForEach(searchDoseViewModel.searchResults, id: \.medicineCode) { result in
                        SearchDoseElementView(viewModel: .constant(result))
                    }
                    .fadeIn(delay: 0.1)
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
    
    @Binding var viewModel: SearchDoseResponseModelResult
    @State var showDoseElementDetail: Bool = false
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.medicineName)
                .multilineTextAlignment(.leading)
                .font(.h5Bold)
                .foregroundStyle(Color.gray90)
                .frame(width: 225)
                .padding(.top, 10)
            
            MedicineEffectView(text: viewModel.medicineEffect)
                .padding(.bottom, 10)
            
            Divider()
        }
        .fullScreenCover(isPresented: $showDoseElementDetail,
                         content: {
            SearchDoseElementDetailPopUpView(viewModel: $viewModel,
                                             leftButtonAction: {},
                                             rightButtonAction: {})
                .background(ClearBackgroundView())
                .background(Material.ultraThin)
        })
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

// MARK: - SearchDoseElementDetailPopUpView

struct SearchDoseElementDetailPopUpView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss

    @Binding var viewModel: SearchDoseResponseModelResult
    
    let steps: [String] = ["효능", "복용 방법", "복용 전 알아두세요!", "보관법"]
    let leftButtonAction: () -> Void
    let rightButtonAction: () -> Void
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                ScrollView {
                    KFImageView(urlString: viewModel.medicineImage)
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                    
                    Text(viewModel.medicineName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.h4Bold)
                        .foregroundStyle(Color.gray90)
                        .lineSpacing(5)
                        .padding(.bottom, 10)
                    
                    HStack {
                        Text("품목기준코드")
                            .multilineTextAlignment(.leading)
                            .font(.body2Medium)
                            .foregroundStyle(Color.gray40)
                            .padding(.trailing, 5)
                        
                        Text(viewModel.medicineCode)
                            .multilineTextAlignment(.leading)
                            .font(.body2Medium)
                            .foregroundStyle(Color.gray70)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                    
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, label in
                        VStack(alignment: .leading) {
                            Text(label)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.body2Medium)
                                .foregroundStyle(Color.gray40)
                                .padding(.bottom, 5)
                            
                            Text(textForIndex(index).splitCharacter())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.body2Medium)
                                .foregroundStyle(Color.gray70)
                                .padding(.bottom, 10)
                                .lineSpacing(3)
                        }
                        
                    }
                }
                
                HStack {
                    CustomButton(buttonSize: .small,
                                 buttonStyle: .disabled,
                                 action: {
                        leftButtonAction()
                        dismiss()
                    }, content: {
                        Text("이전으로")
                    }, isDisabled: false)
                    .padding(.trailing, 3)
                    
                    CustomButton(buttonSize: .small,
                                 buttonStyle: .filled,
                                 action: {
                        rightButtonAction()
                        dismiss()
                    }, content: {
                        Text("선택하기")
                    }, isDisabled: false)
                    .padding(.leading, 3)
                    
                }
            }
            .padding([.leading, .trailing], 27)
            .padding(.top, 29)
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding([.leading, .trailing], 33)
        .scaleFadeIn(delay: 0.1)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func textForIndex(_ index: Int) -> String {
        switch index {
        case 0: return viewModel.medicineEffect
        case 1: return viewModel.useMethod
        case 2: return viewModel.useWarning
        default: return viewModel.depositMethod
        }
    }
}

#Preview {
    SearchDoseView()
}
