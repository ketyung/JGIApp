//
//  PdfContentViewModel.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 08/08/2021.
//

import PDFKit


typealias PCVM = PdfContentViewModel

class PdfContentViewModel : ViewModel {
    
    // this type of data not needed for my work
    @Published var title = "Map Title"
    
    @Published var body = "Map Description"
    
    @Published var version = "Version 100"
    
    @Published var image : UIImage?
   
    
}


extension PdfContentViewModel {
    
    func clear(){
        
        self.image = nil
        self.title = ""
        self.body = ""
    }
}

extension PdfContentViewModel {
    
    func pdfData() -> Data? {
        
        // here create the data by adding an chartImage shared from other view by ketyung@techchee.com
        return PdfCreator().pdfData(title: self.title, body: self.body, version: version, mapImage: self.image)
    }
    
}
