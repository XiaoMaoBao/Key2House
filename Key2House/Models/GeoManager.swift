//
//  GeoManager.swift
//  Key2House
//
//  Created by Xiao on 30/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit
import CoreLocation

class GeoLocationManager: NSObject, CLLocationManagerDelegate{
    private let locationManager :  CLLocationManager = CLLocationManager()

    
    var countDataObject: Int = 0 {
        willSet {
            if self.delegateARSessie?.data.count == newValue  {
                self.delegateARSessie?.doneLoadingData = true
                self.delegateARSessie?.hideLoadingScreen()
            }
        }
    }
    private var delegateARSessie : ARCameraSessieViewController?
    private var userGeoLocation : CLLocation?

    init(delegateARSessie : ARCameraSessieViewController){
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
                            // handle no location found
                            print("Error")
                            self.countDataObject = self.countDataObject + 1
                            return
                    }
                   // placemarks.last?.name
                    object.latAndLon = (location.coordinate.latitude, location.coordinate.longitude)
                    self.countDataObject = self.countDataObject + 1
                }
            }
        }
    }
    
    
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userGeoLocation = locations.last
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(self.userGeoLocation!, completionHandler: {
        
            (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                
                else {
                    // handle no location found
                    print("Error")
                    return
            }
            self.delegateARSessie?.userAddress.text = placemarks.last?.thoroughfare
            /*print(placemarks.last?.country)
            print(placemarks.last?.locality)
            print(placemarks.last?.subLocality)
            print(placemarks.last?.thoroughfare)
            print(placemarks.last?.postalCode)
            print(placemarks.last?.subThoroughfare)
             */

        })
        
    }
    
    
    
}
