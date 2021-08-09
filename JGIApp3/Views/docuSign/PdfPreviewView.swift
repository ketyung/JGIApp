//
//  PdfPreviewView.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 08/08/2021.
//

import SwiftUI

struct PdfPreviewView  : View {
    
    @Binding var viewType : FMM.ViewType
    
    @EnvironmentObject private var signingViewModel : CFSVM
    
    @State  private var itmes : [Any] = []
    @State  private var shareSheetPresented : Bool = false
    @State  private var optionsSheetPresented : Bool = false
    @State  private var proceed : Bool = false
    
    
    
    var body: some View {
        
        if proceed {
            
           UserLoginViewOld(viewType: $viewType)
        }
        else {
       
            view()
           
        }
        
    }
    
}


extension PdfPreviewView {
    
    private func view() -> some View {
        
        VStack {
            
            Spacer()
            
            Common.topBar(title: "Map PDF Preview", switchToViewType: $viewType)
            
            PdfViewUI(data: signingViewModel.attachment)
            
            proceedButton()
            
            Spacer()
            
        }
        
        .bottomSheet(isPresented:$optionsSheetPresented , height: 300, showGrayOverlay: true, content: {
            
            optionsView()
        })
        .sheet(isPresented: $shareSheetPresented, content: {
            if let data = signingViewModel.attachment {
                ShareView(activityItems: [data])
            }
            
        })
    }
}


extension PdfPreviewView {
    
    
    
    private func optionsView() -> some View {
        
        VStack(spacing :10) {
            
            Button(action : {
                
                
                withAnimation{
                    
                    optionsSheetPresented = false
                    
                    proceed = true 
                }
                
            }){
            
                HStack(spacing:20) {
                    
                    Spacer().frame(width: 5)
                    
                    Text("Sign It With".localized).font(.custom(Theme.fontNameBold, size: 24)).foregroundColor(.black)
                    
                    Image("docusign").resizable().frame(width: 80, height : 17.2).aspectRatio(contentMode: .fit)
                    
                    Spacer()
                }
                .padding()
                .frame(height: 50)
            }
            
            
            Button(action: {
                
                withAnimation{
                    
                    optionsSheetPresented = false
                    withAnimation(Animation.easeIn(duration: 0.5).delay(0.5)){
                        shareSheetPresented = true
                    }
                }
                
            }){
            
                
                HStack(spacing:20) {
                    
                    Spacer().frame(width: 5)
              
                    Image("share").resizable().frame(width: 30, height: 30).aspectRatio(contentMode: .fit)
                    
                    Text("Share".localized).font(.custom(Theme.fontNameBold, size: 24)).foregroundColor(.black)
                    
            
                    Spacer()
                    
                }.padding()
                .frame(height: 50)
      
            }
            
            Spacer()
            
        }
    }
}



extension PdfPreviewView {

    private func proceedButton() -> some View {
        
        Button(action: {
         
            withAnimation{
                
                optionsSheetPresented = true
            }
      
        }){
            Text("Proceed")
            .padding(10)
            .frame(width: 100)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
            
        }
    }
}
