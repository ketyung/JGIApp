//
//  ContentView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 28/07/2021.
//

import SwiftUI


typealias FMAP = FrontMapActionParam

struct FrontMapActionParam {
    
    enum Mode : Int {
        
        case edit
        
        case create
        
        case viewOnly
        
        case sign
    }
    
    var mode : Mode = .create
    
    var mapId : String?
    
    var versionNo : Int?
   
    static let defaultValue = FMAP(mode: .create, mapId: nil, versionNo: nil)
  
    
}

struct FrontMapView: View {
    
    @EnvironmentObject private var signingViewModel : SVM
    
    @EnvironmentObject private var viewModel : MAHVM
   
    @EnvironmentObject private var legendViewModel : MLIVM
   
    @EnvironmentObject private var userViewModel : UserViewModel
    
    static let colorHexes : [String] = ["#ffffffff", "#888888ff", "#000000ff", "#ff0000ff", "#ffaa22ff",
                "#ffff00ff", "#00ff00ff", "#0000ffff", "#0088ffff",  "#ff00ffff"]
   
    @State private var promptHasItems : Bool = false
    
    static var colors : [UIColor] = {
        
        FrontMapView.colorHexes.map {
            UIColor(hex:$0)!
        }
    }()
    
   
    @State private var showTopToolbar : Bool = true
    
    @Binding private var viewType : FMM.ViewType
    
    @Binding private var actionParam : FMAP
    
    @State private var showMapVersionNote : Bool = false
    
    @State private var showMapVersionNoteEntry : Bool = false
    
    
    init( viewType : Binding <FMM.ViewType>, actionParam : Binding <FMAP>) {
        
        self._viewType = viewType
        self._actionParam = actionParam
    }
    
    
    
    var body: some View {
      
        switchView()
    }
}

extension FrontMapView {
    
    @ViewBuilder
    private func switchView() -> some View {
        
        if (viewModel.saveSheetPresented) {
            
            infoView()
            .transition(.move(edge: .leading))
          
        }
        else {
            
            mapView()
            .transition(.move(edge: .trailing))
            .onAppear{
            
                loadMap()
            }
            
        }
    }
    
    
    
    @ViewBuilder
    private func infoView() -> some View {
        
        if actionParam.mode == .edit {
            
            MapVersionNoteEntryView(viewType: $viewType)
        }
        else {
            
            MapInfoEntryView(viewType: $viewType)
        }
    }
    
    
    private func loadMap() {
        
        switch(actionParam.mode) {
        
            case .edit :
            
                viewModel.loadFromRemote(mapId: actionParam.mapId ?? "",
                versionNo: actionParam.versionNo ?? 100,
                 completion: {
                    
                    succ in
                    
                    legendViewModel.items = []
                    
                    if succ {
                
                        if let items = viewModel.mapVersion?.legendItems, items.count > 0 {
                            
                            legendViewModel.items = items
                        }
                        
                    }
                 })
         
            case .viewOnly :
            
                viewModel.loadFromRemote(mapId: actionParam.mapId ?? "", versionNo: actionParam.versionNo ?? 100,
                 completion: {
                    
                    succ in
                    
                    
                    legendViewModel.items = []
                    
                    if succ {
                
                        if let items = viewModel.mapVersion?.legendItems, items.count > 0 {
                            
                            legendViewModel.items = items
                        }
                        
                    }
                 })
         
            case .create :
                
                viewModel.loadFromSavedItemsIfAny()
            
            case .sign :
            
                viewModel.loadFromRemote(mapId: actionParam.mapId ?? "", versionNo: actionParam.versionNo ?? 100)
     
            
        }
    }
    
    
    private func mapView() -> some View {
        
        VStack{
            
            ArcGISMapView(mapActionHandler: viewModel)
            
        }
        .themeFullView()
        .progressView(isShowing: $viewModel.inProgress)
        .popOver(isPresented: $viewModel.errorPresented, content: {
            
            Common.errorAlertView(message: viewModel.errorMessage ?? "Error")
        })
        .popOverAt(.topRight, isPresented: $showTopToolbar, content: {
            
            topMenuBar()
        })
        .popOverAt( .mapLegendPosition , isPresented: $viewModel.legendViewPresented, content: {
            
            MapLegendItemsView(isPresented: $viewModel.legendViewPresented).frame(width: 300)
        })
        
        .bottomSheet(isPresented: $viewModel.optionsPresented, height: 450, showGrayOverlay: true,
                     topBarBackgroundColor: Theme.commonBgColor ,
                     content:{
            
            optionsSheetView()
        })
        .bottomSheet(isPresented: $showMapVersionNote, height: UIScreen.main.bounds.height - 200, showGrayOverlay: true,
                     topBarBackgroundColor: Theme.commonBgColor ,content: {
            
            
            MapVersionNotesView(isPresented: $showMapVersionNote,
                                isNoteEntryPresented: $showMapVersionNoteEntry,
                                notes: viewModel.mapVersion?.notes)
           
        })
        
        .bottomSheet(isPresented: $viewModel.legendEditingViewPresented, height: UIScreen.main.bounds.height - 200, showGrayOverlay: true, content: {
            
            MapLegendEditView(isPresented: $viewModel.legendEditingViewPresented)
        })
        
        .sheet(isPresented: $showMapVersionNoteEntry, content: {
       
            MapVersionNoteEntryView(viewType: $viewType)
            
        })
        .alert(isPresented: $promptHasItems){
            
            Alert(title: Text("Your map has unsaved items, do you want to quit now?".localized), primaryButton: .default(Text("Yes".localized)) {
                    
                    withAnimation{
                        
                        viewModel.removeAllMapItems()
                        self.viewType = .menu
                    }
                    
            },secondaryButton: .cancel())
            
        }
    }
}


