//
//  ARCameraSessieViewController.swift
//  Key2House
//
//  Created by Xiao on 23/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit
import os.log
import ARKit

class ARCameraSessieViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var userAddress: UILabel!
    var data = [BagWozModel]()
    var geoManager : GeoLocationManager?
    private let progressHUD = ProgressHUD(text: "Init ARSessie")
    var doneLoadingData : Bool = false
    var doneLoadingAR : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.geoManager = GeoLocationManager(delegateARSessie: self)
        //self.progressVisblility(visable: true)
        self.view.addSubview(progressHUD)
        // Do any additional setup after loading the view.
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Scenetest1.scn")!

        // Set the scene to the view
        sceneView.scene = scene
        
        InitDataManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelARScene(_ sender: Any) {
        let isPresentingInAddMealMode = presentingViewController is UITabBarController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else {
            fatalError("The view is not inside a navigation controller.")
        }

    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Place content only for anchors found by plane detection.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create a SceneKit plane to visualize the plane anchor using its position and extent.
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode(geometry: plane)
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        /*
         `SCNPlane` is vertically oriented in its local coordinate space, so
         rotate the plane to match the horizontal orientation of `ARPlaneAnchor`.
         */
        planeNode.eulerAngles.x = -.pi / 2
        
        // Make the plane visualization semitransparent to clearly show real-world placement.
        planeNode.opacity = 0.25
        
        /*
         Add the plane visualization to the ARKit-managed node so that it tracks
         changes in the plane anchor as plane estimation continues.
         */
        node.addChildNode(planeNode)
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Update content only for plane anchors and nodes matching the setup created in `renderer(_:didAdd:for:)`.
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // Plane estimation may shift the center of a plane relative to its anchor's transform.
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        /*
         Plane estimation may extend the size of the plane, or combine previously detected
         planes into a larger one. In the latter case, `ARSCNView` automatically deletes the
         corresponding node for one plane, then calls this method to update the size of
         the remaining plane.
         */
        plane.width = CGFloat(planeAnchor.extent.x)
        plane.height = CGFloat(planeAnchor.extent.z)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    
    
    
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        
        switch trackingState {
        case .normal where frame.anchors.isEmpty:
            // No planes detected; provide instructions for this app's AR interactions.
           // message = "Move the device around to detect horizontal surfaces."
            //self.progressHUD.text = "Loading Data"
            self.doneLoadingAR = true
            hideLoadingScreen()
            
        case .normal:
            // No feedback needed when tracking is normal and planes are visible.
            message = ""
        case .notAvailable:
            message = "Tracking unavailable."
            
        case .limited(.excessiveMotion):
            message = "Tracking limited - Move the device more slowly."
            
        case .limited(.insufficientFeatures):
            message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions."
            
        case .limited(.initializing):
            self.doneLoadingAR = false
            self.progressHUD.text = "Init AR session"
        }
}
    
    func hideLoadingScreen(){
        if(self.doneLoadingAR && self.doneLoadingData){
            self.progressHUD.removeFromSuperview()
            createModelObjects()
            self.doneLoadingData = false
            
            // The 3D cube geometry we want to draw
            let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
            // The node that wraps the geometry so we can add it to the scene
            boxGeometry.materials.first?.diffuse.contents = UIColor.red
            let boxNode = SCNNode(geometry: boxGeometry)
            // Position the box just in front of the camera
            boxNode.position = SCNVector3Make(0, 0, -1)
            
            self.sceneView.scene.rootNode.addChildNode(boxNode)
            
        }
    }
    
    
    
    private func createModelObjects(){
        let cubeGeo = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
        cubeGeo.materials.first?.diffuse.contents = UIColor.blue
        let node = SCNNode(geometry: cubeGeo)
        let ulocation = self.geoManager?.userLatAndLon
        let ecefUser = latlonToxyz(_coord: ((ulocation?.lat)!, (ulocation?.lon)!))
        for object in self.data{
            let olocation = object.latAndLon
            let ecefObject = latlonToxyz(_coord: (olocation.lat, olocation.lon))

            var xyzARWorld = (x : ecefUser.x - ecefObject.x, y : ecefUser.y - ecefObject.y, z : ecefUser.z - ecefObject.z)
            xyzARWorld.x = xyzARWorld.x.roundToDecimal(5)
            xyzARWorld.y = xyzARWorld.y.roundToDecimal(5)
            xyzARWorld.z = xyzARWorld.z.roundToDecimal(5)

            node.worldPosition =  SCNVector3Make(Float( xyzARWorld.x),Float(xyzARWorld.y), Float(xyzARWorld.z))
            print(node.worldPosition)
            self.sceneView.scene.rootNode.addChildNode(node)
            
        }
        
    }
    
    private func latlonToxyz(_coord : (lat : Double,  lon : Double)) -> (x: Double, y : Double, z: Double){
      
        let cosLat = cos(_coord.lat * Double.pi / 180)
        let sinLat = sin(_coord.lat * Double.pi / 180)
        let cosLon = cos(_coord.lon * Double.pi / 180)
        let sinLon = sin(_coord.lon * Double.pi / 180)
        
        let rad = 500.00
        let x = rad * cosLat * cosLon
        let y = rad * cosLat * sinLon
        let z = rad * sinLat
        return (x,y,z)
    }
    
    
    func InitDataManager(){
        let profile = ManagerSingleton.shared.defaulfProfile

        let dm = DataManager(filtermodule: (profile?.filterModule!)!)
        self.data = dm.requestData(streetname: "Antwerpseweg")
        
        self.geoManager?.calculateGeoLocationFromData()
    }
    

    
}




class ProgressHUD: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            vibrancyView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: activityIndicatorSize + 5,
                                 y: 0,
                                 width: width - activityIndicatorSize - 15,
                                 height: height)
            label.textColor = UIColor.gray
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

