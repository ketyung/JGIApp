//
//  loginView.swift
//  JDIApp
//
//  Created by Chee Ket Yung on 28/07/2021.
//

import SwiftUI

struct UserLoginView : View {
    
    //@StateObject private var viewModel = AuthenticationViewModel()
    
    @EnvironmentObject private var viewModel : AuthenticationViewModel
    
    
    @State private var pushToNext : Bool = false
    
    var body: some View {

        if pushToNext {
            
            OAuthTokenView()
            .transition(.move(edge: .trailing))
           
        }
        else {
        
            view()
            .progressView(isShowing: $viewModel.inProgress)
            
      
        }
    }
}

extension UserLoginView {
    

    
    private func view() -> some View {
        
        VStack {
            
            Spacer().frame(height:200)
            
            signInPanel()
            
            
            Spacer()
        }
        .themeFullView()
        
    }
}


extension UserLoginView {
    
    
    
    private func pushToNextView() {
        
        viewModel.inProgress = true
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
       
            withAnimation(Animation.easeIn(duration: 0.5) ){
                
                viewModel.inProgress = false
                
                pushToNext = true
         
            }

            
        })
       
    }
    
    
    private func signInPanel() -> some View {
        
        VStack(spacing: 20) {
            
            Common.textFieldWithUnderLine("Name", text: $viewModel.userName)
            
            Common.textFieldWithUnderLine("Email", text:$viewModel.email )
            
            
            Button(action: {
                
                pushToNextView()
                
            }) {
                
                Text("Next").font(.custom(Theme.fontName, size: 20))
                .padding()
                .frame(width: 160, height: 40)
                .foregroundColor(.white).background(Color.blue)
                .cornerRadius(6)
                
            }
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 40, height: 200)
        .border(Color.purple, width: 1, cornerRadius: 6)
        
        
    }
}
