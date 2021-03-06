//
//  UserViewModel.swift
//  KyPayApp2
//
//  Created by Chee Ket Yung on 15/06/2021.
//

import Foundation
import SwiftUI

private struct UserHolder {
    
    var user : User = loadUser()
    
    private static func loadUser() -> User{
        
        if let u = KDS.shared.getUser() {
            
            return u
        }
        
        return User()
    }
    
    mutating func clearUser(){
        
        self.user = User()
    }
}


class UserViewModel : ViewModel {
    
    @Published private var userHolder = UserHolder()
    
    @Published var firstSignIn : Bool = false
    
    @Published var selectedUserGroup : UserGroup? {
        
        didSet {
            
            userHolder.user.groupId = selectedUserGroup?.id
            
        }
    }
    
    
    @Published var signInSuccess : Bool = false
    
    @Published var signUpSuccess : Bool = false
    
    @Published var signOutSuccess : Bool = false
    
    @Published var users : [User] = []
    
    
    var id : String {
        
        get {
            
            userHolder.user.id ?? ""
        }
        
        set(newVal){
            
            userHolder.user.id = newVal
        }
    }
    
    var groupId : String {
        
        get {
            
            userHolder.user.groupId ?? ""
        }
        set(newVal) {
            
            userHolder.user.groupId = newVal
        }
    }
    
    var firstName : String {
        
        get {
            
            userHolder.user.firstName ?? ""
        }
        
        set(newVal){
            
            userHolder.user.firstName = newVal
        }
    }
    
    
    var lastName : String {
        
        
        get {
            
            userHolder.user.lastName ?? ""
        }
        
        set(newVal){
            
            userHolder.user.lastName = newVal
        }
    }
    
    
    var email : String {
        
        get {
            
            userHolder.user.email ?? ""
        }
        
        set(newVal){
            
            userHolder.user.email = newVal.trim().lowercased()
        }
    }
    
    
    var dob : Date {
        
        get {
            
            userHolder.user.dob ?? Date()
        }
        
        set(newVal){
            
            userHolder.user.dob = newVal
        }
    }
    
    
    var password : String {
        
        get {
            
            userHolder.user.password ?? ""
        }
        
        set(newVal) {
            
            userHolder.user.password = newVal
        }
    }
    
    var passwordAgain : String {
        
        get {
            
            userHolder.user.passwordAgain ?? ""
        }
        
        set(newVal) {
            
            userHolder.user.passwordAgain = newVal
        }
    }
    
    var phoneNumber : String {
        
        get {
            
            userHolder.user.phoneNumber ?? ""
        }
        
        set(newVal){
            
            userHolder.user.phoneNumber = newVal
        }
    }
    

  
    var hasSignedIn : Bool {
        
            
        if let _ = KDS.shared.getUser() {
     
            return true
        }
        
        
        return false
   
    }
    
    var user : User{
        
        userHolder.user
    }

    
}

extension UserViewModel {
   
    func loadUser(_ user : User) {
        
        self.userHolder.user = user 
    }
}

extension UserViewModel {
    
    private func removeAllStored(){
        
        KDS.shared.removeUser()
        userHolder.clearUser()
    }
    
    
    func signOut(){
        
        signOutSuccess = false
        inProgress = true
        
        let user = User(id : self.user.id)
        ARH.shared.signOutUser(user, returnType: User.self, completion: {
            [weak self] res in
            
            
            DispatchQueue.main.async {
            
                switch(res) {
                
                    case .failure(let err) :
                        self?.errorMessage = (err as? ApiError)?.errorText
                        self?.errorPresented = true
                        self?.inProgress = false
                        
                    case .success(let info) :
                    
                        if info.status == .ok {
                            
                            self?.inProgress = false
                            self?.signOutSuccess = true
                            self?.removeAllStored()
                        }
                        else {
                            
                            self?.errorMessage = info.text
                            self?.errorPresented = true
                            self?.inProgress = false
                        }
                    
                }
            }
            
        })
        
    }
}


extension UserViewModel {
    
    
    func signIn(){
        
        
        self.inProgress = true
        self.signInSuccess = false
        
        ARH.shared.signInUser(email: email, password: password, returnType: User.self, completion:{
            [weak self] res in
            
            
            DispatchQueue.main.async {
            
                switch(res)  {
                
                    case .failure(let err) :
                
                        self?.inProgress = false
                        self?.errorPresented = true
                        self?.errorMessage = (err as? ApiError)?.errorText
                        
                    case .success(let info) :
                        
                        if info.status == .ok {
                            
                            if let user = info.returnedObject  {
                                
                                self?.userHolder.user = user
                                
                                KDS().saveUser(user)
                            }
                            
                            withAnimation{
                                
                                self?.inProgress = false
                                self?.signInSuccess = true

                            }
                        }
                        else {
                            
                            self?.inProgress = false
                            self?.errorMessage = info.text
                            self?.errorPresented = true
                            
                        }
                
                
                }
            }
            
            
        })
    }
    
}


extension UserViewModel {
    
    
    func signUp(){
        
        
        self.inProgress = true
        self.signUpSuccess = false
        
        if self.firstName.trim().isEmpty {
    
            self.errorMessage = "First Name is blank!".localized
            self.errorPresented = true
            self.inProgress = false
            return
            
        }
      
        
        if self.lastName.trim().isEmpty {
    
            self.errorMessage = "Last Name is blank!".localized
            self.errorPresented = true
            self.inProgress = false
            return
            
        }
    
        if !self.email.isValidEmail() {
    
            self.errorMessage = "Email is invalid!".localized
            self.errorPresented = true
           
            self.inProgress = false
            return
            
        }
        
        if self.password.count < 6 {
            
            self.errorMessage = "Password must be at least 6 character in length!".localized
            self.errorPresented = true
           
            self.inProgress = false
            return
      
            
        }
        
        if self.password != self.passwordAgain {
            
            self.errorMessage = "Passwords unmatched!".localized
            self.errorPresented = true
           
            self.inProgress = false
            return
      
        }
        
        if self.groupId == "" {
            
            self.errorMessage = "Please choose a group".localized
            self.errorPresented = true
           
            self.inProgress = false
            return
      
        }
        
       
        ARH.shared.addUser(user, returnType: User.self, completion: { [weak self]
        
            res in
        
            
            DispatchQueue.main.async {
            
                switch(res) {
         
                    case .failure(let err) :
                    
                        self?.errorMessage = (err as? ApiError)?.errorText
                        self?.errorPresented = true
                        self?.inProgress = false
                        self?.userHolder.clearUser()
                        
                    
                    case .success(let info) :
                       
                        if info.status == .ok {
                       
                            withAnimation{
                           
                                self?.inProgress = false
                                self?.signUpSuccess = true
                               
                            }
                           
                        }
                        else if (info.status == .failed){
                            
                            self?.errorMessage = info.text
                            self?.errorPresented = true
                            self?.inProgress = false
                      
                        }
                        self?.userHolder.clearUser()
                        
                }
            
            
            }
            
        
        })
        
        
    }
}


extension UserViewModel {
    
    
    func fetchUsersWithGroupInfo(){
        
        self.inProgress = true
        
        ARH.shared.fetchUsersWithGroup(completion: {
            
            [weak self] res in
            
            
            DispatchQueue.main.async {
             
                switch(res){
             
                    case .failure(let err) :
                        self?.inProgress = false
                        self?.errorMessage = (err as? ApiError)?.errorText
                        self?.errorPresented = true
                        
                    case .success(let users) :
                    
                        self?.inProgress = false
                        self?.users = users 
                    
                
                }
            }
            
        })
    }
}
