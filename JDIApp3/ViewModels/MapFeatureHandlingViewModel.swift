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

    var selectedColor : UIColor { get set }
    
    var inProgress : Bool { get set }
    
    var errorPresented : Bool { get set }
    
    var errorMessage : String? { get set }
    
    var edited : Bool { get set }
    
    func actionForSelectedType()
    
    func set( actionType : MFHVM.ActionType)
    
    func isAction( type : MFHVM.ActionType) -> Bool
    
}

class MapFeatureHandlingViewModel : ViewModel  {
    
    enum ActionType : Int {
        
        case presentOptions
        
        case addFeature
        
        case editFeature
        
        case addPoint
        
        case addLine
        
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
    

    
    func actionForSelectedType() {
        
        withAnimation{
   
            switch(self.actionType){
            
                case .presentOptions :
                
                    self.optionsPresented = true
                    
                case .addFeature :
                    
                    self.addFeature()
                    
                case .addPoint :
                    
                    self.addPoint()
            
                default :
                    return 
                
            }
        }
    }
}


extension MapFeatureHandlingViewModel {
    
    private func addPoint(){
        
        withAnimation{
            
            self.optionsPresented = false
        }
        
        if let point = mapPoints.first {
     
            mapActionDelegate?.addPoint(point, color: selectedColor)
        }
       
        
        mapPoints.removeAll()
        
       //q mapActionDelegate = nil 
        
    }
    
    
    private func addFeature() {
        
        withAnimation{
            
            self.optionsPresented = false
        }
        
        if let point = mapPoints.first {
            
            mapActionDelegate?.addFeature(at: point)
        }
        
        mapPoints.removeAll()
        
    }
}

