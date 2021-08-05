//
//  EmailSignView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 05/08/2021.
//

import Foundation
import SwiftUI

struct EmailSignInView : View {
    
    @State private var email : String = ""
    
    @State private var password : String = ""
    
    @State private var switchToSignUp : Bool = false
    
    var body : some View {
        
        
        if switchToSignUp {
            
            SignUpView()
            .transition(.move(edge: .bottom))
         
        }
        else {
            
            loginView()
        }
      
    }
    
}

extension EmailSignInView {
    
    private func loginView() -> some View {
        
        VStack {
            
            
            VStack {
                
                
                Common.textFieldWithUnderLine("Email".localized, text: $email)
                
                Common.secureFieldWithUnderLine("Password".localized, text: $password)
                
                Button(action : {
                    
                    
                }){
                    
                    Text("Sign In".localized).font(.custom(Theme.fontNameBold, size: 20)).padding()
                    .foregroundColor(.white).background(Color.blue)
                    .frame(width : 160, height: 40)
                    .cornerRadius(10)
                }
                
            }
            .frame(width : UIScreen.main.bounds.width - 40, height: 300)
            .background(Color(UIColor(hex:"#ccddffff")!))
            .cornerRadius(40)
            
            Spacer().frame(height:30)
            
            Button(action : {
                
                withAnimation{
                    
                    self.switchToSignUp = true 
                }
            }){
                
                Text("Sign up, if you haven't got an account")
                .font(.custom(Theme.fontName, size: 16))
                
            }
            
            Spacer()
            
        }
        .themeFullView()
    }
}
