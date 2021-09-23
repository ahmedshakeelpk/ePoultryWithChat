
//
//  GroupCreationConfirm.swift
//  ZedChat
//
//  Created by MacBook Pro on 17/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire

class GroupCreationConfirm: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CreateGroupColCellDelegate, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var arrSelectedNumber_temp = NSMutableArray()
    var arrSelectedNumber = NSMutableArray()
    var groupId = String()
    var groupName = String()
    var doneBtn = UIBarButtonItem()
    @IBOutlet weak var bgvtop: UIView!
    @IBOutlet weak var colv: UICollectionView!
    @IBOutlet weak var imgvgroup: UIImageView!
    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var imgvgroupbg: UIView!
    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var btnupload: UIButton!
    @IBAction func btnupload(_ sender: Any) {
        funUploadImage(sender: sender)
    }
    @IBOutlet weak var lbltotaluser: UILabel!
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    override func viewWillAppear(_ animated: Bool) {
        
    }
    var isVC = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        obj.navigationTwoLineTitle(topline: "New Group", bottomline: "Add Subject", viewcontroller: self)
        
        txtname.becomeFirstResponder()
        //MARK:- Navigation Title Multilines
        lbltotaluser.text = "Participents: \(arrSelectedNumber.count)"
        obj.txtbottomline(textfield: txtname)
        
        DispatchQueue.main.async {
            obj.setimageCircle(image: self.imgvprofile, viewcontroller: self)
            obj.setimageCircle(image: self.imgvgroup, viewcontroller: self)
            obj.setViewCircle(view: self.imgvgroupbg, viewcontroller: self)
        }
        
        //MARK:- Cell Register
        self.colv.register(UINib(nibName: "CreateGroupColCell", bundle: nil), forCellWithReuseIdentifier: "CreateGroupColCell")
        
        let backBtn = UIBarButtonItem(image: UIImage.init(named: "Back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funback))
        self.navigationItem.leftBarButtonItem = backBtn
        
        
        doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(funDone))
        self.navigationItem.rightBarButtonItem = doneBtn
        
        obj.putImgInButtonWithOutLabel2XSmall(button: btngroup, imgname: "arrowNewGroup")
        DispatchQueue.main.async {
            obj.setbuttonHeighWidth4Pad(button: self.btngroup, viewcontroller: self)
            DispatchQueue.main.async {
                self.btngroup.layer.cornerRadius = self.btngroup.frame.size.height / 2
            }
        }
        btngroup.isHidden = true
    }
    
    @objc func funback()
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var btngroup: UIButton!
    @IBAction func btngroup(_ sender: Any) {
        funDone()
    }
    @objc func funDone(){
        
        if arrSelectedNumber.count == 0{
            return
        }
        if doneBtn.tag == 1{
            return
        }
        doneBtn.tag = 1
       
        if txtname.text != ""
        {
            andicator.startAnimating()
            createNewPublicChatGroupId(){ response in
                self.andicator.stopAnimating()
                self.doneBtn.tag = 0
                guard let imagename = response else {
                    obj.showToast(message: "Error Occured try again!", viewcontroller: self)
                    return }
                if response == ""
                {
                    obj.showToast(message: imagename, viewcontroller: self)
                }
                else if response == "success"
                {
                    DispatchQueue.main.async {
                        if self.isVC {
                            self.isVC = false
                           if self.presentingViewController != nil {
                                self.dismiss(animated: false, completion: {
                                   self.navigationController!.popToRootViewController(animated: true)
                                    
                                })
                            }
                            else {
                                //self.navigationController!.popToRootViewController(animated: true)
                        //    self.navigationController?.popToViewController(DashboardPC(), animated: true)
                            
                            let viewControllers = self.navigationController?.viewControllers
                            for vv in viewControllers! {
                                if vv.isKind(of: Contacts.self){
                                    self.navigationController?.popToViewController(vv, animated: true)
                                }
                            }
                            
                            }
                        }
                    }
                }
            }
        }
        else
        {
            obj.showToast(message: "Please Type group name", viewcontroller: self)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK:- Collection view Delegates
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = 5.0
        let width = (self.colv.frame.size.width / 4) - CGFloat(2 * margin)
        return CGSize(width: width, height: width + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSelectedNumber.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colv.dequeueReusableCell(withReuseIdentifier: "CreateGroupColCell", for: indexPath) as! CreateGroupColCell
        cell.cellConfigration(viewcontroller: self, delegate: self)
        let tempindex = arrSelectedNumber[indexPath.row] as! Int
        cell.lbltitle.text = arrGfullname_AppUser[tempindex]
        setCellImage(imgv: cell.imgvuser, index: tempindex)
        cell.bgvcancel.isHidden = true
        cell.imgvcancel.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    //MARK:- Custom Delegate
    func didTapOnColvRow(row: NSInteger) {
        
    }
    //MARK:- End Collection view Delegates
    
    func createNewPublicChatGroupId(completion: @escaping (_ response: String?) -> Void) {
        //MARK:- Add new group
        let autocreatedGroupId = GroupsDB.childByAutoId().key!
        var imgname = ""
        if imgvgroup.accessibilityIdentifier == "groupcamera"
        {
            funUserImageUpload(completion: { imagename in
                if imagename == "error"
                {
                    obj.showToast(message: "Please try again error occur", viewcontroller: self)
                    completion("error")
                    return
                }else{
                    imgname = imagename!
                    self.funCreateGroupId(autoGroupId: autocreatedGroupId, imgname: imgname, completion: {response in
                        if response == "success"
                        {
                            completion("success")
                        }
                        else
                        {
                            completion("error")
                        }
                    })
                }
            })
        }
        else
        {
            self.funCreateGroupId(autoGroupId: autocreatedGroupId, imgname: "2.png", completion: {response in
                if response == "success"
                {
                    completion("success")
                }
                else
                {
                    completion("error")
                }
            })
        }
    }
    
    func funCreateGroupId(autoGroupId: String, imgname: String, completion: @escaping (_ response: String?) -> Void) {
        let timespam = Date().currentTimeMillis()!
        groupName = txtname.text!
        let dicGroup = [
            "groupCreatedAt" : timespam,
            "groupCreatedBy" : USERUID,
            "groupDescription" : "",
            "groupImage" : imgname,
            "groupName" : groupName,
            "groupType" : "Public Group",
            "groupUpdated" : timespam] as [String : Any]
        
        GroupsDB.child(autoGroupId).setValue(dicGroup, withCompletionBlock: {
            error, snapshot in
            print(snapshot)
            if error != nil
            {
                completion(error?.localizedDescription)
            }
            else
            {
                let messageautocreatedid = MessagesDB.childByAutoId().key!
                //MARK:- For Admin User
                
                
                //MARK:- Add other users
                var messagetext = "\(defaults.value(forKey: "phoneno") as! String) created group '\(self.groupName)'"
                var tempcoun = 0
                for index in self.arrSelectedNumber
                {
                    var tempphone = arrGnumber_AppUser[index as! Int]
                    tempphone = tempphone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                    if tempphone.first == "0" || tempphone.first == "+"
                    {
                        tempphone.removeFirst()
                    }
                    if tempphone.first == "0"
                    {
                        tempphone.removeFirst()
                    }
                    let itemsArray = arrGuserphone as! [String]
                    let searchToSearch = tempphone
                    findIndex(value: searchToSearch, in: itemsArray) { userindex in
                        guard let userindex = userindex else {
                            return
                        }
                        self.funAddGroupParticipents(msgtype: CREATE_GROUP, autoGroupId: autoGroupId,
                                                     msgtext: messagetext,
                                                     role: "participant",
                                                     groupName: self.groupName,
                                                     groupid: autoGroupId,
                                                     userid: arrGuserUid[userindex] as! String,
                                                     msgautoid: messageautocreatedid,
                                                     completion: {response in
                                                        if response == "success"
                                                        {
                                                            tempcoun = tempcoun + 1
                                                            if tempcoun == self.arrSelectedNumber.count{
                                                                //MARK:- If admain user
                                                                let myno = defaults.value(forKey: "phoneno") as! String
                                                                messagetext = "\(myno) created group '\(self.groupName)'"
                                                                self.funAddGroupParticipents(msgtype: CREATE_GROUP, autoGroupId: autoGroupId,
                                                                                             msgtext: messagetext,
                                                                                             role: "admin",
                                                                                             groupName: self.groupName,
                                                                                             groupid: autoGroupId,
                                                                                             userid: USERUID,
                                                                                             msgautoid: messageautocreatedid,
                                                                                             completion: {response in
                                                                                                if response == "success"
                                                                                                {
                                                                                                    completion("success")
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    completion("error")
                                                                                                }
                                                                })
                                                            }
                                                        }
                                                        else
                                                        {
                                                            completion("error")
                                                        }
                        })
                    }
                }
            }
        })
    }
    
    
    
    func funAddGroupParticipents(msgtype: Int, autoGroupId: String, msgtext: String, role: String, groupName: String, groupid: String, userid: String, msgautoid: String, completion: @escaping (_ response: String?) -> Void) {
        ParticipantsDB.child(autoGroupId).child(userid).updateChildValues(["Role" : role], withCompletionBlock: {
            error, snapshot in
            if error != nil
            {
                completion(error?.localizedDescription)
            }
            else
            {
                funSendMessage(msgType: msgtype, msgtext: msgtext, groupid: groupid, receiverid: userid, msgautoid: msgautoid, groupName: groupName, completion: {response in
                    if response == "success"
                    {
                        completion("success")
                    }
                    else
                    {
                        completion("error")
                    }
                })
            }
        })
    }
    
    
    
    ////////////////////////////Upload User Image on Own Server
    func funUserImageUpload(completion: @escaping (_ imagename: String?) -> Void)
    {
        let timespamimage = "\(Date().currentTimeMillis()!).png"
        let imageData = imgvprofile.image!.jpegData(compressionQuality: 0.3)!
        let parameters : Parameters = ["filename":timespamimage]
        
        obj.webServiceWithPictureAudioChat(url: UPLOAD_GROUP_THUMB + timespamimage, parameters: parameters, imagename: timespamimage, imageData: imageData, audioData: Data(), viewController: self, completionHandler:{
            
            responseObject, error in
            
            if error == nil
            {
                completion(timespamimage)
            }
            else
            {
                completion("error")
            }
        })
    }
    
    //MARK:- Upload Imaage
    let picker = UIImagePickerController()
    func funUploadImage(sender: Any)
    {
        picker.delegate = self
        picker.allowsEditing = false
        //        picker.sourceType = .photoLibrary
        //        //MRK: - if use .photolibrary photos and videso both will show when library open
        //        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        //        present(picker, animated: true, completion: nil)
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
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
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    //image picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgvprofile.image = pickedImage
            imgvgroup.image = nil
            //self.andicator.startAnimating()
        }
        else
        {
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    //image picker delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //MARK:- End Upload image
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        eview.dismiss()
        //self.view.endEditing(true)
    }
    
    
}

