//
//  DoseAddView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/6/24.
//

import SwiftUI

import LinkNavigator

struct DoseAddView: View {
    
    let navigator: LinkNavigatorType
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }
    
    var body: some View {
        VStack {
            ProgressView(value: 0.5)
                .tint(Color.primary60)

            CustomNavigationBar()
            
            Spacer()
        }
    }
}

//#Preview {
//    DoseAddView()
//}
