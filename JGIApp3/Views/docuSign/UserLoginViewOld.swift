//
//  UserLoginViewOld.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//
import SwiftUI

struct UserLoginViewOld : View {
    
    @EnvironmentObject private var viewModel : AuthenticationViewModel
   
    @EnvironmentObject private var userViewModel : UserViewModel
   
    @EnvironmentObject private var signingViewModel : SVM

    @Binding var viewType : FMM.ViewType
    
    @State private var pushToNext : Bool = false
    
    var body: some View {

        if viewModel.afterSignIn {
            
            if signingViewModel.firstSigner {
     
                AfterSignInView(viewModel: viewModel, viewType: $viewType)
            }
            else {
                
                SigningView(viewType: $viewType)
            }
        }
        else {
        
            view()
            .progressView(isShowing: $viewModel.inProgress)
        }
    }
}

extension UserLoginViewOld {
    

    
    private func view() -> some View {
        
        VStack {
            
            Spacer().frame(height:50)
            
            
            Common.topBar(title: "DocuSign Sign In", switchToViewType: $viewType)
            
            signInPanel()
            
            
            Spacer()
        }
        .onAppear{
            
            viewModel.email = userViewModel.email
        }
        .themeFullView()
        
    }
}


extension UserLoginViewOld {
    
    
    
    private func signInNow() {
        
        viewModel.inProgress = true
        
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
       
            withAnimation(Animation.easeIn(duration: 0.5) ){
                
                viewModel.signIn()
            }

            
        })
       
    }
    
    
    private func signInPanel() -> some View {
        
        VStack(spacing: 20) {
            
            Image("docusign").resizable().frame(width:160).aspectRatio(contentMode: .fit)
         
            Common.textFieldWithUnderLine("Email", text:$viewModel.email )
            
            Common.secureFieldWithUnderLine("Password", text: $viewModel.password )
         
            Button(action: {
                
                signInNow()
                
            }) {
                
                Text("Sign In").font(.custom(Theme.fontName, size: 20))
                .padding()
                .frame(width: 160, height: 40)
                .foregroundColor(.white).background(Color.blue)
                .cornerRadius(6)
                
            }
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 40, height: 260)
        .border(Color.purple, width: 1, cornerRadius: 6)
        
        
    }
}
