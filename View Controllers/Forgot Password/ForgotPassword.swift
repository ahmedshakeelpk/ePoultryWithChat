//
//  ForgotPassword.swift
//  AMPL
//
//  Created by sameer on 11/06/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPassword: UIViewController {

    var userForgotId = ""
    @IBOutlet weak var txtmobno: UITextField!
    @IBOutlet weak var txtcode: UITextField!
    @IBOutlet weak var btnsend: UIButton!
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    @IBOutlet weak var bgvConfirmPassword: UIView!
    @IBOutlet weak var txtpass: UITextField!
    @IBOutlet weak var txtcpass: UITextField!
    @IBOutlet weak var btnsubmit: UIButton!
    @IBAction func btnsubmit(_ sender: Any) {
        if txtpass.text == ""{
            obj.showAlert(title: "Alert!", message: "Please enter password", viewController: self)
        }
        else if txtcpass.text == ""{
            obj.showAlert(title: "Alert!", message: "Please enter confirm password", viewController: self)
        }
        else if txtpass.text != txtcpass.text{
            obj.showAlert(title: "Alert!", message: "Password and confirm password not match", viewController: self)
        }
        else{
            funChangePassword()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnsend.layer.cornerRadius = 3
        btnsubmit.layer.cornerRadius = 3
        obj.txtbottomline(textfield: txtcode)
        obj.txtbottomline(textfield: txtmobno)
        obj.txtbottomline(textfield: txtpass)
        obj.txtbottomline(textfield: txtcpass)
        bgvConfirmPassword.layer.cornerRadius = 3
        bgvConfirmPassword.layer.borderColor = appclr.cgColor
        bgvConfirmPassword.layer.borderWidth = 1
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(confirmpress), name: NSNotification.Name(rawValue: "verificationconfirmed"), object: nil)
    }

    @IBAction func btnsend(_ sender: Any) {
        funGetUserId()
    }
    
    
    func funGetUserId(){
        var code = self.txtcode.text!
        code = code.replacingOccurrences(of: "+", with: "")
        let url =
            BASEURL+"user/\(code)\(txtmobno.text!)/GetID"
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:
            {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil
                    {
                        if responseObject!.count > 0
                        {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0
                            {
                                if let temp = datadic.value(forKey: "message") as? String{
                                    obj.showAlert(title: "Alert!", message: temp, viewController: self)
                                }
                                else{
                                    self.userForgotId =
                                    "\(((datadic.value(forKey: "id") as! NSArray).value(forKey: "id") as! NSArray)[0] as! Int)"
                                    
                                    
                                    self.funSendPhoneAuth()
                                }
                            }
                            else
                            {
                                obj.showAlert(title: "Alert!", message: "No not found", viewController: self)
                            }
                        }
                        else
                        {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else
                    {
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
    func funSendPhoneAuth()
    {
        andicator.startAnimating()
        PhoneAuthProvider.provider().verifyPhoneNumber(("\(txtcode.text!)\(txtmobno.text!)"), uiDelegate: nil){ (verificationID, error) in
            self.andicator.stopAnimating()
            if error != nil {
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                return
            }else{
                GlobalFireBaseverficationID = verificationID!
                objG.showVerificationPopup(string: "textstring", viewController: self)
            }
        }
    }
    @objc func confirmpress(notification: Notification)
    {
        let datadic = notification.object as! NSDictionary
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: GlobalFireBaseverficationID,
            verificationCode: datadic.value(forKey: "code") as! String)
        let tempVC = datadic.value(forKey: "viewController") as! UIViewController
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            
            if error != nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopandicator"), object: nil)
                
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                
                
                return
            }
            else
            {
                //self.funVerifyNumberInServer()
                objG.removeVerificationPopup()
                self.bgvConfirmPassword.isHidden = false
                self.btnsend.isHidden = true
            }
        }
    }
    func funChangePassword(){
        var code = txtmobno.text!
        code = code.replacingOccurrences(of: "+", with: "")
        let url =
            BASEURL+"user/\(userForgotId)/ResetPassword?password=\(txtpass.text!)"

        
        andicator.startAnimating()
        obj.webServicePut(url: url, parameters: Dictionary(), completionHandler: {
            response,str  in
            self.andicator.stopAnimating()
            if response == nil{
                obj.showAlert(title: "Alert!", message: str!, viewController: self)
                return
            }
            let datadic = (response! as NSDictionary)
            if datadic.count > 0
            {
                self.bgvConfirmPassword.isHidden = true
                self.btnsend.isHidden = false
                if datadic.value(forKey: "a") as! Int == 1{
                    let alertController = UIAlertController(title: "Success!", message: "Your password successfully reset.", preferredStyle:UIAlertController.Style.alert)
                    
                    
                    alertController.addAction(UIAlertAction(title: "Done.", style: UIAlertAction.Style.default)
                    { action -> Void in
                        // Put your code here
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else{
                    obj.showAlert(title: "Alert!", message: "An error occurd try again", viewController: self)
                }
            }
            
        })
    }
    
}
