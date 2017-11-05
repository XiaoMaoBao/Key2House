//
//  DeelobjectNode.swift
//  Key2House
//
//  Created by Xiao on 02/11/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit
import SceneKit


struct HouseValues{
    var quality = 0 , maintenance = 0, looks = 0 , usages = 0 ,supply = 0
}


class DeelobjectNode: SCNNode {
    
    struct Size{
        var width : CGFloat = 0.0, height : CGFloat = 0.0, length : CGFloat = 0.0
        
    }
    
    var houseProblem : Bool = false{
        willSet{
             self.drawOuterLine(line: UIColor.red)
        }
    }
    
    var selected : Bool = false{
        willSet{
            if(!houseProblem){
                self.drawOuterLine(line: UIColor.green)
            }
        }
    }
     var size = Size()
    
    private var textureColor : UIColor?
    var houseValues : HouseValues?
    //color moet texture/afbeelding worden
    init(texture : UIColor, name: String, size : (CGFloat, CGFloat, CGFloat) ) {
        self.textureColor = texture
        super.init()
        self.size.width = size.0
        self.size.height = size.1
        self.size.length = size.2
        
        self.geometry = SCNBox(width: self.size.width, height: self.size.height, length: self.size.length, chamferRadius: 0)
        self.geometry?.firstMaterial?.diffuse.contents = texture
        self.name = name
    }
    
    private func drawOuterLine(line : UIColor){
      //draw
    }
    
    public func setHouseValues(values :  (Int, Int, Int,  Int, Int)){
        self.houseValues = HouseValues(quality: values.0, maintenance: values.1, looks: values.2, usages: values.3, supply: values.4)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
