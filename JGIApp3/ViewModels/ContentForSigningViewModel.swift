//
//  PdfContentViewModel.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 08/08/2021.
//

import PDFKit


typealias CFSVM = ContentForSigningViewModel


class ContentForSigningViewModel : ViewModel {
    
    // this type of data not needed for my work
    @Published private var content  = ContentForSigning()
    
    
    var mapId : String {
        
        get {
            
            content.mapId ?? ""
        }
        
        set(newVal) {
            
            content.mapId = newVal
        }
    }
    
    
    var version : String {
        
        get {
            
            content.version ?? ""
            
        }
        
        set(newVal) {
            
            content.version = newVal
        }
    }
    
    
    var title : String {
        
        get {
            
            content.title ?? ""
        }
        
        set(newVal) {
            
            content.title = newVal
        }
    }
    
    
    var note : String {
        
        get {
            
            content.note ?? ""
        }
        
        set(newVal) {
            
            content.note = newVal
        }
    }
    
    
    var attachment : Data? {
        
        
        get {
            
            content.attachment
        }
        
        set(newVal) {
            
            content.attachment = newVal
        }
        
    }
    
    
    var recipients : [ContentForSigning.Recipient] {
        
        get {
            
            content.recipients ?? []
        }
        
        set(newVal) {
            
            content.recipients = newVal
        }
    }
    
    
    var templateId : String {
        
        get {
            
            content.templateId ?? ""
        }
    
        set(newVal) {
            
            content.templateId = newVal
        }
    }
    
    var siginingCompleted : Bool {
        
        get {
            
            content.signingCompleted
        }
        
        set(newVal) {
            
            content.signingCompleted = true 
        }
    }
    
    
}


extension ContentForSigningViewModel {
    
    
    func inRecipients(id : String) -> Bool {
        
        let recipient = Recipient(id : id)
        return recipients.contains(recipient)
    }
    
    func addRecipient(_ recipient : Recipient, removeIfExists : Bool = true ) {
        
        if removeIfExists {
            
            if recipients.contains(recipient) {
                
                recipients.remove(object: recipient)
            }
            else {
                
                recipients.append(recipient)
            }
        }
        else {
            
            if !recipients.contains(recipient) {
                
                recipients.append(recipient)
          
            }
        }
        
    }
}

extension ContentForSigningViewModel {
        
    func generateAttachment( mapImage : UIImage?) {
        
        self.attachment = PdfCreator().pdfData(title: title, body: note, version: version, mapImage: mapImage)
    }
}
