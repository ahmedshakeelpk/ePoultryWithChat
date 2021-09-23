//
//  GoLive.swift
//  ePoltry
//
//  Created by Apple on 14/02/2020.
//  Copyright © 2020 sameer. All rights reserved.
//

import UIKit
import Alamofire

class GoLive: UIViewController {

    var isScheduleLater = false
    var isLive = true
    @IBOutlet weak var bgvDetails: UIView!
    @IBOutlet weak var txttitle: UITextField!
    @IBOutlet weak var lbllatter: UILabel!
    @IBOutlet weak var txtdate: UITextField!
    @IBOutlet weak var txttime: UITextField!
    
    @IBAction func txtfunDate(_ sender: Any) {
        funSelectDateTime(isTime: false)
    }
    @IBAction func txtfunTime(_ sender: Any) {
        funSelectDateTime(isTime: true)
    }
    @IBOutlet weak var btncancel: UIButton!
    @IBAction func btncancel(_ sender: Any) {
        funback()
    }
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var btnGo: UIButton!
    @IBAction func btnGo(_ sender: Any) {
        if txttitle.text == "" {
            obj.funValidationfromBottom(sender: txttitle, text: "Please enter title", view: bgvDetails)
        }
        else if txtdate.text == "" && btnSwitch.isOn {
            obj.funValidationfromBottom(sender: txttitle, text: "Please select date", view: bgvDetails)
        }
        else if txttime.text == "" && btnSwitch.isOn {
            obj.funValidationfromBottom(sender: txttitle, text: "Please select time", view: bgvDetails)
        }
        else {
            isLive = true
            funGoLive()
        }
    }
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBAction func btnSwitch(_ sender: UISwitch) {
        if sender.isOn {
            txttime.backgroundColor = .clear
            txtdate.backgroundColor = .clear
            txttime.isUserInteractionEnabled = true
            txtdate.isUserInteractionEnabled = true
        }
        else {
            txttime.text = ""
            txtdate.text = ""
            txttime.backgroundColor = .gray
            txtdate.backgroundColor = .gray
            txttime.isUserInteractionEnabled = false
            txtdate.isUserInteractionEnabled = false
        }
    }
    override func viewDidLoad() {
        txttitle.delegate = self
        self.title = "Go Live!"
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(funback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
        
        obj.txtbottomline(textfield: txttitle)
        obj.txtbottomline(textfield: txtdate)
        obj.txtbottomline(textfield: txttime)
        bgvDetails.layer.borderWidth = 1
        bgvDetails.layer.borderColor = appclr.cgColor
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func funback(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func funSelectDateTime(isTime: Bool) {
        
        let vc = DateTimePicker(nibName: "DateTimePicker", bundle: nil)
        vc.delegate = self
        vc.isTime = isTime
        vc.isPresent = false
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func funGoLive() {
        let url = BASEURL+"channel/\(NEWsChannelID)/Live"
        if btnSwitch.isOn {
            isLive = false
            isScheduleLater = true
        }
        let parameters : Parameters =
        ["UserId": USERID,
         "LiveTitle":txttitle.text!,
         "IsLive":isLive,
         "LiveOnDate":txtdate.text!,
         "LiveOnTime":txttime.text!,
         "ScheduleForLater":isScheduleLater]
        
        andicator.startAnimating()
        obj.webServicePutUpdateUser(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
              if error == nil && responseObject != nil {
                if (responseObject!.value(forKey: "data") as? Int) != nil {
                    let alert = UIAlertController(title: "Live!", message: "Successfully live", preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK", style: .default)
                    { (action) in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "funisLiveNotification"), object: nil)
                        self.funback()
                    }
                    alert.addAction(OK)
                    self.present(alert, animated: true)
                }
                else {
                    obj.showAlert(title: "Error!", message: "Error occured try again", viewController: self)
                }
            }
            else {
                if error == nil {
                    obj.showAlert(title: "Error!", message: ("error?.description"), viewController: self)
                    return
                }
                obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
            }
        })
    }

}


//MARK:- EXTENSION for Delegates
extension GoLive: UITextFieldDelegate, DateTimeDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.view.endEditing(true)
    }
    // Marks: - Return button delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK:- Date Time Delegates
    func selectedDateTime(selectedDateTime: String, isTime: Bool) {
        if isTime {
            txttime.text = selectedDateTime
        }
        else {
            txtdate.text = selectedDateTime
        }
    }
}
