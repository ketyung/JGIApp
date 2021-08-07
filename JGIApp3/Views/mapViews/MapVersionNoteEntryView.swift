//
//  MapVersionNoteEntryView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 07/08/2021.
//

import SwiftUI

struct MapVersionNoteEntryView : View {
    
    @EnvironmentObject private var viewModel : MAHVM
   
    @EnvironmentObject private var userViewModel : UserViewModel
   
    @State private var textViewFocused : Bool = false
    
    @Binding var viewType : FMM.ViewType
   
    var body: some View {
       
        if viewModel.mapSuccessfullySavedToRemote
        {
            saveSuccessfulView()
            .transition(.move(edge: .bottom))
           
        }
        else {
            
            view()
        }
    }
    
}



extension MapVersionNoteEntryView {
    
    
    private func view() -> some View {
        
        
        VStack(spacing:20){
            
            Spacer().frame(height:30)
            
            topBar()
          
            Spacer().frame(height:50)
          
            Common.textFieldWithUnderLine("Title".localized, text: $viewModel.titleText)
           
            
            VStack(alignment: .leading, spacing:5) {
           
                Text("\("Note".localized) :").font(.custom(Theme.fontNameBold, size: 20)).foregroundColor(.gray)
          
                TextView(text: $viewModel.descriptionText, isFirstResponder: $textViewFocused)
                .frame(width: UIScreen.main.bounds.width - 10, height: 100)
               
                dismissKeyboardButton()
            }
            
            
            Spacer()
            
        }
        .padding()
        .popOver(isPresented: $viewModel.errorPresented, content: {
            
            Common.errorAlertView(message: viewModel.errorMessage ?? "Error!")
        })
        .progressView(isShowing: $viewModel.inProgress)
        .themeFullView()
    }
    
    
    private func topBar(noSaveButton : Bool = false) -> some View {
        
        HStack {
            
            Spacer().frame(width: 5)
            
            Button(action : {
                
                withAnimation{
                    
                    if viewModel.mapSuccessfullySavedToRemote {
                        
                        viewType = .menu
                        viewModel.resetAllNeccessary()
                    }
                    else {
              
                        viewModel.saveSheetPresented = false
                  
                    }
                    
                }
                
            }){
           
                Common.buttonView("close", imageColorInvert: true)
               
            }
            
            Spacer()
          
            Text("Add a note for this version".localized).font(.custom(Theme.fontNameBold, size: 16)).foregroundColor(.black)
            
            Spacer()
          
            if !noSaveButton {
            
                Button(action : {
                    
                    withAnimation{
                        
                        if let userId = userViewModel.user.id {
                            
                            viewModel.saveMapVersionToRemote(uid: userId)
                        }
                        else {
                            
                            viewModel.errorMessage = "You must sign in first"
                            viewModel.errorPresented = true
                        }
                        
                        
                    }
                    
                }){
               
                    Common.buttonView(imageSysteName: "checkmark")
                   
                }
              
                Spacer().frame(width:5)
                
            }
            
        }
    }
    
}

extension MapVersionNoteEntryView {
    
    private func dismissKeyboardButton() -> some View {
        
        HStack(spacing:5) {
       
            Button(action: {
                withAnimation {
                    
                    UIApplication.shared.endEditing()
                }
            }){
                
                Image(systemName: "arrowtriangle.down.circle.fill")
                .resizable()
                .frame(width:20, height: 20, alignment: .topLeading)
                .foregroundColor(.gray)
                
            }
            
            Spacer()
        }
        .opacity(textViewFocused ? 1 : 0)
    }
}


extension MapVersionNoteEntryView {
    
    
    private func saveSuccessfulView() -> some View {
        
        VStack {
            
            Spacer().frame(height:30)
            
            topBar(noSaveButton: true)
            
            Spacer().frame(height:50)
            
            Image(systemName: "checkmark.circle").resizable().frame(width:100, height: 100).foregroundColor(.green)
          
            Text("A new version has been saved successfully. You can view it on your map list")
            .font(.custom(Theme.fontName, size: 20))
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(3)
            
            Spacer()
        }
        .padding()
    }
}
