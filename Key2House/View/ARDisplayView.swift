//
//  ARDisplayView.swift
//  Key2House
//
//  Created by Xiao on 01/11/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit


class ARDisplayView: NSObject {
    
    private var currentDisplayView : [UIView] = []
    private let delegateArController : ARViewController
    /*
    enum DisplayState{
        case normal
        case detailView(model : BagWozModel)
        case focusview(model : BagWozModel)
    }
    */
    let geographicalLabel = UILabel()
    private let superViewFrame : CGRect
    private let superViewBounds : CGRect

    //private let viewcontrollerDelegate : ARViewController
    //private var displayState : DisplayState?
    //private var currentElements : [UIView] = []
    private let geographicalView : UIView
    //private let superView : UIView
    //private var currentModel : BagWozModel?
    
    /*
    func setDisplayState(displayState : DisplayState){
       self.displayState = displayState
        
        if let state = self.displayState{
            switch state {
            case .normal :
                print("Normaalview")
                self.cleanSuperView()
                self.normalDisplayViewState()

            case .detailView(let m):
                print("detailview")
                self.cleanSuperView()
                self.detailDisplayViewState(model: m)
            
            case .focusview(let m):
                print("focusView")
                self.cleanSuperView()
                self.focusDisplayViewState(model: m)
            }
        }
    }
    */
    

    init(controllerDelegate : ARViewController, superView : UIView) {
        self.delegateArController = controllerDelegate
        self.superViewFrame = superView.frame
        self.superViewBounds = superView.bounds
        self.geographicalView = UIView(frame: CGRect(x: superView.frame.origin.x, y: superView.frame.origin.y, width: superView.bounds.width, height: CGFloat(50)))
        
        super.init()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = geographicalView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        geographicalLabel.text = "Bereken locatie..."
        geographicalLabel.frame = geographicalView.bounds
        geographicalLabel.frame.origin.y += 10
        geographicalLabel.textAlignment = .center
        geographicalLabel.textColor = UIColor(displayP3Red: 0/255, green: 150/255, blue: 63/255, alpha: 1)
        geographicalView.addSubview(blurEffectView)
        geographicalView.addSubview(geographicalLabel)
        
        superView.addSubview(geographicalView)
    }
    


    
    @objc private func stopSession(){
        let isPresentingInAddMealMode = self.delegateArController.presentingViewController is UITabBarController
        
        if isPresentingInAddMealMode {
            self.delegateArController.dismiss(animated: true, completion: nil)
        }
        else {
            fatalError("The view is not inside a navigation controller.")
        }
    }
    
    
    @objc private func setDisplayStateNormal(){
        self.delegateArController.setDisplayModeState(state: .normal)
    }
    
    
    @objc private func startFocusView(sender : AnyObject){
        self.delegateArController.setDisplayModeState(state: .focusview(m: self.delegateArController.selectedModel!))

    }
}

extension ARDisplayView{
  
    func setCurrentLocationDisplay(location : String){
        self.geographicalLabel.text = location
    }
    
