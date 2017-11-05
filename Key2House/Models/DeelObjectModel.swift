//
//  HouseObjectModel.swift
//  Key2House
//
//  Created by Xiao on 29/09/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit

class DeelObjectModel: NSObject {
   
    struct Notes {
        var title = "", descriptionTxt = ""
    }
    
    struct Size{
        var width = 0.0, height = 0.0, depth = 0.0
    }
    
    enum Fraction {
        case mainResidence( k : Int, o : Int, u : Int, d : Int,  v: Int)
        case land(k : Int, o : Int, u : Int, d : Int,  v: Int)
        case outerBuilding( k : Int, o : Int, u : Int, d : Int,  v: Int)
        case other( k : Int, o : Int, u : Int, d : Int,  v: Int)
    }
    
    private var fraction : Fraction
    
    var constructionYear : Date?
   
    var id : String?
    //var bagwozID : String?
    var lastCheckDate : Date?
    var insertDate : Date?
    var descriptionObject: String?
    var tax : Double = 0.0
    private var size = Size()
    
    var notes = [Notes]()
    var pictures : [UIImage] = []
    
    var surface : Double{
        get{
            return  size.width * size.height
        }
    }
    
    var volume : Double{
        get{
            return  size.width * size.height * size.depth
        }
    }
    
    func setSize(size : (Double, Double, Double)){
        self.size = Size(width: size.0, height: size.1, depth: size.2)
    }
    
    init(size : (Double, Double, Double), constructionYr : Date, insertDate : Date, lastCheckDate : Date? = nil, tax : Double, descriptionObject : String, fraction : Fraction) {
        self.size.width = size.0
        self.size.width = size.1
        self.size.width = size.2

        self.constructionYear = constructionYr
        self.insertDate = insertDate
        self.tax = tax
        self.lastCheckDate = lastCheckDate
        self.descriptionObject = descriptionObject
        self.fraction = fraction
    }
    
    
    func getHouseValues() -> (Int, Int, Int , Int, Int){
        switch self.fraction {
        case .land(let k , let o, let u, let d, let v):
            return (k,o,u,d,v)
        case .mainResidence(let k, let o, let u, let d, let v):
            return (k,o,u,d,v)
        case .outerBuilding(let k, let o, let u, let d, let v):
            return (k,o,u,d,v)
        case .other(let k, let o, let u, let d, let v):
            return (k,o,u,d,v)
        }
    }
    
    func fractionDetails() -> (name : String, k: Int, o : Int, u : Int, d : Int, v : Int){
            switch self.fraction {
            case .land(let k, let o, let u, let d, let v):
                return ("Grond", k, o, u, d, v)
            case .mainResidence(let k, let o, let u, let d, let v):
                return ("Hoofdwoning",k, o, u, d, v)
            case .other(let k, let o, let u, let d, let v):
                return ("Overige",k, o, u, d, v)
            case .outerBuilding(let k, let o, let u, let d, let v):
                return ("Bijgebouw",k, o, u, d, v)
            }
        }
}
   
    

extension DeelObjectModel{
    
}

