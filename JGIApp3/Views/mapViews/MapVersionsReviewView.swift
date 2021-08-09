//
//  MapVersionsReviewView.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 09/08/2021.
//

import SwiftUI

struct MapVersionsReviewView : View {
    
    @Binding var viewType : FMM.ViewType
  
    @State private var selectedMapId = ""
    
    @State private var selectedMapTitle = ""
    
    @EnvironmentObject private var userViewModel : UserViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing:20) {
            
            Spacer().frame(height: 30)
        
            Common.topBar(title: "Map Versions You Need To Review & Sign", switchToViewType: $viewType, fontSize: Common.isIPad() ? 24 : 16)
       
            HStack {
                
                let fsz : CGFloat =  Common.isIPad() ? 26 : 16
                Text("Your role is :").font(.custom(Theme.fontName, size: fsz))
               
                Text("\(userViewModel.user.groupName ?? "")").font(.custom(Theme.fontNameBold, size: fsz))
               
            }
            .padding()
        
            
            MapVersionsListView(viewType: $viewType, mapId: $selectedMapId, mapTitle: $selectedMapTitle,
            mode : .unsignedByCurrentUser, needFullView: false)
            .transition(.move(edge: .bottom))
            
            Spacer()
        }
        .padding()
        .themeFullView()
    }
}
