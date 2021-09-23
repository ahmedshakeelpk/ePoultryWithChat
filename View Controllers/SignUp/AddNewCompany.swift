//
//  AddNewCompany.swift
//  ePoltry
//
//  Created by MacBook Pro on 26/09/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import Alamofire

class AddNewCompany: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate {

    var phonenumber = ""
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var bgvAddCompany: UIView!
    @IBOutlet weak var txtAddCompanyName: PaddingTextField!
    @IBOutlet weak var txtAddCity: PaddingTextField!
    @IBOutlet weak var txtAddAddress: PaddingTextField!
    @IBOutlet weak var txtAddSelect: PaddingTextField!
    @IBOutlet weak var btnAddSelect: UIButton!
    @IBAction func btnAddSelect(_ sender: Any) {
        //MARK:- Add Company
        if arrSubCId.count == 0{
            obj.showAlert(title: "Alert!", message: "Please wait to upload categories", viewController: self)
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCompany") as! AddCompany
        
        vc.isAddCompany = false
        
        vc.arrSubCName = arrSubCName
        vc.arrSubCId = arrSubCId
        vc.arrSubIcon = arrSubIcon
        vc.arrSubIsActive = arrSubIsActive
        vc.arrSubOldId = arrSubOldId
        vc.arrSubType = arrSubType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var txtlandlineno: PaddingTextField!
    @IBOutlet weak var txtemail: PaddingTextField!
    @IBOutlet weak var txtwebsite: PaddingTextField!
    
    @IBOutlet weak var btnselectlogo: UIButton!
    @IBAction func btnselectlogo(_ sender: Any) {
        showActionSheet(sender: sender)
    }
    @IBOutlet weak var imgvlogo: UIImageView!
    @IBOutlet weak var btnAddCancel: UIButton!
    @IBAction func btnAddCancel(_ sender: Any) {
        bgvAddCompany.isHidden = true
        self.view.endEditing(true)
    }
    @IBOutlet weak var btnAddSubmit: UIButton!
    @IBAction func btnAddSubmit(_ sender: Any) {
        if txtAddCompanyName.text == ""{
            obj.showAlert(title: "Alert!", message: "Please enter company name", viewController: self)
        }
        else if txtAddCity.text == ""{
            obj.showAlert(title: "Alert!", message: "Please enter city", viewController: self)
        }
        else if txtAddAddress.text == ""{
            obj.showAlert(title: "Alert!", message: "Please enter address", viewController: self)
        }
        else if txtAddSelect.text == ""{
            obj.showAlert(title: "Alert!", message: "Please select company category", viewController: self)
        }
        else{
            if imgvlogo.image != nil{
                let imageData: NSData = imgvlogo.image!.jpegData(compressionQuality: 0.4)! as NSData
                uploadMedia(type: "IMAGE", object: imageData, completion: { filename in
                    
                    guard let filename = filename else { return }
                    self.funAddCompany(imgulr: filename)
                })
            }
            else{
                funAddCompany(imgulr: "")
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.obj.txtbottomline(textfield: txtAddCompanyName)
        self.title = "Add New Company"
        DispatchQueue.main.async {
            obj.txtbottomline(textfield: self.txtAddCity)
            obj.txtbottomline(textfield: self.txtAddAddress)
            obj.txtbottomline(textfield: self.txtAddSelect)
            obj.txtbottomline(textfield: self.txtAddCompanyName)
            obj.txtbottomline(textfield: self.txtlandlineno)
            obj.txtbottomline(textfield: self.txtemail)
            obj.txtbottomline(textfield: self.txtwebsite)
            
            self.bgvAddCompany.layer.cornerRadius = 3
            self.bgvAddCompany.layer.borderColor = appclr.cgColor
            self.bgvAddCompany.layer.borderWidth = 1
            obj.setViewShade(view: self.bgvAddCompany)
            NotificationCenter.default.addObserver(self, selector: #selector(self.funSelectCompany), name: NSNotification.Name(rawValue: "selectCompany"), object: nil)
            obj.cornorRadiusOneSide(object: self.btnAddCancel, side: .topRight)
            obj.cornorRadiusOneSide(object: self.btnAddSubmit, side: .topLeft)
        }
    }
    
    func funAddCompany(imgulr: String)
    {
        updatetxtAddSelectCompanyName = txtAddSelect.text!
        updatetxtAddCity = txtAddCity.text!
        updatetxtemail = txtemail.text!
        updatetxtAddAddress = txtAddAddress.text!
        updatetxtwebsite = txtwebsite.text!
        updatephonenumber = phonenumber
        updatelogoUrl = imgulr
        
        let url = BASEURL+"/company"
        let parameters : Parameters =
            ["company":updatetxtAddSelectCompanyName,
             "city": updatetxtAddCity,
             "subCategory": tempAddCompanySubCategory,
             "subCategoryId": tempAddCompanySubCategoryId,
             "email":updatetxtemail,
             "address":updatetxtAddAddress,
             "web": updatetxtwebsite,
             "logo": updatelogoUrl,
             "defaultUser":"0",
             "phone":updatephonenumber,
             "createdby":updatephonenumber]
        
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
            if error == nil && responseObject != nil
            {
                if responseObject?.value(forKey: "success") as! String == "true"
                {
                    let dataarr = responseObject?.value(forKey: "data") as! NSArray
                    let tempcompid = "\((dataarr[0] as! NSDictionary).value(forKey: "company_id") as! Int)"
                    var datadic = [String: AnyObject]()
                    datadic = [
                        "isAddCompany" : true,
                        "isAddNewCompany": true,
                        "name" : self.txtAddCompanyName.text!,
                        "company": tempAddCompanySubCategory,
                        "companyid": tempcompid] as [String : AnyObject]
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectCompany"), object: datadic)
                    let alertController = UIAlertController(title:"Alert!", message: responseObject!.value(forKey: "message") as? String, preferredStyle:.alert)
                    
                    let Action = UIAlertAction.init(title: "Ok", style: .default) { (UIAlertAction) in
                        // Write Your code Here
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(Action)
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    obj.showAlert(title: "Alert!", message: responseObject?.value(forKey: "message") as! String, viewController: self)
                }
            }
            else
            {
                if error == nil
                {
                    obj.showAlert(title: "Error!", message: ("error?.description"), viewController: self)
                    return
                }
                obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
            }
        })
    }
    @objc func funSelectCompany(notification: Notification)
    {
        let datadic = notification.object as! NSDictionary
        let isAddCompany = datadic.value(forKey: "isAddCompany") as! Bool
        if isAddCompany {
            
        }
        else{
            //MARK:- ADD new company
            txtAddSelect.text = datadic.value(forKey: "name") as? String ?? ""
            tempAddCompanySubCategory = datadic.value(forKey: "name") as? String ?? ""
            tempAddCompanySubCategoryId = "\(datadic.value(forKey: "id") as! Int)"
        }
        
        
        //        if isAddCompany{
        //            datadic = ["isAddCompany" : isAddCompany,
        //                       "address": arrCAddress[index],
        //                       "city": arrCCity[index],
        //                       "name": arrCSubCategory[index],
        //                       "company": arrCCompany[index],
        //                       "companyid": arrCCompanyId[index]]
        //        }
        //        else{
        //            datadic = ["isAddCompany" : isAddCompany,
        //                       "name" : arrSubCName[index],
        //                       "id": arrSubCId[index],
        //                       "icon": arrSubIcon[index],
        //                       "isactive": arrSubIsActive[index],
        //                       "oldid": arrSubOldId[index],
        //                       "type": arrSubType[index]]
        //        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //Open Action Sheet for Camera and Gallery
    var imagePicker: UIImagePickerController!
    func showActionSheet(sender: Any)
    {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.OpenCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.OpenGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        imagePicker?.delegate = self
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func OpenCamera()
    {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    func OpenGallary()
    {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// what app will do when user choose & complete the selection image :
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        /// chcek if you can return edited image that user choose it if user already edit it(crop it), return it as image
        if let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            
            /// if user update it and already got it , just return it to 'self.imgView.image'
            self.imgvlogo.image = editedImage
            
            /// else if you could't find the edited image that means user select original image same is it without editing .
        } else if let orginalImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            /// if user update it and already got it , just return it to 'self.imgView.image'.
            self.imgvlogo.image = orginalImage
        }
        else { print ("error") }
        /// if the request successfully done just dismiss
        picker.dismiss(animated: true, completion: nil)
    }
    //MARK:- Upload image or file to Firebase Storage
    func uploadMedia(type: String, object: NSData, completion: @escaping (_ url: String?) -> Void) {
        
        let uploadData = object
        var imgdata = Data()
        var videodatatemp = Data()
        var videofilename = String()
        let timespam = Date().currentTimeMillis()!
        var url = ""
        var imagefilename = ""
        var parameters : Parameters = ["":""]
        if type == "IMAGE"
        {
            imgdata = uploadData as Data
            imagefilename = "\("\(String(describing: timespam))").png"
            parameters = ["filename":imagefilename]
            url = BASEURL + "Upload/Post?filename=\(imagefilename)"
        }
        else if type == "VIDEO"
        {
            videodatatemp = imgdata as Data
            imgdata = uploadData as Data
            imagefilename = "\("\(String(describing: timespam))").png"
            videofilename = "\("\(String(describing: timespam))")video.mp4"
            url = BASEURL + "Upload/PostVideo?videofilename=\(videofilename)&filename=\(imagefilename)"
            parameters = ["filename":imagefilename, "videofilename": videofilename]
        }
        
        andicator.startAnimating()
        obj.webServiceWithPictureAudio(url: url, parameters: parameters, imagefilename: imagefilename, audiofilename:"" , videofilename: videofilename, imageData: imgdata, audioData: Data(), videoData: videodatatemp, viewController: self, completionHandler:{
            
            responseObject, error in
            self.andicator.stopAnimating()
            if error == nil
            {
                if type == "VIDEO"
                {
                    let tmepname = "\(imagefilename),\(videofilename)"
                    completion(tmepname)
                }else{
                    completion(imagefilename)
                }
            }
            else
            {
                completion("error")
            }
        })
    }
}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}


var tempAddCompanySubCategory = ""
var tempAddCompanySubCategoryId = ""
var updateCompanyId = ""
var updatelogoUrl = ""
var updatetxtAddSelectCompanyName = ""
var updatetxtAddCity = ""
var updatetxtemail = ""
var updatetxtAddAddress = ""
var updatetxtwebsite = ""
var updatephonenumber = ""
var updatedefaultUser = ""
func funUpdateCompany(viewController: UIViewController)
{
    
    let url = BASEURL+"/company/\(updateCompanyId)/changeAdmin?defaultUser=\(updatedefaultUser)&createdBy=\(updatephonenumber)"
    let parameters : Parameters =
        ["":""]
    
    obj.webServicePutUpdateUser(url: url, parameters: parameters, completionHandler:{ responseObject, error in
        if error == nil && responseObject != nil
        {
            if responseObject?.value(forKey: "success") as! String == "true"
            {
                
            }
            else {
                
            }
        }
        else
        {
            if error == nil
            {
                
            }
           
        }
    })
}
