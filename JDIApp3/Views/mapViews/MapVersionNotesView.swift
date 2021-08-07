//
//  MapVersionNotesView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 07/08/2021.
//

import SwiftUI

struct MapVersionNotesView : View {
    
    @Binding var isPresented : Bool
    
    @State var notes : [MapVersionNote]?
    
    
    var body : some View {
        
        VStack {
            
            Spacer().frame(height:150)
            
            topBar()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                if let notes = notes {
                    
                    ForEach(notes, id:\.id) { note in
                        
                        noteRowView(note)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .themeFullView()
    }
}


extension MapVersionNotesView {
    
    
    private func noteRowView (_ note : MapVersionNote) -> some View {
        
        HStack(spacing:20) {
                
            Image(systemName: "message").resizable().frame(width:30, height:30).aspectRatio(contentMode: .fit)
   
            VStack(alignment: .leading, spacing:10) {
           
                Text(note.title ?? "").font(.custom(Theme.fontNameBold, size: 20))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                
                Text(note.note ?? "").font(.custom(Theme.fontName, size: 18))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(3)
                
                HStack(spacing:20) {
                    
                    Text("\(note.lastUpdated?.timeAgo() ?? "")").padding().foregroundColor(.white)
                    .font(.custom(Theme.fontName, size:15))
                    .frame(height:30).background(Color(UIColor(hex:"#660000ff")!)).cornerRadius(6)
                    
                    Text("\("By".localized) \(note.uid ?? "")")
                    .foregroundColor(.black)
                    .font(.custom(Theme.fontName, size:15))
                    
                    
                }
              
            }
            
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 20, height: 150)
        .background(Color(UIColor(hex:"#ccddeeff")!))
        .cornerRadius(10)
    }
    
    
    
    private func topBar() -> some View {
        
        HStack {
            
            Spacer().frame(width: 5)
            
            Button(action : {
                
                withAnimation{
                    
                    isPresented = false
                }
                
            }){
           
                Common.buttonView("close", imageColorInvert: true)
               
            }
                
            Text("Version Notes".localized).font(.custom(Theme.fontNameBold, size: 22)).foregroundColor(.black)
           
            Spacer()
        }
    }
}
