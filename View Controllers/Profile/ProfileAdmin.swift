////
////  ProfileAdmin.swift
////  AMPL
////
////  Created by sameer on 11/07/2017 Anno Domini.
////  Copyright © 2017 sameer. All rights reserved.
////
//
import UIKit
//
class ProfileAdmin: UIViewController, UITextFieldDelegate, UITextViewDelegate,UIScrollViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate {
//
//    //MARK:- For Image Picker
    var imagePicker: UIImagePickerController!
    var popover = UIViewController()
    
    
    var userdetailid = String()
    var username = String()
    var request = String()
    var imgname = String()
    
    
    
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var lblpass: UILabel!
    @IBOutlet weak var lblfname: UILabel!
    @IBOutlet weak var lbllname: UILabel!
    @IBOutlet weak var lblgender: UILabel!
    @IBOutlet weak var lbldob: UILabel!
    @IBOutlet weak var lblcnic: UILabel!
    @IBOutlet weak var lblqulification: UILabel!
    @IBOutlet weak var lblfrofession: UILabel!
    @IBOutlet weak var lbladd: UILabel!
    @IBOutlet weak var lblcity: UILabel!
    @IBOutlet weak var lblstate: UILabel!
    @IBOutlet weak var lblcountry: UILabel!
    @IBOutlet weak var lbllandline: UILabel!
    @IBOutlet weak var lblmob: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var bgv: UIView!
    @IBOutlet weak var imgv: UIImageView!
    
    
    
    @IBOutlet weak var contentv: UIView!
    @IBOutlet weak var scrollv: UIScrollView!
    @IBOutlet weak var btnimg: UIButton!
    @IBOutlet weak var btnupload: UIButton!
    @IBOutlet weak var bgtop: UIView!
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Profile"
        //MARK:- Func call for get profile
        getprofile()
        
        imgv.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        self.bgtop.frame.origin.y = self.imgv.frame.maxY + 10
        self.bgv.frame.origin.y = self.bgtop.frame.maxY + 10
        self.bgv.frame.size.height = self.lblemail.frame.maxY + 60
        
