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
    
    private var withCloseButton : Bool = false
    
    
    init(isPresented : Binding <Bool>, @ViewBuilder content: () -> Content,  withCloseButton : Bool = false ){
        
        self._isPresented = isPresented
        self.content = content()
        self.withCloseButton = withCloseButton
    }
    
    
    var body: some View {
        
        ZStack {
            if isPresented {
             
                
                let w = UIScreen.main.bounds.width - 20
                let h : CGFloat = 100
              
                view()
                .padding(2)
                .background(Color.clear)
                .cornerRadius(10)
                .frame(width:w , height: h, alignment: .center)
                
            }
        }
       
    }
   
}

extension PopOverViewAtPoint {
    
    
    @ViewBuilder
    private func view() -> some View {
        
        if withCloseButton {
      
            HStack (spacing: 10){
            
                content
        
                Spacer()
                closeButton()
            
            }
          
        }
        else {
            
            content
        }
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

extension View {
    
    
    func popOverAt<Content: View>( _ point : CGPoint,
        isPresented: Binding<Bool>, withCloseButton : Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
       
            PopOverViewAtPoint(isPresented: isPresented, content: content, withCloseButton: withCloseButton)
            .offset(x: point.x, y: point.y)
               
        }
        
    }
}


extension CGPoint {
    
    static let topRight = CGPoint(x: UIScreen.main.bounds.width - 300, y: -((UIScreen.main.bounds.height / 2) - 50))
}
