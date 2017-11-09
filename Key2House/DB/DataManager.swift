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
    private var filtermodules : FilterModule
    var allBagWozObjects = [BagWozModel]()
    var allMessages : [MessageInterface] = []
    
    
     init(filtermodule : FilterModule){
        self.filtermodules = filtermodule
        super.init()
        createBagWoz()
    }
    /*
    Burgemeester van Reenensingel 109
    2803 PA Gouda
    Netherlands
 */
     func createBagWoz(){
        let newBagWozobjects = [
        BagWozModel(_nr: 7, _streetname: "Antwerpseweg", _city: "Gouda", _pcNr: 2803, _pcCode: "PB", _building: Building.residence(w: 200, h: 200, d: 200), id: "test1", latestCheck: Date()),
        BagWozModel(_nr: 9, _streetname: "Antwerpseweg", _city: "Gouda", _pcNr: 2803, _pcCode: "PB", _building: Building.residence(w: 200, h: 200, d: 200), id: "test2", latestCheck: Date()),
        BagWozModel(_nr: 11, _streetname: "Gentseweg", _city: "Gouda", _pcNr: 2803, _pcCode: "PC", _building: Building.residence(w: 100, h: 200, d: 50), id: "test3", latestCheck: Date()),
        BagWozModel(_nr: 109, _streetname: "Burgemeester van Reenensingel", _city: "Gouda", _pcNr: 2803, _pcCode: "PA", _building: Building.residence(w: 100, h: 200, d: 50), id: "test4", latestCheck: Date()),
        BagWozModel(_nr: 3, _streetname: "Antwerpseweg", _city: "Gouda", _pcNr: 2803, _pcCode: "PB", _building: Building.residence(w: 200, h: 200, d: 200), id: "test5", latestCheck: Date())
        //BagWozModel(_nr: 4, _streetname: "Antwerpseweg", _city: "Gouda", _pcNr: 2803, _pcCode: "PB", _building: Building.residence(w: 200, h: 200, d: 200), id: "test3", latestCheck: Date()),
       // BagWozModel(_nr: 2, _streetname: "Antwerpseweg", _city: "Gouda", _pcNr: 2803, _pcCode: "PB", _building: Building.unknown("Onbekend"),id: "test4" , latestCheck: Date())
        ]
        
        
        //deelobjecten
        //7
        let obj1 = newBagWozobjects[0]
        obj1.deelobjecten.append(DeelObjectModel(id : "2" ,size: (10,10,10), constructionYr: "01-01-2014".toDateTime(), insertDate: Date(), tax: 0.0, descriptionObject: "Schuur", fraction: DeelObjectModel.Fraction.outerBuilding(k: 0, o: 0, u: 0, d: 0, v: 0)))
        obj1.deelobjecten.append(DeelObjectModel(id : "3" , size: (10,10,10), constructionYr: "01-01-2010".toDateTime(), insertDate: Date(), lastCheckDate: Date(), tax: 9000.0, descriptionObject: "Grond", fraction: DeelObjectModel.Fraction.land( k: 0, o: 0, u: 0, d: 0, v: 0)))
        obj1.deelobjecten.append(DeelObjectModel(id : "4" , size: (10,10,10), constructionYr: "01-01-2014".toDateTime(), insertDate: Date(), lastCheckDate: Date(), tax: 0.0, descriptionObject: "Berging", fraction: DeelObjectModel.Fraction.outerBuilding(k: 0, o: 0, u: 0, d: 0, v: 0)))
        //11
        let obj2 = newBagWozobjects[2]
        obj2.deelobjecten.append(DeelObjectModel(id : "5" , size: (10,10,10), constructionYr: "01-01-2014".toDateTime(), insertDate: Date(), tax: 0.0, descriptionObject: "Schuur", fraction: DeelObjectModel.Fraction.outerBuilding(k: 0, o: 0, u: 0, d: 0, v: 0)))
        //109
        let obj3 = newBagWozobjects[3]
        obj3.deelobjecten.append(DeelObjectModel(id : "6" , size: (10,10,10), constructionYr: "01-01-2014".toDateTime(), insertDate: Date(), tax: 0.0, descriptionObject: "Schuur", fraction: DeelObjectModel.Fraction.outerBuilding(k: 0, o: 0, u: 0, d: 0, v: 0)))
        
        let obj4 = newBagWozobjects[4]
        obj4.deelobjecten.append(DeelObjectModel(id : "7" , size: (10,10,10), constructionYr: "01-01-2014".toDateTime(), insertDate: Date(), lastCheckDate: Date(),tax: 200.0, descriptionObject: "Schuur", fraction: DeelObjectModel.Fraction.other(k: 0, o: 0, u: 0, d: 0, v: 0)))
        obj4.deelobjecten.append(DeelObjectModel(id : "1111" , size: (10,10,10), constructionYr: "01-01-2014".toDateTime(), insertDate: Date(), lastCheckDate: Date(),tax: 200.0, descriptionObject: "Schuur", fraction: DeelObjectModel.Fraction.other(k: 0, o: 0, u: 0, d: 0, v: 0)))
           obj4.deelobjecten.append(DeelObjectModel(id : "8" ,size: (10,10,10), constructionYr: "01-01-2014".toDateTime(), insertDate: Date(), lastCheckDate: Date(), tax: 9000.0, descriptionObject: "Perceel", fraction: DeelObjectModel.Fraction.land(k: 0, o: 0, u: 0, d: 0, v: 0)))
           obj4.deelobjecten.append(DeelObjectModel(id : "9" , size: (10,10,10), constructionYr: "01-01-2014".toDateTime(), insertDate: Date(), lastCheckDate: Date(), tax: 7000.0, descriptionObject: "Garage", fraction: DeelObjectModel.Fraction.outerBuilding(k: 0, o: 0, u: 0, d: 0, v: 0)))
        obj4.deelobjecten.append(DeelObjectModel(id : "10" ,size: (10,10,10), constructionYr: "01-01-2014".toDateTime(), insertDate: Date(), lastCheckDate: Date(), tax: 7000.0, descriptionObject: "HoofdWoning", fraction: DeelObjectModel.Fraction.mainResidence(k: 0, o: 0, u: 0, d: 0, v: 0)))
        obj4.deelobjecten.append(DeelObjectModel(id : "12000" ,size: (10,10,10), constructionYr: "01-01-2014".toDateTime(), insertDate: Date(), lastCheckDate: Date(), tax: 7000.0, descriptionObject: "HoofdWoning", fraction: DeelObjectModel.Fraction.mainResidence(k: 0, o: 0, u: 0, d: 0, v: 0)))
        
        let newMessages : [MessageInterface] = [
        PatentMessage(type: .PatentMessage(.In_progress()), insertDate: "01-01-2015".toDateTime(), objectId: "test1", messageId: "absc", image: #imageLiteral(resourceName: "Vergunnig"), patentTitle: "Tuin"),
        PatentMessage(type: .PatentMessage(.done()), insertDate: "01-01-2015".toDateTime(), objectId: "test2", messageId: "klik", image: #imageLiteral(resourceName: "Vergunnig"), patentTitle: "Bouwvergunning"),
        ObjectionMessage(type: .ObjectionMessage(.In_progress()), insertDate: "01-01-2014".toDateTime(), objectId: "test1", messageId: "bezwr131", image: #imageLiteral(resourceName: "Bezwaar"), objectionLetter: "note"),
        ObjectionMessage(type: .ObjectionMessage(.In_progress()), insertDate: "01-01-2014".toDateTime(), objectId: "test2", messageId: "bezwr1", image: #imageLiteral(resourceName: "Bezwaar"), objectionLetter: "note"),
        ObjectionMessage(type: .ObjectionMessage(.In_progress()), insertDate: "01-01-2014".toDateTime(), objectId: "test5", messageId: "bezwr444", image: #imageLiteral(resourceName: "Bezwaar"), objectionLetter: "note"),
        PatentMessage(type: .PatentMessage(.In_progress()), insertDate: "01-01-2015".toDateTime(), objectId: "test5", messageId: "dasd", image: #imageLiteral(resourceName: "Vergunnig"), patentTitle: "Bouwvergunning")

        ]
        
    self.allMessages  = newMessages
    self.allBagWozObjects = newBagWozobjects
    }
    

   private func getObjectsFromAddress(streetname : String) -> [BagWozModel]{
        return self.allBagWozObjects.filter({$0.address.streetname == streetname})
    }
    
   private func getMessages(object : BagWozModel) ->[MessageInterface]{
        return self.allMessages.filter({$0.objectId == object.id})
    }
    
func requestData(streetname : String) -> [BagWozModel]{
    let bagwozAntwerpseweg = self.getObjectsFromAddress(streetname: streetname)
    var objectsForSessie  = [BagWozModel]()

        
        for object in bagwozAntwerpseweg{
            var arrayMessages = [MessageInterface]()
            let objectMessages = self.getMessages(object: object)
                for filterFunction in self.filtermodules.currentFilters{
                    if(filterFunction.active!){
                        arrayMessages += filterFunction.useFunction(object: object, message: objectMessages)
                    }
                object.problemNotification = arrayMessages
            }
            if(object.problemNotification.count > 0){
                objectsForSessie.append(object)
            }
        }
        return objectsForSessie
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

