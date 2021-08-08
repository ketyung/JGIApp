//
//  OauthTokenViewModel.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 31/07/2021.
//

import Foundation
import WebKit
import SwiftUI

class AuthenticationViewModel : ViewModel {
    
    @Published  var email : String = ""
    
    @Published var userName : String = ""
    
    @Published var password : String = ""
    
    @Published var afterSignIn : Bool = false
    
    private lazy var docuSignHandler = DocuSignHandler()
    
}


extension AuthenticationViewModel {
    
    //@available(*, deprecated)
    // old deprecated method
    func signIn() {
        
        docuSignHandler.signIn(email: email, password: password, completion: {[weak self]
            
            accInfo, err in
            
            guard let err = err else {
                
                /**
                if let accountInfo = accInfo {
               
                    print("signedIn.account.info::\(accountInfo.accountId)::\(accountInfo.email)")
                }
                 */
                DispatchQueue.main.async {
              
                    withAnimation{
                        
                        self?.inProgress = false
                        self?.afterSignIn = true
                    }
                   
                }
               
                return
            }
            
            DispatchQueue.main.async {
          
                withAnimation{
             
                    self?.errorMessage = err.localizedDescription
                    self?.errorPresented = true
                    self?.afterSignIn = true
                    self?.inProgress = false
                }
                
            }
            
            
            
            
        })
    }
}


extension AuthenticationViewModel : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if webView.url?.absoluteString.hasPrefix( OTWV.redirectURI) ?? false {
            
            if let code =  webView.url?.valueOf( "code") {
                
              //  print("code:: is :\(code)")
                
                self.docuSignHandler.signIn(accessToken: code,
                userName: self.userName, email: self.email, completion: { [weak self]
                    accountInfo , err in
                    
                    guard let err = err else {
                        
                        if let accountInfo = accountInfo {
                       
                            print("signedIn.account.info::\(accountInfo)")
                        }
                        
                        withAnimation{
                            
                            self?.afterSignIn = true 
                        }
                        
                        return
                    }
                    
                    withAnimation{
                 
                        self?.errorMessage = err.localizedDescription
                        self?.errorPresented = true
                        self?.afterSignIn = true
                    }
                    
    
                })
                
            }
            
        }

    }
}
