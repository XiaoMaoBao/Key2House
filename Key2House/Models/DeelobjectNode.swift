//
//  DeelobjectNode.swift
//  Key2House
//
//  Created by Xiao on 02/11/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit
import SceneKit


class DeelobjectNode: SCNNode {
    
  
    
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
    
     var id : String = ""
    
    var nametype : String = ""
    
    //color moet texture/afbeelding worden
   

    private func drawOuterLine(line : UIColor){
      //draw
        
    }
    

    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
