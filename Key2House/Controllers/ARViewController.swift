//
//  ARViewController.swift
//  Key2House
//
//  Created by Xiao on 31/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit
import CoreLocation
class ARViewController: UIViewController {
    var sceneLocationView = SceneLocationView()
    var data = [BagWozModel]()
    var geoManager : GeoLocationManager?
    private let progressHUD = ProgressHUD(text: "Loading data")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.geoManager = GeoLocationManager(delegateARSessie: self)

        
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        view.addSubview(progressHUD)
        self.progressHUD.isHidden = false
        InitDataManager()
        let button = UIButton(frame: CGRect(x: self.view.bounds.width - 100, y: self.view.bounds.height - 100, width: CGFloat(50), height: CGFloat(50)))
        self.view.addSubview(button)
        button.titleLabel?.text = "Stop"
        button.addTarget(self, action: #selector(stopARSession), for: .touchUpInside)
    }
    
    
    func createArObject(){
        self.progressHUD.isHidden = true
        for object in self.data{
            let coordinate = CLLocationCoordinate2D(latitude: (object.geolocation?.coordinate.latitude)! , longitude: (object.geolocation?.coordinate.longitude)!)
            let location = CLLocation(coordinate: coordinate, altitude: 0)
            let image = object.problemNotification[0].messageImage
            
            let annotationNode = LocationAnnotationNode(location: location, image: image)
            annotationNode.scaleRelativeToDistance = true
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        }
    }
    
    
    func InitDataManager(){
        let profile = ManagerSingleton.shared.defaulfProfile
        
        let dm = DataManager(filtermodule: (profile?.filterModule!)!)
        self.data = dm.requestData(streetname: "Burgemeester van Reenensingel")
        
        self.geoManager?.calculateGeoLocationFromData()
    }
    
    
    @objc private func stopARSession(){
        let isPresentingInAddMealMode = presentingViewController is UITabBarController
        
        if isPresentingInAddMealMode {
        dismiss(animated: true, completion: nil)
        }
        else {
        fatalError("The view is not inside a navigation controller.")
        }
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
