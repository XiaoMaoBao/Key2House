//
//  DataManager.swift
//  Key2House
//
//  Created by Xiao on 26/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    var currentBulk : [BagWozModel] = []
    
    var allBagWozObjects = [BagWozModel]()
    var allMessages = [MessageInterface]()
    
     func createBagWoz(){
        let newBagWozobjects = [
        BagWozModel(_nr: 8, _streetname: "Antwerpseweg", _city: "Gouda", _pcNr: 2803, _pcCode: "PB", _building: Building.residence(w: 200, h: 200, d: 200), id: "test1", latestCheck: Date()),
        BagWozModel(_nr: 7, _streetname: "Antwerpseweg", _city: "Gouda", _pcNr: 2803, _pcCode: "PB", _building: Building.residence(w: 100, h: 200, d: 50), id: "test2", latestCheck: Date()),
        //BagWozModel(_nr: 4, _streetname: "Antwerpseweg", _city: "Gouda", _pcNr: 2803, _pcCode: "PB", _building: Building.residence(w: 200, h: 200, d: 200), id: "test3", latestCheck: Date()),
       // BagWozModel(_nr: 2, _streetname: "Antwerpseweg", _city: "Gouda", _pcNr: 2803, _pcCode: "PB", _building: Building.unknown("Onbekend"),id: "test4" , latestCheck: Date())
        ]
        
        
        //deelobjecten
        let obj1 = newBagWozobjects[0]
        obj1.deelobjecten.append(DeelObjectModel(size: (10,10,10), constructionYr: "01-01-2014".toDateTime(), insertDate: Date(), checkDate: Date(), tax: 0.0, descriptionObject: "Schuur", fraction: DeelObjectModel.Fraction.outerBuilding(id: "deelobject1", k: 0, o: 0, u: 0, d: 0, v: 0)))
        obj1.deelobjecten.append(DeelObjectModel(size: (10,10,10), constructionYr: "01-01-2010".toDateTime(), insertDate: Date(), tax: 9000.0, descriptionObject: "Grond", fraction: DeelObjectModel.Fraction.land(id: "deelobject2", k: 0, o: 0, u: 0, d: 0, v: 0)))
        obj1.deelobjecten.append(DeelObjectModel(size: (10,10,10), constructionYr: "01-01-2014".toDateTime(), insertDate: Date(), tax: 0.0, descriptionObject: "Berging", fraction: DeelObjectModel.Fraction.outerBuilding(id: "deelobject3", k: 0, o: 0, u: 0, d: 0, v: 0)))
        
        let obj2 = newBagWozobjects[1]
        obj2.deelobjecten.append(DeelObjectModel(size: (10,10,10), constructionYr: "01-01-2014".toDateTime(), insertDate: Date(), checkDate: Date(), tax: 0.0, descriptionObject: "Schuur", fraction: DeelObjectModel.Fraction.outerBuilding(id: "deelobject4", k: 0, o: 0, u: 0, d: 0, v: 0)))
        
        let newMessages = [
        PatentMessage(type: .PatentMessage(.In_progress()), insertDate: "01-01-2015".toDateTime(), objectId: "test1", messageId: "", image: #imageLiteral(resourceName: "Vergunnig"), patentType: ""),
        PatentMessage(type: .PatentMessage(.done()), insertDate: "01-01-2015".toDateTime(), objectId: "test2", messageId: "", image: #imageLiteral(resourceName: "Vergunnig"), patentType: "")

        ]
        
    self.allMessages  = newMessages
    self.allBagWozObjects = newBagWozobjects
     
    }
    
    
    
    func getObjectsFromAddress(streetname : String){
        self.currentBulk = self.allBagWozObjects.filter({$0.address.streetname == streetname})
        //connect meldingen
        
    }
    
    func getMessages(object : BagWozModel) ->[MessageInterface]{
        return self.allMessages.filter({$0.objectId == object.id})
    }
    
    
}

extension String
{
    func toDateTime() -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
}

