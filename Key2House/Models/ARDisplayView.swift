//
//  ARDisplayView.swift
//  Key2House
//
//  Created by Xiao on 01/11/2017.
//  Copyright © 2017 Centric_xiao. All rights reserved.
//

import UIKit


class ARDisplayView: NSObject {
    
    private var currentDisplayView : [UIView]?
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
        
    }
    

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
        
        self.currentDisplayView?.append(stopCircleBtn)
   
    }
    
    
    func detailDisplayView(model : BagWozModel){
        let width : CGFloat = self.superViewFrame.size.width - 50
        let height : CGFloat = self.superViewFrame.size.height - geographicalView.frame.size.height - 100
        
        if let customView = Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)?.first as? ARDetailView {
            customView.cancelBtn.addTarget(self, action: #selector(stopDetailView), for: .touchUpInside)
            
            customView.frame = CGRect(x: CGFloat(25), y: self.geographicalView.frame.height + 10, width: width, height: height)
            customView.layer.cornerRadius = 15.0
            customView.layer.masksToBounds = true
            
            customView.addressLabel.text = "\(model.address.streetname)" + " " + "\(model.address.nr)"
            
            let controle = self.getobjectsText(model : model)
            customView.wozValueLabel.text = "\(model.wozWaarde)"
            let dtm  = model.latestCheck?.convertDateToString()
            customView.wozValueDtmLabel.text = dtm
            customView.checkDtmLabel.text = dtm
            customView.deelobjectenLabel.text = controle
            
            let objections = self.getObjectionText(messages: model.problemNotification)
            customView.objectionNrLabel.text = objections.nr
            customView.objectionDtmLabel.text = objections.dtm
            
            
            let bagwozCoupling = self.getCouplingText(messages: model.problemNotification)
            customView.couplingLabel.text = bagwozCoupling
            
            let patent = self.getPatentText(messages: model.problemNotification)
            customView.patentNrLabel.text = patent.nr
            customView.patentDtmLabel.text = patent.insertdate
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
            //focusViewBtn.addTarget(self, action: #selector(startFocusView), for: .touchUpInside)
            
            
            toolbar.addSubview(focusViewBtn)
            self.currentDisplayView?.append(toolbar)
            self.currentDisplayView?.append(customView)
        }
    }
    
    func focusDisplayView(model : BagWozModel){

        
    }
    
    func cleanDisplay(){
        if let view = self.currentDisplayView{
            for uiElement in view{
                uiElement.removeFromSuperview()
                self.currentDisplayView?.remove(object: uiElement)
            }
        }
    }
 
    func drawDisplay(superView : UIView){
        if let view = self.currentDisplayView{
            for uiElement in view{
               superView.addSubview(uiElement)
            }
        }
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
    
    
    @objc private func stopDetailView(){
        self.delegateArController.setDisplayModeState(state: .normal)
    }
    
    
    /*
    private func normalDisplayViewState(){
        let stopCircleBtn = UIButton()
        stopCircleBtn.frame = CGRect(x: geographicalView.frame.origin.x + 5, y: geographicalView.bounds.size.height + 12.5, width: CGFloat(50), height: CGFloat(50))
        stopCircleBtn.layer.cornerRadius = 0.5 * stopCircleBtn.bounds.size.width
        stopCircleBtn.backgroundColor = UIColor(red: 0/255, green: 94/255, blue: 168/255, alpha: 1)
        stopCircleBtn.clipsToBounds = true
        stopCircleBtn.titleLabel?.textColor = UIColor.white
        stopCircleBtn.setTitle("X", for: .normal)
        stopCircleBtn.addTarget(self, action: #selector(stopSession), for: .touchUpInside)
       
        
        let testCircleBtn = UIButton()
        testCircleBtn.frame = CGRect(x: 0, y: self.superView.frame.height - 50, width: CGFloat(50), height: CGFloat(50))
        testCircleBtn.layer.cornerRadius = 0.5 * stopCircleBtn.bounds.size.width
        testCircleBtn.backgroundColor = UIColor(red: 0/255, green: 94/255, blue: 168/255, alpha: 1)
        testCircleBtn.clipsToBounds = true
        testCircleBtn.titleLabel?.textColor = UIColor.white
        testCircleBtn.setTitle("T", for: .normal)
        testCircleBtn.addTarget(self, action: #selector(stopARSession), for: .touchUpInside)
        
        
        
        self.superView.addSubview(testCircleBtn)
        self.superView.addSubview(stopCircleBtn)
        self.currentElements.append(testCircleBtn)
        self.currentElements.append(stopCircleBtn)
    }
    
    private func detailDisplayViewState(model : BagWozModel){
        self.currentModel = model
        let width : CGFloat = self.superView.frame.size.width - 50
        let height : CGFloat = self.superView.frame.size.height - geographicalView.frame.size.height - 100
     
        if let customView = Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)?.first as? ARDetailView {
            customView.cancelBtn.addTarget(self, action: #selector(stopDetailView), for: .touchUpInside)
            
            customView.frame = CGRect(x: CGFloat(25), y: self.geographicalView.frame.height + 10, width: width, height: height)
            customView.layer.cornerRadius = 15.0
            customView.layer.masksToBounds = true
            
            customView.addressLabel.text = "\(model.address.streetname)" + " " + "\(model.address.nr)"
            
            let controle = self.getobjectsText(model : model)
            customView.wozValueLabel.text = "\(model.wozWaarde)"
            let dtm  = model.latestCheck?.convertDateToString()
            customView.wozValueDtmLabel.text = dtm
            customView.checkDtmLabel.text = dtm
            customView.deelobjectenLabel.text = controle
            
            let objections = self.getObjectionText(messages: model.problemNotification)
            customView.objectionNrLabel.text = objections.nr
            customView.objectionDtmLabel.text = objections.dtm
            
        
            let bagwozCoupling = self.getCouplingText(messages: model.problemNotification)
            customView.couplingLabel.text = bagwozCoupling
            
            let patent = self.getPatentText(messages: model.problemNotification)
            customView.patentNrLabel.text = patent.nr
            customView.patentDtmLabel.text = patent.insertdate
            customView.patentTypeLabel.text = patent.type
            
            let h : CGFloat = 50

            let toolbar = UIView(frame: CGRect(x: 0, y: self.superView.frame.height - h, width: self.superView.frame.width, height: h))
            self.currentElements.append(toolbar)
            
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
            self.currentElements.append(toolbar)
            self.currentElements.append(customView)
            
            self.superView.addSubview(toolbar)
            self.superView.addSubview(customView)
        }
    }
    
    private func focusDisplayViewState(model : BagWozModel){
        self.viewcontrollerDelegate.sessieObjectsIsHidden(true)
        let focusModel = FocusView(delegate: self, model : model)
        
        let stopCircleBtn = UIButton()
        stopCircleBtn.frame = CGRect(x: geographicalView.frame.origin.x + 5, y: geographicalView.bounds.size.height + 12.5, width: CGFloat(50), height: CGFloat(50))
        stopCircleBtn.layer.cornerRadius = 0.5 * stopCircleBtn.bounds.size.width
        stopCircleBtn.backgroundColor = UIColor(red: 0/255, green: 94/255, blue: 168/255, alpha: 1)
        stopCircleBtn.clipsToBounds = true
        stopCircleBtn.titleLabel?.textColor = UIColor.white
        stopCircleBtn.setTitle("X", for: .normal)
        stopCircleBtn.addTarget(self, action: #selector(stopDetailView), for: .touchUpInside)
        
        let model = focusModel.focusRootnode
//        model.position =  (self.viewcontrollerDelegate.sceneLocationView.pointOfView?.worldPosition)!
        self.viewcontrollerDelegate.sceneLocationView.scene.rootNode.addChildNode(model)
        self.currentElements.append(stopCircleBtn)
        self.superView.addSubview(stopCircleBtn)
        print(model.position)
    }
    
    private func cleanSuperView(){
        for uiElement in self.currentElements{
            uiElement.removeFromSuperview()
            self.currentElements.removeFirst()
        }
    }
   
    @objc private func stopFocusView(){
        setDisplayState(displayState: .normal)
        self.viewcontrollerDelegate.sessieObjectsIsHidden(false)

        //save?
    }
    
    @objc private func startFocusView(sender : AnyObject){
        setDisplayState(displayState: .focusview(model: currentModel!))
       // setDisplayState()
    }
    
    @objc private func stopARSession(){
  
        self.viewcontrollerDelegate.InitDataManager(streetname: "Burgemeester van Reenensingel")
    }
    
   */
}

