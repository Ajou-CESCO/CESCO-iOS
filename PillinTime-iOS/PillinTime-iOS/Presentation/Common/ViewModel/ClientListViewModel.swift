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
    @Published var todayDoesLog: [TodayDoseLogModel] = []
    @Published var selectedUserId: Int = Int()
    
    // MARK: - Initalizer
    
    init() {
        mockClientList()
    }
    
    // MARK: - Methods
    
    func fetchDataForClient(clientId: Int) {
        if let index = clients.firstIndex(where: { $0.relatedUserId == clientId }) {
            let selectedClient = clients[index]
            clients.remove(at: index)
            clients.insert(selectedClient, at: 0)
        }
    }
    
    func mockClientList() {
        self.clients = [
            ClientListModel(relationshipId: 1, relatedUserId: 101, relatedUserName: "이재현", relatedUserAge: 28),
            ClientListModel(relationshipId: 2, relatedUserId: 102, relatedUserName: "김종명", relatedUserAge: 35),
            ClientListModel(relationshipId: 3, relatedUserId: 103, relatedUserName: "노수인", relatedUserAge: 24),
            ClientListModel(relationshipId: 4, relatedUserId: 104, relatedUserName: "김학준", relatedUserAge: 31),
            ClientListModel(relationshipId: 5, relatedUserId: 105, relatedUserName: "심재민", relatedUserAge: 29),
            ClientListModel(relationshipId: 5, relatedUserId: 105, relatedUserName: "이몽이", relatedUserAge: 38),
            ClientListModel(relationshipId: 5, relatedUserId: 105, relatedUserName: "서영자", relatedUserAge: 90),
            ClientListModel(relationshipId: 5, relatedUserId: 105, relatedUserName: "박정혜", relatedUserAge: 29),
            ClientListModel(relationshipId: 5, relatedUserId: 105, relatedUserName: "이용섭", relatedUserAge: 29)
        ]
        
        self.todayDoesLog = [
            TodayDoseLogModel(pillName: "아스피린", doseTime: "오후 8시", doseStatus: .taken),
            TodayDoseLogModel(pillName: "비타민 C", doseTime: "오후 12시", doseStatus: .scheduled),
            TodayDoseLogModel(pillName: "이부프로펜", doseTime: "오후 3시", doseStatus: .missed),
            TodayDoseLogModel(pillName: "파라세타몰", doseTime: "오후 6시", doseStatus: .taken),
            TodayDoseLogModel(pillName: "항생제", doseTime: "오후 9시", doseStatus: .scheduled)
        ]
    }
}
