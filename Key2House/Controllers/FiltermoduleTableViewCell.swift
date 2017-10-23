//
//  FiltermoduleTableViewCell.swift
//  Key2House
//
//  Created by Xiao on 06/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit

class FiltermoduleTableViewCell: UITableViewCell {

    @IBOutlet weak var IconImageHolder: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var ActiveFilter: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
