//
//  ClientListViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/14/24.
//

import Combine

class ClientListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var clients: [ClientListModel] = []
    
    // MARK: - Initalizer
    
    init() {
        mockClientList()
    }
    
    // MARK: - Methods
    
    func mockClientList() {
        self.clients = [
            ClientListModel(relationshipId: 1, relatedUserId: 101, relatedUserName: "이재현", relatedUserAge: 28),
            ClientListModel(relationshipId: 2, relatedUserId: 102, relatedUserName: "김종명", relatedUserAge: 35),
            ClientListModel(relationshipId: 3, relatedUserId: 103, relatedUserName: "노수인", relatedUserAge: 24),
            ClientListModel(relationshipId: 4, relatedUserId: 104, relatedUserName: "김학준", relatedUserAge: 31),
            ClientListModel(relationshipId: 5, relatedUserId: 105, relatedUserName: "심재민", relatedUserAge: 29)
        ]
    }
}
