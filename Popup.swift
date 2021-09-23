//
//  Popup.swift
//  ZedChat
//
//  Created by MacBook Pro on 13/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

protocol PopupDelegate : class {
    func btnConfirmPressed(code: String)
}

class Popup: UIViewController, UITextFieldDelegate {

    weak var popupDelegate: PopupDelegate?

    var countertotaltime = 120
    var viewController = UIViewController()
    var timerremeaningtime = Timer()
    @IBOutlet weak var vpopup: UIView!
    @IBOutlet weak var lblverificationcode: UILabel!
    @IBOutlet weak var txtverificationcode: UITextField!
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var btnconfirm: UIButton!
    
    
    @IBAction func btnconfirm(_ sender: Any) {
        if txtverificationcode.text?.isEmpty == true
        {
            obj.funValidationfromBottom(sender: txtverificationcode, text: "Please enter verification code", view: vpopup)
        }
        else
        {
            andicator.startAnimating()
            popupDelegate?.btnConfirmPressed(code: txtverificationcode.text!)
        }
    }
    @IBAction func btncancel(_ sender: Any) {
        objG.removeVerificationPopup()
    }
    @IBOutlet weak var btnclose: UIButton!
    @IBAction func btnclose(_ sender: Any) {
    }
    @IBOutlet weak var lbltitle: UILabel!
    
    @IBOutlet weak var vbgtitlelabel: UIView!
    
    @IBOutlet weak var lbltimer: UILabel!
    
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    override func viewWillDisappear(_ animated: Bool) {
        timerremeaningtime.invalidate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtverificationcode.delegate = self
        obj.txtbottomline(textfield: txtverificationcode)
        obj.setViewShade(view: vpopup)
        txtverificationcode.delegate = self
        btncancel.layer.cornerRadius = 4
        btnconfirm.layer.cornerRadius = 4
        
        //Start timer to get driver location for map
        self.timerremeaningtime = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(self.funremeaningtime), userInfo: nil, repeats: true)
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(funStopAndicator), name: NSNotification.Name(rawValue: "stopandicator"), object: nil)
    }
    //MARK:- Stop Andicator
    @objc func funStopAndicator()
    {
        andicator.stopAnimating()
    }

    //MARK:- Function for show timer how many second remeaning
    @objc func funremeaningtime()
    {
        if countertotaltime <= 0
        {
            timerremeaningtime.invalidate()
            countertotaltime = 0
            objG.removeVerificationPopup()
        }
        else
        {
            countertotaltime = countertotaltime - 1
            //Human Language timer calling
            funhmsFrom(seconds: countertotaltime) { hours, minutes, seconds in
                
                //let hours = self.getStringFrom(seconds: hours)
                let minutes = self.getStringFrom(seconds: minutes)
                let seconds = self.getStringFrom(seconds: seconds)
                
                //self.lbltime.text = "\(hours):\(minutes):\(seconds)"
                if minutes == "1"
                {
                    self.lbltimer.text = "\(minutes) minute, \(seconds) sec remeaning"
                }
                else
                {
                    self.lbltimer.text = "\(seconds) sec remeaning"
                }
                let progress = (Float((Int(self.countertotaltime)))/Float(120))
                self.progressbar.setProgress(Float(progress), animated:true)
                
                //print("\(hours):\(minutes):\(seconds)")
            }
        }
    }
    
    //MARK:- Timer show in human language 00:01:23 etc like this
    func funhmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    //MARK:- Timer show in human language 00:01:23 etc like this
    func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "\(seconds)" : "\(seconds)"
    }//End Human language timer
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        eview.dismiss()
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 6
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        eview.dismiss()
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eview.dismiss()
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        eview.dismiss()
    }
    
}
