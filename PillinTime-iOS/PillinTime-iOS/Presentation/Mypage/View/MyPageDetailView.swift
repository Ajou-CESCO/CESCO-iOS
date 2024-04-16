//
//  MyPageDetailView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/15/24.
//

import SwiftUI

struct MyPageDetailView: View {
    
    // MARK: - Properties
    
    var settingListElement: SettingListElement
    
    // MARK: - body
    
    var body: some View {
        
        VStack {
            CustomNavigationBar(title: settingListElement.description)
            
            Spacer()
        }
        
    }
}

#Preview {
    MyPageDetailView(settingListElement: .managementMyInformation)
}
