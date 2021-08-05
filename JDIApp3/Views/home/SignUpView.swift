//
//  SignUpView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 05/08/2021.
//

import SwiftUI


struct SignUpView : View {
    
    @EnvironmentObject private var viewModel : UserViewModel
    
    
    var body : some View {
        
        VStack {
            
            VStack {
                
                Common.textFieldWithUnderLine("First Name".localized, text: $viewModel.firstName)
                
                
                Common.textFieldWithUnderLine("Last Name".localized, text: $viewModel.lastName)
                
                Common.textFieldWithUnderLine("Email".localized, text: $viewModel.email)
                
                Common.secureFieldWithUnderLine("Password".localized, text: $viewModel.password )
               
                Common.secureFieldWithUnderLine("Password Again".localized, text: $viewModel.password )
               
                Button(action : {
                    
                    
                }){
                    
                    Text("Sign Up".localized).font(.custom(Theme.fontNameBold, size: 20)).padding()
                    .foregroundColor(.white).background(Color.blue)
                    .frame(width : 160, height: 40)
                    .cornerRadius(10)
                }
                
            }
            .frame(width : UIScreen.main.bounds.width - 40, height: 300)
            .background(Color(UIColor(hex:"#ccddffff")!))
            .cornerRadius(40)
            
        }
    }
}
