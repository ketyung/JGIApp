//
//  PdfPreviewView.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 08/08/2021.
//

import SwiftUI

struct PdfPreviewView  : View {
    
    @Binding var viewType : FMM.ViewType
    
    @EnvironmentObject private var contentViewModel : PCVM
    
    @State  var itmes : [Any] = []
    @State  var showShareSheet : Bool = false
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Common.topBar(title: "Map PDF Preview", switchToViewType: $viewType)
            
            PdfViewUI(data: contentViewModel.pdfData())
            
            shareButton()
            
            Spacer()
            
        }
        .sheet(isPresented: $showShareSheet, content: {
        
            if let data = contentViewModel.pdfData() {
                ShareView(activityItems: [data])
            }
            
        })
        
    }
    
}




extension PdfPreviewView {

    private func shareButton() -> some View {
        
        Button(action: {
            self.showShareSheet.toggle()
        }, label: {
            Text("Proceed")
            .padding(10)
            .frame(width: 100)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
            
        })
    }
}
