//
//  ProgressViewModifier.swift
//  KyPayApp2
//
//  Created by Chee Ket Yung on 15/06/2021.
//

import SwiftUI

struct ProgressViewModifier : ViewModifier {
    
    @Binding var isShowing : Bool
    
    var text : String
    var size : CGSize
    var color : Color
    var showsGrayOverlay : Bool = true
    
    
    func body(content: Content) -> some View {
    
        ZStack {
            
            content
            
            if isShowing {
                
                if showsGrayOverlay {
                    progressViewWithGrayOverlay()
                }
                else {
                    progressView()
                }
                
            }
        }
    }
    
}


extension ProgressViewModifier {
    
    
    private func progressViewWithGrayOverlay() -> some View {
        
        ZStack {
            
            Color.black
            //.frame(height: UIScreen.main.bounds.height + 100)
            .edgesIgnoringSafeArea(.all)
            .opacity(0.4)
                
            progressView()
        }
    }
    
    
    @ViewBuilder
    private func progressView() -> some View {
        
        if !text.isEmpty {
      
            VStack (spacing : 20) {
                
                CustomActivityIndicator(color: self.color, isRunning:  self.$isShowing)
                
               
                Text(text)
                .foregroundColor(.black)
                .font(.custom(Theme.fontName, size: 16))
                
            }
            .frame(width: size.width, height: size.height)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10 )
            .offset(y : -50)
        }
        else {
            
            CustomActivityIndicator(color: self.color, isRunning:  self.$isShowing)
          
        }
    }
    
    
}


extension View {
    
    func progressView(isShowing: Binding <Bool>, text : String = "", size : CGSize =  CGSize(width:120, height:120), color : Color = .green, showGrayOverlay : Bool = true) -> some View{
        
        self.modifier(ProgressViewModifier(isShowing: isShowing, text: text, size: size, color: color, showsGrayOverlay: showGrayOverlay))
    }
}
