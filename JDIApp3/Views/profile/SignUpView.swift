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
    
    @State private var userGroupsListPresented : Bool = false
    
    
    var body : some View {
        
        view()
        .progressView(isShowing: $viewModel.inProgress)
        .popOver(isPresented: $viewModel.errorPresented, content: {
            
            Common.errorAlertView(message: viewModel.errorMessage ?? "Error!")
        })
        .popOver(isPresented: $viewModel.signUpSuccess, content: {
        
            successView()
        })
        .popOver(isPresented: $userGroupsListPresented, content: {
            
            UserGroupsListView(isPresented: $userGroupsListPresented)
        })
        
    
    }
}

extension SignUpView {
    
    private func view() -> some View {
    
        UserProfileFormView(switchToViewType: $viewType,
        topTitle: "Sign Up".localized, buttonText: "Sign Up".localized,
        userGroupsListPresented: $userGroupsListPresented,
        buttonAction: {
            
            viewModel.signUp()
        })
    }
}


extension SignUpView {
    
    
    private func successView() -> some View {
        
        VStack(spacing:30) {
       
            HStack {
                
                Image(systemName: "info.circle").resizable().frame(width: 30, height: 30).foregroundColor(.green)
             
                Text("You've sucessfully signed up").font(.custom(Theme.fontName, size: 18)).foregroundColor(.black)
                
            }.padding()
            
            Spacer().frame(height:20)
            
            Button(action: {
                withAnimation{
                    
                    viewType = .signIn
                    viewModel.signUpSuccess = false
                }
                
            }){
                
                Text("Let's sign in now").font(.custom(Theme.fontName, size: 20))
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40 ,height: 300)
       
    }
    
    
    
}