extension FrontMapView {
    
    private func topMenuBar() -> some View {
        
        HStack(spacing: 20) {
            
           
            Spacer().frame(width: 20)
            
            Button(action : {
                
                withAnimation{
                  
                    close()
                }
                
            }){
                
                Common.buttonView("close", imageColorInvert: true)
                
            }
            
            if (viewModel.mapVersion?.notes?.count ?? 0) > 0 {
                
                Button(action : {
                    
                    withAnimation{
                        
                        showMapVersionNote = true
                    }
                    
                }){
                    
                    Common.buttonView(imageSysteName: "message")
               
                }
            }
           
            if actionParam.mode != .viewOnly {
        
                Spacer().frame(width : UIScreen.main.bounds.width - (Common.isIPad() ? 600 : 330))
                
                if actionParam.mode != .sign {
                
                    toolButtons()
                  
                }
                else {
                    
                    signButton()
                }
                
                
                Spacer().frame(width:5)
            
            }
            else {
                
                Spacer()
            }
           
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width + 50, height: 40)
        .offset(x : -50)
    }
    
    
    
    private func close() {
        
        
        if actionParam.mode == .viewOnly {
            
            viewType = .menu
            return
        }
        
        
        if viewModel.hasMapItems() {
            
            promptHasItems = true
        }
        else {

            viewType = .menu
        }
    }
    
    
    private func toolButtons() -> some View {
        
        HStack(spacing: 20) {
            
            
            Button(action : {
                
                withAnimation{
                    
                    viewModel.mapActionDelegate?.removeLast()
                }
                
            }){
                
                Common.buttonView("undo", imageColorInvert: true)
           
            }
            .opacity(viewModel.edited ? 1 : 0)
            .disabled(!viewModel.edited)
            
            
            
            Button(action : {
                
                withAnimation{
                    
                    viewModel.legendViewPresented.toggle()
                }
                
            }){
                
                Common.buttonView(imageSysteName: "list.triangle")
           
            }
            .opacity(!viewModel.legendViewPresented ? 1 : 0.35)
            .disabled(viewModel.legendViewPresented)
            
            Button(action : {
                
                withAnimation{
                    
                    viewModel.optionsPresented = true
                }
                
            }){
                
                Common.buttonView(imageSysteName: "gear")
           
            }
           
            Button(action : {
                
                withAnimation{
                    
                    viewModel.saveSheetPresented = true
                }
                
            }){
           
                Common.buttonView(imageSysteName: "checkmark.circle")
            }
            .opacity(viewModel.edited ? 1 : 0.35)
            .disabled(!viewModel.edited)
        }
    }
    
    
    private func signButton() -> some View {
        
        Button(action : {
            
            withAnimation{
                
                signButtonAction()
            }
            
        }){
       
            Common.buttonView(imageSysteName: "signature")
        }
        
    }
    
    
    private func signButtonAction(){
        
        if signingViewModel.firstSigner {
            
            preparePdfPreview()
        }
        else {
            
            
            signingViewModel.prepareForNonFirstSigner(title:
                (viewModel.mapVersion?.notes?.first?.title ?? viewModel.titleText)
                , note:(viewModel.mapVersion?.notes?.first?.note ?? viewModel.descriptionText)
                , mapId: viewModel.mapVersion?.id ?? "", versionNo: viewModel.mapVersion?.versionNo ?? 100,
              completion: { success in
              
                if success {
                    
                    withAnimation{
                        
                        viewType = .docuSignSignIn
                    }
                }
            })

        }
    }
    
    
    