    func normalDisplayView(){
        
        let stopCircleBtn = UIButton()
        
        stopCircleBtn.frame = CGRect(x: geographicalView.frame.origin.x + 5, y: geographicalView.bounds.size.height + 12.5, width: CGFloat(50), height: CGFloat(50))
        stopCircleBtn.layer.cornerRadius = 0.5 * stopCircleBtn.bounds.size.width
        stopCircleBtn.backgroundColor = UIColor(red: 0/255, green: 94/255, blue: 168/255, alpha: 1)
        stopCircleBtn.clipsToBounds = true
        stopCircleBtn.titleLabel?.textColor = UIColor.white
        stopCircleBtn.setTitle("X", for: .normal)
        stopCircleBtn.addTarget(self, action: #selector(self.stopSession), for: .touchUpInside)
        
        self.currentDisplayView.append(stopCircleBtn)
        
    }
    
    
    func detailDisplayView(model : BagWozModel){
        let width : CGFloat = self.superViewFrame.size.width - 50
        let height : CGFloat = self.superViewFrame.size.height - geographicalView.frame.size.height - 100
        self.delegateArController.selectedModel = model
        
        if let customView = Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)?.first as? ARDetailView {
            customView.cancelBtn.addTarget(self, action: #selector(setDisplayStateNormal), for: .touchUpInside)
            
            customView.frame = CGRect(x: CGFloat(25), y: self.geographicalView.frame.height + 10, width: width, height: height)
            customView.layer.cornerRadius = 15.0
            customView.layer.masksToBounds = true
            
            customView.addressLabel.text = "\(model.address.streetname)" + " " + "\(model.address.nr)"
            let dict = model.getSortedMessages()
            
            let controle = model.controleDetails(dict: dict)
            customView.wozValueLabel.text = "\(model.wozWaarde)"
            customView.checkDtmLabel.text = controle.date
            customView.deelobjectenLabel.text = controle.deelobjecten
            
            let objections = model.objectionDetails(dict: dict)
            customView.objectionNrLabel.text = objections.id
            customView.objectionDtmLabel.text = objections.date
            
            
            let bagwozCoupling = model.couplingDetails(dict: dict)
            customView.couplingLabel.text = bagwozCoupling
            
            let patent = model.patentDetails(dict: dict)
            customView.patentNrLabel.text = patent.id
            customView.patentDtmLabel.text = patent.date
            customView.patentTypeLabel.text = patent.type
            
            let h : CGFloat = 50
            
            let toolbar = UIView(frame: CGRect(x: 0, y: self.superViewFrame.height - h, width: self.superViewFrame.width, height: h))
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = geographicalView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            
            toolbar.addSubview(blurEffectView)
            let focusViewBtn = UIButton()
            focusViewBtn.frame = CGRect(x: toolbar.bounds.origin.x, y: toolbar.bounds.origin.y, width: 50, height: 50)
            focusViewBtn.layer.cornerRadius = 0.5 * focusViewBtn.bounds.size.width
            focusViewBtn.backgroundColor = UIColor(red: 0/255, green: 94/255, blue: 168/255, alpha: 1)
            focusViewBtn.clipsToBounds = true
            focusViewBtn.titleLabel?.textColor = UIColor.white
            focusViewBtn.setTitle("F", for: .normal)
            focusViewBtn.addTarget(self, action: #selector(startFocusView), for: .touchUpInside)
            
            
            toolbar.addSubview(focusViewBtn)
            self.currentDisplayView.append(toolbar)
            self.currentDisplayView.append(customView)
        }
    }
    
    func focusDisplayView(model : BagWozModel){
        let focusModel = FocusModel(model : model)
        
        let stopCircleBtn = UIButton()
        stopCircleBtn.frame = CGRect(x: geographicalView.frame.origin.x + 5, y: geographicalView.bounds.size.height + 12.5, width: CGFloat(50), height: CGFloat(50))
        stopCircleBtn.layer.cornerRadius = 0.5 * stopCircleBtn.bounds.size.width
        stopCircleBtn.backgroundColor = UIColor(red: 0/255, green: 94/255, blue: 168/255, alpha: 1)
        stopCircleBtn.clipsToBounds = true
        stopCircleBtn.titleLabel?.textColor = UIColor.white
        stopCircleBtn.setTitle("X", for: .normal)
        stopCircleBtn.addTarget(self, action: #selector(setDisplayStateNormal), for: .touchUpInside)
        
        self.currentDisplayView.append(stopCircleBtn)
        self.delegateArController.focusViewState(focus : focusModel)
    }
    
    func focusDetialdisplayView(model : BagWozModel, deelobjectId : Int){
        //draw detail
    }
    
    
    func cleanDisplay(){
            for uiElement in self.currentDisplayView{
                uiElement.removeFromSuperview()
                self.currentDisplayView.remove(object: uiElement)
        }
    }
    
    func drawDisplay(superView : UIView){
        for uiElement in self.currentDisplayView{
                superView.addSubview(uiElement)
            }
    }
}

extension Date{
     func  convertDateToString() -> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM-dd-yy"
        return dateformatter.string(from: self)
    }
}
