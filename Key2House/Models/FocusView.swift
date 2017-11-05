//
//  FocusView.swift
//  Key2House
//
//  Created by Xiao on 02/11/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit
import SceneKit
class FocusView: NSObject {
    private let displayControllerDelegate : ARDisplayView
    private var rootnode : SCNNode = SCNNode()
    private var bagNode : SCNNode = SCNNode()
    private var deelobjectenNodes : [DeelobjectNode]?
    private var currentModel : BagWozModel
   
    var focusRootnode : SCNNode{
        get{
            return self.rootnode
        }
    }
    
    
    init(delegate : ARDisplayView, model : BagWozModel){
        self.displayControllerDelegate = delegate
        self.currentModel = model
        self.deelobjectenNodes = []
        bagNode.name = "Bag"
        rootnode.name = "Root"
        
        super.init()
        
        self.createModels()
    }
    
  
    private func createModels(){
        let bwidth : CGFloat = 0.1
        let bheight : CGFloat = 0.1
        let bLength : CGFloat = 0.1

        let deelobjecten = self.currentModel.deelobjecten
        let plane = SCNBox(width: bwidth, height: bheight, length: bLength, chamferRadius: 0)
        plane.firstMaterial?.diffuse.contents = UIColor.red
        bagNode = SCNNode(geometry: plane)
       
        for object in deelobjecten{
            var node = DeelobjectNode(texture: UIColor.white, name: "deelobject", size : (0.1,0.1,0.1))
            node.setHouseValues(values: object.getHouseValues())
            self.deelobjectenNodes?.append(node)
        }
        arrangePositionModels()
    }
    

    private func arrangePositionModels(){
        
        if let nodes = self.deelobjectenNodes{
            var newposition = SCNVector3(0,0,0)
            for node in nodes{
                node.position = newposition
                bagNode.addChildNode(node)
                newposition.x += Float(node.size.length)
                print(node.position)
            }
        }
        
        rootnode.addChildNode(bagNode)
        rootnode.position = SCNVector3(0,0,-3)
    }
    
    private func addGestures(){
        
    }
    
    
    
}
