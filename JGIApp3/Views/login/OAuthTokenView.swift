//
//  OAuthTokenView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//

import SwiftUI

struct OAuthTokenView : View {
    
   // @State var viewModel : AuthenticationViewModel
    
    @EnvironmentObject private var viewModel : AuthenticationViewModel
    
    var body: some View {
        
        VStack{
            
            view()
        }
        .themeFullView()
        
    }
}

extension OAuthTokenView {
    
    @ViewBuilder
    private func view() -> some View {
        
        if viewModel.afterSignIn{
            
         //   AfterSignInView(viewModel: viewModel)
        }
        else {
            
            OAuthTokenWebView(delegate: viewModel)
    
        }
    }
}
