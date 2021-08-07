//
//  OauthWebView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 31/07/2021.
//

import SwiftUI
import WebKit

typealias OTWV = OAuthTokenWebView

struct OAuthTokenWebView : UIViewRepresentable {
    
    weak var delegate : WKNavigationDelegate?
    
    private let urlBase = "https://account-d.docusign.com/oauth/auth?"
    
    private let integratorKey  = "8c58de5c-17a0-49ee-b01f-b73bb12eaa84"
    
    private let state = "jsi8998VbFArd2031hf"
    
    private let scope = "signature"
    
    private let responseType = "code"
    
    internal static let redirectURI = "https://techchee.com/JDIAuthCallBack"
    

    func makeUIView(context: Context) -> WKWebView  {
        
        let configuration = WKWebViewConfiguration()
    
        let w =  WKWebView(frame:.zero, configuration: configuration)
    
        w.contentMode = .scaleAspectFit
        w.sizeToFit()
        w.autoresizesSubviews = true
        
        w.navigationDelegate  = self.delegate
        
        
        let urlString =
        "\(urlBase)response_type=\(responseType)&client_id=\(integratorKey)&scope=\(scope)&state=\(state)&redirect_uri=\(OTWV.redirectURI)"
       
        if let url = URL(string: urlString) {
     
            w.load( URLRequest(url: url ) )
        }
        return w
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
      
    }
    
}
