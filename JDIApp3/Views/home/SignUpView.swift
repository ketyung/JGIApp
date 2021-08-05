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
    
    @State private var signUpSUccess : Bool = false
    
    @State private var userGroupsListPresented : Bool = false
    
    
    var body : some View {
        
        view()
        .progressView(isShowing: $viewModel.inProgress)
        .popOver(isPresented: $viewModel.errorPresented, content: {
            
            Common.errorAlertView(message: viewModel.errorMessage ?? "Error!")
        })
        .popOver(isPresented: $signUpSUccess, content: {
        
            successView()
        })
        .popOver(isPresented: $userGroupsListPresented, content: {
            
            UserGroupsListView(isPresented: $userGroupsListPresented)
        })
        
    
    }
}

extension SignUpView {
    
    private func view() -> some View {
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
                
                userGroupView()
                
                Spacer().frame(height:30)
                
                Button(action : {
                    
                    withAnimation{
                        
                        viewModel.signUp(completion: { success in
                            
                            self.signUpSUccess = success
                        })
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
            .frame(width : UIScreen.main.bounds.width - 40, height: 500)
            .background(Color(UIColor(hex:"#ccddffff")!))
            .cornerRadius(10)
            
            Spacer()
            
        }
        .themeFullView()
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
                }
                
            }){
                
                Text("Let's sign in now").font(.custom(Theme.fontName, size: 20))
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40 ,height: 300)
       
    }
    
    
    
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
