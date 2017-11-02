//
//  ARViewController.swift
//  Key2House
//
//  Created by Xiao on 31/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit
import CoreLocation
import ARKit

class ARViewController: UIViewController {
    
    static var displayView : ARDisplayView?
    var sceneLocationView = SceneLocationView()
    var data = [BagWozModel]()
    var geoManager : GeoLocationManager?
    private let progressHUD = ProgressHUD(text: "Loading data")
    static public var currentSessieNodes = [LocationAnnotationNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.geoManager = GeoLocationManager(delegateARSessie: self)
        //InitDataManager(streetname: "Antwerpseweg")

        view.addSubview(sceneLocationView)
        view.addSubview(progressHUD)
        
       // InitDataManager(streetname:  "Burgemeester van Reenensingel")
        
        sceneLocationView.run()
        ARViewController.displayView = ARDisplayView(superView: self.view, controllerDelegate: self)

    }
    
    func createArObject(){
        self.progressHUD.isHidden = true
        for object in self.data{
            let coordinate = CLLocationCoordinate2D(latitude: (object.geolocation?.coordinate.latitude)! , longitude: (object.geolocation?.coordinate.longitude)!)
            let location = CLLocation(coordinate: coordinate, altitude: 0)
            let image = object.problemNotification[0].messageImage
            
            let annotationNode = LocationAnnotationNode(location: location, image: image, bagwozModel: object)
            annotationNode.scaleRelativeToDistance = true
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
            ARViewController.currentSessieNodes.append(annotationNode)
//            sceneLocationView.run()

        }
    }
    
    private func removeAllNodes(){
        for object in ARViewController.currentSessieNodes{
            self.sceneLocationView.removeLocationNode(locationNode: object)
            ARViewController.currentSessieNodes.removeFirst()
        }
    }
    
    func InitDataManager(streetname : String){
        let profile = ManagerSingleton.shared.defaulfProfile
        removeAllNodes()

        let dm = DataManager(filtermodule: (profile?.filterModule!)!)
        self.data = dm.requestData(streetname: streetname)
        
        self.geoManager?.calculateGeoLocationFromData()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



