//
//  MapActionHandlingViewModel.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 31/07/2021.
//

import Foundation
import ArcGIS
import SwiftUI

typealias MAHVM = MapActionHandlingViewModel


protocol MapActionHandler {
    
    var mapActionDelegate : MapActionDelegate? { get set }
    
    var mapPoints : [AGSPoint] { get set }
    
    var mapVersion : MapVersion? { get }

    var selectedColor : UIColor { get set }
    
    var inProgress : Bool { get set }
    
    var errorPresented : Bool { get set }
    
    var errorMessage : String? { get set }
    
    var edited : Bool { get set }
    
    func applyAction()
    
    func set( actionType : MAHVM.ActionType)
    
    func isAction( type : MAHVM.ActionType) -> Bool
    
    func removeLast()
    
}

class MapActionHandlingViewModel : ViewModel  {
    
    enum ActionType : Int {
        
        case presentOptions
        
        case addFeature
        
        case editFeature
        
        case addPoint
        
        case addLine
        
        case addLineStraight
        
        case addPolygon
        
        case none
    }
    
    
    var mapPoints : [AGSPoint] = []
    
    weak var mapActionDelegate: MapActionDelegate?
  
    @Published var saveSheetPresented : Bool = false
  
    @Published var optionsPresented : Bool = false
    
    @Published var mapSuccessfullySavedToRemote : Bool = false
    
    @Published var selectedColor: UIColor = .red
    
    @Published var titleText : String = ""
    
    @Published var descriptionText : String = ""
    
   // @Published var mapTags : String = "" // not needed will be deleted in the future
    
    @Published var edited: Bool = false
    
    private(set) var mapVersion: MapVersion?
    
    @Published private var actionType : ActionType = .addPoint
    
    
    func resetAllNeccessary() {
        
        mapSuccessfullySavedToRemote = false
        titleText = ""
        descriptionText = ""
        saveSheetPresented = false
        optionsPresented = false
        removeAllMapItems()
        mapActionDelegate = nil
    
    }
    
}


extension MapActionHandlingViewModel : MapActionHandler{
    
    func set(actionType: ActionType) {
   
        withAnimation{
            
            
            self.actionType = actionType
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
              
                withAnimation{
              
                    self.optionsPresented = false
                  
                }
               
            })
            
        }
    }
    
    
    func isAction(type: ActionType) -> Bool {
        
        return self.actionType == type 
    }
    

    
    func applyAction() {
        
        withAnimation{
   
            switch(self.actionType){
            
                case .presentOptions :
                
                    self.optionsPresented = true
                    
                case .addFeature :
                    self.addFeature()
                    
                case .addPoint :
                    self.addPoint()
                    
                case .addLine :
                    self.addLine()
                    
                case .addLineStraight :
                    self.addLine()
            
                case .addPolygon :
                    self.addPolygon()

            
                default :
                    return 
                
            }
        }
    }
    
    
    
    func removeLast() {
        
        mapVersion?.items?.removeLast()
    }
    
}


extension MapActionHandlingViewModel {
    
    private func addPoint(){
                
        if let point = mapPoints.first {
     
            mapActionDelegate?.addPoint(point, color: selectedColor)
        }
       
        addItemType(type: .point)

        mapPoints.removeAll()
    }
    
    
    private func addFeature() {
        
        if let point = mapPoints.first {
            
            mapActionDelegate?.addFeature(at: point)
        }
        
        mapPoints.removeAll()
        
    }
    
    
    private func addLine() {
        
        mapActionDelegate?.addLineAtPoints(mapPoints, color: selectedColor)
        
        addItemType(type: .line)
        
        mapPoints.removeAll()
        
    }
    
    
    private func addPolygon() {
        
        mapActionDelegate?.addPolygon(mapPoints, color: selectedColor)
        
        addItemType(type: .polygon)
        
        mapPoints.removeAll()
        
    }
    
    
    private func convertMapPointsToIPoints() -> [MapVersionIpoint] {
        
        var mapIPoints = [MapVersionIpoint]()
        mapPoints.forEach{
            
           // print("x:\($0.x):y:\($0.y)")
            mapIPoints.append( MapVersionIpoint(x: $0.x, y:  $0.y, wkid: $0.spatialReference?.wkid))
            
        }
        
        return mapIPoints
    }
    
    
    private func addItemType(type : MapVersionItem.ItemType){
        
        
        if mapVersion == nil{

            mapVersion = MapVersion()
        }
            
        if mapVersion?.items == nil {
            
            mapVersion?.items = []
        }
        
        let ipoints = self.convertMapPointsToIPoints()
        if ipoints.count > 0 {
      
            let item = MapVersionItem(itemType: type, points: ipoints , color : selectedColor.hexString())
            mapVersion?.items?.append(item)

        }
      
       // print("iPoints::\(ipoints.count)::type::\(type)")
    
    }
    
    
    func hasMapItems() -> Bool {
        
        return (mapVersion?.items?.count ?? 0) > 0
    }
    
