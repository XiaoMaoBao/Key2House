//
//  GeoManager.swift
//  Key2House
//
//  Created by Xiao on 30/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit
import CoreLocation
import GLKit
import SceneKit


class GeoLocationManager: NSObject, CLLocationManagerDelegate{
    private let locationManager :  CLLocationManager = CLLocationManager()
    
    var countDataObject: Int = 0 {
        didSet {
            if self.delegateARSessie?.data.count == (oldValue + 1)  {
                self.delegateARSessie?.createArObject()
                self.countDataObject = 0
            }
        }
    }
    
    private var delegateARSessie : ARViewController?
     var userGeoLocation : CLLocation?
    private var currentStreet : String = ""
    init(delegateARSessie : ARViewController){
        self.delegateARSessie = delegateARSessie
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func calculateGeoLocationFromData(){
        if let dataSet = self.delegateARSessie?.data{
            for object in dataSet{
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(object.convertAddressToString()) { (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let location = placemarks.first?.location
                        
                        else {
                            print("Error")
                            self.countDataObject = self.countDataObject + 1
                            return
                    }
                   // placemarks.last?.name
                    object.latAndLon = (location.coordinate.latitude, location.coordinate.longitude)
                    print(object.latAndLon.lat )
                    print(object.latAndLon.lon )
                    print("end")

                    self.countDataObject = self.countDataObject + 1
                }
            }
        }
    }
    
    /*
    var userLatAndLon : (lat : CLLocationDegrees, lon : CLLocationDegrees){
        get{
            if let coordinate = self.userGeoLocation?.coordinate{
                return (coordinate.latitude, coordinate.longitude)
            }
            return (0.0 , 0.0)
        }
        set{
            self.userGeoLocation = CLLocation(latitude: newValue.lat, longitude: newValue.lon)
        }
    }
    */
 
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userGeoLocation = locations.last
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(self.userGeoLocation!, completionHandler: {
        
            (placemarks, error) in
            guard
                let placemarks = placemarks
                else {
                    // handle no location found
                    print("Error")
                    return
            }
            
            if let street = placemarks.last?.thoroughfare{
                if(self.currentStreet != street){
                    self.currentStreet = street
                    ARViewController.displayView?.setTitleGeographicalLabel(self.currentStreet)
                  //  self.delegateARSessie?.geographicalLabel.text = self.currentStreet
                    self.delegateARSessie?.InitDataManager(streetname: self.currentStreet)
                }
            }
        })
    }
}
    
    
    

