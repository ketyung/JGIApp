//
//  DocuSignHandler.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 30/07/2021.
//

import Foundation
import DocuSignSDK

class DocuSignHandler {
    
    // info obtained from https://admindemo.docusign.com/apps-and-keys
  
    private let integratorKey = "8c58de5c-17a0-49ee-b01f-b73bb12eaa84"
    
    private let hostURL = URL(string: "https://demo.docusign.net/restapi")!
    
    private let userId = "b5ca56d4-305a-4284-80d4-14511b84be71"
    
    private let accountId = "422db137-a0e0-4083-86ae-1f5996fde2a1"

    
    func signIn(accessToken : String, userName : String, email : String,  completion : ((DSMAccountInfo? ,Error?)->Void)? = nil ){
       
         DSMManager.login(withAccessToken: accessToken,
         accountId: accountId, userId: userId, userName: userName,
         email: email , host: hostURL,
         integratorKey: integratorKey, completion: {
                
                accountInfo, error in
            
            
                completion?(accountInfo, error)
                
         })
    }
}

extension DocuSignHandler {
    
    func signIn(email : String, password : String,  completion : ((DSMAccountInfo? ,Error?)->Void)? = nil ) {
        
        DSMManager.login(withEmail: email, password: password, integratorKey: integratorKey, host: hostURL, completion: {
          
            accountInfo, error in
        
            completion?(accountInfo, error)
           
            
        })
    }
}


