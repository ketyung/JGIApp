//
//  MapInfoEntryView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 02/08/2021.
//

import SwiftUI


struct MapInfoEntryView : View {
    
    @EnvironmentObject private var viewModel : MAHVM
   
    @EnvironmentObject private var userViewModel : UserViewModel
   
    @State private var textViewFocused : Bool = false
    
    @Binding var viewType : FrontMenuView.ViewType
   
    
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

extension MapInfoEntryView {
    
    
    private func view() -> some View {
        
        
        VStack(spacing:20){
            
            Spacer().frame(height:30)
            
            topBar()
          
            Spacer().frame(height:50)
          
            Common.textFieldWithUnderLine("Title".localized, text: $viewModel.mapTitle)
           
            /**
            VStack(alignment: .leading, spacing:5) {
           
                Common.textFieldWithUnderLine("Tags".localized, text: $viewModel.mapTags)
                
                Text("Separate tags by space".localized).font(.custom(Theme.fontName, size: 15)).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
             */
            
            VStack(alignment: .leading, spacing:5) {
           
                Text("\("Description".localized) :").font(.custom(Theme.fontNameBold, size: 20)).foregroundColor(.gray)
          
                TextView(text: $viewModel.mapDescription, isFirstResponder: $textViewFocused)
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
          
            Text("Map Info").font(.custom(Theme.fontNameBold, size: 20)).foregroundColor(.black)
            
            Spacer()
          
            if !noSaveButton {
            
                Button(action : {
                    
                    withAnimation{
                        
                        if let userId = userViewModel.user.id {
                            
                      
                            viewModel.addMapToRemote(uid: userId)
                           
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

extension MapInfoEntryView {
    
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


extension MapInfoEntryView {
    
    
    private func saveSuccessfulView() -> some View {
        
        VStack {
            
            Spacer().frame(height:30)
            
            topBar(noSaveButton: true)
            
            Spacer().frame(height:50)
            
            Image(systemName: "checkmark.circle").resizable().frame(width:100, height: 100).foregroundColor(.green)
          
            Text("Your map has been saved successfully. You can view it on your map list")
            .font(.custom(Theme.fontName, size: 20))
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(3)
            
            Spacer()
        }
        .padding()
    }
}
