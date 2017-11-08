//
//  FocusModel.swift
//  Key2House
//
//  Created by Xiao on 02/11/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit
import SceneKit
class FocusModel: NSObject {
    
    var rootnode : SCNNode = SCNNode()
    private var currentBuildingBlockSessie = [String : [SCNNode]]()
    private var buildingBlocks = [SCNNode]()
    private var currentYAngle : Float = 0.0

    init(model : BagWozModel){
        super.init()
        
        self.createBlueprint(model: model)
        
        
        
        /*let sceneJoke = SCNScene(named : "art.scnassets/3D_house.scn" )
        self.rootnode = (sceneJoke?.rootNode.childNode(withName : "BagWozModel", recursively: true)!)!
        
        
        
        let node1 = rootnode.childNode(withName : "Perceel", recursively: true)
        let node2 = rootnode.childNode(withName : "Bijgebouw", recursively: true)
        let node3 = rootnode.childNode(withName : "woning", recursively: true)
        
        
        
        
        let node4 = node2?.clone()
        
        print(node4?.position)
        rootnode.addChildNode(node4!)
        node4?.position.z *= 10
        */
    }
    
    //check op de type gebouw, waardes en meldingen
    
    private func createBlueprint(model : BagWozModel){
        
        switch model.building {
        case .appartment(let e):
            self.createAppartment()
        case .residence(let W, let h,let d):
            self.createResidence(model : model)
        case .unknown():
            self.createResidence(model: model, bagEmpty: true)
        }
    }
  
    private func createAppartment(){
        
    }
    
    
    private func createResidence(model : BagWozModel, bagEmpty : Bool = false){
       
        
        let sceneJoke = SCNScene(named : "art.scnassets/3D_house.scn" )!
        self.rootnode = sceneJoke.rootNode.childNode(withName : "BagWozModel", recursively: true)!
        
        let landNode = rootnode.childNode(withName : "Perceel", recursively: true)!
        let outerBuildingNode = rootnode.childNode(withName : "Bijgebouw", recursively: true)!
        let otherNode = rootnode.childNode(withName : "Overige", recursively: true)!
        let mainResidenceNode = rootnode.childNode(withName : "Woning", recursively: true)!
        
        self.buildingBlocks = [landNode,
                              outerBuildingNode,
                              otherNode,
                              mainResidenceNode]
        
        landNode.removeFromParentNode()
        outerBuildingNode.removeFromParentNode()
        otherNode.removeFromParentNode()
        mainResidenceNode.removeFromParentNode()

        
        
        let wozEmpty = model.deelobjecten.isEmpty
        
        if (!wozEmpty){
            print("woz is not empty")
            //draw woz-objects
                for dObject in model.deelobjecten{
                    let node = buildingBlocks.first(where: {$0.name == dObject.fractionDetails().name})
                    if let n = node{
                        //create
                        n.setValue(dObject.id!, forKey: n.name!)
                        self.currentBuildingBlockSessie[n.name!]?.append(n)
                        
                    }
                }
            //return
            }
        
        
        if (self.currentBuildingBlockSessie["Perceel"] != nil){
            let node = self.buildingBlocks.first(where : {$0.name! == "Perceel"})?.clone()
            node?.setValue("Empty", forKey: (node?.name!)!)
            //return
            
        }
        checkBuildingBlockForOuterline()
        rePostioneringBlocks()
}
    
    
    
    
    private func rePostioneringBlocks(){
        for key in self.currentBuildingBlockSessie.keys{
            switch(key){
            case "Perceel" :
                self.setPosition((0,1,0), nodes: self.currentBuildingBlockSessie[key]!)
            case "Bijgebouw" :
                self.setPosition((0,0,1), nodes: self.currentBuildingBlockSessie[key]!)
            case "Overige":
                self.setPosition((0,0,1), nodes: self.currentBuildingBlockSessie[key]!)
            case "Woning":
                self.setPosition((0,1,0), nodes: self.currentBuildingBlockSessie[key]!)
            default :
                print("Nothing")
            }
        }
    }
    
    private func setPosition(_ vector3 : (Float,Float,Float), nodes: [SCNNode]){
        //self.rootnode.addChildNode(node)
        //node.position =
        var currentPosition = SCNVector3(0,0,0)
        for node in nodes{
            self.rootnode.addChildNode(node)
         
            
            if (SCNVector3EqualToVector3(currentPosition, SCNVector3(0,0,0))){
                currentPosition = node.position
            }else{
                let newVector = SCNVector3(node.position.x * vector3.0,
                                           node.position.y * vector3.1,
                                           node.position.z * vector3.2)
                currentPosition.x += newVector.x
                currentPosition.y += newVector.y
                currentPosition.z += newVector.z

                node.position = currentPosition
            }
        }
    }
    
    private func checkBuildingBlockForOuterline(){
    
     
    }
 
    
    func rotate(_ sender: UIPanGestureRecognizer){
        
        let translation = sender.translation(in: sender.view)
        
        let newAngleY = Float(translation.x) * Float((Double.pi)/180.0)
        self.rootnode.eulerAngles.y = newAngleY + currentYAngle
        
        
        if(sender.state == UIGestureRecognizerState.ended){
            currentYAngle =  (self.rootnode.eulerAngles.y)
            
        }
    }
    
    //reset
    func cleanFocusMode(){
        currentYAngle = 0.0
        self.rootnode.removeFromParentNode()
    }
    
}


extension SCNNode {
    //var id : Int = 0
}
