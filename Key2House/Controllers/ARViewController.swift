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
    var sceneLocationView = SceneLocationView()
    var data = [BagWozModel]()
    var geoManager : GeoLocationManager?
    private let progressHUD = ProgressHUD(text: "Loading data")
    let label = UILabel(frame: CGRect(x: 80, y: 0, width: 200, height: 50))
    static public var currentSessieNodes = [LocationNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.geoManager = GeoLocationManager(delegateARSessie: self)
        InitDataManager(streetname: "Antwerpseweg")

        view.addSubview(sceneLocationView)
        view.addSubview(progressHUD)
        self.progressHUD.isHidden = false
       // InitDataManager(streetname:  "Burgemeester van Reenensingel")
        label.text = ""
        let buttonView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 400, height: 50)))
        buttonView.backgroundColor = UIColor.green
        let button = UIButton(frame: CGRect(x: CGFloat(0), y:CGFloat(0), width: CGFloat(50), height: CGFloat(50)))
        label.text = "locatie"
        button.titleLabel?.text = "Stop"
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(stopARSession), for: .touchUpInside)
        buttonView.addSubview(button)
        buttonView.addSubview(label)
        view.addSubview(buttonView)
        sceneLocationView.run()

        var toolbarView = UIView(frame: CGRect(x: 0, y: self.view.bounds.height - 50, width: self.view.bounds.width, height: 20))
        //toolbarView.backgroundColor = UIColor.white
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = toolbarView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toolbarView.addSubview(blurEffectView)
        
        
        toolbarView.addSubview(blurEffectView)
        self.view.addSubview(toolbarView)
        
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
    
    
    @objc private func stopARSession(){
        /*let isPresentingInAddMealMode = presentingViewController is UITabBarController
        
        if isPresentingInAddMealMode {
        dismiss(animated: true, completion: nil)
        }
        else {
        fatalError("The view is not inside a navigation controller.")
        }*/
        
        
        InitDataManager(streetname: "Burgemeester van Reenensingel")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
