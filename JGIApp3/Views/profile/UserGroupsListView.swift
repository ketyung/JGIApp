//
//  UserGroupsListView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 05/08/2021.
//

import SwiftUI

struct UserGroupsListView : View {

    
    @Binding var isPresented : Bool
    
    @EnvironmentObject private var userViewModel : UserViewModel
    
    @StateObject private var viewModel = UserGroupsViewModel()
    
    
    var body : some View {
        
        VStack(spacing: 20){
            
            Text("Choose a user group").font(.custom(Theme.fontName, size: 20))
            
            List (viewModel.userGroups, id:\.id) {
                
                g in
                
                Button(action: {
                    
                    withAnimation{
                   
                        userViewModel.selectedUserGroup = g
                        isPresented = false
                    }
                    
                }){
               
                    Text(g.name ?? "").font(.custom(Theme.fontNameBold, size: 18))
                    .padding()
                }
                
            }
        }
        .progressView(isShowing: $viewModel.inProgress)
        .popOver(isPresented: $viewModel.errorPresented, content: {
            
            Common.errorAlertView(message: viewModel.errorMessage ?? "Error!")
        })
        .onAppear{
            
            viewModel.fetchAllUserGroups()
        }
    }
    
}
