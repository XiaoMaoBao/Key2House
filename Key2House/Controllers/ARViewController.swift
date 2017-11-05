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
    
    enum DisplayState{
        case normal
        case detailView(m : BagWozModel)
        case focusview(m : BagWozModel)
    }

    
    var displayView : ARDisplayView?
    var sceneLocationView = SceneLocationView()
    var data = [BagWozModel]()
    var geoManager : GeoLocationManager?
    private let progressHUD = ProgressHUD(text: "Loading data")
    var currentSessieNodes = [LocationAnnotationNode]()
  
    static var ARControllerDelegate:ARViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayView = ARDisplayView(controllerDelegate: self, superView: self.view)
        ARViewController.ARControllerDelegate = self

        self.geoManager = GeoLocationManager(delegateARSessie: self)
        //InitDataManager(streetname: "Antwerpseweg")

        view.addSubview(sceneLocationView)
        view.addSubview(progressHUD)
        
       // InitDataManager(streetname:  "Burgemeester van Reenensingel")
        
        sceneLocationView.run()
        self.setDisplayModeState(state: .normal)
        //ARViewController.displayView = ARDisplayView(superView: self.view, controllerDelegate: self)
        
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
            currentSessieNodes.append(annotationNode)
        }
    }
   /* public func sessieObjectsIsHidden(_ hidden : Bool){
        if(hidden){
            hideAllHouseObjects()
        }else {
            showAllHouseObjects()
        }
    }*/
    
    private func removeAllNodes(){
        for object in self.currentSessieNodes{
            self.sceneLocationView.removeLocationNode(locationNode: object)
            self.currentSessieNodes.removeFirst()
        }
    }
    
    func InitDataManager(streetname : String){
        let profile = ManagerSingleton.shared.defaulfProfile
        removeAllNodes()

        let dm = DataManager(filtermodule: (profile?.filterModule!)!)
        self.data = dm.requestData(streetname: streetname)
        
        self.geoManager?.calculateGeoLocationFromData()
    }

    
    func setDisplayModeState(state : DisplayState){
        self.displayView?.cleanDisplay()
        
        switch state {
        case .detailView(let m):
            self.displayView?.detailDisplayView(model : m)
        case .focusview(let m):
            self.displayView?.focusDisplayView(model: m)
        case .normal:
            self.displayView?.normalDisplayView()
            print("normal")
        }
        
        self.displayView?.drawDisplay(superView: self.view)
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


extension ARViewController{
   /* private func hideAllHouseObjects(){
        let sessieNode = ARViewController.currentSessieNodes
        for node in  sessieNode{
            node.isHidden = true
        }
    }*/
    
   /*
    private func showAllHouseObjects(){
        let sessieNode = ARViewController.currentSessieNodes
        for node in  sessieNode{
            node.isHidden = false
        }
    }*/
}


