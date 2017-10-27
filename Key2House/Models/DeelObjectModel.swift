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
        case mainResidence(id: String ,k : Int, o : Int, u : Int, d : Int,  v: Int)
        case land(id: String, k : Int, o : Int, u : Int, d : Int,  v: Int)
        case outerBuilding(id: String, k : Int, o : Int, u : Int, d : Int,  v: Int)
        case other(id: String, k : Int, o : Int, u : Int, d : Int,  v: Int)
    }
    
    private var fraction : Fraction
    
    var constructionYear : Date?
   
  //var id : String?
    var bagwozID : String?
    var checkDate : Date?
    var insertDate : Date?
    var descriptionObject: String?
   
    var tax : Double = 0.0
    var size = Size()
    
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
    
    init(size : (Double, Double, Double), constructionYr : Date, insertDate : Date, checkDate : Date? = nil, tax : Double, descriptionObject : String, fraction : Fraction) {
        self.size.width = size.0
        self.size.width = size.1
        self.size.width = size.2

        self.constructionYear = constructionYr
        self.insertDate = insertDate
        self.tax = tax
        self.checkDate = checkDate
        self.descriptionObject = descriptionObject
        self.fraction = fraction
    }
    
    func fractionDetails() -> (name : String, id : String, k: Int, o : Int, u : Int, d : Int, v : Int){
            switch self.fraction {
            case .land(_):
                return ("Grond", "0001" ,0,0,0,0,0)
            case .mainResidence(_):
                return ("Hoofdwoning", "0001" ,0,0,0,0,0)
            case .other(_):
                return ("Overige", "0001", 0,0,0,0,0)
            case .outerBuilding(_):
                return ("Bijgebouw", "0001" ,0,0,0,0,0)
            }
        }
}
   
    
    