extension ARDisplayView{
    private func UIelementsVisable(view : ARDetailView){
       /* let elements = [view.addressLabel,
                        view.checkDtmLabel,
                        view.couplingLabel,
                        view.deelobjectenLabel,
                        view.objectionDtmLabel,
                        view.objectionNrLabel,
                        view.patentDtmLabel,
                        view.patentNrLabel,
                        view.patentTypeLabel,
                        view.wozValueDtmLabel,
                        view.wozValueLabel]
        
        elements.forEach{ $0?.isHidden = ($0?.text?.isEmpty)! ? true : false}
 */
    }
    
 
    
    private func getObjectionText(messages : [MessageInterface]) -> (nr :  String, dtm : String){
        var objectNr  = ""
        var insertdtm = ""
        var objectionMessages = [MessageInterface]()
        
        
        if(!messages.isEmpty){
            for message in messages{
                if case TypeMessage.ObjectionMessage(_) = message.type{
                    objectionMessages.append(message)
                }
            }
            
            var message : MessageInterface
            
            if(!objectionMessages.isEmpty){
                 message = objectionMessages.reduce(objectionMessages[0], {($0.insertDate > $0.insertDate) ? $0 : $1})
           
                objectNr = message.messageId
                insertdtm = message.insertDate.convertDateToString()
            }
        }
        
        return (objectNr,insertdtm)
    }
    
    
    private func getobjectsText(model : BagWozModel) -> String{
        var allControleObjects : String = ""
        
        let allMessages = model.problemNotification.filter({(m : MessageInterface) in
            if case TypeMessage.ControleMessage(_) = m.type{
                    return true
            }else{
                return false
            }
        })
        
        for m in allMessages{
            let name = m.messageText()
            allControleObjects.append(name.content)
            allControleObjects.append(" ")
        }
        
        
        return (allControleObjects)
    }
    
    
    private func getCouplingText(messages : [MessageInterface]) -> String{
        var couplingMesage = ""

        if(!messages.isEmpty){
            for message in messages{
                if case TypeMessage.CouplingMessage(_) = message.type{
                    couplingMesage = message.messageText().content
                }
            }
        }

        return couplingMesage
    }
    
    private func getPatentText(messages : [MessageInterface]) ->(nr : String, type :  String, insertdate : String) {
        var patentMessage = (nr : "", type : "", insertDate : "")
        var patentMessages = [MessageInterface]()

        if(!messages.isEmpty){
            for message in messages{
                if case TypeMessage.PatentMessage(_) = message.type{
                    patentMessages.append(message)
                }
            }
        }
        if(!patentMessages.isEmpty){
            let patent = patentMessages.reduce(patentMessages[0], {($0.insertDate > $0.insertDate) ? $0 : $1})
            patentMessage.insertDate = patent.insertDate.convertDateToString()
            patentMessage.nr = patent.messageId
           
            switch  patent.type {
            case .ControleMessage(_):
                patentMessage.type = "Controle"
            case .PatentMessage(_):
                 patentMessage.type = "Bouwvergunning"
            case .CouplingMessage(_):
                 patentMessage.type = "Koppeling"
            case .ObjectionMessage(_):
                 patentMessage.type = "Bezwaarschrift"
            }
        }
        
        return (patentMessage.nr, patentMessage.type, patentMessage.insertDate)
    }
}




extension Date{
     func  convertDateToString() -> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM-dd-yy"
        return dateformatter.string(from: self)
    }
}
