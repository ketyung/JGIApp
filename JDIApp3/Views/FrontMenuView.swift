//
//  MenuView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 04/08/2021.
//

import SwiftUI


struct FrontMenuView : View {

    
    enum ViewType : Int {
        
        case menu
        
        case createMap
        
        case mapList
        
        case reviewMap
        
        case profile
        
        case settings
    }
    
    @State private var viewType : ViewType = .menu
    
    var body : some View {
        
        switchView()
    }
}


extension FrontMenuView {
    
    @ViewBuilder
    private func switchView() -> some View {
        
        switch(viewType) {
        
            case .menu :
            
                menuView()
                
            case .createMap :
            
                FrontMapView(viewType : $viewType)
                .transition(.move(edge: .bottom))
                
            default :
                menuView()
            
        }
    }
}


extension FrontMenuView {
    
    
    @ViewBuilder
    private func menuView() -> some View {
        
        let buttonSpacing : CGFloat = Common.isIPad() ? 50 : 20
        
        ScrollView(.vertical, showsIndicators: false) {
            
            Spacer().frame(height : 20)
            
            HStack(spacing: buttonSpacing) {
                
                mapButtonView(title: "Create Map", imageSystemName: "plus.circle", action: {
                    
                    withAnimation{
                        
                        viewType = .createMap
                    }
                })
                
            
                mapButtonView(title: "Your Maps", imageSystemName: "list.star", backgroundColor: .green)
                
            }
            
            Spacer().frame(height: 20)
            
            HStack(spacing:buttonSpacing) {
                
                mapButtonView(title: "Review & Sign", imageSystemName: "signature", backgroundColor:  Color(UIColor(hex:"#226699ff")!))
               
            
                mapButtonView(title: "Messages", imageSystemName: "message",
                            backgroundColor: Color(UIColor(hex:"#883399ff")!))
                
            }
            
            Spacer().frame(height: 20)
            
            HStack(spacing:buttonSpacing) {
                
                mapButtonView(title: "Profile",
                imageSystemName: "person", backgroundColor:  Color(UIColor(hex:"#229955ff")!))
               
            
                mapButtonView(title: "Settings", imageSystemName: "gearshape",
                backgroundColor:  Color(UIColor(hex:"#990000ff")!) )
                
            }
            
            Spacer()
            
        }
        .padding()
        .frame(width : UIScreen.main.bounds.width - (Common.isIPad() ? 200 : 40), height: UIScreen.main.bounds.height - 200)
        .background(Color(UIColor(hex:"#ddeeffff")!))
        .cornerRadius(20)
        .themeFullView()
     
    }
}


extension FrontMenuView {
    
    private func mapButtonView( title : String , imageSystemName : String,
                                backgroundColor : Color = .orange,
                                action : (()->Void)? = nil ) -> some View {
        
        Button(action: {
            
            action?()
        }) {
            
            VStack {
           
                Spacer().frame(height:10)
                
                ZStack {
                    
                    Image("map").resizable().frame(width: 90, height: 77).aspectRatio(contentMode: .fit)
                    
                    
                    ZStack {
                        
                  
                        Circle().fill(Color(UIColor(hex:"#334499ff")!)).frame(width: 50, height: 50)
                        
                        Image(systemName: imageSystemName).resizable()
                        .frame(width: 24, height: 24).aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                      
                    }
                    .offset(x: 34, y: 20)
               
         
                   
                }
                
                Text(title).font(.custom(Theme.fontNameBold, size: 16)).foregroundColor(.white)
                    
               
                
            }
            .padding()
            .frame(width : 150, height: 128)
            .background(backgroundColor)
            .cornerRadius(20)
            
        }
        
       
    }
}


