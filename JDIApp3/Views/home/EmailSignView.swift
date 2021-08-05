//
//  EmailSignView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 05/08/2021.
//

import Foundation
import SwiftUI

struct EmailSignInView : View {
    
    @Binding var viewType : FrontMenuView.ViewType
    
    @State var signInSuccessViewType : FrontMenuView.ViewType = .menu
    
    @State private var switchToSignUp : Bool = false
    
    @EnvironmentObject private var viewModel : UserViewModel
    
    
    var body : some View {
        
        
        if switchToSignUp {
            
            SignUpView(viewType: $viewType)
            .transition(.move(edge: .bottom))
         
        }
        else {
            
            loginView()
            .progressView(isShowing: $viewModel.inProgress)
            .popOver(isPresented: $viewModel.errorPresented, content: {
            
                Common.errorAlertView(message: viewModel.errorMessage ?? "Error!")
            })
            .popOver(isPresented: $viewModel.signInSuccess, content: {
                
                sucessView()
            })
        }
      
    }
    
}

extension EmailSignInView {
    
    private func sucessView() -> some View {
        
        VStack(spacing:30) {
       
            HStack {
                
                Image(systemName: "info.circle").resizable().frame(width: 30, height: 30).foregroundColor(.green)
             
                Text("You've sucessfully signed in").font(.custom(Theme.fontName, size: 18)).foregroundColor(.black)
                
            }.padding()
            
            Spacer().frame(height:20)
            
        }
        .frame(width: UIScreen.main.bounds.width - 40 ,height: 300)
        .onAppear{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3 , execute: {
                
                withAnimation{
                    
                    viewType = signInSuccessViewType
                }
                
            })
        }
    }
}


extension EmailSignInView {
    
    private func loginView() -> some View {
        
        VStack {
            
            Spacer().frame(height:30)
            
            Common.topBar(title: "Sign In".localized, switchToViewType: $viewType )
            
            VStack(spacing:20) {
                
                
                Common.textFieldWithUnderLine("Email".localized, text: $viewModel.email)
                
                Common.secureFieldWithUnderLine("Password".localized, text: $viewModel.password)
                
                Spacer().frame(height:30)
                
                Button(action : {
                    
                    withAnimation{
                        UIApplication.shared.endEditing()
                    }
                    
                    viewModel.signIn()
                    
                }){
                    
                    Text("Sign In".localized).font(.custom(Theme.fontNameBold, size: 20)).padding()
                    .foregroundColor(.white).background(Color.blue)
                    .frame(width : 160, height: 40)
                    .cornerRadius(10)
                }
                
            }
            .padding()
            .frame(width : UIScreen.main.bounds.width - 40, height: 300)
            .background(Color(UIColor(hex:"#ccddffff")!))
            .cornerRadius(10)
            
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
