//
//  UserService.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/18/24.
//

import Foundation

class UserService: UserServiceType {
    func createUser(createUserModel: CreateUserRequestModel) -> Bool {
        return true
    }
    
    func getUserById(uuid: String) -> Bool {
        return true
    }
    
    func getUserList() -> Bool {
        return true
    }
    
    func updateUserById(uuid: String) -> Bool {
        return true
    }
    
    func deleteUserById() -> Bool {
        return true
    }
}
