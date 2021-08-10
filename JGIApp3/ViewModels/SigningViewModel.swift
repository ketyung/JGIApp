//
//  PdfContentViewModel.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 08/08/2021.
//

import PDFKit
import DocuSignSDK
import SwiftUI

typealias SVM = SigningViewModel


class SigningViewModel : ViewModel {
    
    // this type of data not needed for my work
    @Published private var content  = ContentForSigning()
    
    
    var siginingUserId : String {
        
        get {
            
            content.siginingUserId ?? ""
        }
        
        set(newVal) {
            
            content.siginingUserId = newVal
        }
    }
    
    
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
    
    
    var pdfPreview : Data? {
        
        
        get {
            
            content.pdfPreview
        }
        
        set(newVal) {
            
            content.pdfPreview = newVal
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
        pdfPreview = nil
        title = ""
        note = ""
        versionNo = 0
        mapId = ""
    }
}


extension SigningViewModel {
    
    
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

extension SigningViewModel {
    
    func registerForSigningCompletion(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(docuSignCompleted),
                                               name: NSNotification.Name.DSMSigningCompleted
                                               , object: nil)
      
    }
    
    
    @objc
    private func docuSignCompleted(){
        
        withAnimation{
            
            self.siginingCompleted = true
            self.addSignLogToRemote()
            
            
            NotificationCenter.default.removeObserver(self,
                                                      name: NSNotification.Name.DSMSigningCompleted,
                                                      object: nil)
        }
        
    }
        
    func preparePdfPreview( mapImage : UIImage?) {
        
        self.pdfPreview = PdfCreator().pdfData(title: title, body: note, version: "Version : \(versionNo)", mapImage: mapImage)
    }
    
    
    
    private func addSignLogToRemote(){
        
        var signers = [Signer]()
        
        recipients.forEach { r in
            
            var signer = Signer(uid : r.id)
            
            if self.siginingUserId == signer.uid {
                
                signer.signed = .signed
                signer.dateSigned = Date()
                
            }
            signers.append(signer)
        }
        
        let sl = SignLog(mapId: mapId, versionNo: versionNo, signers:  signers, templateId: templateId )
        
        ARH.shared.addSignLog(sl,returnType:SignLog.self, completion: {
            
            res in
            
            switch(res) {
            
                case .failure(let err) :
                    print("Error.adding.sign.log.to.remote::\(err)")
                
                case .success(_) :
                    return 
                
            
            }
            
        })
        
    }
}
