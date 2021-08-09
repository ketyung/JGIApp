//
//  RecipientsView.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 09/08/2021.
//

import SwiftUI


struct RecipientsView : View {
    
    
    @StateObject private var userViewModel = UserViewModel()
    
    @EnvironmentObject private var signingViewModel : CFSVM
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing:20) {
            
            Text("Choose recipients").font(.custom(Theme.fontName, size: 18))
            
            recipientsListView()
            .frame(height:200)
                
        }
        .padding()
        .onAppear{
            
            userViewModel.fetchUsersWithGroupInfo()
        }
        
    }
}

extension RecipientsView {
    
    
    private func recipientsListView() -> some View {
        
        ScrollView(.vertical, showsIndicators: false ) {
            
            ForEach (userViewModel.users, id:\.id) {
                
                user in
                
                Button(action : {
                    
                    let recipient = Recipient(id: user.id, name:
                    "\(user.firstName ?? "") \(user.lastName ?? "")", email: user.email , groupName: user.groupName)
                   
                    signingViewModel.addRecipient(recipient)
                }){
                    
                   
                    userRowView(user)
                }
            }
        }
    }
    
    
    private func userRowView ( _ user : User ) -> some View {
        
    
        HStack {
    
            VStack (alignment: .leading, spacing: 20) {
            
            
                HStack(spacing:10) {
                    
                    Text("\(user.firstName ?? "") \(user.lastName ?? "")").font(.custom(Theme.fontName, size: 18))
                    .foregroundColor(.black)
                    
                    Text(user.email ?? "").font(.custom(Theme.fontName, size: 18))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                    .foregroundColor(.black)
                        
                    Spacer()
                    
                }
                
                HStack(spacing: 10) {
                    
                    Text("Role : \(user.groupName ?? "")").font(.custom(Theme.fontName, size: 18))
                    .foregroundColor(.black)
                    
                    Spacer()
                    
                    if ( signingViewModel.inRecipients(id: user.id ?? "")){
                        
                        Image(systemName: "checkmark.circle.fill")
                        .resizable().frame(width:24,height:24).foregroundColor(.green)
                        
                        Spacer().frame(width:5)
                
                    }
                    
                }
           
            
            }
        
        }
        .padding()
        .background(Color(UIColor(hex:"#ccddeeff")!))
        .cornerRadius(10)
    }
}
