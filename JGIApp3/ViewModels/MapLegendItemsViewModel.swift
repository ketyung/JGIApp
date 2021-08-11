//
//  MapLegendItemsViewModel.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 10/08/2021.
//

import Foundation

typealias MLIVM = MapLegendItemsViewModel

class MapLegendItemsViewModel : ViewModel {
    
    @Published var items = [MapLegendItem]()
    
    @Published var title : String = ""
    
    func addItem (_ item : MapLegendItem){
        
        items.append(item)
    }
    
    
    func setColor(for itemAtIndex : Int, color : String) {
        
        if var item = items[safe: itemAtIndex] {
            item.color = color
            items[itemAtIndex] = item
        }
    }
    
}

