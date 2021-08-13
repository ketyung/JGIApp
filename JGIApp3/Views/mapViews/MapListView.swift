//
//  MapListView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 06/08/2021.
//

import SwiftUI

struct MapListView : View {
    
    @Binding var viewType : FMM.ViewType
    
    @StateObject private var viewModel = MQVM()
    
    @EnvironmentObject private var userViewModel : UserViewModel
 
    @EnvironmentObject private var signingViewModel : SVM
 
    @State private var mapVersionViewPresented : Bool = false
    
    @State private var selectedMapId : String = ""
    
    @State private var selectedMapTitle : String = ""
    
    @State private var listDetailViewPresented : Bool = false
 
    
    var body : some View {
        
   
        if mapVersionViewPresented {
            
            MapVersionsListView(viewType: $viewType, mapId: $selectedMapId,
            mapTitle: $selectedMapTitle, detailViewPresented: $listDetailViewPresented)
            .transition(.move(edge: .bottom))
            .onAppear{
                signingViewModel.firstSigner = true
            }
        }
        else {
            
            mapListView()
        }
        
       
    }
}

extension MapListView {
    
    
    private func mapListView() -> some View {
        
        VStack (alignment: .leading, spacing: 10){
            
            Spacer().frame(height: 30)
            
            Common.topBar(title: "Your Maps", switchToViewType: $viewType)
        
            ScrollView(.vertical, showsIndicators : false ){
            
                VStack(spacing:20) {
                
                    ForEach (viewModel.maps, id:\.id){
                        
                        map in
                        
                        //let _ = print("map::\(map.id ?? "")")
                        mapRowView(map)
                    }
                }.padding()
            }
            
            .padding()
        }
        .themeFullView()
        .onAppear{
            
            viewModel.fetchMaps(userId: userViewModel.id)
        }
        .progressView(isShowing: $viewModel.inProgress)
        .popOver(isPresented: $viewModel.errorPresented, content: {
            
            Common.errorAlertView(message: viewModel.errorMessage ?? "Error!")
        })
    }
    
    
   
}


extension MapListView {
    
    
    private func mapRowView(_ map : UserMap) -> some View {
        
       
        HStack(spacing:20) {
                
            Image("map").resizable().frame(width:80, height:68).aspectRatio(contentMode: .fit)
   
            VStack(alignment: .leading, spacing:10) {
           
                Text(map.title ?? "Untitled".localized).font(.custom(Theme.fontNameBold, size: 16))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
            
                HStack(spacing: 20) {
                    
                    Text("\(map.lastUpdated?.timeAgo() ?? "")").padding().foregroundColor(.white)
                    .font(.custom(Theme.fontName, size:14))
                    .frame(width: 120,height:30).background(Color(UIColor(hex:"#660000ff")!)).cornerRadius(6)
                    
                    Button(action: {
                        
                        withAnimation{
                            
                            self.selectedMapId = map.id ?? ""
                            self.selectedMapTitle = map.title ?? ""
                            
                            self.mapVersionViewPresented = true 
                        }
                        
                    }){
                   
                        Text("Versions".localized).padding().foregroundColor(.white).frame(width: 120,height:30)
                        .background(Color(UIColor(hex:"#006633ff")!)).cornerRadius(6)
                       
                    }
                    
                }
            
            }
            
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 40, height: 120)
        .background(Color(UIColor(hex:"#ccddeeff")!))
        .cornerRadius(10)
    }
}
