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
    
    
    var body: some View {
        
        VStack {
            
            Spacer().frame(height: 30)
            
            
            Common.topBar(title: "Map Versions You Need To Review & Sign", switchToViewType: $viewType, fontSize: 15)
       
            MapVersionsListView(viewType: $viewType, mapId: $selectedMapId, mapTitle: $selectedMapTitle,
            mode : .unsignedByCurrentUser, needFullView: false)
            .transition(.move(edge: .bottom))
            
            Spacer()
        }
        .themeFullView()
    }
}
