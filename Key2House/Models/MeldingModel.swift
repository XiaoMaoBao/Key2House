//
//  MeldingModel.swift
//  Key2House
//
//  Created by Xiao on 24/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit

enum Status{
    case registrated
    case In_progress
    case taxed
    case rated
    case done
}


protocol MessageInterface
{
    var status : Status{set get}
    var insertDate : Date{get set}
    var messageId : String{set get}
    var messageImage : UIImage{get set}
    var objectId : String{set get}
    var title : String{set get}
    
    func messageText() -> (title : String, content : String)
    func changeStatus(status : Status)
    
}

class ControleMessage : MessageInterface{
    
    private let deelobject : DeelObjectModel
    var messageImage: UIImage
    
    
    var status : Status
    var insertDate : Date
    var messageId : String
    var title: String
    var objectId : String
    
    func changeStatus(status: Status) {
        self.status = status
    }
    
    func messageText() -> (title: String, content: String) {
        return (self.title, deelobject.descriptionObject!)
    }
    
    
    
    init(deelobject : DeelObjectModel, status : Status, insertDate : Date, objectId : String, messageId : String, image : UIImage){
        self.status = status
        self.insertDate = insertDate
        self.messageId = messageId
        self.objectId = objectId
        self.messageImage = image
        self.title = "Controle Behoefte"
        self.deelobject = deelobject
    }
}

class PatentMessage : MessageInterface{
    
    private let typePatent : String?
    
    var messageImage: UIImage
    
    
    var status : Status
    var insertDate : Date
    var messageId : String
    var title: String
    
    var objectId : String
    
    func changeStatus(status: Status) {
        self.status = status
    }
    
    func messageText() -> (title: String, content: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let v = self.objectId + " | " + self.typePatent! + " | " + dateFormatter.string(from: self.insertDate)
        return (self.title,v)
    }
    
    
    
    init(status : Status, insertDate : Date, objectId : String, messageId : String, image : UIImage, patentType : String){
        self.status = status
        self.insertDate = insertDate
        self.messageId = messageId
        self.objectId = objectId
        self.messageImage = image
        self.title = "Vergunningen"
        
        self.typePatent = patentType
    }
}



class ObjectionMessage : MessageInterface{
    
    var objectionLetter : String?
    
    
    
    var messageImage: UIImage
    var status : Status
    var insertDate : Date
    var messageId : String
    var title: String
    var objectId : String
    
    func changeStatus(status: Status) {
        self.status = status
    }
    
    func messageText() -> (title: String, content: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let v = self.objectId + " | " + dateFormatter.string(from: self.insertDate)
        return (self.title,v)
    }
    
    
    
    init(status : Status, insertDate : Date, objectId : String, messageId : String, image : UIImage, objectionLetter : String){
        self.status = status
        self.insertDate = insertDate
        self.messageId = messageId
        self.objectId = objectId
        self.messageImage = image
        self.title = "Bezwaarschrift"
        
        self.objectionLetter = objectionLetter
    }
}



class CoupelingMessage : MessageInterface{
    
    
    private var bagEmpty : Bool?
    private var wozEmpty : Bool?
    
    
    var messageImage: UIImage
    var status : Status
    var insertDate : Date
    var messageId : String
    var title: String
    var objectId : String
    
    func changeStatus(status: Status) {
        self.status = status
    }
    
    func messageText() -> (title: String, content: String) {
        
        let b = self.bagEmpty! ? "bag" : ""
        let w = self.wozEmpty! ? "woz" : ""
        let v = b + " " + w + "  onbekend"
        
        
        return (self.title,v)
    }
    
    
    
    init(status : Status, insertDate : Date, objectId : String, messageId : String, image : UIImage, bagWoz : (Bool, Bool)){
        self.status = status
        self.insertDate = insertDate
        self.messageId = messageId
        self.objectId = objectId
        self.messageImage = image
        self.title = "BAG_WOZ koppeling"
        
        self.bagEmpty = bagWoz.0
        self.wozEmpty = bagWoz.1
    }
}

