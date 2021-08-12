//
//  MapVersionsListView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 07/08/2021.
//

import SwiftUI

struct MapVersionsListView : View {
  
    enum Mode : Int {
        
        case byMapId
        
        case unsignedByCurrentUser
        
        case signedByCurrentUser
    }
    
    @Binding var viewType : FMM.ViewType
    
    @Binding var mapId : String
   
    @Binding var mapTitle : String
   
    @State var mode : Mode = .byMapId
    
    @State var needFullView : Bool = true
    
    @Binding var detailViewPresented : Bool
    
    @StateObject private var viewModel = MQVM()
    
    
    @State private var frontMapActionParam : FMAP = .defaultValue
    
    @EnvironmentObject private var userViewModel : UserViewModel
    
    
    var body : some View {
        
       switchView()
    }
}

extension MapVersionsListView {
    
    
    @ViewBuilder
    private func switchView() -> some View {
        
        if detailViewPresented {
            
            FrontMapView(viewType: $viewType, actionParam: $frontMapActionParam)
        }
        else {
            
            if needFullView {
            
                view()
                .themeFullView()
                
            }
            else {
                
                view()
            }
                
        }
    }
    
    private func view() -> some View {
        
        VStack (alignment: .leading, spacing: 10){
            
            if needFullView {
           
                Spacer().frame(height: 30)
                
                
                Common.topBar(title: "Versions Of Map", switchToViewType: $viewType)
           
                Text(mapTitle).font(.custom(Theme.fontNameBold, size: 18))
                .padding(.leading, 20).padding(.bottom, 5).padding(.top, 5)
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                
              
            }
           
            
            ScrollView (/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
                
                VStack {
                
                    ForEach(viewModel.mapVersions, id:\.versionNo) {
                        
                        version in
                        
                        mapVersionRowView(version)
                    }
                    
                }
                .padding()
            }
            
            Spacer()
        }
        
        .onAppear{
        
            fetchMapVersions()
         }
        
    }
}


extension MapVersionsListView {
    
    private func fetchMapVersions(){
        
        
        switch(mode) {
        
            case .byMapId :
                viewModel.fetchVersions(mapId: mapId)
          
            case .signedByCurrentUser :
                
            
                return
                
            case .unsignedByCurrentUser :
            
                viewModel.fetchVersionsUnsignedBy(userId: userViewModel.id)
                return
            
            
        }
    }
}


extension MapVersionsListView {
    
    
    
    private func mapVersionRowView(_ version : MapVersion) -> some View {
        
       
        HStack(spacing:20) {
                
            Spacer().frame(width: 5)
            
            Image("map").resizable().frame(width:60, height:51).aspectRatio(contentMode: .fit)
   
            VStack(alignment: .leading, spacing:10) {
           
                
                HStack(spacing: 20) {
              
                  
                    Text("\("Version".localized) : \(version.versionNo ?? 100)")
                    .font(.custom(Theme.fontNameBold, size: 16)).foregroundColor(.black)
                    .frame(minWidth: 160, alignment: .leading)
                    
                    Text("\(version.lastUpdated?.timeAgo() ?? "")").padding().foregroundColor(.white)
                    .font(.custom(Theme.fontName, size:14))
                    .frame(width: 100,height:30).background(Color(UIColor(hex:"#660000ff")!)).cornerRadius(6)
                    
                }
          
                actionButtons(version)
          
              
            }
            
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 20, height: 120)
        .background(Color(UIColor(hex:"#ccddeeff")!))
        .cornerRadius(10)
    }
    
    
    private func actionButtons(_ version : MapVersion ) -> some View {
        
        HStack(spacing: Common.isIPad() ? 40 : 20) {
            
            actionButton("eye", action: {
                
                withAnimation{
                    
                    frontMapActionParam = FMAP(mode: .viewOnly, mapId: version.id, versionNo: version.versionNo)
                    detailViewPresented = true 
                }
            })
            
            actionButton("pencil", action: {
                
                withAnimation{
                    
                    frontMapActionParam = FMAP(mode: .edit, mapId: version.id, versionNo: version.versionNo)
                    detailViewPresented = true
                }
            })
            
            actionButton("signature", action: {
                
                withAnimation{
                
                    frontMapActionParam = FMAP(mode: .sign, mapId: version.id, versionNo: version.versionNo)
                    detailViewPresented = true
                }
            })
            
            actionButton("trash", action: {
                
            })
            
        }
    }
    
    
    private func actionButton(_ imageSystemName : String, action : (()->Void)? = nil ) -> some View {
        
        Button(action: {
            
            action?()
        }){
       
            
            ZStack {
                
          
                Circle().fill(Color(UIColor(hex:"#334499ff")!)).frame(width: 40, height: 40)
                
                Image(systemName: imageSystemName)
                .imageScale(.medium)
                .foregroundColor(.white)
              
                
            }
            
        }
       
    }
    
}
