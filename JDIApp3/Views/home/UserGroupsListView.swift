//
//  UserGroupsListView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 05/08/2021.
//

import SwiftUI

struct UserGroupsListView : View {

    
    @Binding var isPresented : Bool
    
    @EnvironmentObject private var viewModel : UserViewModel
    
    @State private var userGroups = [UserGroup]()
    
    var body : some View {
        
        VStack(spacing: 20){
            
            Text("Choose a user group").font(.custom(Theme.fontName, size: 20))
            
            List (userGroups, id:\.id) {
                
                g in
                
                Button(action: {
                    
                    withAnimation{
                   
                        viewModel.selectedUserGroup = g
                        isPresented = false
                    }
                    
                }){
               
                    Text(g.name ?? "").font(.custom(Theme.fontNameBold, size: 18))
                    .padding()
                }
                
            }
        }
        .onAppear{
            
            ARH.shared.fetchAllUserGroups(completion: {
                
                res in
                
                switch(res) {
                
                    case .success(let gs) :
                        self.userGroups = gs
                        
                    case .failure(let err) :
                    
                        print("err:\(err.localizedDescription)")
                    
                }
                
                
            })
        }
    }
    
}
