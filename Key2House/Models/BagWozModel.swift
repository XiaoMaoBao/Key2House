//
//  BagObject.swift
//  Key2House
//
//  Created by Xiao on 23/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit
import CoreLocation


//type building
public enum Building{
    case appartment(elevator : Bool)
    case residence(w : Double, h : Double, d : Double)
    case unknown(String)
}


class BagWozModel: NSObject {
    
    private var nr : Int
    private var streetname : String
    private var city : String
    private var pcNr : Int
    private var pcCode : String
    
    var building : Building = Building.unknown("Error")
    var deelobjecten : [DeelObjectModel] = []
    var problemNotification : [MessageInterface] = []
     var geolocation : CLLocation?

    var id : String?

    var locality : Int?
    var latestCheck: Date?

    
    var wozWaarde : Double{
        get{
            return deelobjecten.reduce(0.0, {$0 + $1.tax})
        }
    }
    

    func perceelSize() -> Double {
        switch self.building {
        case .residence(let size):
            return size.w * size.h * size.d
        case .appartment( _):
             return 0
        case .unknown( _):
             return 0
        }
    }
   
    var address: (nr : Int, streetname : String, city : String, pc : (nr : Int, code : String)){
        get{
            return (self.nr, self.streetname, self.city, (self.pcNr, self.pcCode))
        }set{
            self.nr = newValue.nr
            self.streetname = newValue.streetname
            self.city = newValue.city
            self.pcCode = newValue.pc.code
            self.pcNr = newValue.pc.nr
        }
    }
    
    
    var latAndLon : (lat : CLLocationDegrees, lon : CLLocationDegrees){
        get{
            if let coordinate = self.geolocation?.coordinate{
                   return (coordinate.latitude, coordinate.longitude)
            }
            return (0.0 , 0.0)
        }
        set{
            self.geolocation = CLLocation(latitude: newValue.lat, longitude: newValue.lon)
        }
    }
    
    init( _nr : Int , _streetname : String, _city : String, _pcNr : Int,  _pcCode : String, _building : Building, id : String, latestCheck : Date){
        self.id = id
        self.building = _building
        self.nr = _nr
        self.streetname = _streetname
        self.city = _city
        self.pcNr = _pcNr
        self.pcCode = _pcCode
        self.latestCheck = latestCheck
        super.init()
        
    }
    
    
  
    
    func convertAddressToString() -> String{
        //let address = "1 Infinite Loop, Cupertino, CA 95014"
        let address = self.address
        return "\(address.nr) " + address.streetname + " " +  address.city + " \(address.pc.nr) " + address.pc.code
    }
}


