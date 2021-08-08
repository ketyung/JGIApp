//
//  PdfCreator.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 08/08/2021.
//
import PDFKit

class PdfCreator : NSObject {
   
    private  var pageRect : CGRect
    
    private var renderer : UIGraphicsPDFRenderer?

    
    /**
     W: 8.5 inches * 72 DPI = 612 points
     H: 11 inches * 72 DPI = 792 points
     A4 = [W x H] 595 x 842 points
     */
    init(pageRect : CGRect = CGRect(x: 0, y: 0, width: (8.5 * 72.0), height: (11 * 72.0))) {
       
        let format = UIGraphicsPDFRendererFormat()
        let metaData = [
            kCGPDFContextTitle: "It's a PDF of the JDI Map!",
            kCGPDFContextAuthor: "TechChee"
          ]
        format.documentInfo = metaData as [String: Any]
        
        self.pageRect = pageRect
        self.renderer = UIGraphicsPDFRenderer(bounds: self.pageRect,
                                             format: format)
        super.init()
    }
    
    deinit {
        
        self.renderer = nil
    }
   
}

extension PdfCreator {
    
    private func addTitle ( title  : String ){
        
        let textRect = CGRect(x: 20, y: 20, // top margin
                              width: pageRect.width - 40 ,height: 40)

        title.draw(in: textRect, withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)])
      
    }
    
    private func addBody (body : String) {
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor : UIColor.gray
        ]
        
        let bodyRect = CGRect(x: 20, y: 120,
                              width: pageRect.width - 40 ,height: pageRect.height - 80)
        body.draw(in: bodyRect, withAttributes: attributes)
    }
    
    
    private func addVersion ( version  : String ){
        
        let textRect = CGRect(x: 20, y: 70, // top margin
                              width: pageRect.width - 40 ,height: 40)

        version.draw(in: textRect, withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)])
      
    }
    
    private func addMapImage(_ image : UIImage?) {
        
        if let image = image {
            
            let width = pageRect.width * 0.95 // we just use 0.9 of the width of the page width as the chart width
            let height = width * (image.size.height / image.size.width) // calculate the height
            
            let x = (pageRect.width - width) / 2
            let y = (pageRect.height - height) / 2
            let rect = CGRect(x: x, y: y, width: width, height:  height)
            image.draw(in: rect)//,  attributes)
        }
    }
    
   
}

extension PdfCreator {
    
    func pdfData( title : String, body: String, version : String,  mapImage : UIImage? ) -> Data? {
        
        if let renderer = self.renderer {
       
            let data = renderer.pdfData  { ctx in
                
                
                if let image = mapImage {
                    
                    ctx.beginPage()
                   
                    addMapImage(image)
                
                    addWaterMarkAtBottom()
                }
               
                
                ctx.beginPage()
                
                addTitle(title: title)
                
                addVersion(version: version)
                
                addBody(body: body)
                
                addWaterMarkAtBottom()
                
               
            }
            
            return data

        }
        
        return nil
    }
}


extension PdfCreator {
    
    func addWaterMarkAtBottom(){
     
        if let logo = UIImage(named: "techchee_logo") {
   
            let attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor : UIColor.lightGray
            ]
            
            let logoAt = CGRect(x: pageRect.size.width - (logo.size.width + 10), y: pageRect.height - (logo.size.height + 10),
                                width: logo.size.width, height: logo.size.height)
            
            
            let textAt = CGRect (x: logoAt.origin.x - 102, y : logoAt.origin.y + 2, width:100, height: 30 )
            
            let text  = "Created By "
            
            text.draw(in : textAt, withAttributes : attributes)
           
            logo.draw(in: logoAt)
          
        }
    }
    
    
    
}
