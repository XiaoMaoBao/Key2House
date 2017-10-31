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
    var heading = 0.0
    
    var countDataObject: Int = 0 {
        willSet {
            if self.delegateARSessie?.data.count == newValue  {
                self.delegateARSessie?.createArObject()
            }
        }
    }
    private var delegateARSessie : ARViewController?
     var userGeoLocation : CLLocation?

    init(delegateARSessie : ARViewController){
        self.delegateARSessie = delegateARSessie
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    
        
        locationManager.headingFilter = 5
        locationManager.startUpdatingHeading()
        
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
                    print(object.latAndLon.lat )
                    print(object.latAndLon.lon )
                    print("end")

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
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if (newHeading.headingAccuracy < 0){
        return
        }
        
        // Use the true heading if it is valid.
        let theHeading = ((newHeading.trueHeading > 0) ?
            newHeading.trueHeading : newHeading.magneticHeading)
        
        self.heading = theHeading;
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
            //self.delegateARSessie?.userAddress.text = placemarks.last?.thoroughfare
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
/*

extension CLLocationCoordinate2D{
    func coordinate(with bearing: Double, and distance: Double) -> CLLocationCoordinate2D {
        let distRadiansLat = distance / LocationConstants.metersPerRadianLat  // earth radius in meters latitude
        let distRadiansLong = distance / LocationConstants.metersPerRadianLon // earth radius in meters longitude
        let lat1 = self.latitude.toRadians()
        let lon1 = self.longitude.toRadians()
        let lat2 = asin(sin(lat1) * cos(distRadiansLat) + cos(lat1) * sin(distRadiansLat) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadiansLong) * cos(lat1), cos(distRadiansLong) - sin(lat1) * sin(lat2))
        return CLLocationCoordinate2D(latitude: lat2.toDegrees(), longitude: lon2.toDegrees())
    }
}

extension CLLocation {
    func bearingToLocationRadian(_ destinationLocation: CLLocation) -> Double {
        
        let lat1 = self.coordinate.latitude.toRadians()
        let lon1 = self.coordinate.longitude.toRadians()
        
        let lat2 = destinationLocation.coordinate.latitude.toRadians()
        let lon2 = destinationLocation.coordinate.longitude.toRadians()
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x)
        return radiansBearing
    }
    
    
    public func translatedLocation(with latitudeTranslation: Double, longitudeTranslation: Double, altitudeTranslation: Double) -> CLLocation {
        let latitudeCoordinate = self.coordinate.coordinate(with: 0, and: latitudeTranslation)
        let longitudeCoordinate = self.coordinate.coordinate(with: 90, and: longitudeTranslation)
        let coordinate = CLLocationCoordinate2D(
            latitude: latitudeCoordinate.latitude,
            longitude: longitudeCoordinate.longitude)
        let altitude = self.altitude + altitudeTranslation
        return CLLocation(coordinate: coordinate, altitude: altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.verticalAccuracy, timestamp: self.timestamp)
    }
    
    func translation(toLocation location: CLLocation) -> LocationTranslation {
        let inbetweenLocation = CLLocation(latitude: self.coordinate.latitude, longitude: location.coordinate.longitude)
        let distanceLatitude = location.distance(from: inbetweenLocation)
        let latitudeTranslation: Double
        if location.coordinate.latitude > inbetweenLocation.coordinate.latitude {
            latitudeTranslation = distanceLatitude
        } else {
            latitudeTranslation = 0 - distanceLatitude
        }
        let distanceLongitude = self.distance(from: inbetweenLocation)
        let longitudeTranslation: Double
        if self.coordinate.longitude > inbetweenLocation.coordinate.longitude {
            longitudeTranslation = 0 - distanceLongitude
        } else {
            longitudeTranslation = distanceLongitude
        }
        let altitudeTranslation = location.altitude - self.altitude
        return LocationTranslation(
            latitudeTranslation: latitudeTranslation,
            longitudeTranslation: longitudeTranslation,
            altitudeTranslation: altitudeTranslation)
    }
    
    static func bestLocationEstimate(locations: [CLLocation]) -> CLLocation {
        let sortedLocationEstimates = locations.sorted(by: {
            if $0.horizontalAccuracy == $1.horizontalAccuracy {
                return $0.timestamp > $1.timestamp
            }
            return $0.horizontalAccuracy < $1.horizontalAccuracy
        })
        return sortedLocationEstimates.first!
    }
    
    
    func calculateBearing(to coordinate: CLLocationCoordinate2D) -> Double {
       
        
        let x = cos(coordinate.latitude) * sin((coordinate.longitude - self.coordinate.longitude))
        let y = cos(self.coordinate.latitude)  * sin(coordinate.latitude) - sin(self.coordinate.latitude) * cos(coordinate.latitude) * cos((coordinate.longitude - self.coordinate.longitude))
        
        return atan2(x,y).toRadians()
    }
    
    
    func distanct(to coordiante : CLLocation) -> Double{

    
         let distanceInMeters = self.distance(from: coordiante)
        return distanceInMeters
   // coordinate₀.distance(from: coordinate₁)
    }
    
    func calculateDistance(to coordiante : CLLocationCoordinate2D) -> Double{
        let r = 6371e3
        
        let dLon = coordiante.longitude - self.coordinate.longitude
        let dLat = coordiante.latitude - self.coordinate.latitude
        
        let a = pow(sin(dLat/2),2) + cos(self.coordinate.latitude) * cos(coordiante.latitude) *  pow(sin(dLon / 2 ), 2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
       return (r * c)
    }
 
}
*/
