//
//  FrontMapView.swift
//  JDIApp
//
//  Created by Chee Ket Yung on 28/07/2021.
//

import SwiftUI
import ArcGIS

struct ArcGISMapView : UIViewRepresentable {
    
    var mapActionHandler : MapActionHandler? = nil
    
    private let mapView = AGSMapView()
    
    private let urlString = "https://services3.arcgis.com/WtFZIDPTjFVIWtIw/arcgis/rest/services/redlist_species_data_7b024e640fd848a2adf08e43737b5cb3/FeatureServer/0"
    
    private var featureTable : AGSServiceFeatureTable {
        
        let url = URL(string: urlString)!
        let table = AGSServiceFeatureTable(url: url)
       // print("table.hasAttachements::\(table.hasAttachments)")
        
        return table
        
    }
    
    private var featureLayer : AGSFeatureLayer  {
        
        let featureLayer = AGSFeatureLayer(featureTable: featureTable)
        
        return featureLayer
    }
    
    
    
    init(mapActionHandler : MapActionHandler? = nil) {
        
        self.mapActionHandler = mapActionHandler
        
        
        mapView.setViewpoint(
           AGSViewpoint(
               latitude: 6.6111,
               longitude: 20.9394,
               scale: 72_000
           )
       )
    }
    
    
    func makeUIView(context: Context) -> AGSMapView {


        
        let map = AGSMap(basemapType: .topographicVector,   latitude: 6.6111,
                         longitude: 20.9394, levelOfDetail: 4)

        mapView.map = map
      
        map.operationalLayers.add(featureLayer)
        
        
        mapView.touchDelegate = context.coordinator
        
        return mapView
    }

    
    
    func updateUIView(_ uiView: AGSMapView, context: Context) {
    
        /**
            do {
           
                let str = try uiView.map?.toJSON()
        
                print("map.json:\(String(describing: str))")
            }
            catch {
                
                print("err:\(error)")
            }
         */
    }
   
    
    
}

extension ArcGISMapView {
    
    
    func makeCoordinator() -> Coordinator {
        
        return Coordinator(self)
    }
    
    class Coordinator : NSObject {
            
        private var parent : ArcGISMapView
        
        init(_ parent : ArcGISMapView){
           
            self.parent = parent
            super.init()
            self.parent.mapActionHandler?.mapActionDelegate = self
        }
        
        
       
        
        private func identifyFeature(at screenPoint : CGPoint ){
            
            // identify features at tapped location
            
            parent.mapView.identifyLayer(parent.featureLayer, screenPoint: screenPoint, tolerance: 12, returnPopupsOnly: false) { result in
                
                print("result.geoElements.count::\(result.geoElements.count)")
                
                if let feature = result.geoElements.first as? AGSFeature {
                    // select the first feature
                    //self?.selectedPark = feature
                    print("selected.feature:: \(feature)")
                    
                }
            }
        }
        
    }
    
   
}



protocol MapActionDelegate : AnyObject {
    
    func addPoint(_ point : AGSPoint, color : UIColor?)
    
    func addLineAtPoints ( _ points : [AGSPoint] , color : UIColor?)
  
    func addPolygon ( _ points : [AGSPoint] , color : UIColor?)
  
    func addFeature(at point: AGSPoint)
    
    func removeAll()
    
    func removeLast()
    
    func loadFrom(mapVersion : MapVersion)
    
}

extension ArcGISMapView.Coordinator : AGSGeoViewTouchDelegate {
    
    
    private func actionRequiresDragGeature() -> Bool {
        
        return ( (parent.mapActionHandler?.isAction(type: .addLine) ?? false) ||
                 (parent.mapActionHandler?.isAction(type: .addLineStraight) ?? false ) ||
                 (parent.mapActionHandler?.isAction(type: .addPolygon) ?? false )
        )
    }
    
    
    func geoView(_ geoView: AGSGeoView, didTouchDownAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint, completion: @escaping (Bool) -> Void) {
        
        if actionRequiresDragGeature() {
  
            parent.mapActionHandler?.mapPoints.append( mapPoint )
           
            completion(true)
      
        }
        
        else {
            
            completion(false)
      
        }
    }
    
    
    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        
        
        //parent.mapActionHandler?.actionFor(.presentOptions )
        
        if parent.mapActionHandler?.isAction(type: .addPoint) ?? false {
        
            parent.mapActionHandler?.mapPoints.append( mapPoint )
           
            parent.mapActionHandler?.applyAction()
            
        }
        else
        if parent.mapActionHandler?.isAction(type: .addFeature) ?? false {
        
            parent.mapActionHandler?.mapPoints.append( mapPoint )
           
            parent.mapActionHandler?.applyAction()
            
        }
        else
        if parent.mapActionHandler?.isAction(type: .addLine) ?? false {
      
            parent.mapActionHandler?.mapPoints.append( mapPoint )
        }
        
