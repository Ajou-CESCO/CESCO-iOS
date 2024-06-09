//
//  SearchDoseElementByIdPopUpView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 6/9/24.
//

import SwiftUI

import Factory

// MARK: - SearchDoseElementByIdPopUpView

struct SearchDoseElementByIdPopUpView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss

    @ObservedObject var doseScheduleStatusViewModel = Container.shared.doseScheduleStatusViewModel.resolve()

    let steps: [String] = ["효능", "복용 방법", "복용 전 알아두세요!", "보관법"]
    
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
                        
                        KFImageView(urlString: doseScheduleStatusViewModel.doseInfo.medicineImage)
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 10)
                        
                        Text(doseScheduleStatusViewModel.doseInfo.medicineName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.h4Bold)
                            .foregroundStyle(Color.gray90)
                            .lineSpacing(5)
                            .padding(.bottom, 10)
                        
                        if !isAdverseMapSafe(medicineAdverse: doseScheduleStatusViewModel.doseInfo.medicineAdverse) {
                            
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
                                    
                                    Text("해당 의약품은")
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.body2Medium)
                                        .foregroundStyle(Color.white)
                                        .padding(.bottom, 5)
                                        .fadeIn(delay: 0.2)
                                    
                                    if doseScheduleStatusViewModel.doseInfo.medicineAdverse.nonNilValues() != [] {
                                        ForEach(doseScheduleStatusViewModel.doseInfo.medicineAdverse.nonNilValues(), id: \.self) { warning in
                                            Text(warning)
                                                .multilineTextAlignment(.leading)
                                                .font(.body2Bold)
                                                .foregroundStyle(Color.white)
                                                .padding(.bottom, 5)
                                                .fadeIn(delay: 0.2)
                                        }
                                    }
                                    
                                    if doseScheduleStatusViewModel.doseInfo.medicineAdverse.duplicateEfficacyGroup != nil {
                                        Text("의 부작용과,")
                                            .font(.body2Medium)
                                            .foregroundStyle(Color.white)
                                            .padding(.bottom, 10)
                                            .fadeIn(delay: 0.3)
                                        
                                        Text("기존 복용 중인 약과 함께 섭취할 경우")
                                            .multilineTextAlignment(.leading)
                                            .font(.body2Bold)
                                            .foregroundStyle(Color.white)
                                            .padding(.bottom, 5)
                                            .fadeIn(delay: 0.3)
                                    }
                                    
                                    Text("부작용 위험이 있습니다.\n섭취에 주의 바랍니다.")
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(10)
                                        .font(.body2Medium)
                                        .foregroundStyle(Color.white)
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
                            
                            Text(doseScheduleStatusViewModel.doseInfo.medicineCode)
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
        .frame(maxWidth: .infinity, minHeight: 600, maxHeight: 600)
        .shadow(color: Color.gray60.opacity(0.2), radius: 10, x: 0, y: 4)
    }
    
    func textForIndex(_ index: Int) -> String {
        switch index {
        case 0: return doseScheduleStatusViewModel.doseInfo.medicineEffect
        case 1: return doseScheduleStatusViewModel.doseInfo.useMethod
        case 2: return doseScheduleStatusViewModel.doseInfo.useWarning
        default: return doseScheduleStatusViewModel.doseInfo.depositMethod
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
