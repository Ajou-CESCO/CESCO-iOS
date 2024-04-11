//
//  Result+.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/9/24.
//

import Foundation

extension Result {
    @discardableResult
    func success(_ successHandler: (Success) -> Void) -> Result<Success, Failure> {
        if case .success(let value) = self {
            successHandler(value)
        }
        return self
    }
    
    @discardableResult
    func `catch`(_ failureHandler: (Failure) -> Void) -> Result<Success, Failure> {
        if case .failure(let error) = self {
            failureHandler(error)
        }
        return self
    }
}