        else
        if parent.mapActionHandler?.isAction(type: .addLineStraight) ?? false {
      
            parent.mapActionHandler?.mapPoints.append( mapPoint )
        }
        else
        if parent.mapActionHandler?.isAction(type: .addPolygon) ?? false {
      
            parent.mapActionHandler?.mapPoints.append( mapPoint )
        }
      
        self.setEdited()
       // identifyFeature(at: screenPoint)
    }
    
    
    
    func geoView(_ geoView: AGSGeoView, didTouchDragToScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        
        
        if parent.mapActionHandler?.isAction(type: .addLine) ?? false {
            
            parent.mapActionHandler?.mapPoints.append(mapPoint)
            return
        }
        
        
        if parent.mapActionHandler?.isAction(type: .addPolygon) ?? false {
            
            parent.mapActionHandler?.mapPoints.append(mapPoint)
            return
        }
        
    }
    
    
    func geoView(_ geoView: AGSGeoView, didTouchUpAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        
        if actionRequiresDragGeature()  {
            
            parent.mapActionHandler?.mapPoints.append(mapPoint)
        
            
            if (parent.mapActionHandler?.mapPoints.count ?? 0) > 1 {
          
               parent.mapActionHandler?.applyAction()
          
               self.setEdited()
            }
        
        }
        
    }
    
    
    func geoViewDidCancelTouchDrag(_ geoView: AGSGeoView) {
        
    }
    

    
}


extension ArcGISMapView.Coordinator : MapActionDelegate {
    
    func addLineAtPoints ( _ points : [AGSPoint], color : UIColor? = nil ){
        
        if parent.mapView.graphicsOverlays.count == 0 {
             
             let graphicsOverlay = AGSGraphicsOverlay()
             parent.mapView.graphicsOverlays.add(graphicsOverlay)
         }
        
        let pointSymbol = AGSSimpleMarkerSymbol(style: .circle, color: .orange, size: 10.0)

        pointSymbol.outline = AGSSimpleLineSymbol(style: .solid, color: .blue, width: 2.0)

        //let pointGraphic = AGSGraphic(geometry: points.first, symbol: pointSymbol)

        if let overlay = parent.mapView.graphicsOverlays.firstObject as? AGSGraphicsOverlay{
            
            
            let polyline = AGSPolyline(points: points)
         
            let polylineSymbol = AGSSimpleLineSymbol(style: .solid, color: color ?? .blue, width: 2.0)

            let polylineGraphic = AGSGraphic(geometry: polyline, symbol: polylineSymbol)
            
            overlay.graphics.add(polylineGraphic)
        }

      
        
    }
   
   func addPoint(_ point : AGSPoint, color: UIColor? = nil ){
   
  //  print("point.spatialReference::\(String(describing: point.spatialReference?.wkid))::\(point.x):\(point.y)")
    
        addPoint(point, color:  color, size: 20)
    
   }
    
    private func addPoint(_ point : AGSPoint, color: UIColor? = nil, size : CGFloat? = nil ){
        
       if parent.mapView.graphicsOverlays.count == 0 {
            
            let graphicsOverlay = AGSGraphicsOverlay()
            parent.mapView.graphicsOverlays.add(graphicsOverlay)

        }
    
        let pointSymbol = AGSSimpleMarkerSymbol(style: .circle, color: color ?? .orange, size: size ?? 20)

        pointSymbol.outline = AGSSimpleLineSymbol(style: .solid, color: .blue, width: 1.0)

        let pointGraphic = AGSGraphic(geometry: point, symbol: pointSymbol)

        //graphicsOverlay.graphics.add(pointGraphic)
        if let overlay = parent.mapView.graphicsOverlays.firstObject as? AGSGraphicsOverlay{
            
            overlay.graphics.add(pointGraphic)
        }
        
    }
    
    
    
