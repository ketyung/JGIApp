//
//  MenuView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 04/08/2021.
//

import SwiftUI

typealias FMM = FrontMenuView

struct FrontMenuView : View {

    
    enum ViewType : Int {
        
        case menu
        
        case signIn
        
        case createMap
        
        case mapList
        
        case reviewMap
        
        case profile
        
        case pdfPreview
        
        case settings
        
        case docuSignSignIn
        
        // update 221
    }
    
    @State private var viewType : ViewType = .menu
    
    @State private var frontMapActionParam : FMAP = .defaultValue
    
    @EnvironmentObject private var userViewModel : UserViewModel
    
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
            
                FrontMapView(viewType : $viewType, actionParam: $frontMapActionParam)
                .transition(.move(edge: .bottom))
             
            case .mapList :
                MapListView(viewType: $viewType)
                .transition(.move(edge: .bottom))
               
            case .reviewMap :
                MapVersionsReviewView(viewType: $viewType)
                .transition(.move(edge: .bottom))
                
                
            case .profile :
            
                UserProfileView(viewType: $viewType)
                .transition(.move(edge: .bottom))
        
            case .signIn :
        
                SignInView(viewType: $viewType)
                .transition(.move(edge: .bottom))
    
            case .settings :
                SettingsView(viewType: $viewType)
                .transition(.move(edge: .bottom))
                
            
            case .docuSignSignIn :
                UserLoginViewOld(viewType: $viewType)
                .transition(.move(edge: .bottom))
                 
            
            case .pdfPreview :
            
                PdfPreviewView(viewType: $viewType)
                   
            
        }
    }
}


extension FrontMenuView {
    
    
    @ViewBuilder
    private func menuView() -> some View {
        
        let buttonSpacing : CGFloat = Common.isIPad() ? 50 : 20
        
        ScrollView(.vertical, showsIndicators: false) {
            
            Spacer().frame(height : 20)
            
            Image("logo").resizable().frame(width:150, height: 66).aspectRatio(contentMode: .fit)
            
            if userViewModel.hasSignedIn {
           
                Text("You're signed in as \(userViewModel.user.firstName ?? "") \(userViewModel.user.lastName ?? "")").font(.custom(Theme.fontNameBold, size: 18)).padding().foregroundColor(.black)
               
            }
            
            
            HStack(spacing: buttonSpacing) {
                
                mapButtonView(title: "Create Map", imageSystemName: "plus.circle", action: {
                    
                    withAnimation{
                        
                        viewType = .createMap
                    }
                })
                
            
                mapButtonView(title: "Your Maps", imageSystemName: "list.star",
                              backgroundColor: Color(UIColor(hex:"#668822ff")!), action: {
                    
                    withAnimation{
                        
                        viewType = .mapList
                    }
                  })
                
            }
            
            Spacer().frame(height: 20)
            
            HStack(spacing:buttonSpacing) {
                
                mapButtonView(title: "Review & Sign", imageSystemName: "signature", backgroundColor:  Color(UIColor(hex:"#226699ff")!), action: {
                    
                    withAnimation{
                        
                        viewType = .reviewMap
                    }
                })
               
            
                mapButtonView(title: "Messages", imageSystemName: "message",
                            backgroundColor: Color(UIColor(hex:"#883399ff")!))
                
            }
            
            Spacer().frame(height: 20)
            
            HStack(spacing:buttonSpacing) {
                
                mapButtonView(title: "Profile", imageSystemName: "person", backgroundColor:  Color(UIColor(hex:"#229955ff")!), action: {
                                
                    withAnimation{
                        
                        viewType = .profile
                    }
                })
               
            
                mapButtonView(title: "Settings", imageSystemName: "gearshape",
                  backgroundColor:  Color(UIColor(hex:"#990000ff")!) , action: {
              
                    withAnimation{
                        
                        viewType = .settings
                    }
              
                })
                
            }
            
            Spacer()
            
        }
        .padding()
        .frame(width : UIScreen.main.bounds.width - (Common.isIPad() ? 200 : 40),
            height: UIScreen.main.bounds.height - (Common.isIPad() ? 400 : 160))
        .background(Color(UIColor(hex:"#ccddffff")!))
        .cornerRadius(40)
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


