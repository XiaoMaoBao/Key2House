//
//  FilterModule.swift
//  Key2House
//
//  Created by Xiao on 29/09/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit



enum Functions{
    case controleModel((BagWozModel) -> [MessageInterface])
    case patentCheck(([MessageInterface]) -> [MessageInterface])
    case objectionCheck(([MessageInterface]) -> [MessageInterface])
    case bagwozCoupling((BagWozModel) -> [MessageInterface])
}

class Module : NSObject{
    var active : Bool?
    var title: String?
    var icon : UIImage?
    var function : Functions?
    
    init(f :Functions, icon: UIImage, title: String, active : Bool) {
        self.function = f
        self.icon = icon
        self.title = title
        self.active = active
    }
   
    
    func useFunction(objectCheck : BagWozModel, message : [MessageInterface]) -> [MessageInterface]{
        if let f = function{
            switch f {
            case .controleModel(let functie):
                return functie(objectCheck)
            case .bagwozCoupling(let functie):
               return functie(objectCheck)
            case .patentCheck(let functie):
              return functie(message)
            case .objectionCheck(let functie):
                return functie(message)
            }
        }
        return [MessageInterface]()
    }
}

class FilterModule: NSObject {
   
    func controle_Behoefte_func(bagWoz : BagWozModel) -> [MessageInterface]{
        var newArrayMessage = [MessageInterface]()

        for object in bagWoz.deelobjecten{
            if(object.checkDate == nil){
                newArrayMessage.append(ControleMessage(deelobject: object, type: .ControleMessage(.registrated()), insertDate: Date(), objectId: "", messageId: "", image: #imageLiteral(resourceName: "Controle_Behoefte")))
            }
        }
        
        return newArrayMessage
    }
    
    func patent_func(messages : [MessageInterface]) -> [MessageInterface]{
        var newArrayMessage = [MessageInterface]()
        
        for m in messages{
            if case TypeMessage.PatentMessage(_)  = m.type{
                if case Status.done() = m.getStatus() {
                    print("is done")
                }else {
                    newArrayMessage.append(m)
                }
            }
        }
        return newArrayMessage
}
    
    
    
    func objection_func(messages : [MessageInterface]) -> [MessageInterface]{
        var newArrayMessage = [MessageInterface]()
        
        for m in messages{
            if case TypeMessage.ObjectionMessage(_)  = m.type{
                if case Status.done() = m.getStatus() {
                    print("is done")
                }else {
                    newArrayMessage.append(m)
                }
            }
        }
        return newArrayMessage
    }
    
    func couplingBagWoz_func(bagWoz : BagWozModel) -> [MessageInterface]{
        var newArrayMessage = [MessageInterface]()
        
        var bagError = false
        var wozError = false

        if case Building.unknown(_) = bagWoz.building{
            bagError = true
        }
        
        if(bagWoz.deelobjecten.count == 0){
            wozError = true
        }
        if(bagError == true || wozError == true){
            newArrayMessage.append(CoupelingMessage(type: .CouplingMessage(.registrated()), insertDate: Date(), objectId: "", messageId: "", image: #imageLiteral(resourceName: "BagWoz"), bagWoz: (bagError, wozError)))
        }
        
        return newArrayMessage

    }
    
    
    var currentFilters : [Module] = []
    
    override init() {
        super.init()
         setupTaxateur()
    }
    
    func setupTaxateur(){
        
        
        
        let m = Module(f: .controleModel(controle_Behoefte_func), icon: UIImage.init(named: "Controle_Behoefte")!, title: "Controle behoefte", active: true)
        let m1 = Module(f: .bagwozCoupling(couplingBagWoz_func), icon: UIImage.init(named: "BagWoz")!, title: "BagWoz koppeling", active: true)
        let m2 = Module(f: .patentCheck(patent_func), icon: UIImage.init(named: "Vergunnig")!, title: "Vergunning", active: true)
        let m3 = Module(f: .objectionCheck(objection_func), icon: UIImage.init(named: "Bezwaar")!, title: "Bezwaarschriften", active: true)

        currentFilters = [m, m1, m2, m3]
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

