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
/**
extension UserViewModel {
    
    struct FirstSignInError : LocalizedError, CustomStringConvertible {
       
        var description: String {
            
            errorText ?? ""
        }
    
        var errorText : String?
        
        public var errorDescription : String {
            
            errorText ?? ""
        }
        
    }
    
    
    
    
    func add(country : Country?, completion : ((Error?)-> Void)? = nil ){
        
        
        self.showingProgressIndicator = true
        
        
        if self.firstName.trim().isEmpty {
    
            completion?(FirstSignInError(errorText: "First Name is blank!".localized))
            self.showingProgressIndicator = false
            return
            
        }
      
        
        if self.lastName.trim().isEmpty {
    
            completion?(FirstSignInError(errorText: "Last Name is blank!".localized))
            self.showingProgressIndicator = false
            return
            
        }
    
        if !self.email.isValidEmail() {
    
            completion?(FirstSignInError(errorText: "Invalid email!".localized))
            self.showingProgressIndicator = false
            return
            
        }
        
       
        ARH.shared.addUser(user, returnType: User.self, completion: { [weak self]
        
            res in
        
            guard let self = self else {return}
            
            switch(res) {
     
                case .failure(let err) :
                
                    completion?(err)
                
                case .success(let usr ) :
                
                    if let ruser = usr.returnedObject {
                   
                        KDS.shared.saveUser(ruser)
                        
                        // refresh user in userHolder
                        DispatchQueue.main.async {
                       
                            self.userHolder.user = ruser
                            self.firstSignIn = false
                        }
                        
                    }
                    else {
                        
                        let ruser = User(id: usr.id, firstName: self.firstName, lastName: self.lastName, dob: self.dob, email: self.email, phoneNumber: self.phoneNumber, signInStat: .signedIn, countryCode: self.countryCode)
                        
                        KDS.shared.saveUser(ruser)
                        
                        // refresh user in userHolder
                        DispatchQueue.main.async {
                       
                            self.userHolder.user = ruser
                            self.firstSignIn = false
                        }
                        
                    }
                   
                    
                    completion?(nil)
                
            }
            
            DispatchQueue.main.async {
         
                self.showingProgressIndicator = false
            }
           
        
        })
        
        
    }
}*/

