//
//  CameraSceneViewController.swift
//  Key2House
//
//  Created by Xiao on 22/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit
import MapKit
import os.log
class CameraSceneViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
   
    @IBOutlet weak var arCameraBtn: UIButton!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var mapOverView: MKMapView!
    let locationManager :  CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapOverView.delegate = self
        mapOverView.showsCompass = true
        mapOverView.showsScale = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    
       
        centerMapOnUserLocation(location: locationManager.location!)
    }

    @IBAction func CenterMapView(_ sender: Any) {
              centerMapOnUserLocation(location: locationManager.location!)
    }
    
    private func centerMapOnUserLocation(location : CLLocation){
       // let location = locationManager.location!
        let span :MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
        
        self.mapOverView.setRegion(region, animated: true)
        self.mapOverView.showsUserLocation = true
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        
    }


    
    override func viewDidAppear(_ animated: Bool) {
        let profile = ManagerSingleton.shared.defaulfProfile
        
        guard let p = profile else {
            self.titleNameLabel.text = "No profile"
            self.arCameraBtn.isEnabled = false
            return
        }
         self.arCameraBtn.isEnabled = true
            self.titleNameLabel.text = profile?.name!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ARScene":
            os_log("Adding new profile.", log: OSLog.default, type: .debug)
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "Nill")")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


