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
    
    func mockClientList() {
        self.clients = [
            ClientListModel(userId: 1, userName: "이몽이", userSsn: "010101-0", userPhone: "010-1234-5678", userType: 1, caseId: ""),
            ClientListModel(userId: 2, userName: "조인성", userSsn: "020202-0", userPhone: "010-2345-6789", userType: 1, caseId: "C002"),
            ClientListModel(userId: 3, userName: "이주연", userSsn: "030303-0", userPhone: "010-3456-7890", userType: 1, caseId: "C003"),
            ClientListModel(userId: 4, userName: "이재영", userSsn: "040404-0", userPhone: "010-4567-8901", userType: 1, caseId: ""),
            ClientListModel(userId: 5, userName: "정우성", userSsn: "050505-0", userPhone: "010-5678-9012", userType: 1, caseId: "C005"),
            ClientListModel(userId: 6, userName: "천우희", userSsn: "060606-0", userPhone: "010-6789-0123", userType: 1, caseId: "C006"),
            ClientListModel(userId: 7, userName: "김혜수", userSsn: "070707-0", userPhone: "010-7890-1234", userType: 1, caseId: ""),
            ClientListModel(userId: 8, userName: "정우성", userSsn: "080808-0", userPhone: "010-8901-2345", userType: 1, caseId: "C008"),
            ClientListModel(userId: 9, userName: "한지민", userSsn: "090909-0", userPhone: "010-9012-3456", userType: 1, caseId: "C009"),
            ClientListModel(userId: 10, userName: "조인성", userSsn: "101010-0", userPhone: "010-0123-4567", userType: 1, caseId: "")
        ]
        
        self.todayDoesLog = [
            TodayDoseLogModel(pillName: "아스피린", doseTime: "오후 8시", doseStatus: .taken),
            TodayDoseLogModel(pillName: "비타민 C", doseTime: "오후 12시", doseStatus: .scheduled),
            TodayDoseLogModel(pillName: "이부프로펜", doseTime: "오후 3시", doseStatus: .missed),
            TodayDoseLogModel(pillName: "파라세타몰", doseTime: "오후 6시", doseStatus: .taken),
            TodayDoseLogModel(pillName: "항생제", doseTime: "오후 9시", doseStatus: .scheduled)
        ]
    }
    
    func countLogs(filteringBy status: DoseStatus?) -> Int {
        guard let status = status else {
            return todayDoesLog.count
        }
        return todayDoesLog.filter { $0.doseStatus == status }.count
    }
}