    private func preparePdfPreview(){
        
        viewModel.inProgress = true
        
        signingViewModel.signingUserId = userViewModel.id
        
        
        if let title = viewModel.mapVersion?.notes?.first?.title {
            
            signingViewModel.title = title
        }
        else {
            
            signingViewModel.title = viewModel.titleText
        }
        
        if let note = viewModel.mapVersion?.notes?.first?.note {
            
            signingViewModel.note = note
        }
        else {
            
            signingViewModel.note = viewModel.descriptionText
        }
        
        
        
        if let mapId = viewModel.mapVersion?.id {
            
            signingViewModel.mapId = mapId
        }
        
        
        if let version = viewModel.mapVersion?.versionNo {
            
            signingViewModel.versionNo = version
        }
        
        viewModel.mapActionDelegate?.exportImage(completion: { image in
            
            
            signingViewModel.preparePdfPreview(mapImage:  image)
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
        
                viewModel.inProgress = false
            
                viewType = .pdfPreview
            
            })
        
        })
        
        
        
    }
    
}


extension FrontMapView {
    
    private func optionsSheetView() -> some View {
        
        ScrollView(.vertical, showsIndicators: false){
            
            VStack {
        
                
                colorsScrollView()
              
                addPointButton()
                
                addLineButton()
                
                addLineStraightButton()
                
                addPolygonButton()
                
                addFeatureButton()
            
            }
            
           
        }
        .background(Color(UIColor(hex:"#ddeeffff")!))
    }
    
    
    private func addPointButton() -> some View {
        
        Button(action : {
            
            viewModel.set(actionType: .addPoint)
            
        }) {
       
            HStack(spacing:20) {
                
                
                ZStack {
                    
                    Circle().fill(Color.black).frame(width: 30, height: 30)
                    Circle().fill(Color(viewModel.selectedColor)).frame(width: 24, height: 24)
                   
                }
                
                
                Text("Add Point".localized).font(.custom(Theme.fontName, size: 16))
          
                
                Spacer()
                
                if viewModel.isAction(type: .addPoint) {
              
                    Image(systemName: "checkmark.circle").resizable().frame(width: 24, height: 24).foregroundColor(.green)
                  
                    Spacer().frame(width: 10)
                }
              
            }.padding()
            .background(Color(UIColor(hex:"#eeeeffff")!))
        }
       
    }
    
    
    private func addLineButton() -> some View {
        
        Button(action : {
            
            viewModel.set(actionType: .addLine)
            
        }) {
       
            HStack(spacing:20) {
                
                
                ZStack {
                    
                    Rectangle().fill(Color.black).frame(width: 30, height: 30)
                    
                    Image("line").resizable().frame(width: 24, height: 24).colorInvert()
                    
                }
                
                
                Text("\("Draw Line (Freehand)".localized) ").font(.custom(Theme.fontName, size: 16))
          
                
                Spacer()
              
                if viewModel.isAction(type: .addLine) {
              
                    Image(systemName: "checkmark.circle").resizable().frame(width: 24, height: 24).foregroundColor(.green)
                  
                    Spacer().frame(width: 10)
                }
                
            }.padding()
            .background(Color(UIColor(hex:"#eeeeffff")!))
        }
       
    }
    
    
    private func addLineStraightButton() -> some View {
        
        Button(action : {
            
            viewModel.set(actionType: .addLineStraight)
            
        }) {
       
            HStack(spacing:20) {
                
                
                ZStack {
                    
                    Rectangle().fill(Color.black).frame(width: 30, height: 30)
                    
                    Image("line").resizable().frame(width: 24, height: 24).colorInvert()
                    
                }
                
                
                Text("\("Draw Line (Straight)".localized) ").font(.custom(Theme.fontName, size: 16))
          
                
                Spacer()
              
                if viewModel.isAction(type: .addLineStraight) {
              
                    Image(systemName: "checkmark.circle").resizable().frame(width: 24, height: 24).foregroundColor(.green)
                  
                    Spacer().frame(width: 10)
                }
                
            }.padding()
            .background(Color(UIColor(hex:"#eeeeffff")!))
        }
       
    }
    
