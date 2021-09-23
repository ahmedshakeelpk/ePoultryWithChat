//
//  GroupProfile.swift
//  ZedChat
//
//  Created by MacBook Pro on 17/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase

class GroupProfile: UIViewController, UITableViewDataSource, UITableViewDelegate, CreateGroupCellDelegate ,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    func didTapOnCheck(row: NSInteger) {
        
    }
    
    
    var role = ""
    var indexofAdmin = Int()
    var imagename = ""
    var adminid = String()
    var groupType = String()
    var imgview = UIImage()
    var strname = String()
    var strcreateby = String()
    //Groups
    var groupId = String()
    var arrGroupParticipant = NSMutableArray()
    var arrGroupUserRole = NSMutableArray()
    
    var arrSelectedNumber = NSMutableArray()
    
    var arruserpic = NSMutableArray()
    var arrusername = NSMutableArray()
    var arruserphone = NSMutableArray()
    var arruserFBid = NSMutableArray()
    var arruserFBToken = NSMutableArray()
    
    @IBOutlet weak var scrollv: UIScrollView!
    @IBOutlet weak var contentv: UIView!
    @IBOutlet weak var bgvtop: UIView!
    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var bgvnotification: UIView!
    @IBOutlet weak var lblparticipant: UILabel!
    @IBOutlet weak var lblnotification: UILabel!
    @IBOutlet weak var switchnotification: UISwitch!
    @IBAction func switchnotification(_ sender: Any) {
    }
    @IBOutlet weak var bgvLeaveGrooup: UIView!
    @IBOutlet weak var imgvLeaveGroup: UIView!
    @IBOutlet weak var btnLeaveGroup: UIButton!
    @IBAction func btnLeaveGroup(_ sender: Any) {
        funLeaveGroupAlert(phoneNo: USERUniqueID, msgText: "\(USERUniqueID) Left", msgType: LEFT_GROUP)
    }
    @IBOutlet weak var bgvparticipant: UIView!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var bgvupdateprofile: UIView!
    
    @IBOutlet weak var btncancel: UIButton!
    @IBAction func btncancel(_ sender: Any) {
        
        imgvdummyimg.image = UIImage(named: "groupcamera")
        imgvdummyimg.accessibilityIdentifier = "groupcamera"
        imgvgroupprofile.image = nil
        txtgroupname.text = ""
        funedit()
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
    @IBOutlet weak var btnupdate: UIButton!
    @IBAction func btnupdate(_ sender: Any) {
        var tempdatadic = [String: String]()
        if imgvdummyimg.accessibilityIdentifier == "groupcamera" && txtgroupname.text?.isEmpty == true
        {
            //Nothing selected
            return
        }
        else if imgvdummyimg.accessibilityIdentifier != "groupcamera" && txtgroupname.text?.isEmpty == false
        {
            self.view.endEditing(true)
            //Image and name both change
            funUserImageUpload() { imagename in
                 guard let name = imagename else { obj.showToast(message: "error occurd", viewcontroller: self)
                    return
                }
                if imagename == "error"
                {
                    obj.showToast(message: "error occur", viewcontroller: self)
                    return
                }
                tempdatadic = ["groupImage": name, "groupName": "\(self.txtgroupname.text!)"]
                self.funUpdateProfile(tempdatadic: tempdatadic, messagetext: "Group have been update")
            }
        }
        else if imgvdummyimg.accessibilityIdentifier != "groupcamera" && txtgroupname.text?.isEmpty == true
        {
            //Only image change
            funUserImageUpload() { imagename in
                guard let name = imagename else { obj.showToast(message: "error occurd", viewcontroller: self)
                    return }
                if imagename == "error"
                {
                    obj.showToast(message: "error occur", viewcontroller: self)
                    return
                }
                tempdatadic = ["groupImage": name]
                self.funUpdateProfile(tempdatadic: tempdatadic, messagetext: "Group icon has been update")
            }
        }
        else if imgvdummyimg.accessibilityIdentifier == "groupcamera" && txtgroupname.text?.isEmpty == false
        {
            self.view.endEditing(true)
            //Only group name change
            tempdatadic = ["groupName": "\(txtgroupname.text!)"]
            funUpdateProfile(tempdatadic: tempdatadic, messagetext: "Group name has been update")
        }
    }
    
    @IBOutlet weak var lbldesc: UILabel!
    @IBAction func txtgroupname(_ sender: Any) {
    }
    @IBOutlet weak var bgvuploadimage: UIView!
    
    @IBOutlet weak var imgvdummyimg: UIImageView!
    @IBOutlet weak var txtgroupname: UITextField!
    
    @IBOutlet weak var imgvgroupprofile: UIImageView!
    @IBOutlet weak var btnupload: UIButton!
    @IBAction func btnupload(_ sender: Any) {
        funUploadImage(sender: sender)
    }
    override func viewWillAppear(_ animated: Bool) {
        obj.showNavBar(viewcontroller: self)
    }
    @IBOutlet weak var btnprofilepic: UIButton!
    @IBAction func btnprofilepic(_ sender: Any) {
        funShowProfilePic()
    }
    override func viewDidAppear(_ animated: Bool) {
        let height = self.view.frame.size.height - (tablev.frame.minY)
        tablev.frame = CGRect(x: tablev.frame.origin.x, y: tablev.frame.origin.y, width: tablev.frame.size.width, height: height)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgvdummyimg.image = UIImage(named: "groupcamera")
        imgvdummyimg.accessibilityIdentifier = "groupcamera"
        if arruserphone.count > 0 {
            
        }
        else {
            fetchUserData()
        }
        bgvtop.backgroundColor = appclrProfileBG
        if arrGroupParticipant.contains(USERUID) {
            indexofAdmin = arrGroupParticipant.index(of: USERUID)
            role = arrGroupUserRole[indexofAdmin] as! String
        }
        else {
            bgvLeaveGrooup.isHidden = true
        }
        if role == "admin" {
            funAddRightBarButtons()
        }
      
        //funAddRightBarButtons()
        // Do any additional setup after loading the view.
        obj.setViewShade(view: bgvupdateprofile)
        obj.txtbottomline(textfield: txtgroupname)
        DispatchQueue.main.async {
          //  obj.setimageCircle(image: self.imgvgroupprofile, viewcontroller: self)
          //  obj.setViewCircle(view: self.bgvuploadimage, viewcontroller: self)
          //  obj.setimageCircle(image: self.imgvprofile, viewcontroller: self)
            self.imgvprofile.layer.borderColor = appclr.cgColor
           // self.imgvprofile.layer.borderWidth = 1
            
            self.imgvgroupprofile.layer.borderColor = appclr.cgColor
            self.imgvgroupprofile.layer.borderWidth = 1
        }
        
        if groupType == PRIVATECHAT {
            lblparticipant.text = "Status & Phone Number"
        }
        else if groupType == PUBLICGROUP {
            lblparticipant.text = "Participant:  \(arrGroupParticipant.count)"
        }
        imgvprofile.image = imgview
        if imgview.accessibilityIdentifier == "groupicon" {
            imgvprofile.image = UIImage(named: "grouppng")
            imgvprofile.contentMode = .scaleAspectFit
        }
        
        lblname.text = strname
        //MARK:- Navigation Title Multilines
        obj.navigationTwoLineTitle(topline: strname, bottomline: strcreateby, viewcontroller: self)
        self.tablev.register(UINib(nibName: "GroupProfileCell", bundle: nil), forCellReuseIdentifier: "GroupProfileCell")
        let backBtn = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funback))
        self.navigationItem.leftBarButtonItem = backBtn
        self.tablev.tableFooterView = UIView()
        self.contentv.autoresizesSubviews = false
        var contentRect = CGRect()
        contentv.frame.size.height = tablev.frame.maxY + 50
        for view in self.scrollv.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.scrollv.contentSize = contentRect.size
        //MARK:- Add Single Button
        //self.navigationItem.rightBarButtonItem = dots
        
        //        let search = UIBarButtonItem(image: UIImage.init(named: "searchbar"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funSearch))
         NotificationCenter.default.addObserver(self, selector: #selector(funRefreshGroupProfile), name: NSNotification.Name(rawValue: "funRefreshGroupProfile"), object: nil)
        DispatchQueue.main.async{
           // self.fetchGroupParticipant()
        }
    }
    
    func funAddRightBarButtons() {
        // Search Button Dots Button with image
        let addbtn = UIBarButtonItem(image: UIImage(named: "add"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funadd))
        
        let editbtn = UIButton(type: .system)
        editbtn.setImage(UIImage(named: "editpencil2"), for: .normal)
        editbtn.addTarget(self, action: #selector(self.funedit), for: .touchUpInside)
        editbtn.contentMode = .scaleAspectFit
        editbtn.sizeToFit()
        let editpencil = UIBarButtonItem(customView: editbtn)
//        let editpencil = UIBarButtonItem(image: UIImage.init(named: "editpencil2"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funedit))
        self.navigationItem.rightBarButtonItems = [addbtn, editpencil]
    }
    
    func funShowProfilePic(){
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        if imgvprofile.image != nil{
            vc.profilepic =  imgvprofile.image!
        }
        else{
            vc.profilepic = UIImage(named: "user")!
        }
        vc.videoimagename = "Picture"
        vc.videoimagetag = PROFILEPIC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func funadd() {
        let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "CreateGroup") as! CreateGroup
        vc.isAddParticipant = true
        vc.arruserphone = arruserphone
        //vc.arrSelectedNumber_temp = arrSelectedNumber
        vc.groupId = groupId
        vc.groupName = strname
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func funedit() {
        if bgvupdateprofile.isHidden == true {
            bgvupdateprofile.isHidden = false
        }
        else if bgvupdateprofile.isHidden == false {
            bgvupdateprofile.isHidden = true
        }
        txtgroupname.becomeFirstResponder()
    }
    
    @objc func funback() {
        obj.hideNavBar(viewcontroller: self)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arruserphone.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "GroupProfileCell") as! GroupProfileCell
        cell.cellConfigration(row: indexPath.row, delegate: self)
        let tempphone = "\((arruserphone[indexPath.row]))"
        if tempphone == USERUniqueID {
            cell.lblname.text = "You"
        }
        else {
            let tempname = obj.getContactNameFromNumber(contactNumber: "\(tempphone)")
            cell.lblname.text = tempname
        }
        cell.lblnumber.text = tempphone
        if let imgurl = arruserpic[indexPath.row] as? String {
            if imgurl != "" {
                let tempimgpath = USER_IMAGE_PATH
                cell.imgvprofile.kf.setImage(with: URL(string: tempimgpath + imgurl))
            }
        }
        if arrGroupUserRole[indexPath.row] as! String == "admin" {
            cell.lbladmin.isHidden = false
        }
        else {
            cell.lbladmin.isHidden = true
        }
        obj.setimageCircle(image: cell.imgvprofile
        , viewcontroller: self)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD {
            return 130
        }
        else {
            return 65
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if role == "admin" {
            //MARK:- Admin Handling
            if USERUniqueID == arruserphone[indexPath.row] as! String {
                //MARK:- if tap on own number
                if USERUniqueID == self.arruserphone[indexPath.row] as! String {
                    //MARK:- if tap on own number
                    let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "Profile") as! Profile
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.funAdminOptions(row: indexPath.row, indexPath:indexPath)
                    }
                }
            }
            else {
                //MAKR:- if admin tap on other user no
                DispatchQueue.main.async {
                    self.funAdminOptions(row: indexPath.row, indexPath:indexPath)
                }
            }
        }
        else {
        //else if role == "participant"{
            //MARK:- User PArticipant
            guard let cell = self.tablev.cellForRow(at: indexPath) as? GroupProfileCell else {
                return // or fatalError() or whatever
            }
            if USERUniqueID == cell.lblnumber.text! {
                //MARK:- if tap on own number
                let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "Profile") as! Profile
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else{
                DispatchQueue.main.async {
                    self.funUserProfile(row: indexPath.row, indexPath: indexPath)
                }
            }
        }
    }
    
    func funAdminOptions(row: Int, indexPath: IndexPath){
        let alert = UIAlertController(title: "", message: "View Options", preferredStyle: .alert)
        let ViewProfile = UIAlertAction(title: "Profile", style: .default)
        { (action) in
            DispatchQueue.main.async {
                self.funUserProfile(row: row, indexPath: indexPath)
            }
        }
        alert.addAction(ViewProfile)
        var MakeRemoveAdmin = UIAlertAction()
        guard let cell = self.tablev.cellForRow(at: indexPath) as? GroupProfileCell else {
            return // or fatalError() or whatever
        }
        if cell.lblnumber.text == USERUniqueID{
            
        }
        else {
            let tempphone = "\((arruserphone[row]))"
            if arrGroupUserRole[row] as! String == "admin"{
                MakeRemoveAdmin = UIAlertAction(title: "Dismiss as admin", style: .default)
                { (action) in
                    let messagetext = "\(tempphone) are now no longer an admin"
                    self.funMakeRemoveAdmin(msgType: GROUP_ADMIN, role: "participant", row: row, messagetext: messagetext)
                }
            }
            else{
                MakeRemoveAdmin = UIAlertAction(title: "Make group admin", style: .default)
                { (action) in
                    let messagetext = "\(tempphone) are now an admin"
                    self.funMakeRemoveAdmin(msgType: GROUP_ADMIN, role: "admin", row: row, messagetext: messagetext)
                }
            }
            let RemoveThisMember = UIAlertAction(title: "Remove this member", style: .default)
            { (action) in
                self.funRemoveMember(row: row, indexPath: indexPath)
            }
            alert.addAction(MakeRemoveAdmin)
            alert.addAction(RemoveThisMember)
        }
        
        let Cancel = UIAlertAction(title: "Cancel", style: .default)
        { (action) in
            
        }
        alert.addAction(Cancel)
        self.present(alert, animated: true)
    }
    
    func funUserProfile(row: Int, indexPath: IndexPath){
        let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "UserProfile") as! UserProfile
        vc.useruid = arrGroupParticipant[row] as! String
        guard let cell = self.tablev.cellForRow(at: indexPath) as? GroupProfileCell else {
            return // or fatalError() or whatever
        }
        if cell.imgvprofile.image != nil{
            vc.userimage = cell.imgvprofile.image!
        }
        vc.username = cell.lblname.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchUserData() {
        let temparruserpic = NSMutableArray()
        let temparrusername = NSMutableArray()
        let temparruserphone = NSMutableArray()
        let temparruserFBid = NSMutableArray()
        
        for (index, tempiddd) in arrGroupParticipant.enumerated() {
            self.andicator.startAnimating()
           
            UserDB.child(tempiddd as! String)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                    self.andicator.stopAnimating()
                
                    if snapshot.childrenCount > 0 {
                        let datadic = (snapshot.value as! NSDictionary)
                        temparruserpic.add(datadic.value(forKey: "UserLink") as Any)
                        temparrusername.add(datadic.value(forKey: "UserName") as Any)
                        temparruserphone.add(datadic.value(forKey: "UserPhoneNumber") as Any)
                        temparruserFBid.add(snapshot.key)
                    }
                    else {
                       
                    }
                    if index >= self.arruserFBid.count {
                        self.arruserpic = temparruserpic
                        self.arrusername = temparrusername
                        self.arruserphone = temparruserphone
                        self.arruserFBid = temparruserFBid
                        
                        if self.arruserFBid.count  > 0
                        {
                            self.tablev.reloadData()
                        }
                    }
                })
        }
    }

    ////////
    //MARK:- Upload Imaage
    let picker = UIImagePickerController()
    func funUploadImage(sender: Any) {
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
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    //image picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgvgroupprofile.image = pickedImage
            imgvdummyimg.image = nil
            imgvdummyimg.accessibilityIdentifier = ""
        }
        else {
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    //image picker delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //MARK:- End Upload image
    
    ////////////////////////////Upload User Image on Own Server
    func funUserImageUpload(completion: @escaping (_ imagename: String?) -> Void) {
        //MARK:- Replace image with same name in server
       // let timespamimage = imagename
        let timespamimage = "\(Date().currentTimeMillis()!).png"
      //  let imageData = imgvgroupprofile.image!.jpegData(compressionQuality: 0.3)!
        //let imageData = imgvgroupprofile.image?.jpegData(compressionQuality: 0.3)!
       // guard let imageData = imgvgroupprofile.image?.jpegData(compressionQuality: 0.75)
         //   else {
           //     return }
        let imageData = imgvgroupprofile.image!.jpegData(compressionQuality: 0.3)!
        let parameters : Parameters = ["filename":timespamimage]
        self.andicator.startAnimating()
        obj.webServiceWithPictureAudioChat(url: UPLOAD_GROUP_THUMB + timespamimage, parameters: parameters, imagename: timespamimage, imageData: imageData, audioData: Data(), viewController: self, completionHandler:{
            
            responseObject, error in
            self.andicator.stopAnimating()
            if error == nil {
                completion(timespamimage)
            }
            else {
                completion("error")
            }
        })
    }
    
//    //////MARK:- Send Message to all participants
//    func funSendMessage(msgType:Int, receiverid: String, messagetext: String, messageautocreatedid: String, completion: @escaping (_ response: String?) -> Void) {
//
//        let timespam = Date().currentTimeMillis()!
//        let fromuid = USERUID
//        MessagesDB.child(groupId).child(receiverid).child(messageautocreatedid).setValue([
//            "from":"\(fromuid)",
//            "message":messagetext,
//            "messageStatus":NOT_DELIVERED,
//            "messageType":msgType,
//            "phoneNumber": USERUniqueID,
//            "timestamp": timespam] as [String : Any], withCompletionBlock: {
//                error, ref in
//                if error != nil
//                {
//                    // self.isdeliver(messageStatus: SENT)
//                    //MARK:- Uncomment the upper line for testing the unSeenCount
//
//                    completion(error?.localizedDescription)
//                }
//                else
//                {
//                    self.funUpdateChatGroupStatus(msgType: msgType, groupid: self.groupId, messagetext: messagetext, receiverid: receiverid, messageautocreatedid: messageautocreatedid, completion: {
//                        response in
//
//                        if response == "success"
//                        {
//                            completion("success")
//                        }
//                        else
//                        {
//                            completion("error")
//                        }
//                    })
//                }
//        })
//    }
    
    
    //Text Delegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    //MARK:- Send Message in group
    func funSendMsgInGroup(msgText: String, msgType: Int,
                           receiverid: String, autoCreatedId: String,
                           completion: @escaping (_ response: String?) -> Void) {
        let timespam = Date().currentTimeMillis()!
        let fromuid = USERUID
        
        MessagesDB.child(groupId).child(receiverid).child(autoCreatedId).setValue([
            "\(objMessageDBM.from)":"\(USERUID)",
            "\(objMessageDBM.message)":msgText,
            "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
            "\(objMessageDBM.messageType)":msgType,
            "\(objMessageDBM.userName)": USERUniqueID,
            "\(objMessageDBM.timeStamp)": timespam] as [String : Any], withCompletionBlock: {
                error, ref in
                if error != nil {
                    // self.isdeliver(messageStatus: SENT)
                    //MARK:- Uncomment the upper line for testing the unSeenCount
                    
                    completion(error?.localizedDescription)
                }
                else {
                    funUpdateChatGroupStatus(msgType: msgType, groupid: self.groupId, messagetext: msgText, receiverid: receiverid, msgautoid: autoCreatedId, completion: {
                        response in
                        if response == "success" {
                            completion("success")
                        }
                        else {
                            completion("error")
                        }
                    })
                }
        })
    }
    
    func funLeaveGroupAlert(phoneNo: String, msgText: String, msgType: Int){
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Group!", message: "Are you sure you want to Leave '\(lblname.text!)' Group?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        { (action) in
            //self.dissmiss()
        }
        let Share = UIAlertAction(title: "Leave", style: .default)
        { (action) in
            self.andicator.startAnimating()
            let autoCreatedId = MessagesDB.childByAutoId().key!
            for (index, (_, tempReceiverid)) in zip(self.arruserphone, self.arrGroupParticipant).enumerated() {
                self.funSendMsgInGroup(msgText: msgText, msgType: msgType, receiverid: tempReceiverid as! String, autoCreatedId: autoCreatedId, completion: { response in
                    if index == self.arrGroupParticipant.count - 1{
                        self.funLeaveGroup()
                    }
                })
            }
            
        }
        alert.addAction(cancel)
        alert.addAction(Share)
        
        self.present(alert, animated: true)
    }
    func funLeaveGroup() {
    //    self.andicator.startAnimating()
        ParticipantsDB.child(groupId).queryOrderedByKey()
            .observeSingleEvent(of: .value, with: { (snapshot) in
                //MARK:- Make Admin Participant if Admin byself want to leave this group
                self.andicator.stopAnimating()
                let tempParticipant = self.arrGroupParticipant.mutableCopy() as! NSMutableArray
                
                if self.role == "admin"{
                    tempParticipant.removeObject(at: self.indexofAdmin)
                    if tempParticipant.count == 0 {
                        //MARK:- If last user want to leave
                        ParticipantsDB.child(self.groupId)
                            .child(USERUID).removeValue()
                        DispatchQueue.main.async {
                            self.funback()
                        }
                        return
                    }
                    if tempParticipant.contains("admin") {
                        //MARK:- Remove Participant
                        //MARK:- If last user want to leave
                        ParticipantsDB.child(self.groupId)
                            .child(USERUID).removeValue()
                        DispatchQueue.main.async {
                            self.funback()
                        }
                        return
                    }
                }
                var tempUid = ""
                if self.arrGroupParticipant[0] as! String == USERUID {
                    if self.arrGroupParticipant.count > 0{
                        //MARK:- Make other user as admin before leave group
                        tempUid = self.arrGroupParticipant[1] as! String
                    }
                    else {
                        //MARK:- If last user want to leave
                        ParticipantsDB.child(self.groupId)
                            .child(USERUID).removeValue()
                        DispatchQueue.main.async {
                            self.funback()
                        }
                        return
                    }
                }
                else {
                    tempUid = self.arrGroupParticipant[0] as! String
                }
                ParticipantsDB.child(self.groupId)
                    .child(tempUid)
                    .updateChildValues(["Role" : "admin"],
                                       withCompletionBlock: {
                                        error, snapshot in
                                        if error == nil {
                                            //MARK:- Remove Participant
                                            ParticipantsDB.child(self.groupId)
                                                .child(USERUID).removeValue()
                                            DispatchQueue.main.async {
                                                self.funback()
                                            }
                                        }
                    })
                
            })
    }
    func funUpdateProfile(tempdatadic: [String: String], messagetext: String) {
        funedit()
        self.andicator.startAnimating()
        GroupsDB.child(self.groupId).updateChildValues(tempdatadic, withCompletionBlock: {error, ref in
            self.andicator.stopAnimating()
            if error == nil {
                var ChangeType = ""
                //print("update successfully")
                if let tempgroupname = tempdatadic["groupName"] {
                    if tempgroupname != "" {
                        ChangeType = "groupName"
                        self.lblname.text = tempgroupname
                        //MARK:- Send Notification for change the name in chat screen
                        //MARK:- Navigation Title Multilines
                        obj.navigationTwoLineTitle(topline: tempgroupname, bottomline: self.strcreateby, viewcontroller: self)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeProfile"), object: ["name": tempgroupname])
                    }
                }
                if tempdatadic["groupImage"] != nil {
                    ChangeType = ChangeType + "groupImage"
                    self.imgvprofile.image = self.imgvgroupprofile.image
                    //MARK:- Send Notification for change the Image in chat screen
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeProfile"), object: ["image": self.imgvgroupprofile.image])
                }
                self.view.endEditing(true)
                self.imgvdummyimg.image = UIImage(named: "groupcamera")
                self.imgvdummyimg.accessibilityIdentifier = "groupcamera"
                self.imgvgroupprofile.image = nil
                
                self.txtgroupname.text = ""
                let messageautocreatedid = MessagesDB.childByAutoId().key!
                for (index, tempuserid) in self.arrGroupParticipant.enumerated() {
                    let fromuid = USERUID
                    var messagetextt = messagetext
                    if fromuid == tempuserid as! String {
                        //MARK:- If admain user
                        if ChangeType == "groupNamegroupImage" {
                            messagetextt = "You have been update group name & icon"
                        }
                        else if ChangeType == "groupImage" {
                            messagetextt = "You have been update group icon"
                        }
                        else if ChangeType == "groupName" {
                            messagetextt = "You have been update group name"
                        }
                    }
                    funSendMessage(msgType: GROUP_INFO_MESSAGE,
                                   msgtext: messagetext,
                                   groupid: self.groupId,
                                   receiverid: tempuserid as! String,
                                   msgautoid: messageautocreatedid,
                                   groupName: self.strname,
                                   completion: {response in
                                    if response == "success" {
                                        if index >=
                                            self.arrGroupParticipant.count{
                                            obj.showToast(message: "Group update successfully", viewcontroller: self)
                                        }
                                    }
                                    else {
                                        obj.showToast(message: "error occur try again to update", viewcontroller: self)
                                    }
                    })
                }
            }
            else {
                self.funedit()
                obj.showToast(message: "Error occured in image upload", viewcontroller: self)
            }
        })
    }
    
    @objc func funRefreshGroupProfile(notification: Notification) {
        let datadic = notification.object as! NSDictionary
        self.arrGroupParticipant = (datadic.value(forKey: "arrGroupParticipant") as! NSArray).mutableCopy() as! NSMutableArray
        self.arrGroupUserRole = (datadic.value(forKey: "arrGroupUserRole") as! NSArray).mutableCopy() as! NSMutableArray
            
        self.lblparticipant.text = "Participant:  \(self.arrGroupParticipant.count)"
        self.arruserpic = datadic.value(forKey: "arruserpic") as! NSMutableArray
        self.arrusername = datadic.value(forKey: "arrusername") as! NSMutableArray
        self.arruserphone = datadic.value(forKey: "arruserphone") as! NSMutableArray
        self.arruserFBid = datadic.value(forKey: "arruserFBid") as! NSMutableArray

        DispatchQueue.main.async{
            if self.arrGroupParticipant.contains(USERUID) {
                self.indexofAdmin = self.arrGroupParticipant.index(of: USERUID)
                self.role = self.arrGroupUserRole[self.indexofAdmin] as! String
                self.bgvLeaveGrooup.isHidden = false
            }
            else {
                self.bgvLeaveGrooup.isHidden = true
            }
            if self.role == "admin" {
                self.funAddRightBarButtons()
            }
            self.tablev.reloadData()
        }
    }
    
    func funMakeRemoveAdmin(msgType: Int, role: String, row: Int, messagetext: String) {
        let tempuserid = arrGroupParticipant[row] as! String
        //MARK:- For Admin User
        andicator.startAnimating()
        ParticipantsDB.child(groupId).child(tempuserid)
            .updateChildValues(["Role" : role], withCompletionBlock: {
            error, snapshot in
                self.andicator.stopAnimating()
            if error != nil { }
            else {
                self.arrGroupUserRole[row] = role
                DispatchQueue.main.async {
                    let indexPath = IndexPath(item: row, section: 0)
                    self.tablev.reloadRows(at: [indexPath], with: .none)
                }
                let messageautocreatedid = MessagesDB.childByAutoId().key!
                //MARK:- Reload image row after download
                for tempuserid in self.arrGroupParticipant {
                    if USERUID == tempuserid as! String {
                        
                    }
                    funSendMessage(
                        msgType: msgType,
                        msgtext: messagetext,
                        groupid: self.groupId,
                        receiverid: tempuserid as! String,
                        msgautoid: messageautocreatedid,
                        groupName: self.strname,
                        completion: {response in
                        if response == "success" {
                                        
                        }
                        else {
                                        
                        }
                    })
                }
            }
        })
    }
    
    func funRemoveMember(row: Int, indexPath: IndexPath){
        andicator.startAnimating()
        let temppart = self.arrGroupParticipant
        let tempphonenumber = self.arruserphone
        ParticipantsDB.child(groupId).child(arrGroupParticipant[row] as! String).removeValue(completionBlock: { error, ref in
            self.andicator.stopAnimating()
            if error == nil{
                let messageautocreatedid = MessagesDB.childByAutoId().key!
                let messagetext = "\(USERUniqueID) removed '\(tempphonenumber[row])'"
                //MARK:- Reload image row after download
                
                for tempuserid in temppart {
                    if USERUID == tempuserid as! String {
                        
                    }
                    funSendMessage(
                        msgType: REMOVE_MEMBER,
                        msgtext: messagetext,
                        groupid: self.groupId,
                        receiverid: tempuserid as! String,
                        msgautoid: messageautocreatedid,
                        groupName: self.strname,
                        completion: {response in
                            if response == "success" {
                                
                            }
                            else {
                                
                            }
                    })
                }
            }
        })
    }
}
