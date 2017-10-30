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
            if (newValue){
                ManagerSingleton.shared.defaulfProfile = self
            }
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
}






