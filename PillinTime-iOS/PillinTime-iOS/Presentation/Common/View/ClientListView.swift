//
//  ClientListView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/14/24.
//

import SwiftUI

struct ClientListView: View {
    
    // MARK: - Properties

    @ObservedObject var viewModel = ClientListViewModel()
    
    @Binding var selectedClient: Int?
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<viewModel.clients.count, id: \.self) { index in
                        ClientView(client: viewModel.clients[index],
                                   isSelected: index == selectedClient)
                            .onTapGesture {
                                self.selectedClient = index
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
    
    var client: ClientListModel
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Image(isSelected ? "ic_client_filled" : "ic_client_unfilled")
                .resizable()
                .scaledToFill()
                .frame(width: 45, height: 45)
            
            Text(client.relatedUserName)
                .font(isSelected ? .caption2Bold : .caption2Regular)
                .foregroundStyle(Color.gray90)
        }
        .frame(width: 45, height: 64)
    }
}

#Preview {
    ClientListView(selectedClient: .constant(0))
}
