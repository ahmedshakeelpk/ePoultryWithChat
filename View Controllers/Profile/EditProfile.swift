//
//  EditProfile.swift
//  ePoltry
//
//  Created by MacBook Pro on 18/10/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import Alamofire

class EditProfile: UIViewController, UITextFieldDelegate {

    var dataDic = NSMutableDictionary()
    
    
    @IBOutlet weak var contentv: UIView!
    @IBOutlet weak var scrollv: UIScrollView!
    
    @IBOutlet weak var txtdesignation: UITextField!
    @IBOutlet weak var txtfname: UITextField!
    @IBOutlet weak var txtlname: UITextField!
    @IBOutlet weak var txtusername: UITextField!
    @IBOutlet weak var txtpass: UITextField!
    @IBOutlet weak var txtcpass: UITextField!
    
  
    @IBOutlet weak var lblgender: UILabel!
    @IBOutlet weak var lblmale: UILabel!
    @IBOutlet weak var lblfemale: UILabel!
    @IBOutlet weak var imgvmale: UIImageView!
    @IBOutlet weak var imgvfemale: UIImageView!
    @IBOutlet weak var btnmale: UIButton!
    @IBOutlet weak var btnfemale: UIButton!
    @IBOutlet weak var lbldob: UILabel!
    @IBOutlet weak var txtdob: UITextField!
    @IBOutlet weak var btndob: UIButton!
    @IBOutlet weak var txtqualifiation: UITextField!
    @IBOutlet weak var txtprofession: UITextField!
    @IBOutlet weak var txtaddress: UITextField!
    @IBOutlet weak var txtcity: UITextField!
    @IBOutlet weak var txtlandline: UITextField!
    @IBOutlet weak var txtmobile: UITextField!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var btnupdate: UIButton!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    
    @IBAction func btnupdate(_ sender: UIButton){
        if btnmale.tag == 0 && btnfemale.tag == 0{
            obj.showAlert(title: "Alert!", message: "Please select gender", viewController: self)
            return
        }
        else if !obj.isValidEmail(testStr: txtemail.text!) && txtemail.text! != ""{
            obj.showAlert(title: "Alert!", message: "Please enter valid email", viewController: self)
            return
        }
       updateProfile()
    }
    @IBAction func btnmale(_ sender: UIButton){
        imgvmale.backgroundColor = appclr
        imgvfemale.backgroundColor = .lightGray
        btnmale.tag = 1
        btnfemale.tag = 0
    }
    @IBAction func btnfemale(_ sender: UIButton){
        imgvmale.backgroundColor = .lightGray
        imgvfemale.backgroundColor = appclr
        btnmale.tag = 0
        btnfemale.tag = 1
    }
    @IBAction func btndob(_ sender: UIButton){
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //MARK:- Navigation Title Multilines
        obj.navigationTwoLineTitle(topline: "ePoultry", bottomline: "Smart Poultry System", viewcontroller: self)
        
        self.contentv.frame.size.height = self.btnupdate.frame.maxY + 50
        var contentRect = CGRect()
        for view in self.scrollv.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.scrollv.contentSize = (contentRect.size )
        
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
        
        imgvmale.layer.cornerRadius = imgvmale.frame.height / 2
        imgvfemale.layer.cornerRadius = imgvfemale.frame.height / 2
        
        self.BottomLineofTextFields()
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        txtdesignation.text = dataDic.value(forKey: "FirstName") as? String ?? ""
        txtfname.text = dataDic.value(forKey: "FirstName") as? String ?? ""
        txtlname.text = dataDic.value(forKey: "LastName") as? String ?? ""
        txtusername.text = dataDic.value(forKey: "username") as? String ?? ""
        if let temp = dataDic.value(forKey: "gender") as? String{
            if temp != "" {
                if temp == "male" {
                    imgvmale.backgroundColor = appclr
                    imgvfemale.backgroundColor = .lightGray
                    btnmale.tag = 1
                    btnfemale.tag = 0
                }
                else {
                    imgvmale.backgroundColor = .lightGray
                    imgvfemale.backgroundColor = appclr
                    btnmale.tag = 0
                    btnfemale.tag = 1
                }
            }
        }
        txtdob.text = dataDic.value(forKey: "dob") as? String ?? ""
        //CNIC
        txtqualifiation.text = dataDic.value(forKey: "Qualification") as? String ?? ""
        txtprofession.text = dataDic.value(forKey: "Profession") as? String ?? ""
        txtaddress.text = dataDic.value(forKey: "address") as? String ?? ""
        txtcity.text = dataDic.value(forKey: "City") as? String ?? ""
        //Province   // State / Provance / Region
        //Country
        txtlandline.text = dataDic.value(forKey: "ContactNo") as? String ?? ""
        txtmobile.text = dataDic.value(forKey: "mobile") as? String ?? ""
        txtemail.text = dataDic.value(forKey: "email") as? String ?? ""
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        self.contentv.autoresizesSubviews = false
        self.contentv.frame.size.height = self.btnupdate.frame.maxY + 300
        var contentRect = CGRect()
        for view in self.scrollv.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.scrollv.contentSize = (contentRect.size )
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        self.contentv.frame.size.height = self.btnupdate.frame.maxY + 50
        var contentRect = CGRect()
        for view in self.scrollv.subviews {
            contentRect = contentRect.union(view.frame)
        }
        DispatchQueue.main.async {
            self.scrollv.contentSize = (contentRect.size )
        }
    }
    
