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
    
    var featureTable : AGSServiceFeatureTable? { get set }
    
    var mapView : AGSMapView? { get set }
    
    var mapActionDelegate : MapActionDelegate? { get set }
    
    var mapPoints : [AGSPoint] { get set }

    var selectedColor : UIColor { get set }
    
    var inProgress : Bool { get set }
    
    var errorPresented : Bool { get set }
    
    var errorMessage : String? { get set }
    
    var edited : Bool { get set }
    
    func actionFor(_ type : MFHVM.ActionType, featureTable : AGSServiceFeatureTable?)
    
}

class MapFeatureHandlingViewModel : ViewModel  {
    
    enum ActionType : Int {
        
        case presentOptions
        
        case addFeatures
        
        case editFeatures
        
        case addPoint
        
        case addLine
        
        case addPolygon
        
        case none
    }
    
    var featureTable : AGSServiceFeatureTable?
    
    var mapPoints : [AGSPoint] = []
    
    var mapView: AGSMapView?
    
    weak var mapActionDelegate: MapActionDelegate?
  
    @Published var saveSheetPresented : Bool = false
  
    @Published var optionsPresented : Bool = false
    
    @Published var selectedColor: UIColor = .red
    
    @Published var mapTitle : String = ""
    
    @Published var mapDescription : String = ""
    
    @Published var mapTags : String = ""
    
    @Published var edited: Bool = false 
    
    private var actionType : ActionType = .none
    
    private lazy var agh = AGH()
    
}

extension MapFeatureHandlingViewModel {
    
    
    func save(){
        
    }
}

extension MapFeatureHandlingViewModel : MapActionHandler{
    

    
    func actionFor(_ type: ActionType, featureTable : AGSServiceFeatureTable? = nil ) {
        
        withAnimation{
   
            self.actionType = type
            self.featureTable = featureTable
       
            switch(self.actionType){
            
                case .presentOptions :
                
                    self.optionsPresented = true
                    
                case .addFeatures :
                    
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