        self.contentv.frame.size.height = self.bgv.frame.maxY
        var contentRect = CGRect()
        for view in self.scrollv.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.scrollv.contentSize = (contentRect.size )
    }

    
    @IBAction func btnimg(_ sender: Any) {
        return
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        vc.videoimagetag = IMAGE
        vc.videoimagename = imgname
        
        obj.funForceDownloadPlayShow(urlString: imagepath+imgname, isProgressBarShow: true, viewController: self, completion: {
            url in
            
            if url == ""{
                vc.profilepic = UIImage(named: "tempimg")!
            }
            else{
                vc.strurl = url!
            }
            //MARK:- Reload image row after download
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
   
    //MARK:- Upload Image Button
    @IBAction func btnupload(_ sender: Any) {
        showActionSheet(sender: sender)
    }
   
    //Open Action Sheet for Camera and Gallery
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
    
    //    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    //    {
    //        picker.dismiss(animated: true, completion: nil)
    //        imgViewTop.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    //    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imgv.image = image
            
            if imgv.image != nil
            {
                
            }
        }
        //        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //        {
        //            let headers: HTTPHeaders = [ "auth-token": "(profile_pic)" ]
        //            let URL = try! URLRequest(url: ContainerClass.returnBaseURL()+"uploadpic", method: .post, headers: headers)
        //
        //            Alamofire.upload(multipartFormData: { multipartFormData in
        //
        //                if let imageData = UIImageJPEGRepresentation(image, 1.0)
        //                {
        //                    self.activity.startAnimating()
        //
        //                    multipartFormData.append(imageData, withName: "profilepic", fileName: "picture.jpeg", mimeType: "image/jpeg")
        //
        //                    multipartFormData.append("8".data(using: .utf8)!, withName: "cid")
        //                }
        //            }, with: URL, encodingCompletion:
        //                {
        //                    encodingResult in
        //                    switch encodingResult
        //                    {
        //                    case .success(let upload, _, _):
        //                        upload.responseJSON { response in
        //                            print(response.result.value!)
        //                            debugPrint("SUCCESS RESPONSE: \(response)")
        //
        //                            self.imgViewTop.image = image
        //                            self.activity.stopAnimating()
        //                        }
        //                    case .failure(let encodingError):
        //                        // hide progressbas here
        //                        print("ERROR RESPONSE: \(encodingError)")
        //                    }
        //            })
        //        }
        //        else
        //        {
        //            print("Something went wrong")
        //        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil);
    }
    ///////////////////////////////////////////////////

    
    
    // Marks: - Get All Posts
    // Get Location Name from Latitude and Longitude
    func getprofile()
    {
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"user/\(userdetailid)?userId=\(userid)"
        //http://epoultryapi.zederp.net/api/user/35907?userId=35907
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:
            {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil
                    {
                        if responseObject!.count > 0
                        {
                            let tempdataDic = responseObject?.value(forKey: "Data") as! NSArray
                         
                           for temp in tempdataDic {
                               // dump(dict)
                               let dict = temp as! NSDictionary
                               if let FirstName = dict.value(forKey: "FirstName") as? String
                               {
                                   self.lblfname.text = FirstName
                               }
                               else
                               {
                                   self.lblfname.text = ""
                               }
                               if let LastName = dict.value(forKey: "LastName") as? String
                               {
                                   self.lbllname.text = LastName
                               }
                               else
                               {
                                   self.lbllname.text = ""
                               }
                               if let address = dict.value(forKey: "address") as? String
                               {
                                   self.lbladd.text = address
                               }
                               else
                               {
                                   self.lbladd.text = ""
                               }
                               if let City = dict.value(forKey: "City") as? String
                               {
                                   self.lblcity.text = City
                               }
                               else
                               {
                                   self.lblcity.text = ""
                               }
                               if let Province = dict.value(forKey: "Province") as? String
                               {
                                   self.lblstate.text = Province
                               }
                               else
                               {
                                   self.lblstate.text = ""
                               }
                               //
                               if let Country = dict.value(forKey: "Country") as? String
                               {
                                   self.lblcountry.text = Country
                               }
                               else
                               {
                                   self.lblcountry.text = ""
                               }
                               if let profile_img = dict.value(forKey: "profile_img") as? String
                               {
                                   self.imgname = profile_img
                                   let urlprofile = URL(string: userimagepath+profile_img)
                                   self.imgv.kf.setImage(with: urlprofile)
                               }
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

    func getprofileOld()
    {
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String
        {
            userid = tempid
        }
        else
        {
            userid = ""
        }
        
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetUserDetail xmlns='http://threepin.org/'><id>\(userdetailid)</id><userId>\(userid)</userId></GetUserDetail></soap:Body></soap:Envelope>"
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/Users.asmx"
        let theURL = URL(string: theUrlString)
        let mutableR = NSMutableURLRequest(url: theURL!)
        
        // MUTABLE REQUEST
        
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        andicator.startAnimating()
        
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            self.andicator.stopAnimating()
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                dictionaryData as NSDictionary
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetUserDetailResponse")! as Any) as AnyObject).object(forKey:"GetUserDetailResult")   ?? NSDictionary()
                
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
                    }
                    else
                    {
                        let json/*: [AnyObject]*/ = try JSONSerialization.jsonObject(with: text.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                        for dict in json {
                            // dump(dict)
                            
                            if let FirstName = dict.value(forKey: "FirstName") as? String
                            {
                                self.lblfname.text = FirstName
                            }
                            else
                            {
                                self.lblfname.text = ""
                            }
                            if let LastName = dict.value(forKey: "LastName") as? String
                            {
                                self.lbllname.text = LastName
                            }
                            else
                            {
                                self.lbllname.text = ""
                            }
                            if let address = dict.value(forKey: "address") as? String
                            {
                                self.lbladd.text = address
                            }
                            else
                            {
                                self.lbladd.text = ""
                            }
                            if let City = dict.value(forKey: "City") as? String
                            {
                                self.lblcity.text = City
                            }
                            else
                            {
                                self.lblcity.text = ""
                            }
                            if let Province = dict.value(forKey: "Province") as? String
                            {
                                self.lblstate.text = Province
                            }
                            else
                            {
                                self.lblstate.text = ""
                            }
                            //
                            if let Country = dict.value(forKey: "Country") as? String
                            {
                                self.lblcountry.text = Country
                            }
                            else
                            {
                                self.lblcountry.text = ""
                            }
                            if let profile_img = dict.value(forKey: "profile_img") as? String
                            {
                                self.imgname = profile_img
                                let urlprofile = URL(string: imagepath+profile_img)
                                self.imgv.kf.setImage(with: urlprofile)
                            }
                            
                            if let password = dict.value(forKey: "password") as? String
                            {
                                self.lblpass.text = password
                            }
                            else
                            {
                                self.lblpass.text = ""
                            }
                            
                            if let username = dict.value(forKey: "username") as? String
                            {
                                self.lblusername.text = username
                            }
                            else
                            {
                                self.lblusername.text = ""
                            }
                            
                            if let gender = dict.value(forKey: "gender") as? String
                            {
                                self.lblgender.text = gender
                            }
                            else
                            {
                                self.lblgender.text = ""
                            }
                            if let dob = dict.value(forKey: "dob") as? String
                            {
                                self.lbldob.text = dob
                            }
                            else
                            {
                                self.lbldob.text = ""
                            }
                            
                            if let CNIC = dict.value(forKey: "CNIC") as? Int
                            {
                                self.lblcnic.text = String(CNIC)
                            }
                            else
                            {
                                self.lblcnic.text = ""
                            }
                            if let Qualification = dict.value(forKey: "Qualification") as? String
                            {
                                self.lblqulification.text = String(Qualification)
                            }
                            else
                            {
                                self.lblqulification.text = ""
                            }
                            
                            if let Profession = dict.value(forKey: "Profession") as? String
                            {
                                self.lblfrofession.text = String(Profession)
                            }
                            else
                            {
                                self.lblfrofession.text = ""
                            }
                            if let ContactNo = dict.value(forKey: "ContactNo") as? String
                            {
                                self.lbllandline.text = String(ContactNo)
                            }
                            else
                            {
                                self.lbllandline.text = ""
                            }
                            if let mobile = dict.value(forKey: "mobile") as? String
                            {
                                self.lblmob.text = String(mobile)
                            }
                            else
                            {
                                self.lblmob.text = ""
                            }
                            if let email = dict.value(forKey: "email") as? String
                            {
                                self.lblemail.text = String(email)
                            }
                            else
                            {
                                self.lblemail.text = ""
                            }
                            
                        }
                    }
                }
                else{
                    obj.showAlert(title: "Alert", message: "try again", viewController: self)
                }
                
            }
            catch
            {
                print("Your Dictionary value nil")
            }
            if error != nil
            {
                self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
    }

    
    
}

//// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

