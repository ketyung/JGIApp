//
//  MapFeatureHandlingViewModel.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 31/07/2021.
//

import Foundation
import ArcGIS
import SwiftUI

typealias MFHVM = MapFeatureHandlingViewModel


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
    
    func set( actionType : MFHVM.ActionType)
    
    func isAction( type : MFHVM.ActionType) -> Bool
    
    func removeLast()
    
}

class MapFeatureHandlingViewModel : ViewModel  {
    
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
    
    @Published var selectedColor: UIColor = .red
    
    @Published var mapTitle : String = ""
    
    @Published var mapDescription : String = ""
    
    @Published var mapTags : String = ""
    
    @Published var edited: Bool = false
    
    private(set) var mapVersion: MapVersion?
    
    @Published private var actionType : ActionType = .addPoint
    
    
    private lazy var agh = AGH()
    
    
    
}

extension MapFeatureHandlingViewModel {
    
    
    func save(){
        
    }
}

extension MapFeatureHandlingViewModel : MapActionHandler{
    
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


extension MapFeatureHandlingViewModel {
    
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
            
            mapIPoints.append( MapVersionIpoint(x: $0.x, y:  $0.y))
            
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
        let item = MapVersionItem(itemType: type, points: ipoints , color : selectedColor.hexString())
        mapVersion?.items?.append(item)

       // print("iPoints::\(ipoints.count)::type::\(type)")
    
    }
    
    
    func hasMapItems() -> Bool {
        
        return (mapVersion?.items?.count ?? 0) > 0
    }
    
    func removeAllMapItems(){
        
        mapVersion?.items?.removeAll()
        mapActionDelegate?.removeAll()
    }
    
}

extension MapFeatureHandlingViewModel {
    
    func addMapToRemote(uid : String, title : String, description : String){
        
        if let mapVersion = mapVersion, hasMapItems() {
       
            self.inProgress = true
            
            
            let map = UserMap(uid: uid, title: title, description: description, mapVersion: mapVersion)
           
            ARH.shared.addMap(map, returnType: UserMap.self , completion: {
                
                res in
                
                DispatchQueue.main.async {
              
                    switch(res) {
                        
                        case .failure(let err) :
                            
                            self.inProgress = false
                            self.errorMessage = (err as? ApiError)?.errorText
                            self.errorPresented = true
                    
                        case .success(let info) :
                            
                            if info.status == .ok {
                                
                                self.inProgress = false
                            }
                            else {
                                
                                self.inProgress = false
                                self.errorMessage = info.text
                                self.errorPresented = true
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
    
    
    func saveMapVersionToRemote() {
        
        
    }
    
}

