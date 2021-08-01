//
//  BottomSheet.swift
//  SwiftUICollage2
//
//  Created by Chee Ket Yung on 24/04/2021.
//
import SwiftUI

public struct BottomSheet<Content: View>: View {
    
    private var dragToDismissThreshold: CGFloat { height * 0.2 }
    private var grayBackgroundOpacity: Double { isPresented ? (0.5 - Double(draggedOffset)/600) : 0 }
    
    @State private var draggedOffset: CGFloat = 0
    @State private var previousDragValue: DragGesture.Value?

    @Binding var isPresented: Bool
    private let height: CGFloat
    private let topBarHeight: CGFloat
    private let topBarCornerRadius: CGFloat
    private let content: Content
    private let contentBackgroundColor: Color
    private let topBarBackgroundColor: Color
    private let showTopIndicator: Bool
    private let showGrayOverlay : Bool
    private let shouldAddDragOffsetWhenPresented : Bool = false
    
    @State private var yPosition : CGFloat = UIScreen.main.bounds.height
    
    public init(
        isPresented: Binding<Bool>,
        height: CGFloat,
        topBarHeight: CGFloat = 30,
        topBarCornerRadius: CGFloat? = nil,
        topBarBackgroundColor: Color = Color(.systemBackground),
        contentBackgroundColor: Color = Color(.systemBackground),
        showTopIndicator: Bool,
        showGrayOverlay : Bool = true ,
        @ViewBuilder content: () -> Content
    ) {
        self.topBarBackgroundColor = topBarBackgroundColor
        self.contentBackgroundColor = contentBackgroundColor
        self._isPresented = isPresented
        self.height = height
        self.topBarHeight = topBarHeight
        if let topBarCornerRadius = topBarCornerRadius {
            self.topBarCornerRadius = topBarCornerRadius
        } else {
            self.topBarCornerRadius = topBarHeight / 3
        }
        self.showTopIndicator = showTopIndicator
        self.showGrayOverlay = showGrayOverlay
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                if isPresented {
          
                    sheetView(geometry)
                }
            }
            .onAppear{
                
                self.setToNonPresentedYOffset(geometry)
            }
        }
    }
    
}

extension BottomSheet {
    
    
    @ViewBuilder
    private func sheetView(_ geometry : GeometryProxy) -> some View {
        
        self.fullScreenLightGrayOverlay()
        
        VStack(spacing: 0) {
            if self.showTopIndicator  {
                self.topBar(geometry: geometry)
            }
            VStack(spacing: -8) {
                Spacer()
                self.content //.padding(.bottom, geometry.safeAreaInsets.bottom)
                Spacer()
            }
            .frame(width: geometry.size.width)
        }
        .frame( height: self.height - min(self.draggedOffset*2, 0))
        .background(self.contentBackgroundColor)
        .cornerRadius(self.topBarCornerRadius, corners: [.topLeft, .topRight])
        .offset(y:self.yPosition)
        .onAppear{
            
            withAnimation {
     
                self.setToPresentedYOffset(geometry)
            }
        }
        .onDisappear{
         
            withAnimation {
     
                self.setToNonPresentedYOffset(geometry)
            }
        }
            // .animation(.interactiveSpring())
       // .offset(y: yOffset(geometry))
   
    }
}


extension BottomSheet {
    
    private func setToPresentedYOffset(_ geometry : GeometryProxy){
        
        var toAdd : CGFloat = 0
        
        if shouldAddDragOffsetWhenPresented {
            
            toAdd = self.draggedOffset
        }
        
        self.yPosition =
        (geometry.size.height/2 - self.height/2 + geometry.safeAreaInsets.bottom + toAdd)
        
    }
    
    private func setToNonPresentedYOffset(_ geometry : GeometryProxy){
    
        self.yPosition = (geometry.size.height/2 + self.height/2 + geometry.safeAreaInsets.bottom)
      //  print("non.presented::\(self.yPosition)")
    }
    
    private func yOffset ( _ geometry : GeometryProxy ) -> CGFloat{
        
        return self.isPresented ? (geometry.size.height/2 - self.height/2 + geometry.safeAreaInsets.bottom + self.draggedOffset) : (geometry.size.height/2 + self.height/2 + geometry.safeAreaInsets.bottom)
    }
}

extension BottomSheet {
    
    @ViewBuilder
    fileprivate func fullScreenLightGrayOverlay() -> some View {
        
        if self.showGrayOverlay {
            
            Color
            .black
            .opacity(grayBackgroundOpacity)
            .edgesIgnoringSafeArea(.all)
            .animation(.interactiveSpring())
            .onTapGesture { self.isPresented = false }
        }
        else {
            
            Color.clear
            .edgesIgnoringSafeArea(.all)
            .animation(.interactiveSpring())
            .onTapGesture { self.isPresented = false }
          
        }
        
    }
    
    fileprivate func topBar(geometry: GeometryProxy) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
            .fill(Color(UIColor(hex:"#ddddddff")!))
            .frame(width: 40, height: 6)
            .opacity(showTopIndicator ? 1 : 0)
        }
        .frame(width: geometry.size.width, height: topBarHeight)
        .background(topBarBackgroundColor)
        .gesture(
            DragGesture()
                .onChanged({ (value) in
                    
                    let offsetY = value.translation.height
                    self.draggedOffset = offsetY
                    
                    if let previousValue = self.previousDragValue {
                        let previousOffsetY = previousValue.translation.height
                        let timeDiff = Double(value.time.timeIntervalSince(previousValue.time))
                        let heightDiff = Double(offsetY - previousOffsetY)
                        let velocityY = heightDiff / timeDiff
                        if velocityY > 1400 {
                            self.isPresented = false
                            return
                        }
                    }
                    self.previousDragValue = value
                    
                })
                .onEnded({ (value) in
                    let offsetY = value.translation.height
                    if offsetY > self.dragToDismissThreshold {
                        self.isPresented = false
                    }
                    self.draggedOffset = 0
                    //self.previousDragValue = value
                    
                })
        )
    }
}

