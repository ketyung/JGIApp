//
//  MapVersionsListView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 07/08/2021.
//

import SwiftUI

struct MapVersionsListView : View {
  
    @Binding var viewType : FMM.ViewType
    
    @Binding var mapId : String
   
    @Binding var mapTitle : String
   
    @StateObject private var viewModel = MQVM()
    
    @State private var detailViewPresented : Bool = false
    
    @State private var frontMapActionParam : FMAP = .defaultValue
    
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
            
            view()
        }
    }
    
    private func view() -> some View {
        
        VStack (alignment: .leading, spacing: 10){
            
            Spacer().frame(height: 30)
            
            Common.topBar(title: "Versions Of Map For", switchToViewType: $viewType)
       
            Text(mapTitle).font(.custom(Theme.fontNameBold, size: 18))
            .padding(.leading, 20).padding(.bottom, 5).padding(.top, 5)
            .foregroundColor(.black)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(2)
            
          
            
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
            
            viewModel.fetchVersions(mapId: mapId)
        }
        .themeFullView()
    }
}


extension MapVersionsListView {
    
    
    
    private func mapVersionRowView(_ version : MapVersion) -> some View {
        
       
        HStack(spacing:20) {
                
            Image("map").resizable().frame(width:60, height:51).aspectRatio(contentMode: .fit)
   
            VStack(alignment: .leading, spacing:10) {
           
                
                HStack(spacing: 20) {
              
                  
                    Text("\("Version".localized) : \(version.versionNo ?? 100)")
                    .font(.custom(Theme.fontNameBold, size: 20))
                  
                    
                    Text("\(version.lastUpdated?.timeAgo() ?? "")").padding().foregroundColor(.white)
                    .font(.custom(Theme.fontName, size:16))
                    .frame(height:30).background(Color(UIColor(hex:"#660000ff")!)).cornerRadius(6)
                    
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
        
        HStack(spacing:20) {
            
            actionButton("eye", action: {
                
                withAnimation{
                    
                    frontMapActionParam = FMAP(mode: .viewOnly, mapId: mapId, versionNo: version.versionNo)
                    detailViewPresented = true 
                }
            })
            
            actionButton("pencil", action: {
                
                withAnimation{
                    
                    frontMapActionParam = FMAP(mode: .edit, mapId: mapId, versionNo: version.versionNo)
                    detailViewPresented = true
                }
            })
            
            actionButton("signature")
            
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
