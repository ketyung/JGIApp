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
    
    
    var versionNo : Int {
        
        get {
            
            content.versionNo ?? 0
        }
        
        set(newVal) {
            
            content.versionNo = newVal
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
    
    
    
    func reset()
    {
        siginingCompleted = false
        templateId = ""
        recipients = []
        attachment = nil
        title = ""
        note = ""
        versionNo = 0
        mapId = ""
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
        
        self.attachment = PdfCreator().pdfData(title: title, body: note, version: "Version : \(versionNo)", mapImage: mapImage)
    }
    
    
    
    func addSignersToRemote(currentUser : User){
        
        var signers = [Signer]()
        
        recipients.forEach { r in
            
            var signer = Signer(id : r.id)
            
            if currentUser.id == signer.id {
                
                signer.signed = .signed
                signer.dateSigned = Date()
            }
            signers.append(signer)
        }
        
        let sg = SignerGroup(mapId: mapId, versionNo: versionNo, signers:  signers )
        
        ARH.shared.addSignerGroup(sg,returnType:SignerGroup.self, completion: {
            
            res in
            
            switch(res) {
            
                case .failure(let err) :
                    print("Error.adding.signers.to.remote::\(err)")
                
                case .success(_) :
                    return 
                
            
            }
            
        })
        
    }
}
