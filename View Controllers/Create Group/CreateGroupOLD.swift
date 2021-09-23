//////
//////  CreateGroup.swift
//////  AMPL
//////
//////  Created by sameer on 09/06/2017 Anno Domini.
//////  Copyright © 2017 sameer. All rights reserved.
//////
////
//import UIKit
//
//class CreateGroupOLD.swift: UIViewController, UIImagePickerControllerDelegate,
//UINavigationControllerDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate, UITextViewDelegate {
//
//    
//    //Image Picker
//    var imagePicker: UIImagePickerController!
//    var popover = UIViewController()
//
//    /////////////////////////
//    var memberid = String()
//    var type = String()
//    
//    ////////////////////////////////////////////////////
//    @IBOutlet weak var txttitle: UITextField!
//    @IBOutlet weak var btnuploadimg: UIButton!
//    @IBOutlet weak var btncreate: UIButton!
//    @IBOutlet weak var imgv: UIImageView!
//    
//    @IBOutlet weak var btncancel: UIButton!
//    
//    
//    ///////////////////////////////////////////////////
//    override func viewDidLoad() {
//        //super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        
//         imgv.layer.cornerRadius = imgv.frame.width / 2
//    }
//    
//    // Marks: - button Upload Image
//    @IBAction func btnuploadimg(_ sender: Any) {
//        showActionSheet(sender:sender)
//    }
//    
//    // Marks: - button Create Group
//    @IBAction func btncreate(_ sender: Any) {
//        
//    }
//    
//    // Marks: - button Cancel image
//    @IBAction func btncancel(_ sender: Any) {
//        btncancel.isHidden = true
//        imgv.image = nil
//    }
//    
//    
/////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    //Open Action Sheet for Camera and Gallery
//    func showActionSheet(sender: Any)
//    {
//        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
//        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
//        {
//            UIAlertAction in
//            self.OpenCamera()
//        }
//        let gallaryAction = UIAlertAction(title: "Photo Gallery", style: UIAlertAction.Style.default)
//        {
//            UIAlertAction in
//            self.OpenGallary()
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
//        {
//            UIAlertAction in
//        }
//        // Add the actions
//        imagePicker?.delegate = self
//        
//        
//            alert.addAction(cameraAction)
//            alert.addAction(gallaryAction)
//        
//        alert.addAction(cancelAction)
//        // Present the controller
//        
//        switch UIDevice.current.userInterfaceIdiom {
//        case .pad:
//            alert.popoverPresentationController?.sourceView = sender as? UIView
//            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
//            alert.popoverPresentationController?.permittedArrowDirections = .up
//        default:
//            break
//        }
//        
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    func OpenCamera()
//    {
//        imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        
//        imagePicker.sourceType = .camera
//        present(imagePicker, animated: true, completion: nil)
//    }
//    func OpenGallary()
//    {
//        imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
//    }
//    
//    //    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
//    //    {
//    //        picker.dismiss(animated: true, completion: nil)
//    //        imgViewTop.image=info[UIImagePickerControllerOriginalImage] as? UIImage
//    //    }
//    
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
//    {
//// Local variable inserted by Swift 4.2 migrator.
//let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//        
//        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
//        {
//            imgv.image = image
//            btncancel.isHidden = false
//        }
//        
//        
//        //        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        //        {
//        //            let headers: HTTPHeaders = [ "auth-token": "(profile_pic)" ]
//        //            let URL = try! URLRequest(url: ContainerClass.returnBaseURL()+"uploadpic", method: .post, headers: headers)
//        //
//        //            Alamofire.upload(multipartFormData: { multipartFormData in
//        //
//        //                if let imageData = UIImageJPEGRepresentation(image, 1.0)
//        //                {
//        //                    self.activity.startAnimating()
//        //
//        //                    multipartFormData.append(imageData, withName: "profilepic", fileName: "picture.jpeg", mimeType: "image/jpeg")
//        //
//        //                    multipartFormData.append("8".data(using: .utf8)!, withName: "cid")
//        //                }
//        //            }, with: URL, encodingCompletion:
//        //                {
//        //                    encodingResult in
//        //                    switch encodingResult
//        //                    {
//        //                    case .success(let upload, _, _):
//        //                        upload.responseJSON { response in
//        //                            print(response.result.value!)
//        //                            debugPrint("SUCCESS RESPONSE: \(response)")
//        //
//        //                            self.imgViewTop.image = image
//        //                            self.activity.stopAnimating()
//        //                        }
//        //                    case .failure(let encodingError):
//        //                        // hide progressbas here
//        //                        print("ERROR RESPONSE: \(encodingError)")
//        //                    }
//        //            })
//        //        }
//        //        else
//        //        {
//        //            print("Something went wrong")
//        //        }
//        
//        picker.dismiss(animated: true, completion: nil)
//    }
//    
//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
//    {
//        self.dismiss(animated: true, completion: nil);
//    }
//    /////////////////////////////////////////////////// Marks: - Webservices
//    
//    //Marks Add post to server
//    func addpost()
//    {
//        var soapMessage = String()
//        var imageStr = String()
//        
//        var userid = String()
//        if let tempid = defaults.value(forKey: "userid") as? String
//        {
//            userid = tempid
//        }
//        else
//        {
//            userid = ""
//        }
//        if imgv != nil
//        {
//            let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
//            imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
//
//        }
//        else
//        {
//            imageStr = ""
//        }
//            let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
//            print(timespam)
//        
//        //Marks: - image and text both post
//        
//        soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><AddNewGroup xmlns='http://threepin.org/'><title>\(txttitle.text!)</title><userid>\(userid)</userid><membersIds>\("")</membersIds><fileName>\(String(timespam)+".jpg")</fileName><img>\(imageStr)</img><type>\(type)</type></AddNewGroup></soap:Body></soap:Envelope>"
//        
//        let soapLenth = String(soapMessage.count)
//        let theUrlString = "http://websrv.zederp.net/Apml/StatusService.asmx"
//        let theURL = URL(string: theUrlString)
//        let mutableR = NSMutableURLRequest(url: theURL!)
//        
//        // MUTABLE REQUEST
//        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
//        mutableR.httpMethod = "POST"
//        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
//        
//        let session = URLSession.shared
//        
//       // andicator.startAnimating()
//        
//        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
//         //   self.andicator.stopAnimating()
//            var dictionaryData = NSDictionary()
//            
//            do
//            {
//               // dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
//                dictionaryData as NSDictionary
//                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateStatusResponse")! as Any) as AnyObject).object(forKey:"UpdateStatusResult")   ?? NSDictionary()
//                
//                if (mainDict as AnyObject).count > 0{
//                    
//                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
//                    
//                    let text = mainD.value(forKey: "text") as! NSString
//                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
//                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
//                    
//                    if text == "0"
//                    {
//                        obj.showAlert(title: "Alert!", message: "Failed to uploaded post try agian.", viewController: self)
//                    }
//                    else
//                    {
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatepost"), object: nil)
//                        //                        self.txtdesc.text = "Write your post here"
//                        //                        self.txtdesc.textColor = UIColor.darkGray
//                        //
//                        //                        self.imgv.image = nil
//                        //                        self.lblvideo.text = ""
//                        obj.showAlert(title: "Alert!", message: "Post uploaded successfully.", viewController: self)
//                    }
//                }
//                else{
//                    
//                    obj.showAlert(title: "Alert", message: "try again", viewController: self)
//                }
//            }
//            catch
//            {
//                print("Your Dictionary value nil")
//            }
//            if error != nil
//            {
//                //self.andicator.stopAnimating()
//                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
//            }
//        })
//        
//        task.resume()
//    }
//}
//
//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
//    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
//}
//
//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
//    return input.rawValue
//}
