//
//  UserGroupsViewModel.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 05/08/2021.
//

import Foundation

class UserGroupsViewModel : ViewModel {
    
    @Published var userGroups = [UserGroup]()
    
    func fetchAllUserGroups(){
        
        self.inProgress = true
        
        ARH.shared.fetchAllUserGroups(completion: {
            [weak self] res in
            
            DispatchQueue.main.async {
            
                switch(res) {
                
                    case .success(let gs) :
                
                        self?.userGroups = gs
                        self?.inProgress = false
                        
                    case .failure(let err) :
                        self?.errorMessage = (err as? ApiError)?.errorText ?? "Error!"
                        self?.errorPresented = true
                        self?.inProgress = false
                        
                
                }
            }
            
            
        })
    }
}
