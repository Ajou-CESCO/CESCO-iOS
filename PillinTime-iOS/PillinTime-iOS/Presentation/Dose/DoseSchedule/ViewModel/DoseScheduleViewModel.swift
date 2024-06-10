//
//  DoseScheduleViewModel.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/15/24.
//

import SwiftUI

class DoseScheduleViewModel: ObservableObject {
    
    @Published var relationLists: [RelationList] = []

    // MARK: - Constructor
    
    init() {
        loadRelationLists()
    }
    
    // MARK: - Methods
    
    func loadRelationLists() {
        if let data = UserDefaults.standard.data(forKey: "relationLists") {
            do {
                self.relationLists = try PropertyListDecoder().decode([RelationList].self, from: data)
            } catch {
                print("error: \(error)")
            }
        }
    }
}
