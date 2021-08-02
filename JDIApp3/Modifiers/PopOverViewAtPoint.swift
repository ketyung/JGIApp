//
//  PopOverViewAtPoint.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 02/08/2021.
//

import Foundation
import SwiftUI

struct PopOverViewAtPoint <Content: View>: View {
    
    
    @Binding var isPresented : Bool

    private let content: Content
    
    private let point : CGPoint
    
    
    init(isPresented : Binding <Bool>, @ViewBuilder content: () -> Content, point : CGPoint ){
        
        self._isPresented = isPresented
        self.content = content()
        self.point = point
    }
    
    
    var body: some View {
        
        ZStack {
            if isPresented {
                
                let w = UIScreen.main.bounds.width - 20
                let h : CGFloat = 100
              
                Color.black
                .opacity(0.35)
                .frame(minHeight: UIScreen.main.bounds.height + 200)
               
                
                HStack (spacing: 10){
                    
                    
                    content
                
                    Spacer()
                    closeButton()
                
                }
                .padding(2)
                .background(Theme.commonPopUpBgColor)
                .cornerRadius(10)
                .frame(width:w , height: h, alignment: .center)
                
            }
        }.position(x: point.x, y: point.y)
        
    }
   
}

extension PopOverViewAtPoint {
    
    
    private func closeButton() -> some View {
        
        HStack(spacing:5) {
       
            Spacer()
            .frame(width:2)
            
            Button(action: {
                withAnimation {
                    self.isPresented = false
                }
            }){
                
                Image(systemName: "x.circle.fill")
                .resizable()
                .frame(width:20, height: 20, alignment: .topLeading)
                .foregroundColor(.black)
                
            }
            
            Spacer()
        }
        
    }
}
