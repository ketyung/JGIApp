//
//  TopBarPopOverModifier.swift
//  SwiftUIAvFX
//
//  Created by Chee Ket Yung on 29/04/2021.
//

import SwiftUI

struct PopOverView <Content: View>: View {
    
    
    @Binding var isPresented : Bool

    private let content: Content
    
    private let viewXOffset : CGFloat
    
    private let viewXOffsetMultiplier : CGFloat
    
    private let yOffset : CGFloat
    
    private let withCloseButton : Bool
    
    init(isPresented : Binding <Bool>, @ViewBuilder content: () -> Content, notchXOffset : CGFloat = 0,
         viewXOffset : CGFloat = 0, viewXOffsetMultiplier : CGFloat = 0, yOffset : CGFloat = 0, withCloseButton : Bool = false ){
        
        self._isPresented = isPresented
        self.content = content()
        self.viewXOffset = viewXOffset
        self.viewXOffsetMultiplier = viewXOffsetMultiplier
        self.yOffset = yOffset
        self.withCloseButton = withCloseButton
    }
   
    var body: some View {
        
        ZStack {
            if isPresented {
            
                let w = UIScreen.main.bounds.width - 20
                let h : CGFloat = 400
              
                if withCloseButton {
                    
                    Color.black
                    .opacity(0.35)
                    .frame(minHeight: UIScreen.main.bounds.height + 200)
                        
                    
                    VStack (spacing: 10){
                        
                        closeButton()
                        
                        content
                    }
                    .padding(2)
                    .background(Theme.commonPopUpBgColor)
                    .cornerRadius(10)
                    .frame(width:w , height: h, alignment: .center)
                   
                }
                else {
                    
                    Color.black
                    .opacity(0.35)
                    .onTapGesture {
                        withAnimation{
                            self.isPresented = false
                        }
                    }
                    .frame(minHeight: UIScreen.main.bounds.height + 200)
                        
                    
                    
                    content
                    .padding(.top,10).padding(.bottom,4).padding(.leading, 4).padding(.trailing, 4)
                    .background(Theme.commonPopUpBgColor)
                    .cornerRadius(10)
                    .frame(width:w , height: h, alignment: .center)
               
                }
               
                
            }
        }
    
    }
    
    
    
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



public extension View {
    func popOver<Content: View>(
        isPresented: Binding<Bool>,  notchXOffset : CGFloat = 0, viewXOffset : CGFloat = 0,
        viewXOffsetMultiplier : CGFloat = 0, yOffset : CGFloat = 0, withCloseButton : Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            PopOverView(isPresented: isPresented,content: content, notchXOffset : notchXOffset, viewXOffset : viewXOffset, viewXOffsetMultiplier : viewXOffsetMultiplier, yOffset : yOffset, withCloseButton : withCloseButton)
        }
    }
}
