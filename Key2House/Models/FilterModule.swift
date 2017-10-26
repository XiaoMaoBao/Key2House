//
//  FilterModule.swift
//  Key2House
//
//  Created by Xiao on 29/09/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit



enum Functions{
    case controleModel((Date, Date) -> Bool)
    case vergunningBezwaarCheck((Status) -> Bool)
    case bagwozKoppeling((Building, [DeelObjectModel]) -> Bool)
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
   
    
    func useFunction(objectCheck : BagWozModel, deelobject : DeelObjectModel, message : MessageInterface) -> Bool{
        if let f = function{
            switch f {
            case .controleModel(let functie):
                return functie(objectCheck.latestCheck!, deelobject.checkDate!)
                
            case .vergunningBezwaarCheck(let functie):
                return functie(message.status)
                
            case .bagwozKoppeling(let functie):
                return functie(objectCheck.building, objectCheck.deelobjecten)
            }
        }
        return false
    }
    
}

class FilterModule: NSObject {
    func controle_Behoefte_func(bagwozCheck : Date, deelobjectCheck : Date?) -> Bool{
        guard deelobjectCheck != nil else {
            return true
        }

        let yearsToAdd = 5
        
        var dateComponent = DateComponents()
        dateComponent.year = yearsToAdd
        
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: bagwozCheck)
        
        if(futureDate! < bagwozCheck){
            return true
        }
        return false
    }
    
    func vergunningenBezwaar_func(status : Status) -> Bool{
        switch status {
        case .In_progress:
            return true
        case .done, .rated, .registrated, .taxed :
            return false
        }
    }
    
    
    
    func koppelingBagWoz_func(building : Building, deelobjecten : [DeelObjectModel]) -> Bool{
        
        switch building {
        case .unknown(_):
            return true
        case .appartment(_):
            break
        case .residence(_):
            break
        }
        if (deelobjecten.count == 0){
            return true
        }
        return false
    }
    
    
    var currentFilters : [Module] = []
    
    override init() {
        super.init()
         setupTaxateur()
    }
    
    func setupTaxateur(){
        
        
        
        let m = Module(f: .controleModel(controle_Behoefte_func), icon: UIImage.init(named: "Controle_Behoefte")!, title: "Controle behoefte", active: true)
        let m1 = Module(f: .bagwozKoppeling(koppelingBagWoz_func), icon: UIImage.init(named: "BagWoz")!, title: "BagWoz koppeling", active: true)
        let m2 = Module(f: .vergunningBezwaarCheck(vergunningenBezwaar_func), icon: UIImage.init(named: "Vergunnig")!, title: "Vergunning", active: true)
        let m3 = Module(f: .vergunningBezwaarCheck(vergunningenBezwaar_func), icon: UIImage.init(named: "Bezwaar")!, title: "Bezwaarschriften", active: true)

        //currentFilters = [m, m1, m2, m3]
    }
}


