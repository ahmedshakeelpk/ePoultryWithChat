//
//  Profile.swift
//  AMPL
//
//  Created by sameer on 04/06/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit
import Alamofire

class Profile: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        let allkeys = dataDic.allKeys
        let allvalues = dataDic.allValues
        cell.lblkey.numberOfLines = 0
        cell.lblkey.lineBreakMode = .byWordWrapping
        cell.lblvalue.numberOfLines = 0
        cell.lblvalue.lineBreakMode = .byWordWrapping
        cell.lblkey.text = allkeys[indexPath.row] as? String ?? ""
        cell.lblvalue.text = ":\t\(allvalues[indexPath.row] as? String ?? "")"
        cell.lblkey.sizeToFit()
        cell.lblvalue.sizeToFit()
        
        return cell
    }

    var dataDic = NSMutableDictionary()
    var dataDicEditProfile = NSMutableDictionary()
    //MARK:- For Image Picker
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var vheader: UIView!
    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var btnupdateProfilePicture: UIButton!
    @IBAction func btnupdateProfilePicture(_ sender: Any) {
        showActionSheet(sender: sender)
    }
    override func viewDidLoad() {
        

        // Do any additional setup after loading the view.
        funGetUserProfile()
        if IPAD{
            vheader.frame.size.height = vheader.frame.size.height*1.4
        }
        
        self.tablev.tableHeaderView = vheader
        self.tablev.tableFooterView = UIView()
        self.tablev.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        self.tablev.delegate = self
        self.tablev.dataSource = self
        //MARK:- Navigation Title Multilines
        obj.navigationTwoLineTitle(topline: "ePoultry", bottomline: "Smart Poultry System", viewcontroller: self)
               
               // Marks: - Left button multiple
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)

        super.viewDidLoad()
    }
    
    @objc func btnback(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func btnEdit(){
         let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "EditProfile") as! EditProfile
        vc.dataDic = dataDicEditProfile
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Get Location Name from Latitude and Longitude
    func funGetUserProfile() {
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"user/\(userid)?userId=\(userid)"
        //http://epoultryapi.zederp.net/api/user/35907?userId=35907
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let tempdataDic = (responseObject?.value(forKey: "Data") as! NSArray)[0] as! NSMutableDictionary
                            self.dataDicEditProfile = tempdataDic
                            let url = NSURL(string: USER_IMAGE_PATH + (tempdataDic.value(forKey: "profile_img") as? String ?? ""))
                            self.imgvprofile.kf.setImage(with: url! as URL) { result in
                                switch result {
                                case .success(let value):
                                   // print("Image: \(value.image). Got from: \(value.cacheType)")
                                    self.imgvprofile.image = value.image
                                case .failure(let error):
                                   // print("Error: \(error)")
                                    self.imgvprofile.image = UIImage(named: "user")!
                                }
                            }
                            
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.btnEdit))
                            self.btnupdateProfilePicture.isHidden = false
                            self.dataDic = [
                                //"Username":"\(tempdataDic.value(forKey: "username") as? String ?? "")",
                                "Company": "\(tempdataDic.value(forKey: "company") as? String ?? "")",
                                "First Name":"\(tempdataDic.value(forKey: "FirstName") as? String ?? "")",
                                "Last Name":"\(tempdataDic.value(forKey: "LastName") as? String ?? "")",
                                "Gender":"\(tempdataDic.value(forKey: "gender") as? String ?? "")",
                                "Date of Birth":"\(tempdataDic.value(forKey: "dob") as? String ?? "")",
                                //"CNIC No":"\(tempdataDic.value(forKey: "CNIC") as? String ?? "")",
                                //"Qulification":"\(tempdataDic.value(forKey: "Qualification") as? String ?? "")",
                                "Profession":"\(tempdataDic.value(forKey: "Profession") as? String ?? "")",
                                "Address":"\(tempdataDic.value(forKey: "address") as? String ?? "")",
                                "City / Town":"\(tempdataDic.value(forKey: "City") as? String ?? "")",
                                "State / Provance / Region":"\(tempdataDic.value(forKey: "Province") as? String ?? "")",
                                //"Country":"\(tempdataDic.value(forKey: "Country") as? String ?? "")",
                                "Contact No (Landline)":"\(tempdataDic.value(forKey: "ContactNo") as? String ?? "")",
                                "Mobile No":"\(tempdataDic.value(forKey: "mobile") as? String ?? "")",
                                "Email":"\(tempdataDic.value(forKey: "email") as? String ?? "")"]
                            //print(self.dataDic)
                            self.tablev.reloadData()
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
    
    //Open Action Sheet for Camera and Gallery
    func showActionSheet(sender: Any) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.OpenCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.OpenGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
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
    
    func OpenCamera() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    func OpenGallary() {
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
            self.imgvprofile.image = editedImage
            
            /// else if you could't find the edited image that means user select original image same is it without editing .
        } else if let orginalImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            /// if user update it and already got it , just return it to 'self.imgView.image'.
            self.imgvprofile.image = orginalImage
            let imageData: NSData = self.imgvprofile.image!.jpegData(compressionQuality: 0.4)! as NSData
            uploadMedia(type: "IMAGE", object: imageData, completion: { filename in
               // guard let filename = filename else { return }
                // print(filename)

            })
        }
        else { print ("error") }
        
        /// if the request successfully done just dismiss
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK:- Upload image or file to Firebase Storage
    func uploadMedia(type: String, object: NSData, completion: @escaping (_ url: String?) -> Void) {
        let uploadData = object
        var imgdata = Data()
        let timespam = Date().currentTimeMillis()!
        var url = ""
        var filename = ""
        var parameters : Parameters = ["":""]
        if type == "IMAGE" {
            imgdata = uploadData as Data
            filename = "\("\(String(describing: timespam))").png"
            parameters = ["":""]
            url = BASEURL+"ProfileImage/\(defaults.value(forKey: "userid") as! String)/?fileName=\(filename)"
        }
        andicator.startAnimating()
        obj.webServiceWithProfilePicture(url: userimagepathPost, parameters: parameters, imagefilename: filename, audiofilename:"" , videofilename: "", imageData: imgdata, audioData: Data(), videoData: Data(), viewController: self, completionHandler:{
            
            responseObject, error in
            self.andicator.stopAnimating()
            if error == nil || error == "success" {
                self.uploadPictureDataBase(fileName: filename, type: "IMAGE", object: NSData(), completion: { filename in
                   // guard let filename = filename else { return }
                    // print(filename)
                    completion(filename)

                })
            }
            else {
                completion("error")
            }
        })
    }
    //MARK:- Upload image or file to Firebase Storage
    func uploadPictureDataBase(fileName: String, type: String, object: NSData, completion: @escaping (_ url: String?) -> Void) {
        var url = ""
        var parameters : Parameters = ["":""]
        if type == "IMAGE" {
            parameters = ["":""]
            url = BASEURL+"ProfileImage/\(defaults.value(forKey: "userid") as! String)/?fileName=\(fileName)"
        }
        andicator.startAnimating()
        obj.webServiceWithPictureAudio(url: url, parameters: parameters, imagefilename: fileName, audiofilename:"" , videofilename: "", imageData: Data(), audioData: Data(), videoData: Data(), viewController: self, completionHandler:{
            
            responseObject, error in
            self.andicator.stopAnimating()
            if error == nil || error == "success" {
                completion(fileName)
            }
            else {
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
