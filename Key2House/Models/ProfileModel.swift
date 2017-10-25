//
//  ProfileModel.swift
//  Key2House
//
//  Created by Xiao on 16/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit


class Profile{
    enum authority{
        case readWriteDelete(Bool, Bool, Bool)
    }
    
    var name : String?
    private var rights : authority?
    var filterModule : FilterModule?
    var defaultProfile : Bool = false{
        willSet{
            changeDefaultProfile(value: newValue)
        }
    }
    
    init(name : String, filterModule : FilterModule) {
        self.name = name
        self.rights = authority.readWriteDelete(true, false, false)
        self.filterModule = filterModule
    }
    
    init(name : String, filterModule : FilterModule, defaultProfile : Bool) {
        self.name = name
        self.rights = authority.readWriteDelete(true, false, false)
        self.filterModule = filterModule
        self.defaultProfile = defaultProfile
    }
    
    
    private func changeDefaultProfile(value : Bool){
        let tempProfiles = ManagerSingleton.shared.allProfiles
        if(value == true){
            for p in tempProfiles{
                if p.defaultProfile == true{
                    p.defaultProfile = false
                    return
                }
            }
        }
        
        ManagerSingleton.shared.allProfiles = tempProfiles
        ManagerSingleton.shared.defaulfProfile = self
        
    }
}






