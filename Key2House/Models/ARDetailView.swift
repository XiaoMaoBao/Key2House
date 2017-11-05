//
//  ARDetailView.swift
//  Key2House
//
//  Created by Xiao on 02/11/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit

class ARDetailView: UIView {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var wozValueLabel: UILabel!
    
    @IBOutlet weak var checkDtmLabel: UILabel!
    @IBOutlet weak var deelobjectenLabel: UILabel!
    
    @IBOutlet weak var objectionNrLabel: UILabel!
    @IBOutlet weak var objectionDtmLabel: UILabel!
    
    @IBOutlet weak var couplingLabel: UILabel!
    
    @IBOutlet weak var patentNrLabel: UILabel!
    @IBOutlet weak var patentTypeLabel: UILabel!
    @IBOutlet weak var patentDtmLabel: UILabel!
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

}
