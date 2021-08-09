//
//  TemplateView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//

import Foundation
import SwiftUI


struct TemplateView : View {
    
    var body: some View {
        
        VStack{
            
            DocuSignSigningView ()
            
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Theme.commonBgColor)
        .edgesIgnoringSafeArea(.all)
  
    }
}
