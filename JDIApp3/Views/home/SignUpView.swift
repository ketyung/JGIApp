//
//  SignUpView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 05/08/2021.
//

import SwiftUI


struct SignUpView : View {
    
    @Binding var viewType : FrontMenuView.ViewType
    
    @EnvironmentObject private var viewModel : UserViewModel
    
    
    var body : some View {
        
        VStack {
            
            Spacer().frame(height:30)
            
            Common.topBar(title: "Sign Up".localized, switchToViewType: $viewType )
           
            Spacer().frame(height:50)
            
            VStack(spacing:20) {
                
                Common.textFieldWithUnderLine("First Name".localized, text: $viewModel.firstName)
                
                
                Common.textFieldWithUnderLine("Last Name".localized, text: $viewModel.lastName)
                
                Common.textFieldWithUnderLine("Email".localized, text: $viewModel.email)
                
                Common.secureFieldWithUnderLine("Password".localized, text: $viewModel.password )
               
                Common.secureFieldWithUnderLine("Password Again".localized, text: $viewModel.password )
               
                Spacer().frame(height:30)
                
                Button(action : {
                    
                    withAnimation{
                        UIApplication.shared.endEditing()
                    }
                    
                }){
                    
                    Text("Sign Up".localized).font(.custom(Theme.fontNameBold, size: 20)).padding()
                    .foregroundColor(.white).background(Color.blue)
                    .frame(width : 160, height: 40)
                    .cornerRadius(10)
                }
                
            }
            .padding()
            .frame(width : UIScreen.main.bounds.width - 40, height: 400)
            .background(Color(UIColor(hex:"#ccddffff")!))
            .cornerRadius(10)
            
            Spacer()
            
        }
        .themeFullView()
    }
}
