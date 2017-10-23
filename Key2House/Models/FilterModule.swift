//
//  FilterModule.swift
//  Key2House
//
//  Created by Xiao on 29/09/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit



enum functions{
    case binryNumbers((Double, Double) -> Bool)
}

class Module : NSObject{
    var active : Bool?
    var title: String?
    var icon : UIImage?
    var function : functions?
    
    init(f :functions, icon: UIImage, title: String, active : Bool) {
        self.function = f
        self.icon = icon
        self.title = title
        self.active = active
    }
    
    func useFunction(d : Double){
        if let f = function{
            switch f {
            case .binryNumbers(let functie):
               let b =  functie(d,d)
                print(b)
            }
        }
    }
    
    
}

class FilterModule: NSObject {
    func equalCheck(first : Double, second : Double)-> Bool{
        return  first == second
    }

    var currentFilters : [Module] = []
    
    
    override init() {
        super.init()
         setupTaxateur()
    }
    
    func setupTaxateur(){
        let m = Module(f: .binryNumbers(equalCheck), icon: UIImage.init(named: "Controle_Behoefte")!, title: "Controle behoefte", active: true)
        let m1 = Module(f: .binryNumbers(equalCheck), icon: UIImage.init(named: "BagWoz")!, title: "BagWoz koppeling", active: true)
        let m2 = Module(f: .binryNumbers(equalCheck), icon: UIImage.init(named: "Vergunnig")!, title: "Vergunning", active: true)
        let m3 = Module(f: .binryNumbers(equalCheck), icon: UIImage.init(named: "Bezwaar")!, title: "Bezwaarschriften", active: true)

        currentFilters += [m, m1, m2, m3]
    }
}


