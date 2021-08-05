//
//  UserProfileFormView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 05/08/2021.
//

import SwiftUI

struct UserProfileFormView : View {
    
    @Binding var switchToViewType : FrontMenuView.ViewType
   
    @EnvironmentObject private var viewModel : UserViewModel
    
    @State var topTitle : String = "Profile"
    
    @State var buttonText : String = "Update"
  
    @Binding var userGroupsListPresented : Bool
  
    @State var buttonAction : (()->Void)? = nil
    
    var body : some View {
        
        VStack {
            
            Spacer().frame(height:30)
            
            Common.topBar(title: topTitle, switchToViewType: $switchToViewType )
           
            Spacer().frame(height:50)
            
            VStack(spacing:20) {
                
                Common.textFieldWithUnderLine("First Name".localized, text: $viewModel.firstName)
                
                Common.textFieldWithUnderLine("Last Name".localized, text: $viewModel.lastName)
                
                Common.textFieldWithUnderLine("Email".localized, text: $viewModel.email)
                
                Common.secureFieldWithUnderLine("Password".localized, text: $viewModel.password )
               
                Common.secureFieldWithUnderLine("Password Again".localized, text: $viewModel.passwordAgain )
                
                userGroupView()
                
                Spacer().frame(height:30)
                
                Button(action : {
                    
                    withAnimation{
                    
                        UIApplication.shared.endEditing()
                    
                        buttonAction?()
                    }
                    
                }){
                    
                    Text(buttonText).font(.custom(Theme.fontNameBold, size: 20)).padding()
                    .foregroundColor(.white).background(Color.blue)
                    .frame(width : 160, height: 40)
                    .cornerRadius(10)
                }
                
            }
            .padding()
            .frame(width : UIScreen.main.bounds.width - 40, height: 500)
            .background(Color(UIColor(hex:"#ccddffff")!))
            .cornerRadius(10)
            
            Spacer()
            
        }
        .themeFullView()
    }
}

extension UserProfileFormView {
    
    private func userGroupView() -> some View {
        
        
        VStack(alignment: .leading, spacing:20) {
       
            Text("User Group".localized).font(.custom(Theme.fontName, size: 18))
            
            
            Button(action : {
                
                withAnimation{
                    
                    userGroupsListPresented = true
                }
            })
            {
        
                HStack(spacing:20) {
                
                    Image(systemName: "person.2").resizable().frame(width:30, height:20).foregroundColor(.green)
            
                    
                    Text("\(viewModel.selectedUserGroup?.name ?? "")").font(.custom(Theme.fontName, size: 20))
                    
                    Spacer()
                }
            }
                
        }
    }
}
