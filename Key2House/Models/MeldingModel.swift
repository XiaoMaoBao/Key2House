//
//  MeldingModel.swift
//  Key2House
//
//  Created by Xiao on 24/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit


enum TypeMessage{
    case ControleMessage(Status)
    case PatentMessage(Status)
    case CouplingMessage(Status)
    case ObjectionMessage(Status)
}

enum Status{
    case registrated()
    case In_progress()
    case taxed()
    case rated()
    case done()
}





protocol MessageInterface
{

    var type : TypeMessage{set get}
    var insertDate : Date{get set}
    var messageId : String{set get}
    var objectId : String{set get}
    var title : String{set get}
    var messageImage: UIImage{set get}
    func messageText() -> (title : String, content : String)
    func changeStatus(status : Status)
    func getStatus()->Status
    
}

class ControleMessage : MessageInterface{
    func getStatus() -> Status {
        if case  TypeMessage.ControleMessage(let x) = self.type {
            return x
        }
        return Status.done()
    }
    
    
    
    private let deelobject : DeelObjectModel
    var messageImage: UIImage
    
    
    var type : TypeMessage
    var insertDate : Date
    var messageId : String
    var title: String
    var objectId : String
    
    func changeStatus(status: Status) {
       self.type = .ControleMessage(status)
    }
    
    func messageText() -> (title: String, content: String) {
        return (self.title, deelobject.descriptionObject!)
    }
    
    
    
    
    init(deelobject : DeelObjectModel, type : TypeMessage, insertDate : Date, objectId : String, messageId : String, image : UIImage){
        self.type = type
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
    
    var type: TypeMessage
    var insertDate : Date
    var messageId : String
    var title: String
    var objectId : String
    
    func changeStatus(status: Status) {
        self.type = .PatentMessage(status)
    }
    
    func messageText() -> (title: String, content: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let v = self.objectId + " | " + self.typePatent! + " | " + dateFormatter.string(from: self.insertDate)
        return (self.title,v)
    }
    
    func getStatus() -> Status {
        if case  TypeMessage.PatentMessage(let x) = self.type {
            return x
        }
        return Status.done()
    }
    
    
    init(type : TypeMessage, insertDate : Date, objectId : String, messageId : String, image : UIImage, patentType : String){
        self.insertDate = insertDate
        self.messageId = messageId
        self.objectId = objectId
        self.messageImage = image
        self.title = "Vergunningen"
        self.type = type
        self.typePatent = patentType
        
    }
}



class ObjectionMessage : MessageInterface{
    var type: TypeMessage
    
    
    var objectionLetter : String?

    var messageImage: UIImage
    var insertDate : Date
    var messageId : String
    var title: String
    var objectId : String
    
    func changeStatus(status: Status) {
        self.type = .ObjectionMessage(status)
    }
    
    func messageText() -> (title: String, content: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let v = self.objectId + " | " + dateFormatter.string(from: self.insertDate)
        return (self.title,v)
    }
    
    
    
    init(type : TypeMessage, insertDate : Date, objectId : String, messageId : String, image : UIImage, objectionLetter : String){
        self.insertDate = insertDate
        self.messageId = messageId
        self.objectId = objectId
        self.messageImage = image
        self.type = type
        self.title = "Bezwaarschrift"
        
        self.objectionLetter = objectionLetter
    }
    
    
    func getStatus() -> Status {
        if case  TypeMessage.ObjectionMessage(let x) = self.type {
            return x
        }
        return Status.done()
    }
}



class CoupelingMessage : MessageInterface{
    var type: TypeMessage
    
    private var bagEmpty : Bool?
    private var wozEmpty : Bool?
    
    
    var messageImage: UIImage
    var insertDate : Date
    var messageId : String
    var title: String
    var objectId : String
    
    func changeStatus(status: Status) {
        self.type = .CouplingMessage(status)

    }
    
    func messageText() -> (title: String, content: String) {
        
        let b = self.bagEmpty! ? "bag" : ""
        let w = self.wozEmpty! ? "woz" : ""
        let v = b + " " + w + "  onbekend"
        
        
        return (self.title,v)
    }
    
    func getStatus() -> Status {
        if case  TypeMessage.CouplingMessage(let x) = self.type {
            return x
        }
        return Status.done()
    }
    
    init(type : TypeMessage, insertDate : Date, objectId : String, messageId : String, image : UIImage, bagWoz : (Bool, Bool)){
        self.insertDate = insertDate
        self.messageId = messageId
        self.objectId = objectId
        self.messageImage = image
        self.title = "BAG_WOZ koppeling"
        self.type = type
        self.bagEmpty = bagWoz.0
        self.wozEmpty = bagWoz.1
    }
}

