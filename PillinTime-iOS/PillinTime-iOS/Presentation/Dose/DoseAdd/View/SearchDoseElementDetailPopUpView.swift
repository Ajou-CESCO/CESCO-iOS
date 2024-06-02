//
//  SearchDoseElementDetailPopUpView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/18/24.
//

import SwiftUI

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
                ScrollView(showsIndicators: false) {
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
                    
                    if !isAdverseMapSafe(adverseMap: viewModel.adverseMap) {
                        
                        ZStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(Color.white)
                                    
                                    Text("부작용 주의")
                                        .multilineTextAlignment(.leading)
                                        .font(.body2Bold)
                                        .foregroundStyle(Color.white)
                                        .fadeIn(delay: 0.1)
                                }
                                .padding(.bottom, 10)
                                
                                Text("해당 의약품은 현재 복용 중인 약물과")
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.body2Medium)
                                    .foregroundStyle(Color.white)
                                    .padding(.bottom, 5)
                                    .fadeIn(delay: 0.2)
                                
                                ForEach(viewModel.adverseMap.nonNilValues(), id: \.self) { warning in
                                    Text(warning)
                                        .multilineTextAlignment(.leading)
                                        .font(.body2Bold)
                                        .foregroundStyle(Color.white)
                                        .padding(.bottom, 2)
                                        .fadeIn(delay: 0.3)
                                }
                                
                                Text("의 부작용 위험이 있습니다.\n섭취에 주의 바랍니다.")
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(5)
                                    .font(.body2Medium)
                                    .foregroundStyle(Color.white)
                                    .padding(.top, 5)
                                    .fadeIn(delay: 0.4)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                        }
                        .background(Color.primary40)
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 15)
                    }
                    
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
        .shadow(color: Color.gray60.opacity(0.2), radius: 10, x: 0, y: 4)
    }
    
    func textForIndex(_ index: Int) -> String {
        switch index {
        case 0: return viewModel.medicineEffect
        case 1: return viewModel.useMethod
        case 2: return viewModel.useWarning
        default: return viewModel.depositMethod
        }
    }
    
    private func isAdverseMapSafe(adverseMap: AdverseMap) -> Bool {
        return adverseMap.dosageCaution == nil &&
               adverseMap.ageSpecificContraindication == nil &&
               adverseMap.elderlyCaution == nil &&
               adverseMap.administrationPeriodCaution == nil &&
               adverseMap.pregnancyContraindication == nil &&
               adverseMap.duplicateEfficacyGroup == nil
    }
}
