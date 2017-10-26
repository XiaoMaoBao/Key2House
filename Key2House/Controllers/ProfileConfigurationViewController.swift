//
//  ProfileConfigurationViewController.swift
//  Key2House
//
//  Created by Xiao on 06/10/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit

class ProfileConfigurationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var filterModuleTableView: UITableView!
    @IBOutlet weak var defaultProfileSwitch: UISwitch!
    var profile : Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tableSettings()
        
    }
    
    
    private func tableSettings(){
        filterModuleTableView.delegate = self
        filterModuleTableView.dataSource = self
        // Do any additional setup after loading the view.
        filterModuleTableView.isEditing = true
    }
    
    private func setup(){
        if let p = self.profile{
            self.title = p.name
            self.nameTextField.text = p.name
            
            
            
            if let dp = ManagerSingleton.shared.defaulfProfile{
                if (dp === self.profile){
                    self.defaultProfileSwitch.setOn(p.defaultProfile, animated: true)
                }
            }
        }else{
            self.profile = Profile(name: "", filterModule: FilterModule())
            self.nameTextField.text = ""
            self.title = "Nieuwe profiel"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
  
    
    

    @IBAction func cancel(_ sender: Any) {
        let isPresentingInAddMealMode = presentingViewController is UITabBarController

        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The view is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let name = nameTextField.text ?? ""
        let dProfile = defaultProfileSwitch.isOn
        let fModule = getEachValue(filtermodule: (self.profile?.filterModule)!)
        self.profile = Profile(name: name, filterModule: fModule)
        self.profile?.defaultProfile = dProfile
    }
    
    func getEachValue(filtermodule : FilterModule) -> FilterModule{
      
        var moduleArray = filtermodule.currentFilters
        for row in 0 ..< moduleArray.count{
            let cell  = self.filterModuleTableView.cellForRow(at: IndexPath.init(row: row, section: 0)) as! FiltermoduleTableViewCell
            let title  = cell.filterNameLabel.text
            
            let currentIndex = moduleArray.index(where: { (item) -> Bool in
                item.title == title
            })
            
        moduleArray[currentIndex!].active = cell.ActiveFilter.isOn
        
        //swap
            moduleArray.swapAt(row, currentIndex!)
        }
        
        filtermodule.currentFilters = moduleArray
        return filtermodule
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let p = self.profile{
            if let i = p.filterModule?.currentFilters.count{
                return i
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FiltermoduleCell", for: indexPath) as? FiltermoduleTableViewCell else{
            fatalError("Error.")
        }
        
        if let a = self.profile?.filterModule?.currentFilters{
            let e = a[indexPath.row]
            cell.filterNameLabel.text = e.title!
            cell.IconImageHolder.image = e.icon!
            cell.ActiveFilter.isOn = e.active!
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfSections section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0;
    }
}