    private func addPolygonButton() -> some View {
        
        Button(action : {
            
            viewModel.set(actionType: .addPolygon)
            
        }) {
       
            HStack(spacing:20) {
                
                
                ZStack {
                    
                    Rectangle().fill(Color.black).frame(width: 30, height: 30)
                    
                    Image("polygon").resizable().frame(width: 24, height: 24).colorInvert()
                    
                }
                
                
                Text("Draw Polygon".localized).font(.custom(Theme.fontName, size: 15))
          
                
                Spacer()
                
                if viewModel.isAction(type: .addPolygon) {
              
                    Image(systemName: "checkmark.circle").resizable().frame(width: 24, height: 24).foregroundColor(.green)
                  
                    Spacer().frame(width: 10)
                }
                
              
            }.padding()
            .background(Color(UIColor(hex:"#eeeeffff")!))
        }
       
    }
    
    
    private func addFeatureButton() -> some View {
        
        Button(action : {
            
            viewModel.set(actionType: .addFeature)
           
            
        }) {
       
            HStack(spacing:20) {
                
                
                ZStack {
                    
                    Circle().fill(Color.black).frame(width: 30, height: 30)
                    Circle().fill(Color(viewModel.selectedColor)).frame(width: 24, height: 24)
                   
                }
                
                
                Text("Add Feature".localized).font(.custom(Theme.fontName, size: 16))
          
                
                Spacer()
                
                if viewModel.isAction(type: .addFeature) {
              
                    Image(systemName: "checkmark.circle").resizable().frame(width: 24, height: 24).foregroundColor(.green)
                  
                    Spacer().frame(width: 10)
                }
              
            }.padding()
            .background(Color(UIColor(hex:"#eeeeffff")!))
        
        }
       
    }
    
    
    

}




extension FrontMapView {
    
    @ViewBuilder
    private func colorsScrollView(actionType : MAHVM.ActionType = .addPoint) -> some View {
        
        
        
        ScrollView(.horizontal, showsIndicators: false ) {
            
            HStack {
                
                ForEach( FrontMapView.colors, id:\.self) {
                    
                    color in
                    
                    ZStack {
                    
                        
                        if viewModel.selectedColor == color {
                            
                            Circle().fill(Color(UIColor(hex:"#009900ff")!))
                            .frame(width: 30, height: 30)
                        }
                        
                        
                        Circle().fill(Color(color)).frame(width: 24, height: 24)
                        
                        
                    }
                    .onTapGesture {
                    
                        withAnimation{
                  
                            viewModel.selectedColor = color
                            
                            viewModel.applyAction()
                       
                      
                        }
                    }
                   
                   
                }
                
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 100 ,height: 40)
        }
        .padding()
        .background(Color(UIColor(hex:"#ddddddff")!))
        .frame(width: UIScreen.main.bounds.width - 40 ,height: 40)
        .cornerRadius(10)
        .border(Color.black, width: 1, cornerRadius: 10)
       
    }
}
