//
//  ClientListView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/14/24.
//

import SwiftUI

struct ClientListView: View {
    
    // MARK: - Properties

    var relationLists: [RelationList]
    
    @Binding var selectedClientId: Int?
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            if (relationLists.isEmpty) {
                Text("등록된 피보호자가 없어요")
                    .font(.caption2Bold)
                    .foregroundStyle(Color.gray40)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(relationLists, id: \.memberID) { relation in
                        ClientView(client: relation,
                                   isSelected: relation.memberID == selectedClientId)
                            .onTapGesture {
                                self.selectedClientId = relation.memberID
                            }
                    }
                }
            }
            .padding(.top, 10)
            .padding(.leading, 30)
            
        }
        .frame(maxWidth: .infinity,
               minHeight: 100,
               maxHeight: 100)
    }
}

// MARK: - ClientView

struct ClientView: View {
    
    var client: RelationList
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Image(isSelected ? "ic_client_filled" : "ic_client_unfilled")
                .resizable()
                .scaledToFill()
                .frame(width: 45, height: 45)
            
            Text(client.memberName)
                .font(isSelected ? .caption2Bold : .caption2Regular)
                .foregroundStyle(Color.gray90)
        }
        .frame(width: 45, height: 64)
    }
}
