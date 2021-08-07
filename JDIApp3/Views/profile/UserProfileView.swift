//
//  UserProfileView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 05/08/2021.
//

import SwiftUI


struct UserProfileView : View {
    
    @Binding var viewType : FMM.ViewType
    
    @EnvironmentObject private var viewModel : UserViewModel
    
    @State private var userGroupsListPresented : Bool = false
    
    
    var body : some View {
        
        if viewModel.hasSignedIn {
            

            view()
            .progressView(isShowing: $viewModel.inProgress)
            .popOver(isPresented: $viewModel.errorPresented, content: {
                
                Common.errorAlertView(message: viewModel.errorMessage ?? "Error!")
            })
            .popOver(isPresented: $userGroupsListPresented, content: {
                
                UserGroupsListView(isPresented: $userGroupsListPresented)
            })
        
        }
        else {
            
            SignInView(viewType: $viewType)
        }
        
    
    }
}


extension UserProfileView {
    
    private func view() -> some View {
    
        UserProfileFormView(switchToViewType: $viewType,
        topTitle: "Your Profile".localized, buttonText: "Update".localized,
        userGroupsListPresented: $userGroupsListPresented,
        buttonAction: {
            
            withAnimation{
     
                viewModel.errorMessage = "Function isn't available yet"
                viewModel.errorPresented = true
         
            }
        })
    }
}