    func addPolygon ( _ points : [AGSPoint] , color : UIColor?){
        
        if parent.mapView.graphicsOverlays.count == 0 {
             
             let graphicsOverlay = AGSGraphicsOverlay()
             parent.mapView.graphicsOverlays.add(graphicsOverlay)

        }
     

        if let overlay = parent.mapView.graphicsOverlays.firstObject as? AGSGraphicsOverlay{

            let polygon = AGSPolygon( points: points)

            let polygonSymbol = AGSSimpleFillSymbol(style: .solid,
            color: color ?? .orange, outline: AGSSimpleLineSymbol(style: .solid, color: .blue, width: 2.0))
            
            
            let polygonGraphic = AGSGraphic(geometry: polygon, symbol: polygonSymbol)
            
            overlay.graphics.add(polygonGraphic)
        }
       
    }
    
    
    func removeLast(){
        
        if let overlay = parent.mapView.graphicsOverlays.firstObject as? AGSGraphicsOverlay{
        
            overlay.graphics.removeLastObject()
            
            parent.mapActionHandler?.removeLast()
            
            self.setEdited()
        }
        
    }
    
    
    func removeAll() {
        
        if let overlay = parent.mapView.graphicsOverlays.firstObject as? AGSGraphicsOverlay{
        
            overlay.graphics.removeAllObjects()
            self.setEdited()
     
        }
    }
    
    
    func loadFrom(mapVersion : MapVersion) {
        
        let defaultColorStr = "#ff0000ff"
        
        mapVersion.items?.forEach{
            item in
            
            switch(item.itemType){
            
                case .point :
                
                    if let pt = item.points?.first {
                  
                        addPoint(AGSPoint(x: pt.latitute ?? 0 , y: pt.longitute ?? 0,
                        spatialReference: AGSSpatialReference(wkid: 3857))
                        , color: UIColor(hex:item.color ?? defaultColorStr))
                    
                    }
                  
                case .line :
                    if let points = item.points {
                   
                        addLineAtPoints(self.itemPointsToAGSPoints(points), color: UIColor(hex:item.color ?? defaultColorStr))
                    }
                    
                case .polygon :
                    if let points = item.points {
               
                        addPolygon(self.itemPointsToAGSPoints(points), color: UIColor(hex:item.color ?? defaultColorStr) )
                    }
           
                   
                default :
                    
                    return
            }
            
        }
    }
    
    
    private func itemPointsToAGSPoints (_ points : [MapVersionIpoint]) -> [AGSPoint] {
        
        var agsPoints = [AGSPoint]()
        points.forEach{ pt in
            
            agsPoints.append(AGSPoint(x: pt.latitute ?? 0 , y: pt.longitute ?? 0,
            spatialReference: AGSSpatialReference(wkid: 3857)))
        }
        
        return agsPoints
    }
    
    private func setEdited(){
        
        if let overlay = parent.mapView.graphicsOverlays.firstObject as? AGSGraphicsOverlay{
      
            withAnimation{
           
                parent.mapActionHandler?.edited = overlay.graphics.count > 0
            }
        }
       
    }
}



extension ArcGISMapView.Coordinator {
    
    
    func addFeature(at point: AGSPoint) {
           // disable interaction with map view
            parent.mapView.isUserInteractionEnabled = false

           // normalize geometry
           let normalizedGeometry = AGSGeometryEngine.normalizeCentralMeridian(of: point)!

           // attributes for the new feature
           let featureAttributes = ["typdamage": "Minor", "primcause": "Earthquake"]
           // create a new feature

           let feature =  parent.featureTable.createFeature(attributes: featureAttributes, geometry: normalizedGeometry)

    
           parent.mapActionHandler?.inProgress = true
        
         
           // add the feature to the feature table
           parent.featureTable.add(feature) { [weak self] error in
              
                
               if let error = error {
              
                    print("error.addFeature::\(error)")
                
                    self?.parent.mapActionHandler?.errorMessage = error.localizedDescription
                    self?.parent.mapActionHandler?.errorPresented = true
                    self?.parent.mapActionHandler?.inProgress = false
                
               }
               else {
                   // applied edits on success
                   self?.applyEdits()
               }
               // enable interaction with map view
         
               self?.parent.mapView.isUserInteractionEnabled = true
            
           }
    }
    
    
    private func applyEdits() {
           
           parent.featureTable.applyEdits { [weak self] res , error in
            
                guard let err = error else {
                
                    if let res = res?.first, res.completedWithErrors == false {
                        
                        print("Success!:\(res.objectID)")
                        self?.parent.mapActionHandler?.inProgress = false
                    
                    }
                    
                    return
                    
                }
            
                self?.parent.mapActionHandler?.errorMessage = err.localizedDescription
                self?.parent.mapActionHandler?.errorPresented = true
                self?.parent.mapActionHandler?.inProgress = false
        
           }
       }
}



/**
extension AGSMapView {
    
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("Touch.begin....")
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("Touch.end...x")
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesMoved(touches, with: event)
        print("Touch.move...x.")
    }
}
 */
