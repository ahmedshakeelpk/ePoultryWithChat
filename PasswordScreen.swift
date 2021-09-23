//
//  PasswordScreen.swift
//  ZedChat
//
//  Created by MacBook Pro on 30/07/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Foundation
var typecount = 0
var arrPlaceHolders = [PasscodeSignPlaceholderView]()
var tempArrPlaceHolders = [PasscodeSignPlaceholderView]()
class PasswordScreen: UIViewController {
    
    var passwordtype = String()
    var passwordText = [String]()
    var newpasswordText = [String]()
    var isConfirmPassword = false
    var isCancelButton = false
    var isChangeScreen = false
    @IBOutlet weak var btnzero: PasscodeSignButton!
    @IBOutlet weak var btnone: PasscodeSignButton!
    @IBOutlet weak var btntwo: PasscodeSignButton!
    @IBOutlet weak var btnthree: PasscodeSignButton!
    @IBOutlet weak var btnfour: PasscodeSignButton!
    @IBOutlet weak var btnfive: PasscodeSignButton!
    @IBOutlet weak var btnsix: PasscodeSignButton!
    @IBOutlet weak var btnseven: PasscodeSignButton!
    @IBOutlet weak var btneight: PasscodeSignButton!
    @IBOutlet weak var btnnine: PasscodeSignButton!
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var vplaceholder: UIView!
    @IBAction func btnpasswordenter(_ sender: UIButton) {

        if passwordtype == "new" || passwordtype == "change"{
            setNewPasswrod(sender: sender)
        }
        else if passwordtype == "lock"{
            verifyPassword(sender: sender)
        }
    }
    //MARK:- When Password Not Set
    func setNewPasswrod(sender: UIButton){
        if passwordText.count == 4{
            newpasswordText.append(sender.titleLabel!.text!)
            
            if newpasswordText.count == 4{
                let password = passwordText.joined()
                let confirmpassword = newpasswordText.joined()
                if password == confirmpassword{
                    defaults.setValue(password, forKey: "lockpassword")
                    defaults.setValue("1", forKey: "isLock")
                    funCancel()
                }
                else{
                    //MARK:- If Confirm Password not set
                    passwordText = [String]()
                    newpasswordText = [String]()
                    lbltitle.text = "Set lock screen PIN"
                    lbldesc.text = "PIN must be made 4 digits"
                    self.view.isUserInteractionEnabled = false
                    typecount = 0
                    tempArrPlaceHolders = [PasscodeSignPlaceholderView]()
                    vplaceholder.frame.origin.x = vplaceholder.frame.minX - 40
                    self.animatePlaceholders(arrPlaceHolders, toState: .error)
                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { timer in
                        self.errorAnimation()
                    }
                }//End  else
            }//End if
        }//End PasswordText.count
        else{
            //MARK:- When Password digit complete and move for confirm password
            passwordText.append(sender.titleLabel!.text!)
            if passwordText.count == 4{
                lbldesc.text = "Confirm Password"
                self.animatePlaceholders(arrPlaceHolders, toState: .inactive)
                typecount = 0
                tempArrPlaceHolders = [PasscodeSignPlaceholderView]()
            }
        }
    }
    //MARK:- When already Password Set
    func verifyPassword(sender: UIButton){
        passwordText.append(sender.titleLabel!.text!)
        if tempArrPlaceHolders.count == 4{
            let typepassword = passwordText.joined()
            if let password = defaults.value(forKey: "lockpassword") as? String
            {
                passwordText = [String]()
                if password == typepassword{
                    funCancel()
                }
                else{
                    
                    self.view.isUserInteractionEnabled = false
                    typecount = 0
                    tempArrPlaceHolders = [PasscodeSignPlaceholderView]()
                    vplaceholder.frame.origin.x = vplaceholder.frame.minX - 40
                    self.animatePlaceholders(arrPlaceHolders, toState: .error)
                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { timer in
                        self.errorAnimation()
                    }
                }
            }
        }
    }
    func errorAnimation(){
        UIView.animate(
            withDuration: 0.5,
            delay: 3.5,
            usingSpringWithDamping: 2.2,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                self.view.layoutIfNeeded()
        },
            completion: { completed in
                self.vplaceholder.frame.origin.x = self.vplaceholder.frame.minX + 40
                self.view.isUserInteractionEnabled = true
                self.animatePlaceholders(self.placeholders, toState: .inactive)
        })
    }
    var statusbarColor = UIColor()
    
    @IBOutlet public var placeholders: [PasscodeSignPlaceholderView] = [PasscodeSignPlaceholderView]()
    
    @IBOutlet var codeview: UIView!
   
    @IBOutlet var btncancel: UIButton!
    @IBAction func btncancel(_ sender: Any) {
        tempArrPlaceHolders = [PasscodeSignPlaceholderView]()
        typecount = 0
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet var btndelete: UIButton!
    @IBAction func btndelete(_ sender: Any) {
        if tempArrPlaceHolders.count == 0{
            typecount = 0
            return
        }
        animatePlaceholders([tempArrPlaceHolders.last!], toState: .inactive)
        typecount = typecount - 1
        tempArrPlaceHolders.removeLast()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btncancel.isHidden = true
        arrPlaceHolders = placeholders
        // Do any additional setup after loading the view.
        
        if passwordtype == "change"{
            lbldesc.text = "Enter New Password"
        }
        else if let isLock = defaults.value(forKey: "isLock") as? String{
            if isLock == "0"{
                lbltitle.text = "Set lock screen PIN"
                lbldesc.text = "PIN must be made 4 digits"
            }
            else if isLock == "1"{
                lbldesc.text = "Enter Password"
            }
        }
        if isCancelButton == true{
            btncancel.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if UIApplication.shared.statusBarView?.backgroundColor != nil{
            UIApplication.shared.statusBarView?.backgroundColor = statusbarColor
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if UIApplication.shared.statusBarView?.backgroundColor != nil{
            statusbarColor = UIApplication.shared.statusBarView!.backgroundColor!
            UIApplication.shared.statusBarView?.backgroundColor = .clear
        }
    }

    func animatePlaceholders(_ placeholders: [PasscodeSignPlaceholderView], toState state: PasscodeSignPlaceholderView.State) {
        placeholders.forEach { $0.animateState(state) }
    }
    
    func funCancel(){
        tempArrPlaceHolders = [PasscodeSignPlaceholderView]()
        typecount = 0
        self.dismiss(animated: true, completion: nil)
        
        if isChangeScreen == true{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setPassword"), object: nil)
        }
    }
}