    func removeAllMapItems(){
        
        mapVersion?.items?.removeAll()
        mapActionDelegate?.removeAll()
    }
    
    
    func loadFromSavedItemsIfAny() {
        
        if let mapVersion = mapVersion, hasMapItems() {
  
            mapActionDelegate?.loadFrom(mapVersion: mapVersion)
        }
    }
    
}

extension MapActionHandlingViewModel {
    
    func addMapToRemote(uid : String){
        
        if titleText.count == 0 {
            
            self.errorMessage = "Please enter a title for this map".localized
            self.errorPresented = true
            return 
        }
        
        if var mapVersion = mapVersion, hasMapItems() {
       
            self.inProgress = true
            
            mapVersion.levelOfDetail = 3
            
            let map = UserMap(uid: uid, title: titleText, description: descriptionText, mapVersion: mapVersion)
           
            ARH.shared.addMap(map, returnType: UserMap.self , completion: { [weak self] res in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
              
                    withAnimation{
                        
                        switch(res) {
                            
                            case .failure(let err) :
                                
                                self.inProgress = false
                                self.errorMessage = (err as? ApiError)?.errorText
                                self.errorPresented = true
                        
                            case .success(let info) :
                                
                                if info.status == .ok {
                                    
                                    self.inProgress = false
                                    self.mapSuccessfullySavedToRemote = true 
                                }
                                else {
                                    
                                    self.inProgress = false
                                    self.errorMessage = info.text
                                    self.errorPresented = true
                                }
                            
                            
                        }
                    }
                }
              
            })
            
            
        }
        else {
            
            withAnimation{
                
                self.errorMessage = "Empty Map!".localized
                self.errorPresented = true
            }
        }
        
        
    }
    
    
    func saveMapVersionToRemote(uid : String) {
        
        
        if titleText.count == 0 {
            
            self.errorMessage = "Please enter a title for this version note".localized
            self.errorPresented = true
            return
        }
        
        self.inProgress = true
        
        if var mapVersion = mapVersion, let _ = mapVersion.id {
            
            let versionNote = MapVersionNote( title: titleText, note: descriptionText)
            mapVersion.note = versionNote
            
            
            ARH.shared.addMapVersion(mapVersion, returnType:MapVersion.self , completion: {
                [weak self] res in
                
                DispatchQueue.main.async {
               
                    switch (res) {
                    
                        case .failure(let err) :
                        
                            self?.errorMessage = (err as? ApiError)?.errorText
                            self?.errorPresented = true
                            self?.inProgress = false
                            
                        case .success(let info) :
                            if info.status == .ok {
                                
                                self?.inProgress = false
                                self?.mapSuccessfullySavedToRemote = true
                            }
                            else {
                                
                                self?.inProgress = false
                                self?.errorMessage = info.text
                                self?.errorPresented = true
                            }
                        
                    }
                }
               
            })
            
        }
        else {
            
            withAnimation{
                
                self.errorMessage = "Invalid Map Version!".localized
                self.errorPresented = true
            }
        }
    }
    
}


extension MapActionHandlingViewModel {
    
    func loadFromRemote( mapId : String, versionNo : Int){
        
        self.inProgress = true
        
        ARH.shared.fetchMapVersion(id: mapId, versionNo: versionNo, completion:  {
            
            [weak self] res in
            
            DispatchQueue.main.async {
             
                switch(res) {
                
                    case .failure(let err) :
                        self?.inProgress = false
                        self?.errorMessage = (err as? ApiError)?.errorText
                        self?.errorPresented = true
                    
                     //   print("err.loading...::\(err)")
                    case .success(let mapVersion) :
                        self?.mapVersion = mapVersion
                        self?.inProgress = false
                        if let mapVersion = self?.mapVersion {
                  
                            self?.mapActionDelegate?.loadFrom(mapVersion: mapVersion)
                        }
                    
                
                }
            }
            
        })
    }
}
