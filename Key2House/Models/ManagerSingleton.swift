//
//  ManagerSingleton.swift
//  Key2House
//
//  Created by Xiao on 22/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit

final class ManagerSingleton {
        
        // Can't init is singleton
        private init() { }
        
        // MARK: Shared Instance
        
        static let shared = ManagerSingleton()

        // MARK: Local Variable
    var allProfiles : [Profile] = [Profile(name: "Taxateur", filterModule: FilterModule()),
                                       Profile(name: "Controle-BAG Taxateur", filterModule: FilterModule()),
                                       Profile(name: "Markt onderzoeker", filterModule: FilterModule()),
                                       Profile(name: "Bag bekijker", filterModule: FilterModule())]
    var defaulfProfile : Profile?
}
