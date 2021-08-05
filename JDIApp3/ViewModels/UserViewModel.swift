//
//  UserViewModel.swift
//  KyPayApp2
//
//  Created by Chee Ket Yung on 15/06/2021.
//

import Foundation

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
    
    var id : String {
        
        get {
            
            userHolder.user.id ?? ""
        }
        
        set(newVal){
            
            userHolder.user.id = newVal
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
            
            userHolder.user.email = newVal
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
    
    
    
    var countryCode : String {
        
        get {
            
            userHolder.user.countryCode ?? Country.defaultCountry
        }
        
        set(newVal){
            
            userHolder.user.countryCode = newVal
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

/**
extension UserViewModel {
    
    private func removeAllStored(){
        
       
    }
    
    
    func signOut(completion : ((Error?)-> Void)? = nil ){
        
        do {
       
            try Auth.auth().signOut()
    
            removeAllStored()
            
            DispatchQueue.main.async {
                
                self.userHolder.user = User()
            }
            
            completion?(nil)
        }
        catch {
            
            completion?(error)
            
        }
    }
}

 */

extension UserViewModel {
    
    
    
    
    func signUp(completion : ((Bool)-> Void)? = nil ){
        
        
        self.inProgress = true
        
        
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
        
       
        ARH.shared.addUser(user, returnType: User.self, completion: { [weak self]
        
            res in
        
            guard let self = self else {return}
            
            switch(res) {
     
                case .failure(let err) :
                
                    self.errorMessage = err.localizedDescription
                    self.errorPresented = true
        
                    completion?(false)
                    self.userHolder.clearUser()
                    
                
                case .success(_) :
                   
                    completion?(true)
                    self.userHolder.clearUser()
                    
                
            }
            
            DispatchQueue.main.async {
         
                self.inProgress = false
            }
           
        
        })
        
        
    }
}

