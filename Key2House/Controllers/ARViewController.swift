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


    static var ARControllerDelegate:ARViewController?

    private var sceneLocationView = SceneLocationView()
    private let progressHUD = ProgressHUD(text: "Loading data")

    var data = [BagWozModel]()
    var geoManager : GeoLocationManager?
    var currentSessieNodes = [LocationAnnotationNode]()
    var selectedModel :  BagWozModel?
    var displayView : ARDisplayView?
    var focus : FocusModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        ARViewController.ARControllerDelegate = self

        
        //InitDataManager(streetname: "Antwerpseweg")

        view.addSubview(sceneLocationView)
        view.addSubview(progressHUD)
        
       // InitDataManager(streetname:  "Burgemeester van Reenensingel")
        
        sceneLocationView.run()
        
        
        self.displayView = ARDisplayView(controllerDelegate: self, superView: self.view)
        self.setDisplayModeState(state: .normal)
        
        
        self.geoManager = GeoLocationManager(delegateARSessie: self)

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
    
    
    private func hideAllSessieObjects(_ hidden : Bool){
        if(hidden){
            currentSessieNodes.forEach({$0.isHidden = true})
        }else {
            currentSessieNodes.forEach({$0.isHidden = false})
        }
    }
    
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
        if let f = self.focus {
            f.cleanFocusMode()
            self.focus = nil
        }
        
        switch state {
        case .detailView(let m):
            self.displayView?.detailDisplayView(model : m)
            self.hideAllSessieObjects(false)
        case .focusview(let m):
            self.displayView?.focusDisplayView(model: m)
            self.hideAllSessieObjects(true)
        case .normal:
            self.displayView?.normalDisplayView()
            self.hideAllSessieObjects(false)
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

    func focusViewState(focus : FocusModel){
        self.focus = focus
        self.focus?.rootnode.position = SCNVector3(0,-0.5,-1.0)
        self.sceneLocationView.scene.rootNode.addChildNode((self.focus?.rootnode)!)
    }
}


