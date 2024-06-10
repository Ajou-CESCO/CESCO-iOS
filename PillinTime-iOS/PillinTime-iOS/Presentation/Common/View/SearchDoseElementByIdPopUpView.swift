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
}
