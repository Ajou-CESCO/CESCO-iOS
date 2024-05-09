//
//  DoseAddView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/6/24.
//

import SwiftUI
import Combine

import LinkNavigator

struct DoseAddView: View {
    
    // MARK: - Properties
    
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
                CustomTextInput(placeholder: "의약품명 검색",
                                text: $doseAddViewModel.searchDose,
                                isError: .constant(false),
                                errorMessage: "",
                                textInputStyle: .search)
                .padding([.leading, .trailing], 33)
                .fadeIn(delay: 0.3)
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

//#Preview {
//    DoseAddView()
//}
