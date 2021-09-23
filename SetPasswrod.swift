//
//  SetPasswrod.swift
//  sChat
//
//  Created by MacBook Pro on 31/07/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class SetPasswrod: UIViewController {
    var statusbarColor = UIColor()
    
    @IBOutlet weak var btnsetPass: UIButton!
    @IBAction func btnsetPass(_ sender: Any) {
        
        // funEnterNewPasswordScreen(viewController: self)
        // funLockScreen(viewController: self, isCancelButton: true, type: "new")
        self.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setPassword"), object: nil)
        }
    }
    @IBOutlet weak var btncancel: UIButton!
    @IBAction func btncancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var btnDontShow: UIButton!
    @IBAction func btnDontShow(_ sender: Any) {
        defaults.setValue("1", forKey: "DontShowAppLock")
        self.dismiss(animated: true, completion: nil)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        btncancel.layer.cornerRadius = 4
        btncancel.layer.borderColor = UIColor.white.cgColor
        btncancel.layer.borderWidth = 1
        
        btnsetPass.layer.cornerRadius = 4
        btnsetPass.layer.borderColor = UIColor.white.cgColor
        btnsetPass.layer.borderWidth = 1
        
        btnDontShow.layer.cornerRadius = 4
        btnDontShow.layer.borderColor = UIColor.white.cgColor
        btnDontShow.layer.borderWidth = 1
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