    @objc func btnback() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func BottomLineofTextFields(){
        // Marks: - Buttons Cornor Radius
        btnupdate.layer.cornerRadius = 4
        
        // Marks: - text field border width and colotd
        obj.txtbottomline(textfield: txtdesignation)
        obj.txtbottomline(textfield: txtfname)
        obj.txtbottomline(textfield: txtlname)
        obj.txtbottomline(textfield: txtusername)
        obj.txtbottomline(textfield: txtpass)
        obj.txtbottomline(textfield: txtcpass)
        obj.txtbottomline(textfield: txtdob)
        obj.txtbottomline(textfield: txtqualifiation)
        obj.txtbottomline(textfield: txtprofession)
        obj.txtbottomline(textfield: txtaddress)
        obj.txtbottomline(textfield: txtcity)
        obj.txtbottomline(textfield: txtlandline)
        obj.txtbottomline(textfield: txtmobile)
        obj.txtbottomline(textfield: txtemail)
        
        txtdesignation.delegate = self
        txtfname.delegate = self
        txtlname.delegate = self
        txtpass.delegate = self
        txtcpass.delegate = self
        txtdob.delegate = self
        txtqualifiation.delegate = self
        txtprofession.delegate = self
        txtaddress.delegate = self
        txtlandline.delegate = self
        txtmobile.delegate = self
        txtemail.delegate = self
    }

    // Marks: - Uitextfields delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    func updateProfile() {
        let userid = defaults.value(forKey: "userid") as! String
        //Doct Amjad Sahab no 03008507407
         //Doct Amjad Sahab ID userid = "5077
        let url = BASEURL+"user/\(userid)"
       
        var gender = "male"
        if btnfemale.tag == 1{
            gender = "female"
        }
        
        let parameters : Parameters =
            ["username":txtusername.text!,
             "FirstName":txtfname.text!,
             "LastName":txtlname.text!,
             "gender":gender,
             "dob":txtdob.text!,
             "CNIC":"",
             "Qualification":txtqualifiation.text!,
             "Profession":txtprofession.text!,
             "address":txtaddress.text!,
             "City":txtcity.text!,
             "Province":"",
             "Country":"",
             "ContactNo":txtlandline.text!,
             "mobile":txtmobile.text!,
             "email":txtemail.text!]
        
        andicator.startAnimating()
        obj.webServicePutUpdateUser(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            if error == nil && responseObject != nil {
                if responseObject?.value(forKey: "data") as? Int == 1 {
                    let alert = UIAlertController(title: "Success!", message: "Profile update successfully...!", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    { (action) in
                        self.btnback()
                    }
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true)
                }
                else {
                    obj.showAlert(title: "Alert!", message: "Error! Try again", viewController: self)
                }
            }
            else
            {
                if error == nil
                {
                    obj.showAlert(title: "Alert!", message: "Error! Try again", viewController: self)
                }
            }
        })
    }

}
