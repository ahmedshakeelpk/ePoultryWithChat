

//
//  Messaging.swift
//  Talklo
//
//  Created by IOS Dev on 02/05/2018.
//  Copyright © 2018 Paragon Marketing. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import GoogleMaps
import DropDown
import VHBoomMenuButton
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import FirebaseDatabase
import DropDown
import ContactsUI
import MediaPlayer
import RSKGrowingTextView
import RSKKeyboardAnimationObserver
import SNVideoRecorder

//enum tag{
//    case incomming, outgoing
//}
//var msgviewtag = 0
//var arrmsg = [String]()
//var arrmsguser = [String]()

@available(iOS 10.0, *)
class Messagingg: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate, GMSPlacePickerViewControllerDelegate, UIDocumentMenuDelegate,UIDocumentPickerDelegate, CNContactPickerDelegate, UIGestureRecognizerDelegate, BoomDelegate, MPMediaPickerControllerDelegate, CNContactViewControllerDelegate, UITextViewDelegate, SNVideoRecorderDelegate, AddCaptianDelegate{
    
    
   
    //FCM Token
    
    //Groups
    var groupId = String()
    var arrGroupParticipant = NSArray()
    var arrGroupUserRole = NSArray()
    ///////
    var otherUserStatusTimer = Timer()
    var selectContactNo = ""
    var otherUserPhoneNumber = ""
    var otherUserStatus = ""
    var otherUserShowStatus = ""
    var otherUserShowProfilePic = ""
    var otherUserShowLastSeen = ""
    var isUserActivityStatusFunRun = 0
    var groupType = String()
    var uploadData = Data()
    var isviewloaad = 0
    var objecturl = ""
    var videoimageurl = ""
    var selectedimage = UIImage()
    var imagename = ""
    var useridserver = ""
    var otherUserPhone_Number = ""
    var unSeenCount = ""
    
    
    var arrSelectedDeletIndex = [Int]()
    var temparrMsgId = NSMutableArray()
    var arrMsgFomid = NSMutableArray()
    var arrMsg = NSMutableArray()
    var arrMsgStatus = NSMutableArray()
    var arrMsgType = NSMutableArray()
    var arrMsgTime = NSMutableArray()
    var arrMsgPic = NSMutableArray()
    //var arrMsgAudio = NSMutableArray()
    var arrMsgVideo = NSMutableArray()
    
    var arrMsgPicThumb = NSMutableArray()
    var arrMsgLat = NSMutableArray()
    var arrMsgLong = NSMutableArray()
    //var arrMsgAddress = NSMutableArray()
    var arrMsgId = NSMutableArray()
    
    var lastonlinetime = String()
    var isonline = String()
    
    ///////////
    //MARK:- Delete Selection Parameters
    var iscopytext = 0
    var canDeleteEveryOne = 0
    
    //MAARK:- Dropdown
    let dropDown = DropDown()
    var selecteDict = [String: Any]()
    var refreshControl = UIRefreshControl()
    
    //MARK:- Location
    let locationManager = CLLocationManager()
    var userlat = Double()
    var userlong = Double()
    //MARK:- Picker
    var picker = UIImagePickerController()
    //var documentPicker = UIDocumentPickerViewController()
    
    var documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.audiovisual-content", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)
    var touid = String()
    var fromuid = String()
    var username = String()
    var userprofilepic = String()
    
    var touidDic = String()
    var fromuidDic = String()
    private var isVisibleKeyboard = true
    
    @IBOutlet weak var bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtmsgv: RSKGrowingTextView!
    @IBOutlet weak var btnprofilepic: UIButton!
    @IBOutlet weak var imgvaudiotimer: UIImageView!
    @IBOutlet weak var lblaudiotimer: UILabel!
    @IBOutlet weak var lblslidertocancel: UILabel!
    @IBOutlet weak var btnCancelRecording: UIButton!
    @IBAction func btnCancelRecording(_ sender: Any) {
        finishRecordingCancel()
    }
    @IBOutlet weak var imgvCallDelete: UIImageView!
    @IBOutlet weak var bgvaudiotimer: UIView!
    @IBOutlet weak var imgvVideoCallCopy: UIImageView!
    @IBOutlet weak var imgvDotsFwd: UIImageView!
    @IBOutlet weak var btnProfile: UIButton!
    @IBAction func btnProfile(_ sender: Any) {
        self.view.endEditing(true)
        funViewProfile()
    }
    
    @IBOutlet weak var btnscrolltobottom: UIButton!
    @IBAction func btnscrolltobottom(_ sender: Any) {
        let indexPath = IndexPath(row: self.arrMsgType.count-1, section: 0)
        self.scrolltobottom(indexpath: indexPath)
    }
    @IBOutlet weak var imgvSlideToLock: UIImageView!
    @IBOutlet weak var bgvSlideToLock: UIView!
    @IBOutlet weak var bgvButtons: UIView!
    @IBAction func btnprofilepic(_ sender: Any) {
        showimage(index: PROFILEPIC)
    }
    @IBOutlet weak var lblnotgroupmember: UILabel!
    func funViewProfile() {
        if groupType == PRIVATECHAT {
            let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "UserProfile") as! UserProfile
            vc.useruid = touid
            vc.userphone = otherUserPhoneNumber
            vc.userstatus = otherUserStatus
            if imgv.image == nil{
                return
            }
            vc.userimage = imgv.image!
            vc.username = lblname.text!
            vc.otherUserPhoneNumber = otherUserPhoneNumber
            vc.otherUserStatus = otherUserStatus
            vc.otherUserShowStatus = otherUserShowStatus
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if groupType == PUBLICGROUP {
            let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "GroupProfile") as! GroupProfile
            if imgv.image != nil{
                vc.imgview = imgv.image!
            }
            else{
                vc.imgview = UIImage(named: "grouppng")!
            }
            vc.strname = lblname.text!
            vc.strcreateby = lblstatus.text!
            vc.arrGroupParticipant = arrGroupParticipant.mutableCopy() as! NSMutableArray
            vc.arrGroupUserRole = arrGroupUserRole.mutableCopy() as! NSMutableArray
            vc.groupId = groupId
            vc.groupType = groupType
            vc.arruserpic =  arruserpic
            vc.arrusername =  arrusername
            vc.arruserphone =  arruserphone
            vc.arruserFBid =  arruserFBid
            vc.arruserFBToken = arruserFBToken
            vc.imagename = imagename
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var btnAudioCall: UIButton!
    @IBAction func btnAudioCall(_ sender: Any) {
        if imgvCallDelete.image!.isEqualToImage(image: UIImage(named: "trash")!) {
            //MARK:- Delete a User Messages
            //funDeleteSelectedMessages(isClear: 0, isDeleteEveryOne: isDeleteEveryOne)
            self.view.endEditing(true)
            objG.showDeletePopup(isDeleteForEveryOne: self.canDeleteEveryOne, viewController: self)
        }
        else {
            if receivertokenLocalClass == "" {
                return
            }
            if useridserver == ""{
                return
            }
            btnAudioCall.isUserInteractionEnabled = false
            //MARK:- Call a user
            let vc = UIStoryboard.init(name: "Calling", bundle: nil).instantiateViewController(withIdentifier: "AnswerCall") as! AnswerCall
            call_ReceiverFBToken = receivertokenLocalClass
            isOutGoing = 1
            isAudio = 1
            callUser_Receiver_id = self.otherUserPhone_Number + "_" + self.useridserver
            call_ReceiverImage = imgv.image!
            //callUser_image_Sender = userprofilepic
            callGroup_Id = self.groupId
            callUser_FBID_Receiver = self.touid
            callUser_FBID = self.fromuid
            callUser_image_Sender = self.imagename
            
            callUser_Name = self.lblname.text!
            callUser_PhoneNumber_Receiver = self.otherUserPhone_Number
            callUser_PhoneNumber = USERUniqueID
            call_ReceiverUser_id = self.useridserver
            DispatchQueue.main.async {
                self.btnAudioCall.isUserInteractionEnabled = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @IBOutlet weak var btnVideoCall: UIButton!
    @IBAction func btnVideoCall(_ sender: Any) {
        if imgvVideoCallCopy.image!.isEqualToImage(image: UIImage(named: "copy")!) {
            //MARK:- User Message Copy
            var tempArrayString = [String]()
            for index in arrSelectedDeletIndex{
                tempArrayString.append(self.arrMsg[index] as? String ?? "")
            }
            let tempString = tempArrayString.joined(separator: "\n")
            // Copy text/write to clipboard
            UIPasteboard.general.string = tempString
            btnback(btnback as Any)
        }
        else if imgvVideoCallCopy.image!.isEqualToImage(image: UIImage(named: "trash")!) {
            //MARK:- If multiple category selected like video text location audio etc
            //funDeleteSelectedMessages(isClear: 0, isDeleteEveryOne: isDeleteEveryOne)
            objG.showDeletePopup(isDeleteForEveryOne: self.canDeleteEveryOne, viewController: self)
        }
        else {
            if receivertokenLocalClass == "" {
                return
            }
            if useridserver == ""{
                return
            }
            btnVideoCall.isUserInteractionEnabled = false
            //MARK:- Viceo Call a user
            //MARK:- Call a user
            let vc = UIStoryboard.init(name: "Calling", bundle: nil).instantiateViewController(withIdentifier: "AnswerCall") as! AnswerCall
            call_ReceiverFBToken = receivertokenLocalClass
            isOutGoing = 1
            isAudio = 0
            callUser_Receiver_id = self.otherUserPhone_Number + "_" + self.useridserver
            call_ReceiverImage = imgv.image!
            //callUser_image_Sender = userprofilepic
            callGroup_Id = self.groupId
            callUser_FBID_Receiver = self.touid
            callUser_FBID = self.fromuid
            callUser_image_Sender = self.imagename
            callUser_Name = self.lblname.text!
            callUser_PhoneNumber_Receiver = self.otherUserPhone_Number
            callUser_PhoneNumber = USERUniqueID
            call_ReceiverUser_id = self.useridserver
            DispatchQueue.main.async {
                self.btnVideoCall.isUserInteractionEnabled = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func funDeleteSelectedMessages(isClear: Int, isDeletedFromEveryOne: Int) {
        if isClear == 1 {
            if arrMsgId.count == 0{
                return
            }
            else{
                var tempOtherUserId = ""
                if groupType == PUBLICGROUP {
                    tempOtherUserId = ""
                }
                else {
                    tempOtherUserId = self.touid
                }
                let timespam = Date().currentTimeMillis()!
                let dicGroupFrom = [
                    "\(objChatDBM.createdAt)" : timespam,
                    "\(objChatDBM.groupType)" : groupType,
                    "\(objChatDBM.lastMessage)" : "",
                    "\(objChatDBM.lastMessageStatus)" : NOT_DELIVERED,
                    "\(objChatDBM.lastMessageTime)" : timespam,
                    "\(objChatDBM.lastMessageType)" : TEXT,
                    "\(objChatDBM.lastMessageUserId)" : self.fromuid,
                    "\(objChatDBM.messageStatus)" : "",
                    "\(objChatDBM.otherUserId)" : tempOtherUserId,
                    "\(objChatDBM.seen)" : false,
                    "\(objChatDBM.typing)" : STOP_TYPING_RECORDING,
                    "\(objChatDBM.userName)" : USERUniqueID,
                    "\(objChatDBM.unSeenCount)" :0,
                    "\(objChatDBM.source)" :SOURCECODE] as [String : Any]
                
                ChatDB.child(fromuid).child(groupId)
                    .updateChildValues(dicGroupFrom)
                
                MessagesDB.child(groupId)
                    .child(fromuid)
                    .removeValue(completionBlock: { error, snapshot in
                        if error != nil {
                            obj.showToast(message: (error?.localizedDescription)!, viewcontroller: self)
                        }
                        else {
                            self.arrMsgFomid = NSMutableArray()
                            self.arrMsg = NSMutableArray()
                            self.arrMsgType = NSMutableArray()
                            self.arrMsgTime = NSMutableArray()
                            self.arrMsgPicThumb = NSMutableArray()
                            self.arrMsgPic = NSMutableArray()
                            self.arrMsgVideo = NSMutableArray()
                            self.arrMsgLat = NSMutableArray()
                            self.arrMsgLong = NSMutableArray()
                            //self.arrMsgAddress.removeObject(at: index)
                            self.arrMsgId  = NSMutableArray()
                            self.arrMsgStatus  = NSMutableArray()
                            DispatchQueue.main.async{
                                self.tablev.reloadData()
                            }
                        }
                    })
            }
            return
        }
        // andicator.startAnimating()
        var arrIndexes = arrSelectedDeletIndex
        temparrMsgId = arrMsgId
        if isClear == 1 {
            arrIndexes += 0...arrMsgId.count - 1
        }
        arrSelectedDeletIndex = arrIndexes
        for (index, i) in arrIndexes.enumerated() {
            deleteMessages(index: i, isClear: isClear, isDeleteFromEveryOne: isDeletedFromEveryOne, completion: {response in
                print(response as Any)
                if index ==  arrIndexes.count - 1{
                    if isClear == 1 {
                        //MARK:- Clear All chat
                        self.arrMsgFomid = NSMutableArray()
                        self.arrMsg = NSMutableArray()
                        self.arrMsgType = NSMutableArray()
                        self.arrMsgTime = NSMutableArray()
                        self.arrMsgPicThumb = NSMutableArray()
                        self.arrMsgPic = NSMutableArray()
                        self.arrMsgVideo = NSMutableArray()
                        self.arrMsgLat = NSMutableArray()
                        self.arrMsgLong = NSMutableArray()
                        //self.arrMsgAddress = NSMutableArray()
                        self.arrMsgId = NSMutableArray()
                        self.arrMsgStatus = NSMutableArray()
                    }
                    self.unSelectionMessages()
                    self.arrSelectedDeletIndex = [Int]()
                    DispatchQueue.main.async{
                        DispatchQueue.main.async{
                            self.tablev.reloadData()
                        }
                        self.andicator.stopAnimating()
                    }
                }
            })
        }
    }
    @IBOutlet weak var lblSelectionCount: UILabel!
    
    var dataarray = [""]
    let arrPrivateChat = ["View Contacts", "Mute Notification", "Clear Chat", "Block User"]
    let arrPrivateChatWithAddContact = ["View Contacts", "Mute Notification", "Clear Chat", "Block User", "Add to Contact"]
    var arrGroupChat = ["Group Info", "Clear Chat", "Exit Group"]
    
    //var btnCamera = UIButton()
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnDots: UIButton!
    @IBAction func btnDots(_ sender: Any) {
        dropDown.dataSource = dataarray
        dropDown.direction = .bottom
        dropDown.width = 140
        
        self.dropDown.anchorView = btnDots
        dropDown.show()
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dropDown.hide()
            //MARK:-
            switch self.dataarray[index] {
                
            case "View Contacts":
                self.funViewProfile()
                break
            case "Mute Notification":
                
                break
            case "Clear Chat":
                self.funClearChat()
                break
            case "Group Info":
                self.funViewProfile()
                break
            case "Block User":
                self.alertBlockUser()
                break
            case "Add to Contact":
                self.funAddtoContact()
                break
            case "Exit Group":
                let tempno = USERUniqueID
                self.funLeaveGroupAlert(phoneNo: tempno, msgText: "\(tempno) Left", msgType: LEFT_GROUP)
                break
            default:
                print("no match")
                break
            }
        }
    }
    func funClearChat(){
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Contacts!", message: "Are you sure you want to Clear this Chat?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        { (action) in
            //self.dissmiss()
        }
        let Share = UIAlertAction(title: "Clear", style: .default)
        { (action) in
            DispatchQueue.main.async{
                self.funDeleteSelectedMessages(isClear: 1, isDeletedFromEveryOne: 0)
            }
        }
        alert.addAction(cancel)
        alert.addAction(Share)
        
        self.present(alert, animated: true)
    }
    func funAddtoContact(){
        let newContact = CNMutableContact()
        newContact.phoneNumbers.append(CNLabeledValue(label: "home", value: CNPhoneNumber(stringValue: lblname.text!)))
        let contactVC = CNContactViewController(forUnknownContact: newContact)
        
        contactVC.contactStore = CNContactStore()
        
        contactVC.hidesBottomBarWhenPushed = true
        contactVC.allowsEditing = false
        contactVC.allowsActions = false
        contactVC.delegate = self
        // 3
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationItem.hidesBackButton = false
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(contactVC, animated: true)
        }
    }
    func alertBlockUser()
    {
        let alert = UIAlertController(title: "Block!", message: "Are you sure you want to block this user?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        { (action) in
            
        }
        let Block = UIAlertAction(title: "Block", style: .default)
        { (action) in
            obj.showAlert(title: "Block!", message: "User will block soon thanks for report!", viewController: self)
        }
        alert.addAction(cancel)
        alert.addAction(Block)
        
        self.present(alert, animated: true)
    }
    
    var longPressGesture = UILongPressGestureRecognizer()
    var tapGesture = UITapGestureRecognizer()
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var meterTimer:Timer!
    var blinkLabelTimer:Timer!
    var audioVideoDocumentData: Data!
    var selecteFileName = ""
    var selecteFileExtension = ""
    var audioDuration = Double()
    var playingurl = NSURL()
    var counttypingstatus = 0
    var audioplayerisplaying = "stop"
    var timeruseronline = Timer()
    var timeruseroffline = Timer()
    var timer_isonline = Timer()
    var clientid = String()
    var is_online = "0"
    var chatuserfullname = String()
    var receivertokenLocalClass = String()
    var receiverimgurl = String()
    var messagetext = String()
    var imgdriwer = UIImage()
    var arrimages = [String]()
    var arrImagePlayPause = [String]()
    var arrTotalAudioTime = [String]()
    var driver_idForAwardReject = String()
    var selectedDict = NSDictionary()
    var ridestatus = String()
    var is_award = Bool()
    var updater : CADisplayLink! = nil

    //This handler is using for remove Specific Observer
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var imgvuserstatus: UIImageView!
    @IBOutlet weak var lblstatus: UILabel!
    @IBOutlet weak var vnavigation: UIView!
    @IBOutlet var imgvhold: UIImageView!
    @IBOutlet var imgvmike: UIImageView!
    @IBOutlet var imgvattach: UIImageView!
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var btnback: UIButton!
    @IBAction func btnback(_ sender: Any) {
        if arrSelectedDeletIndex.count > 0
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removePopup"), object: nil)
            arrSelectedDeletIndex = [Int]()
            tablev.reloadData()
            unSelectionMessages()
            
            return
        }
        if groupType == PRIVATECHAT
        {
            if groupId != ""
            {
                self.isTypingOrRecording(isTypingOrRecording: STOP_TYPING_RECORDING)
                ChatDB.child(fromuid).child(groupId).removeAllObservers()
                MessagesDB.child(groupId).child(fromuid).removeAllObservers()
                MessagesDB.child(groupId).child(touid).removeAllObservers()
            }
        }
        else if groupType == PUBLICGROUP
        {
            ParticipantsDB.child(self.groupId)
                .child(self.fromuid)
                .removeAllObservers()
            ParticipantsDB.child(groupId).removeAllObservers()
            MessagesDB.child(groupId).child(fromuid).removeAllObservers()
        }
        
        self.slidertimer.invalidate()
        self.unregisterForKeyboardNotifications()
        defaults.setValue("0", forKey: "is_chatscreen")
        self.vnavigation.isHidden = true
        obj.showNavBar(viewcontroller: self)
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.popViewController(animated: true)
        DispatchQueue.main.async {
            self.otherUserStatusTimer.invalidate()
        }
    }
    // MARK: - Helper Methods
    private func adjustContent(for keyboardRect: CGRect) {
        let keyboardHeight = keyboardRect.height + 10
        self.bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint.constant = self.isVisibleKeyboard ? keyboardHeight - self.bottomLayoutGuide.length : 10.0
        self.view.layoutIfNeeded()
    }
    
    @IBAction func handleTapGestureRecognizer(sender: UITapGestureRecognizer) {
        self.txtmsgv.resignFirstResponder()
    }
    
    private func registerForKeyboardNotifications() {
        self.rsk_subscribeKeyboardWith(beforeWillShowOrHideAnimation: nil,
                                       willShowOrHideAnimation: { [unowned self] (keyboardRectEnd, duration, isShowing) -> Void in
                                        self.isVisibleKeyboard = isShowing
                                        self.adjustContent(for: keyboardRectEnd)
            }, onComplete: { (finished, isShown) -> Void in
                self.isVisibleKeyboard = isShown
                let indexPath = IndexPath(row: self.arrMsgType.count-1, section: 0)
                self.scrolltobottom(indexpath: indexPath)
        }
        )
        
        self.rsk_subscribeKeyboard(willChangeFrameAnimation: { [unowned self] (keyboardRectEnd, duration) -> Void in
            self.adjustContent(for: keyboardRectEnd)
            }, onComplete: nil)
    }
    
    private func unregisterForKeyboardNotifications() {
        self.rsk_unsubscribeKeyboard()
    }
    @IBOutlet weak var boombutton: BoomMenuButton!
    
    //MARK:- Not using in this app
    @IBOutlet weak var attachbutton: UIButton!
    @IBAction func buttonattach(_ sender: Any) {
        self.view.endEditing(true)
        picker.delegate = self
        picker.allowsEditing = false
        let alert = UIAlertController(title: "Choose Image or Location", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction(title: "Share Location", style: .default, handler: { _ in
            self.confirmAlert()
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
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func confirmAlert()
    {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if (authorizationStatus == CLAuthorizationStatus.notDetermined) {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.startUpdatingLocation()
        }
        let alertController = UIAlertController(title: "Current Location!", message: "Are you sure want to share your current location?", preferredStyle: UIAlertController.Style.alert)
        
        let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = UIColor.white
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        let okAction = UIAlertAction(title: "Share", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            //print(alertController.textFields?.first?.text)
            self.locationManager.delegate = self
            //MARK: - Check Authorization of map
            
            let authorizationStatus = CLLocationManager.authorizationStatus()
            if (authorizationStatus == CLAuthorizationStatus.notDetermined) {
                self.locationManager.requestWhenInUseAuthorization()
            } else {
                self.locationManager.startUpdatingLocation()
                DispatchQueue.main.async {
                    self.shareLocation()
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var vimgselected: UIView!
    @IBOutlet weak var imgvselected: UIImageView!
    @IBOutlet weak var txtmsg: UITextField!
    @IBOutlet weak var btnsend: TouchMoveButton!
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBAction func btnsend(_ sender: AnyObject) {
        
        if imgvmike.accessibilityIdentifier == "holdmike" || imgvmike.accessibilityIdentifier == "unholdmike"
        {
            
        }
        else
        {
            if txtmsgv.text!.isEmpty != true
            {
                //andicator.startAnimating()
                sendMessage(msgtype: TEXT)
            }
//            else if imgvselected.image != nil
//            {
//                //  andicator.startAnimating()
//            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //msgviewtag = 0
        self.view.endEditing(true)
        self.vnavigation.isHidden = true
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        obj.hideNavBar(viewcontroller: self)
        //imgvuserstatus.isHidden = true
        if groupType == PRIVATECHAT {
            getOtherUserLastOnlineTime()
            if groupId != "" {
                DispatchQueue.main.async {
                    self.isdeliverWhenMsgScreenOpen()
                }
            }
        }
        //MARK:- Show Status Bar
        //UIApplication.shared.isStatusBarHidden = false
        
        self.vnavigation.isHidden = false
        txtmsg.delegate = self
//        btnsend.addTarget(self, action: #selector(funholdRelease(sender:)), for: .touchUpInside);
//        btnsend.addTarget(self, action: #selector(funHoldDown(sender:)), for: .touchDown)
        //If you want to add some thing perment in all view
        //self.navigationController?.navigationBar.isHidden = true
        objG.statusbarcolor(viewcontroller: self)
        self.vnavigation.backgroundColor = appclr
    }
    @objc func changeProfile(notification: Notification){
        
        let profiledatadic = notification.object as! [String: AnyObject]
        
        if let tempgroupname = profiledatadic["name"] as? String{
            if tempgroupname != "" {
                self.lblname.text = tempgroupname
            }
        }
        if let tempprofileimage = profiledatadic["image"] as? UIImage{
            self.imgv.image = tempprofileimage
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.bgview.backgroundColor = UIColor.init(patternImage: UIImage(named: "chat_bg.png")!)
        self.registerForKeyboardNotifications()
        UIView.performWithoutAnimation {
            tablev.beginUpdates()
            tablev.endUpdates()
            
        }
        self.vnavigation.frame.origin.y = STATUSBAR_HEIGHT
        self.tablev.frame.origin.y = vnavigation.frame.maxY + 1
    }
    override func didReceiveMemoryWarning() {
        
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Return", style: .done, target: self, action: #selector(self.returnButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        txtmsgv.inputAccessoryView = doneToolbar

    }

    @objc func returnButtonAction() {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        andicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        //MARK:- Add Return Button in Keyboard for UITextView
        addDoneButtonOnKeyboard()
        btnscrolltobottom.isHidden = true
        btnscrolltobottom.clipsToBounds = true
        btnscrolltobottom.backgroundColor = .white
        imgvCallDelete.isHidden = true
        imgvVideoCallCopy.isHidden = true
        btnAudioCall.isHidden = true
        btnVideoCall.isHidden = true
        navigationItem.hidesBackButton = true
        objG.statusbarcolor(viewcontroller: self)

        self.imgvmike.image = UIImage(named: "unholdmike")
        self.imgvmike.accessibilityIdentifier = "unholdmike"
        self.tablev.isHidden = true
        //MARK:- Test Group id
        //groupId = "-Lhdz-7EmVHHJ26alJo-"
        // txtmsg.frame.size.height = 45
        DispatchQueue.main.async {
            objMessage = self
        }
        obj.putImgInButtonWithOutLabel2XSmall(button: btnscrolltobottom, imgname: "scrollbottom")
        btnscrolltobottom.layer.cornerRadius = btnscrolltobottom.frame.size.height / 2
        btnscrolltobottom.layer.borderColor = UIColor.lightGray.cgColor
        btnscrolltobottom.layer.borderWidth = 0.5
        if imgvhold == nil {
            return
        }
        
//        if UIDevice().userInterfaceIdiom == .phone {
//            switch UIScreen.main.nativeBounds.height {
//            case 1136:
//                print("iPhone 5 or 5S or 5C")
//
//            case 1334:
//                print("iPhone 6/6S/7/8")
//                self.vnavigation.frame.origin.y = barHeight
//
//            case 1920, 2208:
//                print("iPhone 6+/6S+/7+/8+")
//
//            case 2436:
//                print("iPhone X, XS")
//                self.vnavigation.frame.origin.y = barHeight
//            case 2688:
//                print("iPhone XS Max")
//                DispatchQueue.main.async{
//                self.vnavigation.frame.origin.y = barHeight
//                }
//            case 1792:
//                print("iPhone XR")
//
//            default:
//                print("Unknown")
//            }
//        }
        
        isAndroidUser = Bool()
        imgvhold.backgroundColor = appclr
        check_record_permission()
        fontsize = 15.0
        
        if let tempsize = defaults.value(forKey: "fontsize") as? CGFloat {
            fontsize = tempsize
        }
        defaults.setValue("1", forKey: "is_chatscreen")
        defaults.setValue("0", forKey: "is_message")
        
        DispatchQueue.main.async {
            //MARK:- Enable Speaker
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.voiceChat, options: .defaultToSpeaker)
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
                try AVAudioSession.sharedInstance().setActive(true)
            }
            catch _ {
                print("Error 2")
            }
        }
        
        //If you want something permanently in all view
        //UIApplication.shared.keyWindow!.addSubview(self.vnavigation)
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if (authorizationStatus == CLAuthorizationStatus.notDetermined) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        else {
            self.locationManager.startUpdatingLocation()
        }
        arrMsg = NSMutableArray()
        // arrmsguser = [String]()
        //  msgviewtag = 1
        self.tablev?.tableFooterView = UIView()
        
        imgvhold.layer.cornerRadius = imgvhold.frame.size.height / 2
        //MARK:- Unimited rows in cell
        tablev.rowHeight = 128
        tablev.estimatedRowHeight = UITableView.automaticDimension
        // registerForKeyboardNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleMsgNotificaions), name: NSNotification.Name(rawValue: "hideKeyboard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMsgNotificaions), name: NSNotification.Name(rawValue: "deleteMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchGroupParticipant), name: NSNotification.Name(rawValue: "fetchGroupParticipant"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopPlayer), name: NSNotification.Name(rawValue: "stopPlayer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeProfile), name: NSNotification.Name(rawValue: "changeProfile"), object: nil)
        
        //MARK:- Scroll to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tablev.addSubview(refreshControl) // not required when using UITableViewController
        
        funSetting()
        self.vnavigation.frame.origin.y = 0
        super.viewDidLoad()
    }
    
    @objc func funCamera() {
        self.openCamera()
    }
    func funSetting() {
        btnCamera.setImage(UIImage(named: "camera"), for: .normal)
        btnCamera.addTarget(self, action: #selector(funCamera), for: .touchUpInside)
        // btnCamera.sizeToFit()
        
        lblstatus.text = ""
        lblname.text = username
        
        obj.setimageCircle(image: imgvuserstatus, viewcontroller: self)
        obj.setimageCircle(image: imgv, viewcontroller: self)
        
        // imgvhold.backgroundColor = appclr
        
        //MARK;- Boom button Code
        self.boombutton.isUserInteractionEnabled = false
        //boombutton.buttonEnum = .simpleCircle
        boombutton.buttonEnum = .textInsideCircle
        boombutton.piecePlaceEnum = .dot_6_1
        boombutton.buttonPlaceEnum = .sc_6_1
        //boombutton.duration = 1
        boombutton.hasBackground = false
        boombutton.boomDelegate = self
        imgvmike.center = imgvhold.center
        
        boombutton.target(forAction: #selector(funHideKeyboard), withSender: self)
        
        for i in 0..<boombutton.piecePlaceEnum.pieceNumber() {
            addBuilder(i: i)
        }
     //   obj.setBottomShadow(object: self.txtmsg)
        self.txtmsgv.layer.borderWidth = 0.2
        self.bgvSlideToLock.layer.borderWidth = 0.2
        self.bgvaudiotimer.layer.borderWidth = 0.2
        self.txtmsgv.layer.borderColor = UIColor.lightGray.cgColor
        self.bgvaudiotimer.layer.borderColor = UIColor.lightGray.cgColor
        self.bgvSlideToLock.layer.borderColor = UIColor.lightGray.cgColor
        self.txtmsgv.delegate = self
        
        DispatchQueue.main.async {
            self.txtmsgv.layer.cornerRadius = self.txtmsgv.frame.size.height / 2
            self.bgvaudiotimer.layer.cornerRadius = self.bgvaudiotimer.frame.size.height / 2
            self.bgvSlideToLock.layer.cornerRadius = self.bgvSlideToLock.frame.size.width / 2
            //  obj.putRightViewAndButtonInTextViewField(button: self.btnCamera, view: self.boombutton, txtview: self.txtmsgv, x: 0, width: 40, height: 40)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
                print("Fire timer \(timer)")
                self.boombutton.isUserInteractionEnabled = true
                if self.unSeenCount == "0"{
                   // self.txtmsgv.becomeFirstResponder()
                }
                DispatchQueue.main.async {
                    //obj.setBottomShadow(object: self.txtmsgv)
                    //obj.setViewShade(view: self.bgvaudiotimer)
                   // obj.setViewShade(view: self.bgvSlideToLock)
                    self.txtmsgv.backgroundColor = .white
                    self.txtmsgv.clipsToBounds = true
                }
            }
        }
        //End Boom Button Code
        
        if groupType == PRIVATECHAT {
            if username.isAlphabatic {
                print("String not contain only Alphabatic")
                dataarray = arrPrivateChat
            }
            else if username.isNumeric {
                print("String contain only Numeric")
                dataarray = arrPrivateChatWithAddContact
            }
            else {
                print("String contain String and Numeric Both")
                dataarray = arrPrivateChat
            }
            otherUserStatusTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { timer in
                DispatchQueue.main.async {
                    self.getOtherUserLastOnlineTime()
                }
                print(". . . . . . . . . . . . . . . . . .")
            }
            getUserProfile()
             if groupId != "" {
                //MARK:- When Chat Screen Run Frist time own Message Count should be Zero
                self.retreiveMessages()
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        self.isdeliverWhenMsgScreenOpen()
                    }
                }
            }
            else {
                retreivePrivateChatGroupId()
            }
            if userprofilepic != "" {
                //Kingfisher Image upload
                let url = URL(string: userprofilepic)
               
                imgv.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    if (image != nil){
                        self.imgv.image = image
                    }
                    else {
                        self.self.imgv.image = UIImage(named: "user")
                    }
                })

            }
        }
        else if groupType == PUBLICGROUP {
            self.retreiveMessages()
            dataarray = arrGroupChat
            fetchGroupParticipant()
            fetchGroupDetails()
            isdeliverWhenMsgScreenOpen()
            imgvuserstatus.isHidden = true
            btnAudioCall.isHidden = true
            btnVideoCall.isHidden = true
            imgvCallDelete.isHidden = true
            imgvVideoCallCopy.isHidden = true
            if userprofilepic != "" {
                //Kingfisher Image upload
                let url = URL(string: userprofilepic)
                
                imgv.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    if (image != nil){
                        self.imgv.image = image
                    }
                    else {
                        self.imgv.image = UIImage(named: "groupicon")
                    }
                })
            }
            else {
                imgv.image = UIImage(named: "groupicon")
                imgv.backgroundColor = UIColor.white
            }
        }
        
        //MARK:- Add Long Gesture
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.allowableMovement = 15 // 15 points
        longPressGesture.delegate = self
        self.tablev.addGestureRecognizer(longPressGesture)
        
        //MARK:- Add Tap Gesture
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPressed(sender:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.tablev.addGestureRecognizer(tapGesture)
        
        //MARK:- Register Cell for Send and Receive Message
        // Do any additional setup after loading the view.
        self.tablev.register(UINib(nibName: "ChatSendCell", bundle: nil), forCellReuseIdentifier: "ChatSendCell")
        self.tablev.register(UINib(nibName: "ChatReceiveCell", bundle: nil), forCellReuseIdentifier: "ChatReceiveCell")
        
        self.tablev.register(UINib(nibName: "SenderDeleteCell", bundle: nil), forCellReuseIdentifier: "SenderDeleteCell")
        self.tablev.register(UINib(nibName: "ReceiverDeleteCell", bundle: nil), forCellReuseIdentifier: "ReceiverDeleteCell")
        
        self.tablev.register(UINib(nibName: "SendContactCell", bundle: nil), forCellReuseIdentifier: "SendContactCell")
        
        self.tablev.register(UINib(nibName: "ReceiveContactCell", bundle: nil), forCellReuseIdentifier: "ReceiveContactCell")
        
        self.tablev.register(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
        self.tablev.register(UINib(nibName: "imgCaptionReceiverCell", bundle: nil), forCellReuseIdentifier: "imgCaptionReceiverCell")
        self.tablev.register(UINib(nibName: "imgCaptionSenderCell", bundle: nil), forCellReuseIdentifier: "imgCaptionSenderCell")
    }
    
    let imageNames: [String] = ["searchboom","cameraboom","galleryboom","locationboom","audioboom","userboom","bee","bee"]
    let buttonNames: [String] = ["Docs","Camera","Gallery","Location","Audio","Contacts","bee","bee"]
    
    func addBuilder(i : Int) {
        //let builder = SimpleCircleButtonBuilder.init()
        let builder = TextInsideCircleButtonBuilder()
        //MARK- Boom Button Clicked Action
        builder.clickedClosure = { [weak self] (index: Int) in
            guard self != nil else { return }
            
            switch index {
            case 0:
                self!.OpenDocumentGallary()
                break
            case 1:
                self!.openCamera()
                //self!.openVideoGallery()
                break
            case 2:
                self!.openGallary()
                break
            case 3:
                self!.shareLocation()
                break
            case 4:
                self!.openAudio()
                break
            case 5:
                self!.openContact()
                break
                
            default:
                break
            }
            // print(i)
        }
        builder.normalText = buttonNames[i]
        builder.normalImageName = imageNames[i]
        //MARK:- Custom Builder Settings
        if IPAD{
            builder.imageSize = CGSize.init(width: 70, height: 70)
            builder.textFont = UIFont.systemFont(ofSize: self.fontsize)
            builder.textFont = UIFont.systemFont(ofSize: 24)
            builder.imageFrame.origin.y = builder.imageFrame.origin.y - 16
            builder.textFrame.origin.y = builder.textFrame.origin.y - 16
        }
        else {
            builder.imageSize = CGSize.init(width: 35, height: 35)
            builder.textFont = UIFont.systemFont(ofSize: 12)
            if i == 5{
                builder.textFont = UIFont.systemFont(ofSize: 11)
            }
            builder.imageFrame.origin.y = builder.imageFrame.origin.y - 8
            builder.textFrame.origin.y = builder.textFrame.origin.y - 8
        }
        
        boombutton.addBuilder(builder)
    }
    @objc func stopPlayer() {
        if audioplayerisplaying != "stop" {
            //audioPlayer.stop()
            let button = UIButton()
            button.tag = playeraudioindex
            DispatchQueue.main.async {
                self.funTapOnAudio(sender: button)
            }
        }
    }
    @objc func funHideKeyboard() {
        self.view.endEditing(true)
    }
    @objc func refresh(sender:AnyObject) {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            print("Fire timer \(timer)")
            self.tablev.reloadData()
            self.refreshControl.endRefreshing()
        }
        // Code to refresh table view
    }
    
    @objc func funrefresh() {
        
    }
    @objc func funback() {
        otherUserStatusTimer.invalidate()
        ParticipantsDB.child(groupId).removeAllObservers()
        navigationController?.popViewController(animated: true)
    }
    //MARK:- Did Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrSelectedDeletIndex.count == 0 {
            return
        }
        //MARK:- Select Unselect Table View Cells for Delete
        funTableSelectUnselect(indexPath: indexPath)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMsgId.count
    }
    func checkselecteindex(index: Int, view: UIView) {
        if arrSelectedDeletIndex.count > 0 {
            if arrSelectedDeletIndex.contains(index) {
                view.isHidden = false
            }
            else {
                view.isHidden = true
            }
        }
        else {
            view.isHidden = true
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        DispatchQueue.main.async {
            cell.contentView.reloadInputViews()
            cell.setNeedsLayout()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK:- This is Sender Cell which will display from Right Side
        //MARK:- If True its means self sended messages
        
        let timestring = obj.convertTimespamIntoTime(timestring: "\(arrMsgTime[indexPath.row] as! Int)")
        let cellMsgType = arrMsgType[indexPath.row] as? Int
        var statutype = Int()
        if let status = arrMsgStatus[indexPath.row] as? String {
            statutype = Int(status)!
        }
        else if let status = arrMsgStatus[indexPath.row] as? Int {
            statutype = status
        }
        if cellMsgType == GROUP_INFO_MESSAGE {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            cell.lblmsg.text = arrMsg[indexPath.row] as? String
            return cell
        }
        else if cellMsgType == LEFT_GROUP || cellMsgType == CREATE_GROUP || cellMsgType == ADD_MEMBER || cellMsgType == REMOVE_MEMBER || cellMsgType == GROUP_ADMIN {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            var tempTextMsg = arrMsg[indexPath.row] as! String
            var tempphone = ""
            var tempphone2 = ""
            if cellMsgType == ADD_MEMBER || cellMsgType == REMOVE_MEMBER{
                let strArray = tempTextMsg.components(separatedBy: " ")
                tempphone = strArray[0].components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                if strArray.count > 2{
                    tempphone2 = strArray[2].components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                }

                if tempphone == USERUniqueID {
                    tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: "You")
                }
                else {
                    let tempname = obj.getContactNameFromNumber(contactNumber: "\(tempphone)")
                    tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: tempname)
                }
                if tempphone2 == USERUniqueID {
                    tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone2, with: "You")
                }
                else {
                    let tempname = obj.getContactNameFromNumber(contactNumber: "\(tempphone2)")
                    tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone2, with: tempname)
                }
                
            }
            else {
                if cellMsgType == CREATE_GROUP{
                    let strArray = tempTextMsg.components(separatedBy: " ")
                    tempphone = strArray[0].components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                }
                else {
                    tempphone = tempTextMsg.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                }
                
                if tempphone == USERUniqueID {
                    tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: "You")
                }
                else{
                    let tempname = obj.getContactNameFromNumber(contactNumber: "\(tempphone)")
                    tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: tempname)
                }
            }
            //let tempname = obj.getContactNameFromNumber(contactNumber: "\(tempphone)")
//                tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: tempname)
            
            cell.lblmsg.text = tempTextMsg
            return cell
        }
        if arrMsgFomid[indexPath.row] as! String == fromuid {
            if statutype == MESSAGE_DELETED {//MARK:- If Message is deleted
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "SenderDeleteCell", for: indexPath) as! SenderDeleteCell
                cell.lbltime.text = "\(timestring)"
                cell.lblmsg.text = "You deleted this message"
                cell.lblmsg.textColor = .lightGray
                cell.lblmsg.font = UIFont.italicSystemFont(ofSize: cell.lblmsg.font.pointSize)
                obj.setImageViewShade(imageview: cell.vbg)
                return cell
            }
            else if cellMsgType == IMAGE || cellMsgType == VIDEO {
                //MARK:- Picture Message
                //MARK:- Sender Cell
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "imgCaptionSenderCell", for: indexPath) as! imgCaptionSenderCell
                obj.labelunlimitedtext(label: cell.lblmsg)
                cell.lblmsg.text = arrMsg[indexPath.row] as? String ?? ""
                cell.lblmsg.sizeToFit()
                labelfontsize(label: cell.lblmsg)

                if cellMsgType == IMAGE {
                    cell.imgvplayvideo.isHidden = true
                    if let tempurl = arrMsgPic[indexPath.row] as? String {
                        self.funImageTask(urlString: tempurl, imageview: cell.imgv, type: IMAGE, isAuto: true, isProgressBarShow: false)
                    }
                }
                else if cellMsgType == VIDEO {
                    cell.lblmsg.text = ""
                    cell.imgvplayvideo.isHidden = false
                    //MARK:- thumb ko bad main chage karna ha arrMsgPic k sat zeeshan galat bhaj raha ha
                    if let tempurl = arrMsgPicThumb[indexPath.row] as? String {
                        self.funImageTask(urlString: tempurl, imageview: cell.imgv, type: IMAGE, isAuto: false, isProgressBarShow: false)
                    }
                    if let tempurl = arrMsgVideo[indexPath.row] as? String {
                        self.funImageTask(urlString: tempurl, imageview: cell.imgv, type: VIDEO, isAuto: true, isProgressBarShow: false)
                    }
                }
                
                //MARK:- Message Status Set
                self.setMessageStatusForCell(msgStatus: statutype, imageview: cell.imgvmsgstatus)
                obj.setImageViewShade(imageview: cell.imgvbg)
                checkselecteindex(index: indexPath.row, view: cell.vselection)
                cell.lbltime.text = "\(timestring)"
                return cell
            }
            else if cellMsgType == AUDIO {
                //MARK:- Voice Message
                //Receiver Cell
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "cellreceivervoice", for: indexPath) as! MessagingReceiverCell
                
                cell.btnplay.tag = indexPath.row
                cell.btnplay.addTarget(self, action: #selector(funTapOnAudio(sender:)), for: .touchUpInside)
                
                cell.slider.tag = indexPath.row
                cell.slider.addTarget(self, action: #selector(seekBarValueChange), for: .valueChanged)
                cell.slider.isUserInteractionEnabled = false
                
                cell.lblcurrentvoicetime.text = "00:00"
                if let temptotaltime = arrMsg[indexPath.row] as? String {
                    cell.lbltotalvoicetime.text = temptotaltime
                }
                if arrImagePlayPause[indexPath.row] == "play" {
                    //cell.btnplay.setImage(UIImage(named:"play"), for: .normal)
                    obj.putImgInButtonWithOutLabelForCell(button: cell.btnplay, imgname: "play")
                }
                else {
                    //cell.btnplay.setImage (UIImage(named:"pause"), for: .normal)
                    obj.putImgInButtonWithOutLabelForCell(button: cell.btnplay, imgname: "pause")
                }
                self.funImageTask(urlString: arrMsgPic[indexPath.row] as! String, imageview: UIImageView(), type: IMAGE, isAuto: true, isProgressBarShow: false)
                
                //MARK:- Message Status Set
                self.setMessageStatusForCell(msgStatus: statutype, imageview: cell.imgvmsgstatus)
                obj.setImageViewShade(imageview: cell.imgvbg)
                
                cell.lbltime.text = "\(timestring)"
                checkselecteindex(index: indexPath.row, view: cell.vselection)
                return cell
            }
            else if cellMsgType == LOCATION {
                //MARK:- Location Message
                //MARK:- Sender Cell
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "cellreceiverLocation", for: indexPath) as! MessagingReceiverCell
                

                cell.imgv.layer.borderWidth = 1
                cell.imgv.layer.borderColor = UIColor.yellow.cgColor
                cell.imgv.layer.cornerRadius = cell.imgv.frame.size.height / 2
                if let templat = (arrMsgLat[indexPath.row] as? Double), let templong = (arrMsgLong[indexPath.row] as? Double) {
                    movetosaidlocation(lat: Double(templat), long: Double(templong), vformap: cell.vformap)
                }
                //MARK:- Message Status Set
                self.setMessageStatusForCell(msgStatus: statutype, imageview: cell.imgvmsgstatus)
                
                cell.btnmap.tag = indexPath.row
                cell.btnmap.addTarget(self, action: #selector(funRedirectGoogleNav), for: .touchUpInside)
                obj.setImageViewShade(imageview: cell.imgvbg)
                
                cell.lbltime.text = "\(timestring)"
                checkselecteindex(index: indexPath.row, view: cell.vselection)
                
                return cell
            }
            else if cellMsgType == CONTACT || cellMsgType == DOCUMENT {
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "SendContactCell", for: indexPath) as! SendContactCell
                 obj.labelunlimitedtext(label: cell.lblmsg)
                //MARK:- Message Status Set
                self.setMessageStatusForCell(msgStatus: statutype, imageview: cell.imgvmsgstatus)
                cell.lblmsg.text = arrMsg[indexPath.row] as? String
                // cell.lblmsg.sizeToFit()
                // labelfontsize(label: cell.lblmsg)
                cell.lbltime.text = "\(timestring)"
                obj.setImageViewShade(imageview: cell.vbg)
                obj.setimageCircle(image: cell.vbgcontactimg, viewcontroller: self)
                cell.vbgpurple.layer.cornerRadius = 4
                checkselecteindex(index: indexPath.row, view: cell.vselection)
                if cellMsgType == CONTACT{
                    cell.imgvcontact.image = UIImage(named: "contactno")
                }
                else if cellMsgType == DOCUMENT{
                    cell.imgvcontact.image = UIImage(named: "document")
                }
                return cell
            }
            else {
                //MARK:- Text Messaage
                //Receiver Cell
                let cell: ChatSendCell = self.tablev.dequeueReusableCell(withIdentifier: "ChatSendCell", for: indexPath) as! ChatSendCell
                
                obj.labelunlimitedtext(label: cell.lblmsg)
                
                //MARK:- Message Status Set
                self.setMessageStatusForCell(msgStatus: statutype, imageview: cell.imgvmsgstatus)
                cell.lblmsg.text = arrMsg[indexPath.row] as? String
                cell.lblmsg.sizeToFit()
                labelfontsize(label: cell.lblmsg)
                cell.lbltime.text = "\(timestring)"
                obj.setImageViewShade(imageview: cell.vbg)
                obj.findLinkInText(label: cell.lblmsg)
                checkselecteindex(index: indexPath.row, view: cell.vselection)
                
                return cell
            }
        }
        else {
            //MARK:-  its means Receive Messages from other user
            if statutype == MESSAGE_DELETED {//MARK:- If Message is deleted
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "ReceiverDeleteCell", for: indexPath) as! ReceiverDeleteCell
                cell.lbltime.text = "\(timestring)"
                cell.lblmsg.text = "User deleted this message"
                cell.lblmsg.textColor = .lightGray
                cell.lblmsg.font = UIFont.italicSystemFont(ofSize: 14)
                obj.setImageViewShade(imageview: cell.vbg)
                return cell
            }
            else if cellMsgType == IMAGE || cellMsgType == VIDEO {
                //MARK:- Picture Message
                let tempCaption = arrMsg[indexPath.row] as! String
                //MARK:- Caption Image/Video Cell
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "imgCaptionReceiverCell", for: indexPath) as! imgCaptionReceiverCell
                
                cell.lblmsg.text = tempCaption
                cell.lblmsg.sizeToFit()
                labelfontsize(label: cell.lblmsg)
                cell.imgv.image = selectedimage
               // print(timestring)
                if cellMsgType == IMAGE {
                        cell.imgvplayvideo.isHidden = true
                        if let tempurl = arrMsgPic[indexPath.row] as? String {
                            self.funImageTask(urlString: tempurl, imageview: cell.imgv, type: IMAGE, isAuto: true, isProgressBarShow: false)
                        }
                }
                else if cellMsgType == VIDEO {
                    cell.lblmsg.text = ""
                        cell.imgvplayvideo.isHidden = false
                        //MARK:- thumb ko bad main chage karna ha arrMsgPic k sat zeeshan galat bhaj raha ha
                        if let tempurl = arrMsgPicThumb[indexPath.row] as? String{
                            self.funImageTask(urlString: tempurl, imageview: cell.imgv, type: IMAGE, isAuto: false, isProgressBarShow: false)
                        }
                        if let tempurl = arrMsgVideo[indexPath.row] as? String {
                            self.funImageTask(urlString: tempurl, imageview: cell.imgv, type: VIDEO, isAuto: true, isProgressBarShow: false)
                        }
                }
                obj.setImageViewShade(imageview: cell.imgvbg)
                checkselecteindex(index: indexPath.row, view: cell.vselection)
                cell.lbltime.text = "\(timestring)"
                return cell
            }
            else if cellMsgType == AUDIO {
                //MARK:- Receiver Cell
                let cell3 = self.tablev.dequeueReusableCell(withIdentifier: "cellsendervoice", for: indexPath) as! MessagingSenderCell
                //MARK:- Voice Message
                //SEnder Cell
                //let cell = self.tablev.dequeueReusableCell(withIdentifier: "cellsendervoice") as! MessagingSenderCell
                cell3.btnplay.tag = indexPath.row
                cell3.btnplay.addTarget(self, action: #selector(funTapOnAudio(sender:)), for: .touchUpInside)
                cell3.slider.tag = indexPath.row
                cell3.slider.addTarget(self, action: #selector(seekBarValueChange), for: .valueChanged)
                cell3.slider.isUserInteractionEnabled = false
                
                cell3.lblcurrentvoicetime.text = "00:00"
                //cell3.lbltotalvoicetime.text = arrMsg[indexPath.row] as? String
                if let temptotaltime = arrMsg[indexPath.row] as? String {
                    cell3.lbltotalvoicetime.text = temptotaltime
                }
                if arrImagePlayPause[indexPath.row] == "play" {
                    //cell3.btnplay.setImage(UIImage(named:"play"), for: .normal)
                    obj.putImgInButtonWithOutLabelForCell(button: cell3.btnplay, imgname: "play")
                }
                else {
                    // cell3.btnplay.setImage (UIImage(named:"pause"), for: .normal)
                    obj.putImgInButtonWithOutLabelForCell(button: cell3.btnplay, imgname: "pause")
                }
                self.funImageTask(urlString: arrMsgPic[indexPath.row] as! String, imageview: UIImageView(), type: AUDIO, isAuto: true, isProgressBarShow: false)
                
                obj.setImageViewShade(imageview: cell3.imgvbg)
                cell3.lbltime.text = "\(timestring)"
                checkselecteindex(index: indexPath.row, view: cell3.vselection)
                
                return cell3
            }
            else if cellMsgType == LOCATION {
                //MARK:- Receiver Cell
                let cell4 = self.tablev.dequeueReusableCell(withIdentifier: "cellsenderLocation", for: indexPath) as! MessagingSenderCell
                cell4.imgv.image = selectedimage

                cell4.imgv.layer.borderWidth = 1
                cell4.imgv.layer.borderColor = UIColor.yellow.cgColor
                cell4.imgv.layer.cornerRadius = cell4.imgv.frame.size.height / 2
                if let templat = (arrMsgLat[indexPath.row] as? Double), let templong = (arrMsgLong[indexPath.row] as? Double) {
                    movetosaidlocation(lat: Double(templat), long: Double(templong), vformap: cell4.vformap)
                }
                
                cell4.btnmap.tag = indexPath.row
                cell4.btnmap.addTarget(self, action: #selector(funRedirectGoogleNav), for: .touchUpInside)
                obj.setImageViewShade(imageview: cell4.imgvbg)
                
                cell4.lbltime.text = "\(timestring)"
                checkselecteindex(index: indexPath.row, view: cell4.vselection)
                return cell4
            }
            else if cellMsgType == CONTACT || cellMsgType == DOCUMENT {
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "ReceiveContactCell", for: indexPath) as! ReceiveContactCell
                // obj.labelunlimitedtext(label: cell.lblmsg)
                //MARK:- Message Status Set
                cell.lblmsg.text = arrMsg[indexPath.row] as? String
                // cell.lblmsg.sizeToFit()
                // labelfontsize(label: cell.lblmsg)
                cell.lbltime.text = "\(timestring)"
                obj.setImageViewShade(imageview: cell.vbg)
                obj.setimageCircle(image: cell.vbgcontactimg, viewcontroller: self)
                cell.vbgpurple.layer.cornerRadius = 4
                checkselecteindex(index: indexPath.row, view: cell.vselection)
                if cellMsgType == CONTACT{
                    cell.imgvcontact.image = UIImage(named: "contactno")
                }
                else if cellMsgType == DOCUMENT{
                    cell.imgvcontact.image = UIImage(named: "document")
                }
                return cell
            }
            else {
                //MARK:- Text Message
                //                //SEnder Cell
                
                let cell: ChatReceiveCell = self.tablev.dequeueReusableCell(withIdentifier: "ChatReceiveCell", for: indexPath) as! ChatReceiveCell
                obj.labelunlimitedtext(label: cell.lblmsg)
                if arrMsgStatus[indexPath.row] as? Int == MESSAGE_DELETED {
                    cell.lblmsg.text = "User deleted this message"
                }
                else {
                    //MARK:- Message Status Set
                    cell.lblmsg.text = arrMsg[indexPath.row] as? String
                }
                cell.lblmsg.sizeToFit()
                labelfontsize(label: cell.lblmsg)
                cell.lbltime.text = "\(timestring)"
                obj.setImageViewShade(imageview: cell.vbg)
                checkselecteindex(index: indexPath.row, view: cell.vselection)
                obj.findLinkInText(label: cell.lblmsg)
                return cell
            }
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
       
    }
    var fontsize = CGFloat()
    func labelfontsize(label: UILabel) {
        DispatchQueue.main.async{
            if IPAD {
                label.font = UIFont.systemFont(ofSize: self.fontsize*2)
            }
            else {
                label.font = UIFont.systemFont(ofSize: self.fontsize)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = arrMsgType[indexPath.row] as? Int
        if type == LOCATION {
            if IPAD {
                return 171*2
            }
            return 171
        }
        else if arrMsgType[indexPath.row] as? String == "\(AUDIO)" || type == AUDIO {
            if IPAD {
                return 67*2
            }
            return 67
        }
        else if type == CONTACT || arrMsgType[indexPath.row] as? String == "\(CONTACT)" || type == DOCUMENT || arrMsgType[indexPath.row] as? String == "\(DOCUMENT)" {
            if IPAD
            {
                return 75*2
            }
            return 75
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
    func setMessageStatusForCell(msgStatus: Int, imageview: UIImageView) {
//        if arrMsgFomid[indexPath.row] as! String == fromuid
//        {
//
//        }
        if msgStatus == NOT_DELIVERED {
            // imageview.image = UIImage(named: "msgnotsent")
            imageview.image = UIImage(named: "msgsent")
        }
        else if msgStatus == SENT {
            imageview.image = UIImage(named: "msgsent")
        }
        else if msgStatus == DELIVERED {
            imageview.image = UIImage(named: "msgdeliver")
        }
        else if msgStatus == SEEN {
            imageview.image = UIImage(named: "msgseen")
        }
    }
    
    //MARK:- Cell image task
    func funImageTask(urlString: String, imageview: UIImageView, type: Int, isAuto: Bool, isProgressBarShow: Bool){
        if type == VIDEO{
            obj.funDownloadPlayShow(urlString: urlString, type: type, isAuto: isAuto, isProgressBarShow: isProgressBarShow, viewController: self, completion: { url in
            })
        }
        else if type == AUDIO{
            obj.funDownloadPlayShow(urlString: urlString, type: type, isAuto: isAuto, isProgressBarShow: isProgressBarShow, viewController: self, completion: { url in
            })
        }
        else{
            obj.funDownloadPlayShow(urlString: urlString, type: type, isAuto: isAuto, isProgressBarShow: isProgressBarShow, viewController: self, completion: { url in
                if url == ""{
                    imageview.image = UIImage(named: "tempimg")
                    imageview.contentMode = .scaleAspectFit
                }
                else if let imageData = NSData(contentsOf: URL(string: url!)!) {
                    let image = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
                    DispatchQueue.main.async{
                        imageview.image = image
                        imageview.contentMode = .scaleAspectFill
                    }
                    
                }
                else {
                    DispatchQueue.main.async{
                        imageview.image = UIImage(named: "tempimg")
                        imageview.contentMode = .scaleAspectFit
                    }
                }
            })
        }
    }
    //MARK:- Long Press Gesture
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            return
        }
        else if sender.state == UIGestureRecognizer.State.began
        {
            let p = sender.location(in: self.tablev)
            let indexPath = self.tablev.indexPathForRow(at: p)
            funTableSelectUnselect(indexPath: indexPath!)
        }
        else {
            print("Could not find index path")
        }
    }
    
    //MARK:- Tap Gesture
    @objc func tapPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            let p = sender.location(in: self.tablev)
            let indexPath = self.tablev.indexPathForRow(at: p)
            if indexPath == nil {
                return
            }
            if arrSelectedDeletIndex.count == 0 {
                if arrMsgType[indexPath!.row] as! Int == IMAGE || arrMsgType[indexPath!.row] as! Int == VIDEO {
                    showimage(index: indexPath!.row)
                }
                else if arrMsgType[indexPath!.row] as! Int == CONTACT {
                    if let tempmsg = arrMsg[indexPath!.row] as? String {
                        do {
                            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
                            let matches = detector.matches(in: tempmsg, range: NSRange(tempmsg.startIndex..., in: tempmsg))
                            for match in matches{
                                if match.resultType == .phoneNumber, let number = match.phoneNumber {
                                    print(number)
                                    print(number)
                                    var tempphone = number.replacingOccurrences(of: " ", with: "")
                                    tempphone = tempphone.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
                                    DispatchQueue.main.async{
                                        self.dialNumber(number: tempphone)
                                    }
                                    break
                                }
                            }
                            if matches.count == 0{
                                obj.showToast(message: "Phone number is not valid...", viewcontroller: self)
                            }
                            //print(matches)
                            //print(matches)
                        } catch {
                            print(error)
                        }
                    }
                }
                else if arrMsgType[indexPath!.row] as! Int == DOCUMENT{
                    if arrMsgStatus[indexPath!.row] as! Int == MESSAGE_DELETED{
                        return
                    }
                    if let url = URL(string: "\(arrMsgPic[indexPath!.row])") {
                        UIApplication.shared.open(url)
                    }
                }
            }
            else {
                //MARK:- Select Unselect Table View Cells for Delete
                funTableSelectUnselect(indexPath: indexPath!)
            }
        }
        if sender.state == UIGestureRecognizer.State.began {
            
        }
    }
    func dialNumber(number : String) {
        var tempphone = number
        tempphone = tempphone.replacingOccurrences(of: " ", with: "")
        tempphone = tempphone.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        if let url = URL(string: "tel://\(tempphone)"),UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
        } else {
            obj.showToast(message: "Can't make call from this device", viewcontroller: self)
        }
    }
    func funTableSelectUnselect(indexPath: IndexPath) {
        let index = indexPath
        // do stuff with your cell, for example print the indexPath
        //print("longpressed Tag: \(index.row)")
        if arrMsgStatus[index.row] as! Int == MESSAGE_DELETED{
            //MARK:- if tap on deleted message
            return
        }
        var selectunselect = 0
        if arrSelectedDeletIndex.contains(index.row) == true
        {
            let indexofcell = arrSelectedDeletIndex.firstIndex(of:index.row)
            arrSelectedDeletIndex.remove(at: indexofcell!)
            selectunselect = 1
        }
        else{
            arrSelectedDeletIndex.append(index.row)
            selectunselect = 0
        }
        if arrMsgFomid[index.row] as! String == USERUID {
            //MARK:- Sender Cell
            if arrMsgType[indexPath.row] as? Int == TEXT {
                let cell = self.tablev.cellForRow(at: index) as! ChatSendCell
                tablev.beginUpdates()
                if selectunselect == 1 {
                    cell.vselection.isHidden = true
                }
                else{
                    cell.vselection.isHidden = false
                }
                tablev.endUpdates()
            }
            else if arrMsgType[indexPath.row] as? Int == CONTACT || arrMsgType[indexPath.row] as? Int == DOCUMENT {
                let cell = self.tablev.cellForRow(at: index) as! SendContactCell
                tablev.beginUpdates()
                if selectunselect == 1 {
                    cell.vselection.isHidden = true
                }
                else{
                    cell.vselection.isHidden = false
                }
                tablev.endUpdates()
            }
            else {
                let cell = self.tablev.cellForRow(at: index) as! imgCaptionSenderCell
                tablev.beginUpdates()
                if selectunselect == 1 {
                    cell.vselection.isHidden = true
                }
                else{
                    
                    cell.vselection.isHidden = false
                }
                tablev.endUpdates()
            }
        }
        else {
            //MARK:- Receiver Cell
            if arrMsgType[indexPath.row] as? Int == TEXT {
                let cell = self.tablev.cellForRow(at: index) as! ChatReceiveCell
                tablev.beginUpdates()
                if selectunselect == 1 {
                    cell.vselection.isHidden = true
                }
                else {
                    cell.vselection.isHidden = false
                }
                tablev.endUpdates()
            }
            else if arrMsgType[indexPath.row] as? Int == CONTACT || arrMsgType[indexPath.row] as? Int == DOCUMENT {
                let cell = self.tablev.cellForRow(at: index) as! ReceiveContactCell
                tablev.beginUpdates()
                if selectunselect == 1
                {
                    cell.vselection.isHidden = true
                }else{
                    cell.vselection.isHidden = false
                }
                tablev.endUpdates()
            }
            else {
                let cell = self.tablev.cellForRow(at: index) as! imgCaptionReceiverCell
                tablev.beginUpdates()
                if selectunselect == 1
                {
                    cell.vselection.isHidden = true
                }else{
                    cell.vselection.isHidden = false
                    //cell.contentView.backgroundColor = appclr.withAlphaComponent(0.15)
                }
                tablev.endUpdates()
            }
        }
        if arrSelectedDeletIndex.count > 0 {
            selectionMessages()
        }
        else {
            unSelectionMessages()
        }
    }
    func selectionMessages() {
        imgv.isHidden = true
        lblstatus.isHidden = true
        lblname.isHidden = true
        imgvuserstatus.isHidden = true
        lblSelectionCount.text = "\(arrSelectedDeletIndex.count) Selected"
        lblSelectionCount.isHidden = false
        imgvCallDelete.image = UIImage(named: "trash")
        imgvVideoCallCopy.image = UIImage(named: "copy")
        imgvDotsFwd.image = UIImage(named: "forward")
        //
        iscopytext = 1
        canDeleteEveryOne = 1
        for i in arrSelectedDeletIndex {
            if arrMsgType[i] as? Int == IMAGE || arrMsgType[i] as? Int == AUDIO || arrMsgType[i] as? Int == VIDEO || arrMsgType[i] as? Int == DOCUMENT || arrMsgType[i] as? Int == LOCATION {
                iscopytext = 0
            }
            
            let selected = obj.ifPreviousDateMessageSelect(timestring: "\(arrMsgTime[i] as! Int)")
            if selected == "0" {
                canDeleteEveryOne = 0
            }
            if arrMsgFomid[i] as! String == self.touid {
                canDeleteEveryOne = 0
            }
        }
        
        if iscopytext == 0 {
            imgvCallDelete.isHidden = true
            imgvVideoCallCopy.image = nil
        }
        else {
            imgvCallDelete.isHidden = false
            imgvVideoCallCopy.image = UIImage(named: "copy")
        }
        print("Total Selected Count: \(arrSelectedDeletIndex.count)")
        
        imgvCallDelete.isHidden = false
        imgvVideoCallCopy.isHidden = false
        btnAudioCall.isHidden = false
        btnVideoCall.isHidden = false
    }
    func unSelectionMessages() {
        imgv.isHidden = false
        lblstatus.isHidden = false
        lblname.isHidden = false
        imgvCallDelete.isHidden = false
        //imgvuserstatus.isHidden = false
        lblSelectionCount.isHidden = true
        imgvCallDelete.image = UIImage(named: "callicon")
        imgvVideoCallCopy.image = UIImage(named: "video")
        imgvDotsFwd.image = UIImage(named: "dots")
        
        imgvCallDelete.isHidden = true
        imgvVideoCallCopy.isHidden = true
        btnAudioCall.isHidden = true
        btnVideoCall.isHidden = true
    }
    //MARK:- Function table view scroll to bottom
    func scrolltobottom(indexpath: IndexPath) {
        if indexpath.row < 0 {
            return
        }
        DispatchQueue.main.async {
            self.tablev.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0); //values
            self.tablev.scrollToRow(at: indexpath, at: .bottom, animated: true)
            DispatchQueue.main.async{
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                    self.tablev.isHidden = false
                }
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if keyboardtag == 1 {
            //self.view.endEditing(true)
        }
        DispatchQueue.main.async{
            guard self.tablev.cellForRow(at: IndexPath(row: self.tablev.numberOfRows(inSection: 0)-1, section: 0)) != nil else {
                //MARK:- Last Cell not visibale
                if !self.tablev.isHidden{
                    // if table view is not hidden
                    let indexPath = IndexPath(row: 0, section: 0)
                    if !((self.tablev.indexPathsForVisibleRows?.contains(indexPath))!) {
                      // Means if 0 row is not hidden then we will show the scroll to bottom button
                        self.btnscrolltobottom.isHidden = false
                    }
                }
               
                return
            }
            //MARK:- Last Cell visibale
            self.btnscrolltobottom.isHidden = true
        }
    }
    //Marks: - Video Play button
    @objc func playvideo(index: Int) {
        if arrMsgStatus[index] as! Int == MESSAGE_DELETED{
            //MARK:- if tap on deleted message
            return
        }
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        vc.videoimagetag = VIDEO
        vc.videoimagename = "Video"
        
        obj.funForceDownloadPlayShow(urlString: arrMsgVideo[index] as! String, isProgressBarShow: true, viewController: self, completion: {
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
    //Marks: - Show image button
    @objc func showimage(index: Int) {
        if index == PROFILEPIC {
            let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
            vc.videoimagename = "Picture"
            vc.profilepic = imgv.image!
            vc.videoimagetag = PROFILEPIC
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        if arrMsgType.count < index{
            return
        }
        if arrMsgStatus[index] as! Int == MESSAGE_DELETED{
            //MARK:- if tap on deleted message
            return
        }
        if arrMsgType[index] as! Int == IMAGE {
            
            let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
            vc.videoimagename = "Picture"
            vc.videoimagetag = PROFILEPIC
            
            obj.funForceDownloadPlayShow(urlString: arrMsgPic[index] as! String, isProgressBarShow: true, viewController: self, completion: {
                url in
                
                if url == ""{
                    vc.profilepic = UIImage(named: "tempimg")!
                }
                else if let imageData = NSData(contentsOf: URL(string: url!)!) {
                    let image = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
                    vc.profilepic = image!
                    
                }else{
                    vc.profilepic = UIImage(named: "tempimg")!
                }
                
                
                DispatchQueue.main.async {
                    //MARK:- Reload image row after download
                    let indexPath = IndexPath(item: index, section: 0)
                    self.tablev.reloadRows(at: [indexPath], with: .none)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }
        else if arrMsgType[index] as! Int == VIDEO {
            playvideo(index: index)
        }
    }
    //MARK:- Keyboard handle
    var activeField: UITextField?
    @IBOutlet var scrollView: UIScrollView!
    //    func registerForKeyboardNotifications(){
    //        //Adding notifies on keyboard appearing
    //
    //        //Removing notifies on keyboard appearing
    //        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    //        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    //
    ////        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    ////        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    //    }
    
    var keyboardtag = 0
    var tablevheight = CGFloat()
//    @objc func keyboardWillShowNotification(notification: NSNotification){
//        //Need to calculate keyboard exact size due to Apple suggestions
//        // self.scrollView.isScrollEnabled = true
//
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        //let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
//
//        //  self.tablev.frame.origin.y = vnavigation.frame.maxY + 5
//
//        var aRect :CGRect = self.view.frame
//        if let activeField = self.activeField {
//            if activeField == txtmsg
//            {
//                // if (!(aRect.contains(activeField.frame.origin))){
//                //self.view.frame = aRect
//                if keyboardtag == 0
//                {
//                    // self.tablev.frame.size.height -= (keyboardSize!.height - 120)
//                    self.view.frame.size.height = self.view.frame.size.height - (keyboardSize!.height)
//                    self.tablev.frame.size.height = tablevheight - (keyboardSize!.height)//self.view.frame.size.height - 120
//                    DispatchQueue.main.async{
//                        aRect.size.height -= keyboardSize!.height
//                    }
//                    keyboardtag = 1
//                }
//                // }
//            }
//        }
//        if arrMsgType.count > 0
//        {
//            let indexPath = IndexPath(row: self.arrMsgType.count-1, section: 0)
//            DispatchQueue.main.async {
//                self.scrolltobottom(indexpath: indexPath)
//            }
//        }
//    }
    
//    @objc func keyboardWillBeHidden(notification: NSNotification){
//        //Once keyboard disappears, restore original positions
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        //let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
//
//        //  self.tablev.frame.origin.y = vnavigation.frame.maxY + 5
//
//        //self.view.frame = aRect
//        if keyboardtag == 1
//        {
//            // self.view.frame.size.height = self.view.frame.size.height + (288)
//            var aRect :CGRect = self.view.frame
//            // self.view.endEditing(true)
//            aRect.size.height += keyboardSize!.height
//            self.view.frame.size.height = self.view.frame.size.height + (keyboardSize!.height)
//            keyboardtag = 0
//            DispatchQueue.main.async {
//                //  self.tablev.frame.size.height = self.tablevheight
//            }
//        }
//        if arrMsgType.count > 0
//        {
//            let indexPath = IndexPath(row: self.arrMsgType.count-1, section: 0)
//            DispatchQueue.main.async {
//                self.scrolltobottom(indexpath: indexPath)
//            }
//        }
//    }
    //MARK:- Boom Button Delegate when boom meny show
    func boomMenuButtonWillBoom(boomMenuButton bmb: BoomMenuButton) {
        self.view.endEditing(true)
    }
    
    //MARK:- Textfield Delegates
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    //MARK:- Textfield Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK:- Textview Delegates
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            //textView.resignFirstResponder()
            textView.text = textView.text + "\n"
            DispatchQueue.main.async{
                //   obj.putRightViewAndButtonInTextViewField(button: self.btnCamera, view: self.boombutton, txtview: self.txtmsgv, x: 0, width: 40, height: 40)
            }
            return false
        }
        //Remove first white space
        if textView.text.count == 0 && text == " "{
            return false
        }
        let string = text
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            if textView.text.count > 0{
                //textView.text!.removeLast()
            }
            
            if text.count == 0 {
                counttypingstatus = 0
                imgvmike.image = UIImage(named: "unholdmike")
                imgvmike.accessibilityIdentifier = "unholdmike"
                if groupId != "" {
                    if groupType == PRIVATECHAT {
                        isTypingOrRecording(isTypingOrRecording: STOP_TYPING_RECORDING)
                    }
                }
            }
            return true
        }
        
        let newLength = string.count
        if newLength > 0 {
            if counttypingstatus == 0 {
                counttypingstatus = 4
                timertypingstatus = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] timer in
                    //                        self!.counttypingstatus -= 1
                    //                        if self?.counttypingstatus == 0 {
                    print("Go! Stop Typing")
                    
                    //MARK:- Check
                    if defaults.value(forKey: "is_chatscreen") as? String == "1" {
                        print(self!.groupId)
                        if self!.groupId != "" {
                            self!.counttypingstatus = 0
                            self!.updateOnline()
                            if self!.groupType == PRIVATECHAT {
                                self!.isTypingOrRecording(isTypingOrRecording: STOP_TYPING_RECORDING)
                            }
                        }
                    }
                    else {
                        return
                    }
                }
                
                if groupId != "" {
                    if self.groupType == PRIVATECHAT {
                        isTypingOrRecording(isTypingOrRecording: TYPING)
                    }
                }
            }
            else {
                counttypingstatus = 4
            }
            
            let trimmedString = string.trimmingCharacters(in: .whitespaces)
            if (trimmedString.count > 0){
                imgvmike.image = UIImage(named: "send")
                imgvmike.accessibilityIdentifier = "send"
            }
        }
        if newLength == 0 {
            counttypingstatus = 0
            if groupId != "" {
                if self.groupType == PRIVATECHAT {
                    isTypingOrRecording(isTypingOrRecording: STOP_TYPING_RECORDING)
                }
            }
            let trimmedString = string.trimmingCharacters(in: .whitespaces)
            if (trimmedString.count > 0) {
                imgvmike.image = UIImage(named: "send")
                imgvmike.accessibilityIdentifier = "send"
            }
            else {
                imgvmike.image = UIImage(named: "unholdmike")
                imgvmike.accessibilityIdentifier = "unholdmike"
            }
            //SendAlert(text : "TypingStop", title: "TypingStop", content_type: true)
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        counttypingstatus = 0
        //imgvmike.image = UIImage(named: "unholdmike")
        if groupId != "" {
            if groupType == PRIVATECHAT {
                isTypingOrRecording(isTypingOrRecording: STOP_TYPING_RECORDING)
            }
        }
        return true
    }
    //MARK:- Textfield Delegates Did change char
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            textField.text!.removeLast()
            if textField.text?.count == 0
            {
                counttypingstatus = 0
                imgvmike.image = UIImage(named: "unholdmike")
                imgvmike.accessibilityIdentifier = "unholdmike"
                if groupId != ""
                {
                    if groupType == PRIVATECHAT
                    {
                        isTypingOrRecording(isTypingOrRecording: STOP_TYPING_RECORDING)
                    }
                }
            }
            return false
        }
        
        let newLength = string.count
        if newLength > 0
        {
            if counttypingstatus == 0
            {
                counttypingstatus = 4
                timertypingstatus = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] timer in
                    //                        self!.counttypingstatus -= 1
                    //                        if self?.counttypingstatus == 0 {
                    print("Go! Stop Typing")
                    
                    //MARK:- Check
                    if defaults.value(forKey: "is_chatscreen") as? String == "1"
                    {
                        print(self!.groupId)
                        if self!.groupId != ""
                        {
                            self!.counttypingstatus = 0
                            self!.updateOnline()
                            if self!.groupType == PRIVATECHAT
                            {
                                self!.isTypingOrRecording(isTypingOrRecording: STOP_TYPING_RECORDING)
                            }
                        }
                    }
                    else
                    {
                        return
                    }
                }
                
                if groupId != ""
                {
                    if self.groupType == PRIVATECHAT
                    {
                        isTypingOrRecording(isTypingOrRecording: TYPING)
                    }
                }
            }else
            {
                counttypingstatus = 4
            }
            
            let trimmedString = string.trimmingCharacters(in: .whitespaces)
            if (trimmedString.count > 0){
                imgvmike.image = UIImage(named: "send")
                imgvmike.accessibilityIdentifier = "send"
            }
        }
        if newLength == 0
        {
            counttypingstatus = 0
            if groupId != ""
            {
                if self.groupType == PRIVATECHAT
                {
                    isTypingOrRecording(isTypingOrRecording: STOP_TYPING_RECORDING)
                }
            }
            let trimmedString = string.trimmingCharacters(in: .whitespaces)
            if (trimmedString.count > 0){
                imgvmike.image = UIImage(named: "send")
                imgvmike.accessibilityIdentifier = "send"
            }
            else{
                imgvmike.image = UIImage(named: "unholdmike")
                imgvmike.accessibilityIdentifier = "unholdmike"
            }
            //SendAlert(text : "TypingStop", title: "TypingStop", content_type: true)
        }
        return true
    }
    //MARK:- AddCaptian Delegate
    func btnsend(_ sender: Any, textCaptian: String) {
        messagetext = textCaptian
        print(messagetext)
        self.sendPictureMsg()
    }
    
    func btncancel(_ sender: Any){
        selectedimage = UIImage()
    }
    //MARK:- check if string is only spaces
    struct MyString {
        static func blank(text: String) -> Bool {
            let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
    
    func shareLocation()
    {
        //Hide keyboard
        self.view.endEditing(true)
        vnavigation.tag = 1
        self.vnavigation.isHidden = true
        let center = CLLocationCoordinate2D(latitude: currentlat, longitude: currentlong)
        
        let islamabadzeropoint = CLLocationCoordinate2D(latitude: center.latitude + 0.01, longitude: center.longitude + 0.01)
        
        let rawalpindizeropoint = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let bounds = GMSCoordinateBounds(coordinate: islamabadzeropoint, coordinate: rawalpindizeropoint)
        
        //MARK: - Sample link is https://developers.google.com/places/ios-sdk/placepicker
        let config = GMSPlacePickerConfig(viewport: bounds)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
    }
    func openCamera()
    {
        self.picker.delegate = self
        if(UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            let vc = SNVideoRecorderViewController()
            vc.delegate = self
            
            // flashlight icons
            vc.flashLightOnIcon = UIImage(named: "flash_light_50")
            vc.flashLightOffIcon = UIImage(named: "flash_light_off_50")
            
            // switch camera icon
            vc.switchCameraOption.setImage(UIImage(named: "switch_camera_50")?.withRenderingMode(.alwaysTemplate), for: .normal)
            
            // close options
            vc.closeOption.isHidden = false
            vc.closeOption.setImage(UIImage(named: "delete_50")?.withRenderingMode(.alwaysTemplate), for: .normal)
            
            // preview text
            vc.agreeText = "Done"
            vc.discardText = "Retake"
            
            // max seconds able to record
            vc.maxSecondsToRecord = 120
            //MARK:- Hide Status Bar
            //UIApplication.shared.isStatusBarHidden = true
            // start camera position
            vc.defaultCameraPosition = .back
            DispatchQueue.main.async {
                // show up
                self.present(vc, animated: true, completion: nil)
            }
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func videoRecorder(withVideo url: URL) {
        print(url)
        let tempabsoluteURL = url.absoluteURL
        audioVideoDocumentData = NSData(contentsOf: (tempabsoluteURL)) as Data?
        let image = obj.thumbnailForVideoAtURL(url: url as URL)
        let imageData = image?.jpegData(compressionQuality: 0.3)
        uploadData = imageData!
        //MARK:- Upload thumb image before sending video
        uploadMedia(type: VIDEOIMAGE, completion: { url in
            guard let url = url else { return }
            self.videoimageurl = url
            let audioAsset = AVURLAsset.init(url: tempabsoluteURL as URL, options: nil)
            let duration = audioAsset.duration
            let durationInSeconds = CMTimeGetSeconds(duration)
            if durationInSeconds < 0.1
            {
                obj.showToast(message: "Video is so small", viewcontroller: self)
                return
            }
            self.audioDuration = Float64(durationInSeconds)
            self.sendAudioVideoDocumentMsg(AudioVideoDocument: self.audioVideoDocumentData, msgType: VIDEO)
        })
    }
    
    func funAddCaptian(){
        let popvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCaptian") as! AddCaptian
        
        //popvc.viewController = self
        popvc.imgforview = selectedimage
        popvc.vcdelegate = self
        self.addChild(popvc)
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        popvc.view.frame = frame
        self.view.addSubview(popvc.view)
        popvc.didMove(toParent: self)
        
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        //MARK:- agar is main 0.25 karn dain gay to popup blink kar k atta ha animation .//UIView.animate(withDuration: 0.25, animations: {
        UIView.animate(withDuration: 0.0, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
    }
    func videoRecorder(withImage image: UIImage) {
        //print(image)
        selectedimage = image
        funAddCaptian()
        //self.sendPictureMsg()
    }
    
    func openGallary()
    {
        picker = UIImagePickerController()
        picker.delegate = self
        vnavigation.tag = 1
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        picker.mediaTypes = ["public.movie", "public.image"]
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    func openAudio()
    {
        let audiopicker = MPMediaPickerController(mediaTypes: [.anyAudio])
        audiopicker.prompt = "Audios"
        audiopicker.delegate = self
        audiopicker.allowsPickingMultipleItems = false
        audiopicker.showsCloudItems = false
        self.present(audiopicker, animated: true, completion: nil)
    }
    func openVideoGallery()
    {
//        picker = UIImagePickerController()
//        picker.title = "Videos"
//        picker.delegate = self
//        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
//        picker.mediaTypes = ["public.movie", "public.image"]
//
//        picker.allowsEditing = false
//        present(picker, animated: true, completion: nil)
    }
    
    //MARK:- contact picker
    var tagViewContacts = 0
    func openContact(){
        let contactPicker = CNContactPickerViewController()
        tagViewContacts = 0
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
                , CNContactPhoneNumbersKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    var selectedFilePath: URL?
    func OpenDocumentGallary()
    {
        imgv.contentMode = .scaleAspectFit
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        let documentPickerAllFiles = UIDocumentPickerViewController(documentTypes: ALLDOCUMENTSTYPE, in: .import)

        documentPickerAllFiles.delegate = self
        present(documentPickerAllFiles, animated: true, completion: nil)
    }
    
    //MARK:- Share Location Delegate
    //MARK:- Place Picker Delegates
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        //        print("Place name \(place.name)")
        //        print("Place address \(place.formattedAddress)")
        //        print("Place attributions \(place.attributions)")
        //
        vnavigation.tag = 0
        self.vnavigation.isHidden = false
        
        userlat = place.coordinate.latitude
        userlong = place.coordinate.longitude
        if place.formattedAddress != nil
        {
            sendLocationMsg(address: place.formattedAddress!)
        }
        else
        {
            sendLocationMsg(address: "")
        }
    }
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        vnavigation.tag = 0
        self.vnavigation.isHidden = false
        viewController.dismiss(animated: true, completion: nil)
        print("No place selected")
    }
    
    //Audio Picker Delegates
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        var itemUrl = NSURL()
        for i in 0 ..< mediaItemCollection.items.count {
            let representativeItem: MPMediaItem = mediaItemCollection.items[i]
            let title = representativeItem.title
            let artist = representativeItem.artist
            let imageSound: MPMediaItemArtwork = (representativeItem.value( forProperty: MPMediaItemPropertyArtwork ) as? MPMediaItemArtwork)!
            itemUrl = (representativeItem.value(forProperty: MPMediaItemPropertyAssetURL) as? NSURL)!
        }
        audioVideoDocumentData = NSData(contentsOf: (itemUrl as URL)) as Data?
        
        if audioVideoDocumentData != nil
        {
            let audioAsset = AVURLAsset.init(url: itemUrl as URL, options: nil)
            let duration = audioAsset.duration
            let durationInSeconds = CMTimeGetSeconds(duration)
            if durationInSeconds < 1
            {
                obj.funValidationfromTopWithColor(sender: btnsend, text: "Hold to Record, release to send", view: self.view, color: .black)
                return
            }
            audioDuration = Float64(durationInSeconds)
            //audioDuration = durationInSeconds.millisecond
            self.sendAudioVideoDocumentMsg(AudioVideoDocument: self.audioVideoDocumentData, msgType: AUDIO)
        }
        dismiss(animated: true, completion: nil)
    }
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
    ////image picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //            imgvselected.image = pickedImage
            //            vimgselected.isHidden = false
            print("Picture Selected")
            selectedimage = pickedImage
            self.funAddCaptian()
            // self.sendPictureMsg()
        }
        else if let pickedVideo = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            print("Video Selected")
            let videourl = pickedVideo.absoluteURL
            audioVideoDocumentData = NSData(contentsOf: (videourl)) as Data?
            
            if audioVideoDocumentData != nil
            {
                let image = obj.thumbnailForVideoAtURL(url: videourl as URL)
                let imageData = image?.jpegData(compressionQuality: 0.3)
                uploadData = imageData!
                //MARK:- Upload thumb image before sending video
                uploadMedia(type: VIDEOIMAGE, completion: { url in
                    guard let url = url else { return }
                    self.videoimageurl = url
                    let audioAsset = AVURLAsset.init(url: pickedVideo.absoluteURL as URL, options: nil)
                    let duration = audioAsset.duration
                    let durationInSeconds = CMTimeGetSeconds(duration)
                    if durationInSeconds < 0.1
                    {
                        obj.showToast(message: "Video is so small", viewcontroller: self)
                        return
                    }
                    self.audioDuration = Float64(durationInSeconds)
                    //self.audioDuration = durationInSeconds.millisecond
                    self.sendAudioVideoDocumentMsg(AudioVideoDocument: self.audioVideoDocumentData, msgType: VIDEO)
                })
            }
        }
        else
        {
            
        }
        let trimmedString = txtmsgv.text!.trimmingCharacters(in: .whitespaces)
        if (trimmedString.count > 0){
            imgvmike.image = UIImage(named: "send")
            imgvmike.accessibilityIdentifier = "send"
        }
        else{
            imgvmike.image = UIImage(named: "unholdmike")
            imgvmike.accessibilityIdentifier = "unholdmike"
        }
        dismiss(animated: true, completion: nil)
    }
    //image picker delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Documents Picker Delegates
     func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
         vnavigation.tag = 0
     }
     
     //MARK:- Documents Picker Delegates
    //MARK:- Documents Picker Delegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
    vnavigation.tag = 0
     let cico = url as URL
     print(cico)
     print(url)
     print(url.lastPathComponent)
     print(url.pathExtension)
         if url.pathExtension == ""{
             obj.showAlert(title: "Alert!", message: "Please select valid file format", viewController: self)
             return
         }
         selectedFilePath = url
         let documentData = NSData(contentsOf: (cico.absoluteURL))
         audioVideoDocumentData = documentData! as Data
       
         selecteFileName = url.lastPathComponent
         selecteFileExtension = url.pathExtension
         self.andicator.startAnimating()
         //MARK:- Send Document Message
         self.sendAudioVideoDocumentMsg(AudioVideoDocument: self.audioVideoDocumentData, msgType: DOCUMENT)
    }
     //MARK:- Documents Picker Delegates
     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
         DispatchQueue.main.async {
             self.view.endEditing(true)
         }
         self.dismiss(animated: true, completion: nil)
     }
    
    //MARK:- Contact Add View Picker Delegates
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        
    }
    //MARK:- Contact Picker Delegates
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contactProperty: CNContactProperty) {
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way
        // user name
        //MARK:- tagViewContacts = 1 means you want to just view the contacts
        //MARK:- tagViewContacts = 0 means you want to share the contacts
        if tagViewContacts == 0{
            let userName:String = contact.givenName
            
            // user phone number
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
            // user phone number string
            let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue
            
            DispatchQueue.main.async{
                self.funShareContact(userName: userName, primaryPhoneNumberStr: primaryPhoneNumberStr)
            }
        }
    }
    
    func dissmiss()
    {
        dismiss(animated: true, completion: nil)
    }
    func funShareContact(userName: String, primaryPhoneNumberStr: String)
    {
        let alert = UIAlertController(title: "Contacts!", message: "Are you sure you want to Share this Contact:  ?\n\(userName)\n\(primaryPhoneNumberStr)", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        { (action) in
            //self.dissmiss()
        }
        let Share = UIAlertAction(title: "Share", style: .default)
        { (action) in
            print(primaryPhoneNumberStr)
            self.txtmsgv.text = "" + userName + "\n" + "" + primaryPhoneNumberStr
            self.selectContactNo = "" + userName + "\n" + "" + primaryPhoneNumberStr
            self.sendMessage(msgtype: CONTACT)
            self.dissmiss()
        }
        alert.addAction(cancel)
        alert.addAction(Share)
        
        self.present(alert, animated: true)
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        dismiss(animated: true, completion: nil)
    }//MARK:- Contact Picker Delegates End
    
    var timertypingstatus = Timer()
   
    var animatingTimer = Timer()
    func MikeButtonAnimatingStart(){
        self.lblslidertocancel.text = "< Slide to cancel"
        self.lblslidertocancel.textColor = .gray
        imgvmike.image = UIImage(named: "unholdmike")
        imgvmike.accessibilityIdentifier = "unholdmike"
        animatingTimer = Timer.scheduledTimer(withTimeInterval: 0.3 / 2.1, repeats: true) { [weak self] timer in
            var scale = CGFloat(3.1)
            if IPAD{
                scale = scale * 2
            }
//            self!.imgvhold.transform =
//                CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
//            self!.imgvmike.transform =
//                CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
            UIView.animate(withDuration: 0.3 / 2.1, animations: {
                self!.imgvhold.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
                self!.imgvmike.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
            })
            { finished in
                UIView.animate(withDuration: 0.3 / 2, animations: {
                    self!.imgvhold.transform = CGAffineTransform.identity.scaledBy(x: scale/1.5, y: scale/1.5)
                    self!.imgvmike.transform = CGAffineTransform.identity.scaledBy(x: scale/1.5, y: scale/1.5)
                })
            }
        }
        
    }
    func MikeButtonAnimatingStop(){
        animatingTimer.invalidate()
        DispatchQueue.main.async{
            UIView.animate(withDuration: 0.3 / 2, animations: {
                self.imgvhold.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
                self.imgvmike.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }) { finished in
                UIView.animate(withDuration: 0.3 / 2, animations: {
                    self.imgvhold.transform = CGAffineTransform.identity
                    self.imgvmike.transform = CGAffineTransform.identity
                })
            }
        }
    }
    //target functions
    func funHoldDown(sender:AnyObject?)
    {
        if imgvmike.accessibilityIdentifier == "holdmike" || imgvmike.accessibilityIdentifier == "unholdmike" || imgvmike.accessibilityIdentifier == "send" && isLockRecording == true
        {
            MikeButtonAnimatingStart()
            if isAudioRecordingGranted == false
            {
                if imgvmike.accessibilityIdentifier == "holdmike" || imgvmike.accessibilityIdentifier == "unholdmike"
                {
                    obj.showToast(message: "Please grant permission for your microphone", viewcontroller: self)
                }
                
                return
            }
            if audioplayerisplaying != "stop"
            {
                self.funStopPlayer(sender: sender as Any, index: self.playeraudioindex, completion: {response in
                    print(response as Any)
                })
                audioPlayer.stop()
            }
            if imgvmike.accessibilityIdentifier == "holdmike" || imgvmike.accessibilityIdentifier == "unholdmike"
            {
                startRecording()
                DispatchQueue.main.async {
                    if self.audioplayerisplaying != "stop"
                    {
                        self.funStopPlayer(sender: sender as Any, index: self.playeraudioindex, completion: {response in
                            print(response as Any)
                        })
                    }
                    self.txtmsgv.placeholderColor = .clear
                    //                self.txtmsgv.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                    //SendAlert(text: "VoiceRecStart", title: "VoiceRecStart", content_type: true)
                    self.imgvmike.image = UIImage(named: "holdmike")
                    self.imgvmike.accessibilityIdentifier = "holdmike"
                    
                    if self.groupId != ""
                    {
                        if self.groupType == PRIVATECHAT
                        {
                            self.isTypingOrRecording(isTypingOrRecording: RECORDING)
                        }
                    }
                }
            }
            // print("hold down")
        }
        else
        {
            if txtmsgv.text!.isEmpty != true
            {
                //andicator.startAnimating()
                //sendMessage(msgtype: TEXT)
            }
        }
    }
    

    
    func funholdRelease(sender:AnyObject?)
    {
        if imgvmike.accessibilityIdentifier == "holdmike" || imgvmike.accessibilityIdentifier == "unholdmike" || imgvmike.accessibilityIdentifier == "send"
        {
            MikeButtonAnimatingStop()
            if self.audioplayerisplaying == "play"
            {
                return
            }
            //print("hold release")
            if imgvmike.accessibilityIdentifier == "holdmike" || imgvmike.accessibilityIdentifier == "unholdmike" || imgvmike.accessibilityIdentifier == "send" && self.isLockRecording == false
            {
                if isAudioRecordingGranted == false
                {
                    obj.showToast(message: "Grant a microphone permission", viewcontroller: self)
                    return
                }
                finishRecording(success: true)
                DispatchQueue.main.async {
                    self.txtmsgv.placeholderColor = .lightGray
                    
                    //self.txtmsgv.text = "Type a message..."
                    //                self.txtmsgv.attributedPlaceholder = NSAttributedString(string: "   Type a message...",
                    //                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                    //SendAlert(text: "VoiceRecStop", title: "VoiceRecStop", content_type: true)
                    self.imgvmike.image = UIImage(named: "unholdmike")
                    self.imgvmike.accessibilityIdentifier = "unholdmike"
                    if self.groupId != ""
                    {
                        if self.groupType == PRIVATECHAT
                        {
                            self.isTypingOrRecording(isTypingOrRecording: STOP_TYPING_RECORDING)
                        }
                    }
                }
            }else{
                self.btnsend(btnsend)
            }
        }
    }
    @objc func seekBarValueChange(sender:UISlider)
    {
        sender.isUserInteractionEnabled = true
        audioPlayer.currentTime = TimeInterval(sender.value)
        totalsecond = audioPlayer.currentTime
    }
    //asdf
    var timeraudiotyping = Timer()
    @objc func handleMsgNotificaions(notification: Notification) {
        if notification.name.rawValue == "deleteMessages" {
            let datadic = notification.object as! NSDictionary
            let isDeletedFromEveryOne = datadic.value(forKey: "isDeletedFromEveryOne") as! Int
            funDeleteSelectedMessages(isClear: 0, isDeletedFromEveryOne: isDeletedFromEveryOne)
        }
        else if notification.name.rawValue == "otherUserOnlineTime" {
            //MARK:- Check user status online or offline
            let datadic = notification.object as! NSDictionary
            if let templastonlinetime = datadic.value(forKey: "time") as? String {
                if let online = datadic.value(forKey: "isOnline") as? String {
                    if online == "1" {
                        isonline = "1"
                    }
                    else {
                        isonline = "0"
                    }
                    updateOnline()
                }
                lastonlinetime = templastonlinetime
                lblstatus.text = "\(lastonlinetime)"
            }
        }
    }
    
    @objc func updateOnline() {
        if groupType == PUBLICGROUP {
            lblstatus.text = lastonlinetime
            lblstatus.sizeToFit()
            return
        }
        if isonline == "1" {
           // imgvuserstatus.backgroundColor = UIColor.green
            imgvuserstatus.backgroundColor = UIColor.clear
            lblstatus.text = "online"
        }
        else {
           // imgvuserstatus.backgroundColor = UIColor.lightGray
            imgvuserstatus.backgroundColor = UIColor.clear
            if GLastSeen == "Nobody" {
                lblstatus.text = ""
            }
            else
            {
                lblstatus.text = lastonlinetime
            }
        }
    }
    @objc func updateTyping() {
        // imgvuserstatus.backgroundColor = UIColor.green
        imgvuserstatus.backgroundColor = UIColor.clear
        lblstatus.text = "Typing ..."
    }
    @objc func updateRecording() {
        // imgvuserstatus.backgroundColor = UIColor.lightGray
        imgvuserstatus.backgroundColor = UIColor.clear
        lblstatus.text = "Recording ..."
    }
    @objc func updateTextFieldMsg() {
        txtmsgv.text = ""
        imgvmike.image = UIImage(named: "unholdmike")
        imgvmike.accessibilityIdentifier = "unholdmike"
    }
    
    //MARK:- Online Ofline module Handling
    @objc func funUserIsOnline() {
        //SendAlert(text: "StatusOnline", title: "StatusOnline", content_type: true)
    }
    //    @objc func funOnlineStatus()
    //    {
    //        timeruseroffline.invalidate()
    //        timeruseronline.invalidate()
    //        timeruseronline = Timer.scheduledTimer(timeInterval: 60.0, target:self, selector: #selector(self.funUserIsOnline), userInfo: nil, repeats: false)
    //        timeruseroffline = Timer.scheduledTimer(timeInterval: 65.0, target:self, selector: #selector(self.funUserOffline), userInfo: nil, repeats: false)
    //    }
    
    func funsettingvoice() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            //            if #available(iOS 10.0, *) {
            //                // try recordingSession.setCategory(.playAndRecord, mode: .default)
            //            } else {
            //                // Fallback on earlier versions
            //
            //            }
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    
                    if allowed {
                        
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    func startRecording() {
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        //        let settings = [
        //            AVFormatIDKey:kAudioFormatAppleIMA4,
        //            AVSampleRateKey:44100.0,
        //            AVNumberOfChannelsKey:2,AVEncoderBitRateKey:12800,
        //            AVLinearPCMBitDepthKey:16,
        //            AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue] as [String : Any]
        
        //        do
        //        {
        //            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
        //            audioPlayer.delegate = self
        //            audioPlayer.prepareToPlay()
        //            audioPlayer.play()
        //        }
        //        catch{
        //            print("Error")
        //        }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            bgvaudiotimer.isHidden = false
            self.bgvSlideToLock.isHidden = false
            lblaudiotimer.text = "00:00"
            meterTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                
            }
            blinkLabelTimer = Timer.scheduledTimer(timeInterval: 2 , target:self, selector:#selector(self.blinkLabel(timer:)), userInfo:nil, repeats:true)
            
        } catch {
            finishRecording(success: false)
        }
    }
    var isAudioRecordingGranted: Bool!
    func check_record_permission()
    {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSessionRecordPermission.granted:  isAudioRecordingGranted = true
            break
        case AVAudioSessionRecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func finishRecordingCancel(){
        MikeButtonAnimatingStop()
        audioRecorder.stop()
        meterTimer.invalidate()
        blinkLabelTimer.invalidate()
        self.bgvSlideToLock.isHidden = true
        self.bgvaudiotimer.isHidden = true
        self.isLockRecording = false
        self.lblslidertocancel.text = "< Slide to cancel"
        self.lblslidertocancel.textColor = .gray
        imgvmike.image = UIImage(named: "unholdmike")
        imgvmike.accessibilityIdentifier = "unholdmike"
        self.txtmsgv.placeholderColor = .lightGray
    }
    func lockRecording(){
        MikeButtonAnimatingStop()
        self.isLockRecording = true
        blinkLabelTimer.invalidate()
        self.bgvSlideToLock.isHidden = true
        imgvmike.image = UIImage(named: "send")
        imgvmike.accessibilityIdentifier = "send"
        self.lblslidertocancel.textColor = .red
        self.lblslidertocancel.text = "CANCEL"
    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        if success
        {
            meterTimer.invalidate()
            blinkLabelTimer.invalidate()
            bgvaudiotimer.isHidden = true
            self.bgvSlideToLock.isHidden = true
            if let tempaudiodata = NSData(contentsOf: audioRecorder.url)
            {
                let audioAsset = AVURLAsset.init(url: audioRecorder.url, options: nil)
                let duration = audioAsset.duration
                let durationInSeconds = CMTimeGetSeconds(duration)
                if durationInSeconds < 1
                {
                    obj.funValidationfromTopWithColor(sender: btnsend, text: "Hold to record, release to send", view: self.view, color: .black)
                    return
                }
                audioVideoDocumentData = tempaudiodata as Data
                //audioDuration = durationInSeconds.millisecond
                audioDuration = Float64(durationInSeconds)
                self.sendAudioVideoDocumentMsg(AudioVideoDocument: self.audioVideoDocumentData, msgType: AUDIO)
                
                if audioRecorder.isRecording == false
                {
                    //            do {
                    //                try audioPlayer = AVAudioPlayer(contentsOf:
                    //                    (audioRecorder?.url)!)
                    //                audioPlayer.delegate = self
                    //                audioPlayer.prepareToPlay()
                    //                audioPlayer.play()
                    //            } catch let error as NSError {
                    //                print("audioPlayer error: \(error.localizedDescription)")
                    //            }
                }
            }
            else
            {
                obj.showAlert(title: "Alert!", message: "Error in Recording", viewController: self)
            }
        }
        else
        {
            obj.showAlert(title: "Alert!", message: "Error in Recording", viewController: self)
        }
        //audioRecorder = nil
    }
    
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    //var audioPlayer : AVAudioPlayer?
    var audioPlayer : AVAudioPlayer!

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
        else
        {
            
        }
    }
    
    //MARK:- Show Audio Recorder Time
    @objc func updateAudioMeter(timer: Timer) {
        if audioRecorder.isRecording {
            //let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            //let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            lblaudiotimer.text = totalTimeString
            audioRecorder.updateMeters()
            //MARK:- Blink Image
            self.imgvaudiotimer.blink()
        }
    }
    //MARK:- Blink Label
    @objc func blinkLabel(timer: Timer) {
        self.lblslidertocancel.blink()
        self.imgvSlideToLock.blink()
        self.bgvSlideToLock.isHidden = false
    }
    
    //            if audioPlayer.rate == 0
    //            {
    //                audioplayerisplaying = "pause"
    //                audioPlayer.pause()
    //            }
    //            else
    //            {
    //                audioplayerisplaying = "play"
    //                audioPlayer.play()
    //            }
    
    //MARK:- Handling audio in tableview cell when click on play or stop audio
    var playeraudioindex = 0
    @objc func funTapOnAudio(sender: UIButton)
    {
        let index = sender.tag
        if playeraudioindex == 0
        {
            if (audioplayerisplaying != "stop")
            {
                if playeraudioindex == index
                {
                    if (audioplayerisplaying == "play")
                    {
                        audioplayerisplaying = "pause"
                        audioPlayer.pause()
                    }
                    else
                    {
                        audioplayerisplaying = "play"
                        audioPlayer.play()
                    }
                    funTableViewCellRefresh(index: playeraudioindex)
                }
                else if playeraudioindex != index
                {
                    funStopPlayer(sender: sender, index: playeraudioindex, completion: {response in
                        print(response as Any)
                        self.playeraudioindex = index
                        self.funPlayAudio(index: index)
                    })
                }
                else
                {
                    playeraudioindex = index
                    funPlayAudio(index: index)
                }
            }
            else
            {
                playeraudioindex = index
                funPlayAudio(index: index)
            }
        }
        else if playeraudioindex == index
        {
            if (audioplayerisplaying == "play")
            {
                audioplayerisplaying = "pause"
                audioPlayer.pause()
            }
            else
            {
                audioplayerisplaying = "play"
                audioPlayer.play()
            }
            funTableViewCellRefresh(index: playeraudioindex)
        }
        else if playeraudioindex != index
        {
            funStopPlayer(sender: sender, index: playeraudioindex, completion: {response in
                print(response as Any)
                self.playeraudioindex = index
                DispatchQueue.main.async{
                    self.funPlayAudio(index: index)
                }
            })
        }
        else
        {
            playeraudioindex = index
            funPlayAudio(index: index)
        }
    }
    
    func funPlayAudio(index: Int)
    {
        let url = URL(string: arrMsgPic[index] as! String)
        if (audioplayerisplaying == "play")
        {
            audioplayerisplaying = "pause"
            audioPlayer.pause()
            self.funTableViewCellRefresh(index: index)
        }
        else
        {
            tablev.isUserInteractionEnabled = false
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(url!.lastPathComponent)
            print(destinationUrl)
            
            // self.downloadFile()
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                self.tablev.isUserInteractionEnabled = true
                
                do {
                     audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                    guard let player = audioPlayer else { return }
                    let tempfileName = destinationUrl.lastPathComponent
                    let componentArray = tempfileName.components(separatedBy: ".")
                    let first = componentArray.first
                    let last = componentArray.last
                //
                   
                    
//                    let file = NSURL(fileURLWithPath:Bundle.main.path(forResource: "\(first!)", ofType:"\(last!)")!)
                  //  self.audioPlayer = try AVAudioPlayer(contentsOf: file as URL)
                    self.audioPlayer.prepareToPlay()
                    self.audioPlayer.delegate = self
                    self.audioPlayer.volume = 50
                    DispatchQueue.main.async {
                        self.audioplayerisplaying = "play"
                        self.audioPlayer.play()
                        self.funTableViewCellRefresh(index: index)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                // if the file doesn't exist
                var downloadTask:URLSessionDownloadTask
                downloadTask = URLSession.shared.downloadTask(with: url!, completionHandler: { [weak self](URL, response, error) -> Void in
                    
                    self!.tablev.isUserInteractionEnabled = true
                    do {
                        guard let URL = URL, error == nil else {
                            self?.playeraudioindex = 0
                            return }
                        try FileManager.default.moveItem(at: URL, to: destinationUrl)
                        print("File moved to documents folder")
                        
                        self?.playingurl = URL as NSURL
                        self?.audioPlayer = try AVAudioPlayer(contentsOf: self!.playingurl as URL)
                        self?.audioPlayer.prepareToPlay()
                        self!.audioPlayer.delegate = self
                        self!.audioPlayer.volume = 50
                        DispatchQueue.main.async {
                            self?.audioplayerisplaying = "play"
                            self?.audioPlayer.play()
                            self!.funTableViewCellRefresh(index: index)
                        }
                    }
                    catch let error as NSError {
                        //self.player = nil
                        print(error.localizedDescription)
                    } catch {
                        print("AVAudioPlayer init failed")
                    }
                })
                downloadTask.resume()
            }
        }
    }
    
    func downloadFile() {
        
        if let audioUrl = URL(string: "http://freetone.org/ring/stan/iPhone_5-Alarm.mp3") {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully : Bool)
    {
        funStopPlayer(sender: player, index: playeraudioindex, completion: {response in
            print(response as Any)
        })
    }
    
    func funStopPlayer(sender: Any, index: Int, completion: @escaping (_ key: String?) -> Void) {
        
        playeraudioindex = 0
        self.audioplayerisplaying = "stop"
        audioPlayer.stop()
        //audioPlayer = AVAudioPlayer()
        audioRecorder = nil
        
        self.slidertimer.invalidate()
        self.slidertimer = Timer()
        ////        //MARK:- Add new row in table view
        let indexPath = IndexPath(row: index, section: 0)
        if arrMsgFomid[index] as! String == USERUID
        {
            //MARK:- Sender Cell
            if !((tablev.indexPathsForVisibleRows?.contains(indexPath))!) {
              // Your code here

            }
            else{
                let cell = self.tablev.cellForRow(at: indexPath) as! MessagingReceiverCell
                cell.slider.setValue(0, animated: false)
                cell.lblcurrentvoicetime.text = "00:00"
            }
        }
        else
        {
            //MARK:- Receiver Cell
            if !((tablev.indexPathsForVisibleRows?.contains(indexPath))!) {
              // Your code here
                
                
            }
            else{
                let cell = self.tablev.cellForRow(at: indexPath) as! MessagingSenderCell
                //asdf
                //           let guard let cell = self.tablev.dequeueReusableCell(withIdentifier: "cellreceivervoice", for: indexPath) as? MessagingReceiverCell else {...}
                cell.slider.setValue(0, animated: false)
                cell.lblcurrentvoicetime.text = "00:00"
            }
        }
        
        //        tablev.endUpdates()
        //DispatchQueue.main.async {
        self.funTableViewCellRefresh(index: index)
        //}
        completion("success")
    }
    //MARK:- TableView Row Refresh
    func funTableViewCellRefresh(index: Int)
    {
        //MARK:- Add new row in table view
        let indexPath = IndexPath(row: index, section: 0)
        
        if arrMsgFomid[index] as! String == USERUID {
            //MARK:- Sender Cell
            let cell = self.tablev.cellForRow(at: indexPath) as! MessagingReceiverCell
            self.tablev.beginUpdates()
            if (cell.btnplay.imageView?.image!.isEqualToImage(image: UIImage(named: "play")!))!
            {
                var cmTime = CMTime()
                var duration = CMTime()
                if self.audioplayerisplaying != "stop"
                {
                    cell.btnplay.setImage(UIImage(named: "pause"), for: .normal)
                    arrImagePlayPause[index] = "pause"
                    cmTime = CMTime(seconds: audioPlayer.duration, preferredTimescale: 1000000)
                    duration = cmTime
                    self.totalsecond = CMTimeGetSeconds(duration)
                    
                    cell.slider.maximumValue = Float(self.totalsecond)
                    cell.slider.isUserInteractionEnabled = true
                    self.tablev.endUpdates()
                    obj.funhmsFrom(seconds: Int(self.totalsecond)) { hours, minutes, seconds in
                        
                        let hours = obj.getStringFrom(seconds: hours)
                        let minutes = obj.getStringFrom(seconds: minutes)
                        let secondss = obj.getStringFrom(seconds: seconds)
                        self.tablev.beginUpdates()
                        //self.lbltimer.text = "\(hours):\(minutes):\(seconds)"
                        
                        self.arrTotalAudioTime[index] = "\(minutes):\(secondss)"
                        print("\(hours):\(minutes):\(secondss)")
                        self.slidertimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                            self.totalsecond -= 0.05
                            if self.totalsecond <= 0 {
                                //print("Go!")
                                cell.slider.setValue(Float(0), animated: false)
                                self.slidertimer.invalidate()
                                self.tablev.endUpdates()
                            } else {
                                //  print("Slider: " + "\(self.sliderr.value)")
                                //  print("Player: " + "\(self.audioPlayer.currentTime)")
                                
                                cell.lblcurrentvoicetime.text = self.updateSeekBar()
                                cell.slider.setValue(Float(self.audioPlayer.currentTime), animated: false)
                                self.tablev.endUpdates()
                            }
                        }
                    }
                }
                else
                {
                    self.tablev.beginUpdates()
                    cell.btnplay.setImage(UIImage(named: "play"), for: .normal)
                    arrImagePlayPause[index] = "play"
                    totalsecond = 0
                    cell.slider.setValue(0, animated: false)
                    cell.lblcurrentvoicetime.text = "00:00"
                    tablev.endUpdates()
                }
            }
            else
            {
                self.slidertimer.invalidate()
                cell.btnplay.setImage(UIImage(named: "play"), for: .normal)
                arrImagePlayPause[index] = "play"
                self.tablev.endUpdates()
            }
        }
        else
        {
            //MARK:- Receiver Cell
            let cell = self.tablev.cellForRow(at: indexPath) as! MessagingSenderCell
            self.tablev.beginUpdates()
            if (cell.btnplay.imageView?.image!.isEqualToImage(image: UIImage(named: "play")!))!
            {
                var cmTime = CMTime()
                var duration = CMTime()
                if self.audioplayerisplaying != "stop"
                {
                    
                    cell.btnplay.setImage(UIImage(named: "pause"), for: .normal)
                    arrImagePlayPause[index] = "pause"
                    cmTime = CMTime(seconds: audioPlayer.duration, preferredTimescale: 1000000)
                    duration = cmTime
                    self.totalsecond = CMTimeGetSeconds(duration)
                    
                    cell.slider.maximumValue = Float(self.totalsecond)
                    cell.slider.isUserInteractionEnabled = true
                    
                    obj.funhmsFrom(seconds: Int(self.totalsecond)) { hours, minutes, seconds in
                        
                        let hours = obj.getStringFrom(seconds: hours)
                        let minutes = obj.getStringFrom(seconds: minutes)
                        let secondss = obj.getStringFrom(seconds: seconds)
                        
                        //self.lbltimer.text = "\(hours):\(minutes):\(seconds)"
                        
                        self.arrTotalAudioTime[index] = "\(minutes):\(secondss)"
                        print("\(hours):\(minutes):\(secondss)")
                        self.slidertimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                            self.totalsecond -= 0.05
                            if self.totalsecond <= 0 {
                                //print("Go!")
                                cell.slider.setValue(Float(0), animated: false)
                                self.slidertimer.invalidate()
                                self.tablev.endUpdates()
                            } else {
                                //  print("Slider: " + "\(self.sliderr.value)")
                                //  print("Player: " + "\(self.audioPlayer.currentTime)")
                                
                                cell.lblcurrentvoicetime.text = self.updateSeekBar()
                                cell.slider.setValue(Float(self.audioPlayer.currentTime), animated: false)
                                self.tablev.endUpdates()
                            }
                        }
                    }
                }
                else
                {
                    cell.btnplay.setImage(UIImage(named: "play"), for: .normal)
                    arrImagePlayPause[index] = "play"
                    totalsecond = 0
                    cell.slider.setValue(0, animated: false)
                    cell.lblcurrentvoicetime.text = "00:00"
                    tablev.endUpdates()
                }
            }
            else
            {
                self.slidertimer.invalidate()
                cell.btnplay.setImage(UIImage(named: "play"), for: .normal)
                arrImagePlayPause[index] = "play"
                self.tablev.endUpdates()
            }
        }
        // self.tablev.reloadRows(at: [indexPath], with: .none)
    }
    
    var totalsecond = Float64()
    var slidertimer = Timer()
    func updateSeekBar() -> String
    {
        let currentTime = Int(audioPlayer.currentTime)
        //let duration = Int(audioPlayer.duration)
        //let total = currentTime - duration
        //let totalString = String(total)
        
        let minutes = currentTime/60
        let seconds = currentTime - minutes / 60
        
        let playertime = NSString(format: "%02d:%02d", minutes,seconds) as String
        return playertime
    }
    
    var arrchatid = NSMutableArray()
    var arrrectoken = NSMutableArray()
    var arrrecid = NSMutableArray()
    var arrsendertoken = NSMutableArray()
    var arrsenderid = NSMutableArray()
    var arrtime = NSMutableArray()
    var arrpic = NSMutableArray()
    var arrvoice = NSMutableArray()
    var arrlat = NSMutableArray()
    var arrlong = NSMutableArray()
    
    var currentlat = Double()
    var currentlong = Double()
    var newLocation = CLLocation()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        newLocation = (locations.last)!
        
        userlat = locations.first!.coordinate.latitude
        userlong = locations.first!.coordinate.longitude
        
        
        if let location = locations.first {
            
            currentlat = location.coordinate.latitude
            currentlong = location.coordinate.longitude
        }
    }
    
    //    func funAddMessage(_ snapshot: DataSnapshot)
    //    {
    //        print(snapshot)
    //        let indexPath = IndexPath(row: self.arrmsgtype.count-1, section: 0)
    //        //MARK:- Add new row in table view
    //        self.tablev.beginUpdates()
    //        self.tablev.insertRows(at: [IndexPath(row: self.arrmsgtype.count-1, section: 0)], with: .automatic)
    //        self.tablev.endUpdates()
    //        if arrmsgtype.count > 0
    //        {
    //            self.scrolltobottom(indexpath: indexPath)
    //        }
    //    }
    
    //MARK: - Function to move map to said location
    func movetosaidlocation(lat:Double , long: Double, vformap :GMSMapView)
    {
        vformap.delegate = self
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        vformap.camera = GMSCameraPosition(target: center, zoom: 11.2, bearing: 0, viewingAngle: 0)
        // 8
        locationManager.stopUpdatingLocation()
        
        vformap.settings.compassButton = true
        let marker = GMSMarker()
        marker.position = center
        marker.title = "Sender Location"
        marker.map = vformap
    }
    @objc func funRedirectGoogleNav(sender: UIButton)
    {
        //        if let url = URL(string: "https://maps.google.com") {
        //            UIApplication.shared.open(url, options: [:])
        //        }
        let tag = sender.tag
        
        if (UIApplication.shared.canOpenURL(NSURL(string:"https://maps.google.com")! as URL))
        {
            UIApplication.shared.open(URL(string: "https://maps.google.com/?q=@\(arrMsgLat[tag]),\(arrMsgLong[tag])")!)
        }
    }
    
    var autocreatedid = String()
    var isAudioTag = false
    func sendMessage(msgtype: Int) {
        messagetext = txtmsgv.text!
        DispatchQueue.main.async {
            self.updateTextFieldMsg()
        }
        if msgtype == CONTACT {
            messagetext = selectContactNo
        }
        
        //andicator.startAnimating()
        autocreatedid = MessagesDB.childByAutoId().key!
        if groupType == PUBLICGROUP {
            for (indexParticipant, receiverid) in self.arrGroupParticipant.enumerated() {
                let temp = arrDeviceSource.object(at: indexParticipant) as! String
                if temp == SOURCECODE {
                    isAndroidUser = false
                }
                else {
                    isAndroidUser = true
                }
                funSendMsgInGroup(msgType: msgtype, receiverid: receiverid as! String, receiverToken: arruserFBToken[indexParticipant] as! String, isAndroidUserTemp: isAndroidUser)
            }
            andicator.stopAnimating()
            return
        }
        
        if groupId.isEmpty == true {
            funCreateNewChat(msgType: msgtype, completion: {
                response in
               
            })
            return
        }
        else {
            let timespam = Date().currentTimeMillis()!
            //print(timespam)
            MessagesDB.child(self.groupId).child(self.fromuid)
                .child(self.autocreatedid).setValue([
                "\(objMessageDBM.from)" :"\(self.fromuid)",
                "\(objMessageDBM.message)" :messagetext,
                "\(objMessageDBM.messageStatus)" :NOT_DELIVERED,
                "\(objMessageDBM.messageType)" :msgtype,
                "\(objMessageDBM.userName)" : USERUniqueID,
                "\(objMessageDBM.timeStamp)" : timespam,
                "\(objMessageDBM.source)" :SOURCECODE], withCompletionBlock: {
                error, ref in
                    if error == nil {
                        MessagesDB.child(self.groupId).child(self.touid)
                            .child(self.autocreatedid).setValue([
                            "\(objMessageDBM.from)" :"\(self.fromuid)",
                                "\(objMessageDBM.message)" :self.messagetext,
                            "\(objMessageDBM.messageStatus)" :NOT_DELIVERED,
                            "\(objMessageDBM.messageType)" :msgtype,
                            "\(objMessageDBM.userName)" : USERUniqueID,
                            "\(objMessageDBM.timeStamp)" : timespam,
                            "\(objMessageDBM.source)" :SOURCECODE] as [String : Any], withCompletionBlock: {
                                error, ref in
                                self.andicator.stopAnimating()
                                if error == nil {
                                    // self.isdeliver(messageStatus: SENT)
                                    //MARK:- Uncomment the upper line for testing the unSeenCount
                                    //obj.showToast(message: "Message send successfully.", viewcontroller: self)
                                    
                                    let parameters :Parameters = [
                                        "title":"1 new message",
                                        "body":self.messagetext,
                                        "sound":"default",
                                        //"groupId":self.groupId,
                                        "groupType":self.groupType,
                                        "messageId":ref.key!,
                                        "action":"newMessage",
                                        "messageType":msgtype,
                                        "firebaseId":self.fromuid,
                                        //"to":self.touid,
                                        "groupFireBaseId":self.groupId,
                                        "froma":USERUniqueID,
                                        "profilePic":defaults.value(forKey: "userimage") as? String ?? "",
                                        "message":self.messagetext,
                                        "mutable_content": true] as [String: AnyObject]
                                    DispatchQueue.main.async{
                                        obj.SendPushNotification(toToken: self.receivertokenLocalClass, title: "1 new message", body: self.messagetext, data: parameters )
                                    }
                                }
                        })

                    }
                })
            
            
            self.createChat(msgtype: msgtype, key: groupId, ifupdate: "1", completion: {
                response in
                self.andicator.stopAnimating()
                if response == "success" {
                    
                }
                else {
                    //MARK:- From
                    obj.showToast(message: response!, viewcontroller: self)
                }
            })
        }
    }
    
    func sendPictureMsg() {
        autocreatedid = MessagesDB.childByAutoId().key!
        if groupType == PUBLICGROUP {
            self.andicator.startAnimating()
            //MARK:- PICTURE Message
            self.uploadMedia(type: IMAGE) { url in
                guard let url = url else { return }
                self.objecturl = url
                for (indexParticipant, receiverid) in self.arrGroupParticipant.enumerated() {
                    self.funSendMsgInGroup(msgType: IMAGE, receiverid: receiverid as! String, receiverToken: self.arruserFBToken[indexParticipant] as! String, isAndroidUserTemp: isAndroidUser)
                }
            }
            andicator.stopAnimating()
            return
        }
        if groupId.isEmpty == true {
            funCreateNewChat(msgType: IMAGE, completion: {
                response in
                
            })
        }
        else {
            //MARK:- Groupid already exist just send message
            self.createChat(msgtype: IMAGE, key: groupId, ifupdate: "1", completion: {
                response in
                self.andicator.stopAnimating()
                if response == "success" {
                    //MAARK:- Need to improve this
                    let timespam = Date().currentTimeMillis()!
                    self.uploadMedia(type: IMAGE) { url in
                        guard let url = url else { return }
                        self.objecturl = url
                        let dicfromto = [
                            "\(objMessageDBM.from)":"\(self.fromuid)",
                            "\(objMessageDBM.imageThumb)":self.objecturl,
                            "\(objMessageDBM.message)": self.messagetext,
                            "\(objMessageDBM.messageImagePath)":self.objecturl,
                            "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                            "\(objMessageDBM.messageType)":IMAGE,
                            "\(objMessageDBM.userName)":USERUniqueID,
                            "\(objMessageDBM.timeStamp)": timespam,
                            "\(objMessageDBM.source)":SOURCECODE] as [String : Any]
                        //self.andicator.startAnimating()
                        MessagesDB.child(self.groupId).child(self.fromuid).child(self.autocreatedid).setValue(dicfromto
                            as [String :Any],withCompletionBlock: {
                                error, ref in
                                self.andicator.stopAnimating()
                                if error != nil {
                                    obj.showToast(message: (error?.localizedDescription)!, viewcontroller: self)
                                }
                                else {
                                    let parameters :Parameters = [
                                        "title":"1 new message",
                                        "body":"Image Received",
                                        "sound":"default",
                                        //"groupId":self.groupId,
                                        "groupType":self.groupType,
                                        "messageId":ref.key!,
                                        "action":"newMessage",
                                        "messageType":IMAGE,
                                        "firebaseId":self.fromuid,
                                        //"to":self.touid,
                                        "groupFireBaseId":self.groupId,
                                        "froma":USERUniqueID,
                                        "profilePic":defaults.value(forKey: "userimage") as? String ?? "",
                                        "message":self.messagetext,
                                        "mutable_content": true]
                                    
                                    obj.SendPushNotification(toToken: self.receivertokenLocalClass, title: "1 new message", body: self.messagetext, data: parameters )
                                    MessagesDB.child(self.groupId).child(self.touid).child(self.autocreatedid).setValue(dicfromto)
                                    //obj.showToast(message: "Picture send successfully.", viewcontroller: self)
                                }
                        })
                    }
                    
                }
                else {
                    //MARK:- From
                    obj.showToast(message: response!, viewcontroller: self)
                }
            })
        }
    }
    func sendLocationMsg(address: String) {
        //andicator.startAnimating()
        autocreatedid = MessagesDB.childByAutoId().key!
        if groupType == PUBLICGROUP {
            for (index, receiverid) in arrGroupParticipant.enumerated() {
                let temp = arrDeviceSource.object(at: index) as! String
                if temp == SOURCECODE {
                    isAndroidUser = false
                }
                else{
                    isAndroidUser = true
                }
                
                funSendMsgInGroup(msgType: LOCATION, receiverid: receiverid as! String, receiverToken: arruserFBToken[index] as! String, isAndroidUserTemp: isAndroidUser)
            }
            andicator.stopAnimating()
            return
        }
        if groupId.isEmpty == true {
            funCreateNewChat(msgType: LOCATION, completion: {
                response in
            })
        }
        else {
            //MARK:- Groupid already exist just send message
            //MAARK:- Need to improve this
            let timespam = Date().currentTimeMillis()!
            let fromtodic =
                ["\(objMessageDBM.from)":"\(self.fromuid)",
                    "\(objMessageDBM.imageThumb)":"\(self.currentlat),\(self.currentlong)",
                    "\(objMessageDBM.message)":address,
                    "\(objMessageDBM.messageImagePath)":"",
                    "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                    "\(objMessageDBM.messageType)":LOCATION,
                    "\(objMessageDBM.userName)":USERUniqueID,
                    "\(objMessageDBM.timeStamp)": timespam,
                    "\(objMessageDBM.source)":SOURCECODE] as [String : Any]
            MessagesDB.child(self.groupId).child(self.fromuid).child(self.autocreatedid).setValue(fromtodic, withCompletionBlock: {
                error, snapshot in
                self.andicator.stopAnimating()
                if error == nil {
                    
                }
            })
            MessagesDB.child(self.groupId).child(self.touid).child(self.autocreatedid).setValue(fromtodic, withCompletionBlock: {
                error, ref in
                self.andicator.stopAnimating()
                if error == nil {
                    // self.isdeliver(messageStatus: SENT)
                    //MARK:- Uncomment the upper line for testing the unSeenCount
                    // obj.showToast(message: "Message send successfully.", viewcontroller: self)
                    self.updateTextFieldMsg()
                }
            })
           // obj.showToast(message: "Location send successfully.", viewcontroller: self)
            
            //MARK:- delivery status inbox
            self.createChat(msgtype: LOCATION, key: self.groupId, ifupdate: "1", completion: {
                response in
                self.andicator.stopAnimating()
                if response == "success" {
                    
                }
                else {
                    //MARK:- From
                    obj.showToast(message: response!, viewcontroller: self)
                }
            })
        }
    }

    func sendAudioVideoDocumentMsg(AudioVideoDocument: Data, msgType: Int) {
        autocreatedid = MessagesDB.childByAutoId().key!
        if groupType == PUBLICGROUP {
            self.andicator.startAnimating()
            //MARK:- PICTURE Message
            self.uploadMedia(type: msgType) { url in
                guard let url = url else { return }
                self.objecturl = url
                for (indexParticipant, receiverid) in self.arrGroupParticipant.enumerated() {
                    let temp = self.arrDeviceSource.object(at: indexParticipant) as! String
                    if temp == SOURCECODE{
                        isAndroidUser = false
                    }
                    else{
                        isAndroidUser = true
                    }
                    self.funSendMsgInGroup(msgType: msgType, receiverid: receiverid as! String, receiverToken: self.arruserFBToken[indexParticipant] as! String, isAndroidUserTemp: isAndroidUser)
                }
            }
            andicator.stopAnimating()
            return
        }
        if groupId.isEmpty == true
        {
            funCreateNewChat(msgType: msgType, completion: {
                response in
                
            })
        }
        else
        {
            //MARK:- Groupid already exist just send message
            //MAARK:- Need to improve this
            let timespam = Date().currentTimeMillis()!
            // let millisecond = self.audioDuration.millisecond    // 531
            var bodytext = ""
            print(self.audioDuration)
            print(self.audioDuration*1000)
            var tempmilisecond = String(Int(self.audioDuration*1000))
            self.uploadMedia(type: msgType) { url in
                guard let url = url else { return }
                self.objecturl = url
                var dicfromto = [String : Any]()
                if msgType == AUDIO || msgType == DOCUMENT
                {
                    bodytext = "Audio Received"
                    if msgType == DOCUMENT{
                        bodytext = "Document Received"
                        tempmilisecond = self.selecteFileName
                    }
                    dicfromto = [
                        "\(objMessageDBM.from)":"\(self.fromuid)",
                        "\(objMessageDBM.message)":String(tempmilisecond),
                        "\(objMessageDBM.messageImagePath)":self.objecturl,
                        "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                        "\(objMessageDBM.messageType)":msgType,
                        "\(objMessageDBM.userName)":USERUniqueID,
                        "\(objMessageDBM.timeStamp)": timespam,
                        "\(objMessageDBM.source)":SOURCECODE]
                }
                else if msgType == VIDEO
                {
                    bodytext = "Video Received"
                    dicfromto = [
                        "\(objMessageDBM.from)":"\(self.fromuid)",
                        "\(objMessageDBM.message)":String(tempmilisecond),
                        "\(objMessageDBM.imageThumb)":self.videoimageurl,
                        "\(objMessageDBM.messageImagePath)":self.videoimageurl,
                        "\(objMessageDBM.messageVideoPath)":self.objecturl,
                        "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                        "\(objMessageDBM.messageType)":msgType,
                        "\(objMessageDBM.userName)":USERUniqueID,
                        "\(objMessageDBM.timeStamp)": timespam,
                        "\(objMessageDBM.source)":SOURCECODE]
                }
                
                //self.andicator.startAnimating()
                MessagesDB.child(self.groupId).child(self.fromuid).child(self.autocreatedid).setValue(dicfromto
                    as [String :Any],withCompletionBlock: {
                        error, ref in
                        self.andicator.stopAnimating()
                        if error != nil
                        {
                            obj.showToast(message: (error?.localizedDescription)!, viewcontroller: self)
                        }
                        else
                        {
                            MessagesDB.child(self.groupId).child(self.touid).child(self.autocreatedid).setValue(dicfromto)
                            
                            let parameters :Parameters = ["title":"1 new message",
                                                          "body":bodytext,
                                                          "sound":"default",
                                                          //"groupId":self.groupId,
                                                          "groupType":self.groupType,
                                                          "messageId":ref.key!,
                                                          "action":"newMessage",
                                                          "messageType":msgType,
                                                          "firebaseId":self.fromuid,
                                                          //"to":self.touid,
                                                          "groupFireBaseId":self.groupId,
                                                          "froma":USERUniqueID,
                                                          "profilePic":defaults.value(forKey: "userimage") as? String ?? "",
                                                          "message":String(tempmilisecond),
                                                          "mutable_content": true]
                            
                            obj.SendPushNotification(toToken: self.receivertokenLocalClass, title: "1 message", body: self.messagetext, data: parameters )
                            // obj.showToast(message: "Message send successfully.", viewcontroller: self)
                            self.createChat(msgtype: msgType, key: self.groupId, ifupdate: "1", completion: {
                                response in
                                self.andicator.stopAnimating()
                                if response == "success"
                                {
                                    
                                }
                            })
                        }
                })
            }
        }
    }
    
    func funCreateNewChat(msgType: Int, completion: @escaping (_ key: String?) -> Void) {
        let timespam = Date().currentTimeMillis()!
        var dicmsg = [String: Any]()
        switch (msgType) {
        case (TEXT):
            let fromdic = [autocreatedid : [
                "\(objMessageDBM.from)":"\(fromuid)",
                "\(objMessageDBM.message)":messagetext,
                "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                "\(objMessageDBM.messageType)":TEXT,
                "\(objMessageDBM.userName)":USERUniqueID,
                "\(objMessageDBM.timeStamp)": timespam,
                "\(objMessageDBM.source)":SOURCECODE]]
            
            let todic = [autocreatedid : [
                "\(objMessageDBM.from)":"\(fromuid)",
                "\(objMessageDBM.message)":messagetext,
                "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                "\(objMessageDBM.messageType)":TEXT,
                "\(objMessageDBM.userName)":USERUniqueID,
                "\(objMessageDBM.timeStamp)": timespam,
                "\(objMessageDBM.source)":SOURCECODE]]
            
            dicmsg = [fromuid: fromdic, touid: todic]
            
            break
        case (LOCATION):
            dicmsg = [
                fromuid: [autocreatedid : [
                    "\(objMessageDBM.from)":"\(fromuid)",
                    "\(objMessageDBM.message)":messagetext,
                    "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                    "\(objMessageDBM.messageType)":LOCATION,
                    "\(objMessageDBM.userName)":USERUniqueID,
                    "\(objMessageDBM.timeStamp)": timespam,
                    "\(objMessageDBM.source)":SOURCECODE,
                    "\(objMessageDBM.imageThumb)":"\(self.currentlat),\(self.currentlong)",
                    "\(objMessageDBM.messageImagePath)":""]],
                
                touid: [autocreatedid : [
                    "\(objMessageDBM.from)":"\(fromuid)",
                    "\(objMessageDBM.message)":messagetext,
                    "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                    "\(objMessageDBM.messageType)":LOCATION,
                    "\(objMessageDBM.userName)":USERUniqueID,
                    "\(objMessageDBM.timeStamp)": timespam,
                    "\(objMessageDBM.source)":SOURCECODE,
                    "\(objMessageDBM.imageThumb)":"\(self.currentlat),\(self.currentlong)",
                    "\(objMessageDBM.messageImagePath)":""]],
            ]
            break
        case (IMAGE):
            dicmsg = [
                fromuid: [autocreatedid : [
                    "\(objMessageDBM.from)":"\(fromuid)",
                    "\(objMessageDBM.message)":messagetext,
                    "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                    "\(objMessageDBM.messageType)":IMAGE,
                    "\(objMessageDBM.userName)":USERUniqueID,
                    "\(objMessageDBM.timeStamp)": timespam,
                    "\(objMessageDBM.source)":SOURCECODE,
                    "\(objMessageDBM.imageThumb)":"\(objecturl)",
                    "\(objMessageDBM.messageImagePath)":self.objecturl]],
                
                touid: [autocreatedid : [
                    "\(objMessageDBM.from)":"\(fromuid)",
                    "\(objMessageDBM.message)":messagetext,
                    "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                    "\(objMessageDBM.messageType)":IMAGE,
                    "\(objMessageDBM.userName)":USERUniqueID,
                    "\(objMessageDBM.timeStamp)": timespam,
                    "\(objMessageDBM.source)":SOURCECODE,
                    "\(objMessageDBM.imageThumb)":"\(objecturl)",
                    "\(objMessageDBM.messageImagePath)":self.objecturl]]
            ]
            break
        case AUDIO:
            dicmsg = [
                fromuid: [autocreatedid : [
                    "\(objMessageDBM.from)":"\(fromuid)",
                    "\(objMessageDBM.message)":audioDuration,
                    "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                    "\(objMessageDBM.messageType)":AUDIO,
                    "\(objMessageDBM.userName)":USERUniqueID,
                    "\(objMessageDBM.timeStamp)": timespam,
                    "\(objMessageDBM.source)":SOURCECODE,
                    "\(objMessageDBM.messageImagePath)":objecturl]],
                
                touid: [autocreatedid : [
                     "\(objMessageDBM.from)":"\(fromuid)",
                     "\(objMessageDBM.message)":audioDuration,
                     "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                     "\(objMessageDBM.messageType)":AUDIO,
                     "\(objMessageDBM.userName)":USERUniqueID,
                     "\(objMessageDBM.timeStamp)": timespam,
                     "\(objMessageDBM.source)":SOURCECODE,
                     "\(objMessageDBM.messageImagePath)":objecturl,]]
            ]
            break
        case VIDEO:
            dicmsg = [
                fromuid: [autocreatedid : [
                    "\(objMessageDBM.from)":"\(fromuid)",
                    "\(objMessageDBM.message)":audioDuration,
                    "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                    "\(objMessageDBM.messageType)":VIDEO,
                    "\(objMessageDBM.imageThumb)":self.videoimageurl,
                    "\(objMessageDBM.messageImagePath)":self.videoimageurl,
                    "\(objMessageDBM.messageVideoPath)":self.objecturl,
                    "\(objMessageDBM.userName)":USERUniqueID,
                    "\(objMessageDBM.source)":SOURCECODE,
                    "\(objMessageDBM.messageImagePath)":videoimageurl]],
                
                
                touid: [
                    "\(objMessageDBM.from)":"\(fromuid)",
                    "\(objMessageDBM.message)":audioDuration,
                    "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                    "\(objMessageDBM.messageType)":VIDEO,
                    "\(objMessageDBM.imageThumb)":self.videoimageurl,
                    "\(objMessageDBM.messageImagePath)":self.videoimageurl,
                    "\(objMessageDBM.messageVideoPath)":self.objecturl,
                    "\(objMessageDBM.userName)":USERUniqueID,
                    "\(objMessageDBM.source)":SOURCECODE,
                    "\(objMessageDBM.messageImagePath)":videoimageurl]
            ]
            break
        default:
            print("dfggf")
        }
        
        //MARK:- Create new groupid and send message
        createNewPrivateChatGroupId(msgtype: msgType){ key in
            self.andicator.stopAnimating()
            guard let key = key else {
                obj.showToast(message: "Error Occured try again!", viewcontroller: self)
                return }
            if self.groupId == ""
            {
                obj.showToast(message: key, viewcontroller: self)
            }
            else
            {
                if msgType == TEXT || msgType == LOCATION
                {
                    MessagesDB.child(key)
                        .setValue(dicmsg, withCompletionBlock: { error, snapshot in
                            print(snapshot)
                            
                            if error != nil
                            {
                                obj.showToast(message: (error?.localizedDescription)!, viewcontroller: self)
                            }
                            else
                            {
                                self.txtmsgv.text = ""
                                self.imgvmike.image = UIImage(named: "unholdmike")
                                self.imgvmike.accessibilityIdentifier = "unholdmike"
                                // obj.showToast(message: "Message send successfully.", viewcontroller: self)
                                
                            }
                            completion("")
                        })
                }
                else
                {
                    self.uploadMedia(type: msgType) { url in
                        guard let url = url else { return }
                        self.objecturl = url
                        MessagesDB.child(key)
                            .setValue(dicmsg
                                as [String :Any],withCompletionBlock: {
                                    error, ref in
                                    self.andicator.stopAnimating()
                                    if error != nil
                                    {
                                        obj.showToast(message: (error?.localizedDescription)!, viewcontroller: self)
                                    }
                                    else
                                    {
                                        //  obj.showToast(message: "Message send successfully.", viewcontroller: self)
                                    }
                                    completion("")
                            })
                    }
                }
            }
        }
    }
    //MARK:- if you have send first message to receiver and no Private Chat Group Id Exist
    func createNewPrivateChatGroupId(msgtype: Int,completion: @escaping (_ key: String?) -> Void) {
        //MARK:- Add new group
        let timespam = Date().currentTimeMillis()!
        let dicGroup = [
            "\(objGroupsDBM.groupCreatedAt)" : timespam,
            "\(objGroupsDBM.groupCreatedBy)" : timespam,
            "\(objGroupsDBM.groupDescription)" : "",
            "\(objGroupsDBM.groupImage)" : "",
            "\(objGroupsDBM.groupName)" : "\(self.fromuid),\(self.touid)",
            "\(objGroupsDBM.groupType)" : PRIVATECHAT,
            "\(objGroupsDBM.groupUpdated)" : timespam,
            "\(objGroupsDBM.source)":SOURCECODE] as [String : Any]
        
        GroupsDB.childByAutoId()
            .setValue(dicGroup ,withCompletionBlock: {
                error, snapshot in
                print(snapshot)
                if error != nil {
                    completion(error?.localizedDescription)
                }
                else {
                    //MARK:- From
                    let fromdic =  [self.touid:
                        ["\(objPrivateChatDBM.groupId)": "\(String(describing: snapshot.key!))"]]
                    
                    let todic =  [self.fromuid:
                        ["\(objPrivateChatDBM.groupId)": "\(String(describing: snapshot.key!))"]]
                    
                    //MARK:- Add data in Private Chat with Group id
                    PrivateChatDB.child(self.fromuid)
                        .updateChildValues(fromdic,withCompletionBlock: {
                            error, ref in
                            if error != nil
                            {
                                completion(error?.localizedDescription)
                            }
                            else
                            {
                                PrivateChatDB.child(self.touid)
                                    .updateChildValues(todic, withCompletionBlock: {
                                        
                                        error, ref in
                                        if error != nil
                                        {
                                            completion(error?.localizedDescription)
                                        }
                                        else
                                        {
                                            self.createChat(msgtype: msgtype, key: snapshot.key!, ifupdate: "0", completion: {
                                                response in
                                                if response != "success"
                                                {
                                                    completion(response)
                                                }
                                                else
                                                {
                                                    //MARK:- Observer on Gouped ID Messageses
                                                    if self.groupId == ""
                                                    {
                                                        //MARK:- From
                                                        self.groupId = snapshot.key!
                                                        self.retreiveMessages()
                                                        self.funUserActivityStatus()
                                                    }
                                                    completion(snapshot.key)
                                                }
                                            })
                                        }
                                    })
                            }})
                }
                //MARK:-v1- From and 2- To both
                //            self.PrivateChatDB.child(self.fromuid).child(self.touid).setValue(dicgroupId)
                //            self.PrivateChatDB.child(self.touid).child(self.fromuid).setValue(dicgroupId)
            })
    }
    
    func createChat(msgtype: Int,key: String,ifupdate: String, completion: @escaping (_ key: String?) -> Void) {
        
        let timespam = Date().currentTimeMillis()!
        funGetMessageCount(receiverid: touid, completion: {
            unSeenCount in
            let dicGroupFrom = [
                "\(objChatDBM.createdAt)" : timespam,
                "\(objChatDBM.groupType)" : PRIVATECHAT,
                "\(objChatDBM.lastMessage)" : self.messagetext,
                "\(objChatDBM.lastMessageId)" : self.autocreatedid,
                "\(objChatDBM.lastMessageStatus)" : NOT_DELIVERED,
                "\(objChatDBM.lastMessageTime)" : timespam,
                "\(objChatDBM.lastMessageType)" : msgtype,
                "\(objChatDBM.lastMessageUserId)" : self.fromuid,
                "\(objChatDBM.messageStatus)"  : "",
                "\(objChatDBM.otherUserId)" : self.touid,
                "\(objChatDBM.seen)" : false,
                "\(objChatDBM.typing)" : STOP_TYPING_RECORDING,
                "\(objChatDBM.userName)" : USERUniqueID,
                "\(objChatDBM.unSeenCount)" :0,
                "\(objChatDBM.source)":SOURCECODE] as [String : Any]
            let dicGroupTo = [
                "\(objChatDBM.createdAt)" : timespam,
                "\(objChatDBM.groupType)" : PRIVATECHAT,
                "\(objChatDBM.lastMessage)" : self.messagetext,
                "\(objChatDBM.lastMessageId)" : self.autocreatedid,
                "\(objChatDBM.lastMessageStatus)" : NOT_DELIVERED,
                "\(objChatDBM.lastMessageTime)" : timespam,
                "\(objChatDBM.lastMessageType)" : msgtype,
                "\(objChatDBM.lastMessageUserId)" : self.fromuid,
                "\(objChatDBM.messageStatus)" : "",
                "\(objChatDBM.otherUserId)" : self.fromuid,
                "\(objChatDBM.seen)" : false,
                "\(objChatDBM.typing)" : STOP_TYPING_RECORDING,
                "\(objChatDBM.userName)" : USERUniqueID,
                "\(objChatDBM.unSeenCount)" : unSeenCount! as Any,
                "\(objChatDBM.source)":SOURCECODE] as [String : Any]
            
            ChatDB.child(self.fromuid)
                .child(key)
                .updateChildValues(dicGroupFrom, withCompletionBlock: {
                    error, snapshot in
                    if error != nil
                    {
                        completion(error?.localizedDescription)
                    }
                    else
                    {
                        DispatchQueue.main.async{
                            ChatDB.child(self.touid)
                                .child(key)
                                .updateChildValues(dicGroupTo)
                            completion("success")
                        }
                    }
                })
        })
        
    }
    
    //MARK:- Delete Messages
    func deleteMessages(index: Int, isClear: Int, isDeleteFromEveryOne: Int, completion: @escaping (_ key: String?) -> Void) {
        print("deleting index: \(index)")
        
        let msgid = temparrMsgId[index] as! String
        //MARK:- 0 Means delete from my chat only
        if isDeleteFromEveryOne == 0
        {
            MessagesDB.child(groupId)
                .child(fromuid)
                .child(msgid)
                .removeValue(completionBlock: { error, snapshot in
                    let tempdic = snapshot
                    
                    if error != nil
                    {
                        obj.showToast(message: (error?.localizedDescription)!, viewcontroller: self)
                        completion("fail")
                    }
                    else
                    {
                        let index = self.arrMsgId.index(of: snapshot.key as Any)
                        
                        self.arrMsgFomid.removeObject(at: index)
                        self.arrMsg.removeObject(at: index)
                        self.arrMsgType.removeObject(at: index)
                        self.arrMsgTime.removeObject(at: index)
                        self.arrMsgPicThumb.removeObject(at: index)
                        self.arrMsgPic.removeObject(at: index)
                        self.arrMsgVideo.removeObject(at: index)
                        self.arrMsgLat.removeObject(at: index)
                        self.arrMsgLong.removeObject(at: index)
                        //self.arrMsgAddress.removeObject(at: index)
                        self.arrMsgId.removeObject(at: index)
                        self.arrMsgStatus.removeObject(at: index)
                        
                        let indexPath = IndexPath(row: index, section: 0)
                        self.tablev.deleteRows(at: [indexPath], with: .fade)
                        
                        let tempLastMessageId = self.arrMsgId.lastObject as! String
                        
                        MessagesDB.child(self.groupId)
                            .child(self.fromuid)
                            .child(tempLastMessageId)
                            .observeSingleEvent(of: .value, with: {(snapshot) in
                                
                                let tempdic2nd = snapshot.value as! NSDictionary
                                if error == nil
                                {
                                    let dicGroupFrom = [
                                        "\(objChatDBM.createdAt)" : tempdic2nd.value(forKey: "\(objMessageDBM.timeStamp)") as Any,
                                        "\(objChatDBM.groupType)" : self.groupType,
                                        "\(objChatDBM.lastMessage)" : tempdic2nd.value(forKey: "\(objMessageDBM.message)") as Any,
                                        "\(objChatDBM.lastMessageId)" : snapshot.key,
                                        "\(objChatDBM.lastMessageStatus)" : tempdic2nd.value(forKey: "\(objMessageDBM.messageStatus)") as Any,
                                        "\(objChatDBM.lastMessageTime)" : tempdic2nd.value(forKey: "\(objMessageDBM.timeStamp)") as Any,
                                        "\(objChatDBM.lastMessageType)" : tempdic2nd.value(forKey: "\(objMessageDBM.messageType)") as Any,
                                        "\(objChatDBM.lastMessageUserId)": tempdic2nd.value(forKey: "\(objMessageDBM.from)") as Any,
                                        "\(objChatDBM.messageStatus)" : tempdic2nd.value(forKey: "\(objMessageDBM.messageStatus)") as Any,
                                        "\(objChatDBM.otherUserId)" : self.touid,
                                        "\(objChatDBM.seen)" : false,
                                        "\(objChatDBM.typing)" : STOP_TYPING_RECORDING,
                                        "\(objChatDBM.userName)" : tempdic2nd.value(forKey: "\(objMessageDBM.userName)") as Any,
                                        "\(objChatDBM.unSeenCount)" :0,
                                        "\(objChatDBM.source)" :SOURCECODE] as [String : Any]
                                    
                                    ChatDB.child(self.fromuid).child(self.groupId)
                                        .updateChildValues(dicGroupFrom, withCompletionBlock: {
                                            error, snapshot in
                                            if error != nil
                                            {
                                                completion(error?.localizedDescription)
                                            }
                                            else
                                            {
                                                
                                            }
                                        })
                                    
                                }
                                else
                                {
                                    print(error?.localizedDescription as Any)
                                }
                            })
                        
                        
                        if isDeleteFromEveryOne == 1{
                            ChatDB.child(self.touid)
                                .child(self.groupId)
                                .updateChildValues(tempdic as! [AnyHashable : Any], withCompletionBlock: {
                                    error, snapshot in
                                    if error != nil
                                    {
                                        print(error?.localizedDescription as Any)
                                        print("Error in  typing")
                                    }
                                    else
                                    {
                                        print("is typing")
                                    }
                                })
                        }
                        completion("success")
                    }
                })
        }
        else
        {
            if arrMsgId[index] as! String == arrMsgId[arrMsgId.count - 1] as! String
            {
                isSelfdeliver(messageStatus: MESSAGE_DELETED)
                isdeliver(messageStatus: MESSAGE_DELETED)
            }
            MessagesDB.child(self.groupId)
                .child(self.touid)
                .child(msgid)
                .updateChildValues([
                    "\(objMessageDBM.messageStatus)":MESSAGE_DELETED],
                                   withCompletionBlock: { error, snapshot in
                                    
                                    if error != nil
                                    {
                                        obj.showToast(message: (error?.localizedDescription)!, viewcontroller: self)
                                        completion("fail")
                                    }
                                    else
                                    {
                                        
                                        completion("success")
                                    }
                })
            
            
            MessagesDB.child(groupId)
                .child(fromuid)
                .child(msgid)
                .updateChildValues([
                    "\(objMessageDBM.messageStatus)":MESSAGE_DELETED,
                    ], withCompletionBlock: { error, snapshot in
                        
                        if error != nil
                        {
                            obj.showToast(message: (error?.localizedDescription)!, viewcontroller: self)
                            completion("fail")
                        }
                        else
                        {
                            if isDeleteFromEveryOne == 1
                            {
                                //MARK:- If other User Message Delete
                                
                            }
                            
                            if isClear == 1
                            {
                                completion("success")
                                return
                            }
                            completion("success")
                        }
                })
        }
        
    }
    //Mark:- if you already have send any message to receiver then group id will find
    func retreivePrivateChatGroupId(){
        //Firebase Fetch Query
        //MARK:- How to get a single valuee by key and again in this node get another single value
        PrivateChatDB.child(fromuid)
            .child(touid)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if snapshot.childrenCount > 0 {
                    if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                        for snap in snapShot {
                            self.andicator.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            if let gid = snap.value as? String {
                                if self.groupId == "" {
                                    self.groupId = gid
                                    DispatchQueue.main.async {
                                        self.retreiveMessages()
                                        self.funUserActivityStatus()
                                    }
                                }
                            }
                            break
                        }
                    }
                }
            })
    }
    
    
    //MARK:- Retreive Messages from db and add observer
    var totalmessagecount = 0
    func retreiveMessages(){
        MessagesDB.child(groupId)
        .child(fromuid)
            .queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                self.andicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    if self.groupType == PRIVATECHAT {
                        self.funMessageDBDeliveryStatus()
                    }
                    if snapShot.count > 0 {
                        //self.andicator.startAnimating()
                        self.totalmessagecount = Int(snapshot.childrenCount)
                        print(snapShot)
                        //MARK:- WHEN I USE THIS DATADIC  sortting issue occur
                        let datadic = (snapshot.value as! NSDictionary).allValues as NSArray
                        if datadic.count > 0 {
                            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                                for snap in snapShot{
                                    if let data = snap.value as? [String:AnyObject]{
                                        if data.count == 1 {
                                            MessagesDB.child(self.groupId)
                                                .child(self.fromuid)
                                                .child(snap.key)
                                                .removeValue(completionBlock: { (error,snapshot) in
                                                    if error != nil {
                                                        
                                                    }else{
                                                        
                                                    }
                                                })
                                        }
                                        else{
                                            self.funaddvalue(snapShotValue: data as NSDictionary, snapshotkey:  snap.key)
                                            self.arrImagePlayPause.append("play")
                                            self.arrTotalAudioTime.append("00:00")
                                        }
                                    }
                                }
                                // print(self.arrMsg)
                            }
                        }
                        DispatchQueue.main.async{
                            self.tablev.reloadData() {
                                self.funReceiveMessage()
                                let indexPath = IndexPath(row: self.arrMsgType.count-1, section: 0)
                                self.scrolltobottom(indexpath: indexPath)
                                self.andicator.stopAnimating()
                            }
                        }
                    }
                    else {
                        self.isviewloaad = 1
                        self.funReceiveMessage()
                    }
                }
        })
    }
    func funaddvalue(snapShotValue: NSDictionary, snapshotkey: String) {
        print(snapShotValue)
        self.arrMsgFomid.add(snapShotValue.value(forKey: "\(objMessageDBM.from)") as! String)
        if let msg = snapShotValue.value(forKey: "\(objMessageDBM.message)") as? String {
            if let type = snapShotValue.value(forKey: "\(objMessageDBM.messageType)") as? Int {
                if type == AUDIO {
                    if let sec = Int(msg)?.msToSeconds {
                        let tempaudiotime = obj.funHMSFromSeconds(seconds: sec)
                        self.arrMsg.add(String(tempaudiotime))
                    }
                    else {
                        self.arrMsg.add("")
                    }
                }
                else {
                    self.arrMsg.add(msg)
                }
            }
        }
        else if let msg = snapShotValue.value(forKey: "\(objMessageDBM.message)") as? Double {
            let sec = Int(msg).msToSeconds
            self.arrMsg.add(String(sec))
            //            let tempaudiotime = obj.funHMSFromSeconds(seconds: msg)
            //            if let totaltime = Int(tempaudiotime)
            //            {
            //                let sec = totaltime.msToSeconds
            //                self.arrMsg.add(String(sec))
            //            }
            //            else
            //            {
            //                 self.arrMsg.add("")
            //            }
        }
        else if let msg = snapShotValue.value(forKey: "\(objMessageDBM.message)") as? Int {
            let sec = msg.msToSeconds
            self.arrMsg.add(String(sec))
        }
        if let type = snapShotValue.value(forKey: "\(objMessageDBM.messageType)") as? String {
            self.arrMsgType.add(type)
            if type == "\(LOCATION)" {
                if let thumb = snapShotValue.value(forKey: "\(objMessageDBM.imageThumb)") as? String {
                    let arr = "\(thumb)".split {$0 == ","}
                    self.arrMsgLat.add(Double(arr[0]) as Any)
                    self.arrMsgLong.add(Double(arr[1]) as Any)
                }
                else {
                    self.arrMsgLong.add("")
                    self.arrMsgLat.add("")
                }
            }
            else {
                self.arrMsgLong.add("")
                self.arrMsgLat.add("")
            }
        }
        else if let type = snapShotValue.value(forKey: "\(objMessageDBM.messageType)") as? Int {
            self.arrMsgType.add(type)
            if type == LOCATION {
                if let thumb = snapShotValue.value(forKey: "\(objMessageDBM.imageThumb)") as? String {
                    let arr = "\(thumb)".split {$0 == ","}
                    self.arrMsgLat.add(Double(arr[0]) as Any)
                    self.arrMsgLong.add(Double(arr[1]) as Any)
                }
                else {
                    self.arrMsgLong.add("")
                    self.arrMsgLat.add("")
                }
            }
            else {
                self.arrMsgLong.add("")
                self.arrMsgLat.add("")
            }
        }
        if let time = snapShotValue.value(forKey: "\(objMessageDBM.timeStamp)") as? String {
            self.arrMsgTime.add(Int(time)!)
        }
        else if let time = snapShotValue.value(forKey: "\(objMessageDBM.timeStamp)") as? Int {
            self.arrMsgTime.add(time)
        }
        if let thumb = snapShotValue.value(forKey: "\(objMessageDBM.imageThumb)") as? String {
            self.arrMsgPicThumb.add(thumb)
        }
        else {
            self.arrMsgPicThumb.add("")
        }
        
        if let urltype = snapShotValue.value(forKey: "\(objMessageDBM.messageImagePath)") as? String {
            self.arrMsgPic.add(urltype)
        }
        else {
            self.arrMsgPic.add("")
        }
        if let video = snapShotValue.value(forKey: "\(objMessageDBM.messageVideoPath)") as? String {
            self.arrMsgVideo.add(video)
        }
        else {
            self.arrMsgVideo.add("")
        }
        
        //        if let address = snapShotValue.value(forKey: "address") as? String
        //        {
        //            self.arrMsgAddress.add(address)
        //        }
        //        else
        //        {
        //            self.arrMsgAddress.add("")
        //        }
        self.arrMsgId.add(snapshotkey)
        
        if let msgStatus = snapShotValue.value(forKey: "\(objMessageDBM.messageStatus)") as? Int {
            if msgStatus != SEEN && msgStatus != MESSAGE_DELETED {
                if USERUID != snapShotValue.value(forKey: "\(objMessageDBM.from)") as! String {
                    if READ_RECEIPT == true{
                        self.arrMsgStatus.add(SEEN)
                    }
                    else{
                        self.arrMsgStatus.add(DELIVERED)
                    }
                    
                    if self.groupType == PRIVATECHAT {
                        MessagesDB.child(groupId)
                            .child(self.touid)
                            .child(snapshotkey)
                            .queryOrderedByKey()
                            .observe(.value) { (snapshot) in
                                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                                    if snapShot.count > 0
                                    {
                                        let tempdic = snapshot.value as! NSMutableDictionary
                                        //print(tempdic)
                                        if tempdic.value(forKey: "\(objMessageDBM.messageStatus)") as! Int == SEEN{
                                            return
                                        }
                                        else{
                                            if READ_RECEIPT == true{
                                                tempdic.setValue(SEEN, forKey: "\(objMessageDBM.messageStatus)")
                                            }
                                            else{
                                                tempdic.setValue(DELIVERED, forKey: "\(objMessageDBM.messageStatus)")
                                            }
                                        }
                                        
                                        let tempkeyarray = tempdic.allKeys as NSArray
                                        if tempkeyarray.contains("\(objMessageDBM.source)")
                                        {
                                            tempdic.setValue(SOURCECODE, forKey: "\(objMessageDBM.source)")
                                        }
                                        else
                                        {
                                            tempdic.setValue(SOURCECODE, forKey: "\(objMessageDBM.source)")
                                        }
                                        //print(tempdic)
                                        MessagesDB.child(self.groupId).child(self.touid).child(snapshotkey).updateChildValues(tempdic as! [AnyHashable : Any])
                                    }
                                }
                        }
                    }
                }
                else {
                    self.arrMsgStatus.add(msgStatus)
                }
            }
            else {
                self.arrMsgStatus.add(msgStatus)
            }
        }
    }
    var arrBackGroundMessages = [String]()
    //MARK:- When New Message RECEIVE
    func funReceiveMessage() {
        var tempcount = 0
        MessagesDB.child(groupId)
            .child(fromuid)
            .observe(.childAdded) { (snapshot : DataSnapshot) in
                if snapshot.childrenCount > 0
                {
                    if self.isviewloaad == 0
                    {
                        tempcount = tempcount + 1
                        if tempcount == self.totalmessagecount - 1
                        {
                            self.isviewloaad = 1
                        }
                        return
                    }
                    let snapShotValue = snapshot.value as! NSDictionary
                    print(snapShotValue)
                    if snapShotValue.count == 1
                    {
                        MessagesDB.child(self.groupId)
                            .child(self.fromuid)
                            .child(snapshot.key)
                            .removeValue(completionBlock: { (error,snapshot) in
                                
                                if error != nil
                                {
                                    
                                }else{
                                    
                                }
                            })
                        return
                    }
                    self.arrMsgId.add(snapshot.key)
                    self.arrMsgFomid.add(snapShotValue.value(forKey: "\(objMessageDBM.from)") as! String)
                    if let msgStatus = snapShotValue.value(forKey: "\(objMessageDBM.messageStatus)") as? Int
                    {
                        if msgStatus != SEEN
                        {
                            if self.fromuid != snapShotValue.value(forKey: "\(objMessageDBM.from)") as? String
                            {
                                let tempdic = snapshot.value as! NSMutableDictionary
                                //print(tempdic)
                                var tempstatus = Int()
                                if READ_RECEIPT == true {
                                    tempstatus = SEEN
                                }
                                else if READ_RECEIPT == false{
                                    tempstatus = DELIVERED
                                }
                                let application = UIApplication.shared
                                if application.applicationState == .background {
                                    tempstatus = DELIVERED
                                    self.arrBackGroundMessages.append(snapshot.key)
                                }
                                tempdic.setValue(tempstatus, forKey: "\(objMessageDBM.messageStatus)")
                                self.arrMsgStatus.add(tempstatus)
                                //print(tempdic)
                                let tempkeyarray = tempdic.allKeys as NSArray
                                if tempkeyarray.contains("\(objMessageDBM.source)")
                                {
                                    tempdic.setValue(SOURCECODE, forKey: "\(objMessageDBM.source)")
                                }
                                else
                                {
                                    tempdic.setValue(SOURCECODE, forKey: "\(objMessageDBM.source)")
                                }
                                DispatchQueue.main.async{
                                    if self.groupType == PUBLICGROUP
                                    {
                                    
                                        if let tempfromUid = snapShotValue.value(forKey: "\(objMessageDBM.from)") as? String{
                                           // MessagesDB.child(self.groupId)
                                            //    .child(tempfromUid)
                                           //     .child(snapshot.key)
                                           //     .updateChildValues(tempdic as! [AnyHashable : Any])
                                        }
                                    }
                                    else{
                                        MessagesDB.child(self.groupId)
                                            .child(self.touid)
                                            .child(snapshot.key)
                                            .updateChildValues(tempdic as! [AnyHashable : Any])
                                    }
                                    //self.isdeliver(messageStatus: SEEN)
                                    self.isdeliverWhenMsgScreenOpen()
                                }
                                
                            }else
                            {
                                self.arrMsgStatus.add(msgStatus)
                                if self.groupType == PUBLICGROUP
                                {
                                    self.isdeliverWhenMsgScreenOpen()
                                }
                            }
                        }else
                        {
                            self.arrMsgStatus.add(msgStatus)
                        }
                    }
                    
                    if let msg = snapShotValue.value(forKey: "\(objMessageDBM.message)") as? String{
                        if let type = snapShotValue.value(forKey: "\(objMessageDBM.messageType)") as? Int{
                            if type == AUDIO{
                                if let sec = Int(msg)?.msToSeconds{
                                    let tempaudiotime = obj.funHMSFromSeconds(seconds: sec)
                                    self.arrMsg.add(String(tempaudiotime))
                                }
                                else{
                                    self.arrMsg.add("")
                                }
                            }
                            else{
                                self.arrMsg.add(msg)
                            }
                        }
                    }
                    else if let msg = snapShotValue.value(forKey: "\(objMessageDBM.message)") as? Double{
                        let sec = Int(msg).msToSeconds
                        
                        self.arrMsg.add(String(sec))
                        
                        
                        
                        //                    if let totaltime = Int(tempaudiotime)
                        //                    {
                        //                        let sec = totaltime.msToSeconds
                        //                        self.arrMsg.add(String(sec))
                        //                    }
                        //                    else
                        //                    {
                        //                        self.arrMsg.add("")
                        //                    }
                    }
                    else if let msg = snapShotValue.value(forKey: "\(objMessageDBM.message)") as? Int{
                        let sec = msg.msToSeconds
                        self.arrMsg.add(String(sec))
                    }
                    if let type = snapShotValue.value(forKey: "\(objMessageDBM.messageType)") as? String{
                        self.arrMsgType.add(type)
                        if type == "\(LOCATION)"{
                            if let thumb = snapShotValue.value(forKey: "\(objMessageDBM.imageThumb)") as? String {
                                let arr = "\(thumb)".split {$0 == ","}
                                self.arrMsgLat.add(Double(arr[0]) as Any)
                                self.arrMsgLong.add(Double(arr[1]) as Any)
                            }
                            else{
                                self.arrMsgLong.add("")
                                self.arrMsgLat.add("")
                            }
                        }
                        else{
                            self.arrMsgLong.add("")
                            self.arrMsgLat.add("")
                        }
                    }
                    else if let type = snapShotValue.value(forKey: "\(objMessageDBM.messageType)") as? Int  {
                        self.arrMsgType.add(type)
                        if type == LOCATION{
                            if let thumb = snapShotValue.value(forKey: "\(objMessageDBM.imageThumb)") as? String{
                                let arr = "\(thumb)".split {$0 == ","}
                                self.arrMsgLat.add(Double(arr[0]) as Any)
                                self.arrMsgLong.add(Double(arr[1]) as Any)
                            }
                            else{
                                self.arrMsgLong.add("")
                                self.arrMsgLat.add("")
                            }
                        }
                        else{
                            self.arrMsgLong.add("")
                            self.arrMsgLat.add("")
                        }
                    }
                    if let time = snapShotValue.value(forKey: "\(objMessageDBM.timeStamp)") as? String {
                        self.arrMsgTime.add(Int(time)!)
                    }
                    else if let time = snapShotValue.value(forKey: "\(objMessageDBM.timeStamp)") as? Int {
                        self.arrMsgTime.add(time)
                    }
                    if let thumb = snapShotValue.value(forKey: "\(objMessageDBM.imageThumb)") as? String {
                        self.arrMsgPicThumb.add(thumb)
                    }
                    else {
                        self.arrMsgPicThumb.add("")
                    }
                    if let urltype = snapShotValue.value(forKey: "\(objMessageDBM.messageImagePath)") as? String {
                        self.arrMsgPic.add(urltype)
                    }
                    else {
                        self.arrMsgPic.add("")
                    }
                    if let video = snapShotValue.value(forKey: "\(objMessageDBM.messageVideoPath)") as? String {
                        self.arrMsgVideo.add(video)
                    }
                    else {
                        self.arrMsgVideo.add("")
                    }
                    self.arrImagePlayPause.append("play")
                    self.arrTotalAudioTime.append("00:00")
                    //                if let address = snapShotValue.value(forKey: "address") as? String
                    //                {
                    //                    self.arrMsgAddress.add(address)
                    //                }
                    //                else
                    //                {
                    //                    self.arrMsgAddress.add("")
                    //                }
                    //self.tablev.reloadData()
                    let indexPath = IndexPath(row: self.arrMsgType.count-1, section: 0)
                    //MARK:- Add new row in table view
                    DispatchQueue.main.async{
                        self.tablev.beginUpdates()
                        self.tablev.insertRows(at: [IndexPath(row: self.arrMsgType.count-1, section: 0)], with: .automatic)
                        self.tablev.endUpdates()
                        if self.arrMsgType.count > 0{
                            self.scrolltobottom(indexpath: indexPath)
                        }
                    }
                    
                }
        }
    }
    
    //MARK:- When other user is Typing or Recording His Status will work Accrodingly
    func funUserActivityStatus(){
        if isUserActivityStatusFunRun == 0 {
            isUserActivityStatusFunRun = 1
            DispatchQueue.main.async {
                ChatDB.child(self.fromuid)
                    .child(self.groupId)
                    .observe(.childChanged, with: { (snapshot) in
                        if snapshot.key == "\(objChatDBM.typing)"{
                            self.isonline = "1"
                            if snapshot.value as! Int == TYPING{
                                self.updateTyping()
                            }
                            else if snapshot.value as! Int == RECORDING{
                                self.updateRecording()
                            }
                            else{
                                self.updateOnline()
                            }
                        }
                        else if snapshot.key == "\(objChatDBM.lastMessageStatus)"{
                            //MARK:- If user ask for if message NOT_DELIVERED we will update it to seen
                            if snapshot.value as! Int == NOT_DELIVERED{
                                //self.isdeliver(messageStatus: SEEN)
                            }
                            else if snapshot.value as! Int == SENT{
                                //MARK:- Response for other user that message has been Seen
                                self.isdeliver(messageStatus: SEEN)
                            }
                        }
                    })
                
                ChatDB.child(self.fromuid)
                    .child(self.groupId)
                    .observe(.value, with: { (snapshot) in
                        
                        if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                            if snapShot.count > 0 {
                                if ((snapshot.value as! NSDictionary).value(forKey: "\(objChatDBM.typing)") as? Int) != nil{
                                    
                                }
                            }
                        }
                        if snapshot.key == "\(objChatDBM.typing)"{
                            self.isonline = "1"
                            if snapshot.value as! Int == TYPING{
                                self.updateTyping()
                            }
                            else if snapshot.value as! Int == RECORDING{
                                self.updateRecording()
                            }
                            else{
                                self.updateOnline()
                            }
                        }
                        else if snapshot.key == "\(objChatDBM.lastMessageStatus)"
                        {
                            //MARK:- If user ask for if message NOT_DELIVERED we will update it to seen
                            if snapshot.value as! Int == NOT_DELIVERED{
                                //self.isdeliver(messageStatus: SEEN)
                            }
                            else if snapshot.value as! Int == SENT{
                                //MARK:- Response for other user that message has been Seen
                                self.isdeliver(messageStatus: SEEN)
                            }
                        }
                    })
            }
        }
    }
    
    func funTypingStatusOtherUser(snapshot: DataSnapshot){
        if snapshot.key == "\(objChatDBM.typing)" {
            self.isonline = "1"
            if snapshot.value as! Int == TYPING{
                self.updateTyping()
            }
            else if snapshot.value as! Int == RECORDING{
                self.updateRecording()
            }
            else{
                self.updateOnline()
            }
        }
        else if snapshot.key == "\(objChatDBM.lastMessageStatus)" {
            //MARK:- If user ask for if message NOT_DELIVERED we will update it to seen
            if snapshot.value as! Int == NOT_DELIVERED{
                //self.isdeliver(messageStatus: SEEN)
            }
            else if snapshot.value as! Int == SENT{
                //MARK:- Response for other user that message has been Seen
                self.isdeliver(messageStatus: SEEN)
            }
        }
    }
    
    //MARK:- When message DELIVER or SEEN
    func funMessageDBDeliveryStatus(){
        MessagesDB.child(groupId)
            .child(fromuid)
            .queryOrderedByKey()
            .observe(.childChanged) { (snapshot) in
                print(snapshot)
                let index = self.arrMsgId.index(of: snapshot.key)
                let tempstatus = (snapshot.value as! NSDictionary).value(forKey: "\(objMessageDBM.messageStatus)")
                
                if self.fromuid == (snapshot.value as! NSDictionary).value(forKey: "\(objMessageDBM.from)") as! String {
                    if self.arrMsgId.contains(snapshot.key) == true {
                        if let status = (snapshot.value as! NSDictionary).value(forKey: "\(objMessageDBM.messageStatus)") as? Int {
                            self.arrMsgStatus[index] = status
                            let indexPath = IndexPath(row: index, section: 0)
                            DispatchQueue.main.async{
                                self.tablev.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                }
                else{
                    if self.arrMsgId.contains(snapshot.key) == true{
                        if let status = (snapshot.value as! NSDictionary).value(forKey: "\(objMessageDBM.messageStatus)") as? Int{
                            if status == MESSAGE_DELETED{
                                self.arrMsgStatus[index] = status
                                let indexPath = IndexPath(row: index, section: 0)
                                DispatchQueue.main.async {
                                    self.tablev.reloadRows(at: [indexPath], with: .none)
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.funCheckLastMessageStatus(status: tempstatus as! Int)
                }
        }
    }
    
    func funCheckLastMessageStatus(status: Int){
        if self.groupType == PRIVATECHAT {
            if arrMsgStatus.contains(1){
                for (index, temp) in arrMsgStatus.enumerated(){
                    let tempStatus = temp as! Int
                    if tempStatus != MESSAGE_DELETED && tempStatus != DELIVERED && tempStatus != SEEN{
                        MessagesDB.child(self.groupId)
                            .child(self.fromuid)
                            .child(arrMsgId[index] as! String)
                            .observeSingleEvent(of: .value, with: {(snapshot) in
                                
                                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                                    if snapShot.count > 0{
                                        let tempdic = snapshot.value as! NSMutableDictionary
                                        //print(tempdic)
                                        tempdic.setValue(status, forKey: "\(objMessageDBM.messageStatus)")
                                        let tempkeyarray = tempdic.allKeys as NSArray
                                        if tempkeyarray.contains("\(objMessageDBM.source)"){
                                            tempdic.setValue(SOURCECODE, forKey: "\(objMessageDBM.source)")
                                        }
                                        else{
                                            tempdic.setValue(SOURCECODE, forKey: "\(objMessageDBM.source)")
                                        }
                                        //print(tempdic)
                                        MessagesDB
                                            .child(self.groupId)
                                            .child(self.fromuid)
                                            .child(snapshot.key)
                                            .updateChildValues(tempdic as! [AnyHashable : Any])
                                    }
                                }
                        })
                    }
                }
            }
        }
    }
    
    func isTypingOrRecording(isTypingOrRecording: Int){
        ChatDB.child(self.touid)
            .child(self.groupId)
            .observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    if snapShot.count > 0{
                        let tempdic = snapshot.value as! NSMutableDictionary
                        // print(tempdic)
                        tempdic.setValue(isTypingOrRecording, forKey: "\(objChatDBM.typing)")
                        
                        let tempkeyarray = tempdic.allKeys as NSArray
                        if tempkeyarray.contains("\(objChatDBM.source)"){
                            tempdic.setValue(SOURCECODE, forKey: "\(objChatDBM.source)")
                        }
                        else{
                            tempdic.setValue(SOURCECODE, forKey: "\(objChatDBM.source)")
                        }
                        //print(tempdic)
                        ChatDB.child(self.touid)
                            .child(self.groupId)
                            .updateChildValues(tempdic as! [AnyHashable : Any],
                                               withCompletionBlock: { error, snapshot in
                                if error != nil{
                                    print(error?.localizedDescription as Any)
                                    print("Error in  typing")
                                }
                                else{
                                    print("is typing")
                                }
                            })
                    }
                }
            })
    }
    //MARK:- Run Time Message Delivery Status
    func isdeliver(messageStatus: Int){
        ChatDB.child(touid)
            .child(groupId)
            .observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    if snapShot.count > 0{
                        if let lastmessagestatus = (snapshot.value as! NSDictionary).value(forKey: "\(objChatDBM.lastMessageStatus)") as? Int{
                            if lastmessagestatus != SEEN //&& lastmessagestatus != MESSAGE_DELETED
                            {
                                let tempdic = snapshot.value as! NSMutableDictionary
                                //print(tempdic)
                                tempdic.setValue(messageStatus, forKey: "\(objChatDBM.lastMessageStatus)")
                                let tempkeyarray = tempdic.allKeys as NSArray
                                if tempkeyarray.contains("\(objChatDBM.source)"){
                                    tempdic.setValue(SOURCECODE, forKey: "\(objChatDBM.source)")
                                }
                                else{
                                    tempdic.setValue(SOURCECODE, forKey: "\(objChatDBM.source)")
                                }
                                //print(tempdic)
                                ChatDB.child(self.touid)
                                    .child(self.groupId)
                                    .updateChildValues(tempdic as! [AnyHashable : Any], withCompletionBlock: {
                                        error, snapshot in
                                        if error != nil{
                                            print(error?.localizedDescription as Any)
                                            print("Error in  typing")
                                        }
                                        else{ //ChatDB.child(self.touid).child(self.groupId).updateChildValues(["typing": istyping])
                                            print("is Deliver")
                                        }
                                    })
                            }
                        }
                    }
                }
            })
    }
    
    //MARK:- Run Time Message Delivery Status
    func isSelfdeliver(messageStatus: Int){
        ChatDB.child(fromuid)
            .child(groupId)
            .observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    if snapShot.count > 0{
                        
                        if let lastmessagestatus = (snapshot.value as! NSDictionary).value(forKey: "\(objChatDBM.lastMessageStatus)") as? Int{
                            if lastmessagestatus != SEEN //&& lastmessagestatus != MESSAGE_DELETED
                            {
                                let tempdic = snapshot.value as! NSMutableDictionary
                                //print(tempdic)
                                tempdic.setValue(messageStatus, forKey: "\(objChatDBM.lastMessageStatus)")
                                //print(tempdic)
                                let tempkeyarray = tempdic.allKeys as NSArray
                                if tempkeyarray.contains("\(objChatDBM.source)"){
                                    tempdic.setValue(SOURCECODE, forKey: "\(objChatDBM.source)")
                                }
                                else{
                                    tempdic.setValue(SOURCECODE, forKey: "\(objChatDBM.source)")
                                }
                                ChatDB.child(self.fromuid)
                                    .child(self.groupId)
                                    .updateChildValues(tempdic as! [AnyHashable : Any], withCompletionBlock: {
                                        error, snapshot in
                                        if error != nil{
                                            print(error?.localizedDescription as Any)
                                            print("Error in  typing")
                                        }
                                        else{ //ChatDB.child(self.touid).child(self.groupId).updateChildValues(["typing": istyping])
                                            print("is Deliver")
                                        }
                                    })
                            }
                        }
                    }
                }
            })
    }
    //MARK:- When Chat Screen Open
    func isdeliverWhenMsgScreenOpen(){
        ChatDB.child(fromuid)
            .child(groupId).observeSingleEvent(of: .value, with: { (snapshot) in
                DispatchQueue.main.async{
                    self.funUserActivityStatus()
                }
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    
                    //MARK:- When Chat Screen Run Frist time tells other use that message has been received
                    if self.groupType == PRIVATECHAT{
                        self.isdeliver(messageStatus: SEEN)
                    }
                    if snapShot.count > 0 {
                        if ((snapshot.value as! NSDictionary).value(forKey: "\(objChatDBM.lastMessageStatus)") as? Int) != nil{
                            let tempdic = snapshot.value as! NSMutableDictionary
                            //print(tempdic)
                            tempdic.setValue("0", forKey: "\(objChatDBM.unSeenCount)")
                            //print(tempdic)
                           // let tempkeyarray = tempdic.allKeys as NSArray
                            //                            if tempkeyarray.contains("source")
                            //                            {
                            //                                tempdic.setValue(SOURCECODE, forKey: "source")
                            //                            }
                            //                            else
                            //                            {
                            //                                tempdic.setValue(SOURCECODE, forKey: "source")
                            //                            }
                            ChatDB.child(self.fromuid)
                                .child(self.groupId)
                                .updateChildValues(tempdic as! [AnyHashable : Any], withCompletionBlock: {
                                    error, snapshot in
                                    if error != nil{
                                        print(error?.localizedDescription as Any)
                                        print("Error in  unSeenCount")
                                    }
                                    else{
                                        print("is unSeenCount = 0")
                                    }
                                })
                        }
                        
                    }
                }
            })
    }
    
    //MARK:- Upload image or file to Firebase Storage
    func uploadMedia(type: Int, completion: @escaping (_ url: String?) -> Void) {
        //andicator.startAnimating()
        // let storageRef = Storage.storage().reference().child("UserPictures")
        let timespam = Date().currentTimeMillis()!
        var filename = ""
        var localFileName = "\(String(describing: timespam))"
        if type == IMAGE{
            localFileName = localFileName + ".png"
            filename = "UserMsgPictures/\(localFileName)"
            uploadData = selectedimage.jpegData(compressionQuality: 0.3)!
        }
        else if type == AUDIO{ 
            localFileName = localFileName + "audio.mp4"
            filename = "UserMsgAudio/\("\(localFileName)")"
            uploadData = audioVideoDocumentData
        }
        else if type == VIDEOIMAGE{
            localFileName = localFileName + ".png"
            filename = "UserVideoThumbPictures/\(localFileName)"
        }
        else if type == VIDEO{
            localFileName = localFileName + "video.mp4"
            filename = "UserMsgVideo/\(localFileName)"
            uploadData = audioVideoDocumentData
        }
        else if type == DOCUMENT{
            localFileName = localFileName + "." + selecteFileExtension
            filename = "UserMsgDocument/\(localFileName)"
            uploadData = audioVideoDocumentData
        }
        if (uploadData.count/1024)/1024 > 100{
            //  completion("error")
            obj.showToast(message: "File size cannot be more then 100 MB", viewcontroller: self)
            return
        }
        print(localFileName)
        print(filename)
        // if let uploadData = self.imgvprofile.image?.jpegData(compressionQuality: 0.4) {
        
        if uploadData.isEmpty !=  true{
            let uploadTask = refStorageFireBase
                .child(filename)
                .putData(uploadData, metadata: nil) {
                    (snapshot, error) in
                    self.andicator.stopAnimating()
                    if error != nil {
                        print("error")
                        completion("Error Occured in upload picture")
                    } else {
                        print(snapshot as Any)
                        refStorageFireBase.child(filename)
                            .downloadURL { (url, error) in
                                guard let downloadURL = url else {
                                    completion("Uh-oh, an error occurred! try again.")
                                    return
                                }
                                //MARK:- This try cach is use for move local image/audio/video/documents file to Local Directry
                                
                                obj.funMoveLocalFileToLocalDirectory(fileName: localFileName, downloadURL: downloadURL, fileData: self.uploadData)
                                completion("\(downloadURL)")
                        }
                    }
            }
            
            MEDIAPROGRESS = Float()
            objG.showProgressBar(viewController: self)
            DispatchQueue.main.async{
                if MEDIAPROGRESS == Float(){
                    uploadTask.observe(.progress) { snapshot in
                        print(snapshot.progress!) // NSProgress object
                        MEDIAPROGRESS = Float(snapshot.progress!.fractionCompleted)
                        if snapshot.progress!.fractionCompleted > 0.99{
                            print("Uploading Complete")      // THIS IS WHAT I WANT
                            MEDIAPROGRESS = 1.0
                        }
                        else{
                            print("Not pausable")    // THIS IS MY PROBLEM
                            if MEDIAPROGRESS == 0.0{
                                
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    func funGetMessageCount(receiverid: String, completion: @escaping (_ unSeenCount: Int?) -> Void) {
        var unSeenCount = 0
        if groupId == ""{
            completion(1)
            return
        }
        else if receiverid == fromuid{
            completion(0)
            return
        }
        //ChatDB.keepSynced(true)
        ChatDB.child(receiverid).child(groupId).keepSynced(true)
        ChatDB.child(receiverid).child(groupId)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    if snapShot.count > 0{
                        if let tempunSeenCount = (snapshot.value as! NSDictionary).value(forKey: "\(objChatDBM.unSeenCount)") as? Int{
                            unSeenCount = tempunSeenCount
                        }
                        else if let tempunSeenCount = (snapshot.value as! NSDictionary).value(forKey: "\(objChatDBM.unSeenCount)") as? String{
                            unSeenCount = Int(tempunSeenCount)!
                        }
                    }
                    unSeenCount = unSeenCount + 1
                    completion(unSeenCount)
                }
            })
    }
    
    
    //MARK:- Run Time Message Delivery Status
    @objc func getOtherUserLastOnlineTime(){
        UserDB.child(touid)
            .observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.children.allObjects.count > 5{
                let datadic = snapshot.value as! NSDictionary
                var lasttime = ""
                if let temp = datadic.value(forKey: "\(objUserDBM.onLineUpdatedAt)") as? Int{
                    lasttime = "\(temp)"
                }
                else if let temp = datadic.value(forKey: "\(objUserDBM.onLineUpdatedAt)") as? String{
                    lasttime = temp
                }
                self.otherUserPhoneNumber = "\(datadic.value(forKey: "\(objUserDBM.userName)") as! String)"
                if let tempstatus = datadic.value(forKey: "\(objUserDBM.status)") as? String{
                    self.otherUserStatus = tempstatus
                }
                else{
                    self.otherUserStatus = ""
                }
                
                if let temp = datadic.value(forKey: "\(objUserDBM.fcmId)") as? String{
                    self.receivertokenLocalClass = temp
                }
                if let temp = datadic.value(forKey: "\(objUserDBM.lastSeen)") as? String{
                    if temp == "Nobody"{
                        GLastSeen = temp
                        self.otherUserShowLastSeen = temp
                    }
                }
                if let temp = datadic.value(forKey: "\(objUserDBM.seeAbout)") as? String{
                    if temp == "Nobody"{
                        self.otherUserShowStatus = temp
                    }
                }
                if let temp = datadic.value(forKey: "\(objUserDBM.profilePhotoPrivacy)") as? String{
                    if temp == "Nobody"{
                        self.otherUserShowProfilePic = temp
                    }
                }
                if let temp = datadic.value(forKey: "\(objUserDBM.profilePhoto)") as? String{
                    if temp != ""{
                        //Kingfisher Image upload
                        let url = URL(string: USER_IMAGE_PATH + temp)
                        
                        self.imgv.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                            if (image != nil) {
                                self.imgv.image = image
                            }
                            else {
                                self.imgv.image = UIImage(named: "user")
                            }
                        })
                    }
                }
                if let temp = datadic.value(forKey: "\(objUserDBM.source)") as? String {
                    if temp == SOURCECODE {
                        isAndroidUser = false
                    }
                    else {
                        isAndroidUser = true
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "otherUserProfileUpdate"), object: nil)
                
                self.useridserver = datadic.value(forKey: "\(objUserDBM.userId)") as! String
                
                obj.convertTimespamIntoFullDateTime(timestring: "\(lasttime)", completion:{ isOnline, timestring in
                    
                    //MARK:- Check user status online or offline
                    if isOnline == "1" {
                        self.isonline = isOnline
                    }
                    else {
                        self.lastonlinetime = timestring
                        self.isonline = isOnline
                    }
                    if let temp = datadic.value(forKey:  "\(objUserDBM.onLine)") as? Int{
                        if temp != 1 {
                            self.isonline = "0"
                        }
                    }
                    if GLastSeen == "Nobody" {
                        self.lastonlinetime = ""
                    }
                    
                    self.updateOnline()
                    
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "otherUserOnlineTime"), object: ["isOnline":isOnline, "time": timestring])
                })
            }
            else if snapshot.childrenCount == 0 {
                
            }
        })
    }
    func ObserverUserOnlineOfflineStatus() {
        UserDB.child(touid)
            .observeSingleEvent(of: .value, with: { (snapshot) in
            let datadic = snapshot.value as! NSDictionary
            print(snapshot)
            var lasttime = Int()
            var onLine = Int()
            if let temp = datadic.value(forKey: "\(objUserDBM.onLineUpdatedAt)") as? Int {
                lasttime = temp
            }
            if let temp = snapshot.value(forKey: "\(objUserDBM.onLine)") as? Int {
                onLine = temp
            }
            if onLine == 1 {
                
            }
            obj.convertTimespamIntoFullDateTime(timestring: "\(lasttime)", completion:{ isOnline, timestring in
                
                //MARK:- Check user status online or offline
                if isOnline == "1"{
                    self.isonline = isOnline
                }
                else{
                    self.lastonlinetime = timestring
                    self.isonline = isOnline
                }
                if GLastSeen == "Nobody"{
                    self.lastonlinetime = ""
                }
                self.updateOnline()
                
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "otherUserOnlineTime"), object: ["isOnline":isOnline, "time": timestring])
            })
        })
    }
    
    //MARK:- Run Time Message Delivery Status
    @objc func getUserProfile() {
        UserDB.child(fromuid)
            .observeSingleEvent(of: .value, with: {(snapshot) in
                print(snapshot)
                if snapshot.childrenCount > 0 {
                    let dicdata = (snapshot.value as! NSDictionary)
                    if let temp = dicdata.value(forKey: "\(objUserDBM.lastSeen)") as? String {
                        if temp == "Nobody" {
                            GLastSeen = temp
                        }
                    }
                }
            })
    }
    
    //Groups Messaging Start
    @objc func fetchGroupParticipant() {
        ParticipantsDB.child(groupId)
            .queryOrderedByKey()
            .observe(.value) { (snapshot) in
                if snapshot.childrenCount == 0 {
                    self.bgvButtons.isHidden = true
                    self.txtmsgv.isHidden = true
                    self.bgvButtons.isHidden = true
                    self.lblnotgroupmember.isHidden = false
                    self.arrGroupParticipant = NSArray()
                    self.arrGroupUserRole = NSArray()
                    self.arruserpic = NSMutableArray()
                    self.arrusername = NSMutableArray()
                    self.arruserphone = NSMutableArray()
                    self.arruserFBid = NSMutableArray()
                    self.arrDeviceSource = NSMutableArray()
                    self.arruserFBToken = NSMutableArray()
                    
                    self.view.endEditing(true)
                    return
                }
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    
                    if snapShot.count > 0 {
                        let datadic = (snapshot.value as! NSDictionary)
                        self.arrGroupParticipant = datadic.allKeys as NSArray
                        self.arrGroupUserRole = (datadic.allValues as NSArray).value(forKey: "\(objParticipantsDBM.Role)") as! NSArray
                        
                        //print(self.arrGroupParticipant)
                        //print(self.arrGroupUserRole)
                        if self.arrGroupParticipant.contains(self.fromuid) {
                            self.bgvButtons.isHidden = false
                            self.txtmsgv.isHidden = false
                            self.lblnotgroupmember.isHidden = true
                            self.indexofAdmin = self.arrGroupParticipant.index(of: self.fromuid)
                            self.role = self.arrGroupUserRole[self.indexofAdmin] as! String
                            self.arrGroupChat = ["Group Info", "Clear Chat", "Exit Group"]
                        }else {
                            self.bgvButtons.isHidden = true
                            self.txtmsgv.isHidden = true
                            self.lblnotgroupmember.isHidden = false
                            self.view.endEditing(true)
                            self.arrGroupChat = ["Group Info", "Clear Chat"]
                        }
                        DispatchQueue.main.async{
                            DispatchQueue.main.async{
                                self.fetchUserData()
                            }
                        }
                    }
                }
        }
    }
    //MARK:- Fetch Groups Users Details for profile
    var arruserpic = NSMutableArray()
    var arrusername = NSMutableArray()
    var arruserphone = NSMutableArray()
    var arruserFBid = NSMutableArray()
    var arrDeviceSource = NSMutableArray()
    var arruserFBToken = NSMutableArray()
    func fetchUserData() {
        DispatchQueue.main.async{
            self.arruserpic = NSMutableArray()
            self.arrusername = NSMutableArray()
            self.arruserphone = NSMutableArray()
            self.arruserFBid = NSMutableArray()
            for (index, tempiddd) in self.arrGroupParticipant.enumerated() {
                UserDB.child(tempiddd as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    //UserDB.child(tempiddd as! String).observe(.value, with: { (snapshot) in
                    print(snapshot)
                    self.andicator.stopAnimating()
                    if snapshot.childrenCount > 0 {
                        let datadic = (snapshot.value as! NSDictionary)
                        let allkeys = datadic.allKeys as NSArray
                        if self.arruserphone.contains(datadic.value(forKey: "\(objUserDBM.userName)") as Any){
                            return
                        }
                        else {
                            self.arruserpic.add(datadic.value(forKey: "\(objUserDBM.profilePhoto)") as Any)
                            self.arrusername.add(datadic.value(forKey: "\(objUserDBM.userName)") as Any)
                            self.arruserphone.add(datadic.value(forKey: "\(objUserDBM.phoneNumber)") as Any)
                            self.arruserFBToken.add(datadic.value(forKey: "\(objUserDBM.fcmId)") as Any)
                            self.arruserFBid.add(snapshot.key)
                            
                            if allkeys.contains("\(objUserDBM.source)") {
                                self.arrDeviceSource.add((datadic.value(forKey: "\(objUserDBM.source)") as Any))
                            }
                            else if allkeys.contains("\(objUserDBM.source)") {
                                self.arrDeviceSource.add((datadic.value(forKey: "\(objUserDBM.source)") as Any))
                            }
                            else {
                                self.arrDeviceSource.add("")
                            }
                        }
                    }
                    else {
                        
                    }
                    if index >= self.arrGroupParticipant.count - 1 {
                        if self.arruserFBid.count  > 0 {
                            self.tablev.reloadData()
                            let tempdatadic = ["arrGroupParticipant":self.arrGroupParticipant,
                                               "arrGroupUserRole":self.arrGroupUserRole,
                                               "arruserpic":self.arruserpic,
                                               "arrusername":self.arrusername,
                                               "arruserphone":self.arruserphone,
                                               "arruserFBid":self.arruserFBid]
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "funRefreshGroupProfile"), object: tempdatadic as NSDictionary)
                        }
                    }
                })
            }
        }
    }
    
    //MARK:- Run Time Message Delivery Status
    @objc func fetchGroupDetails() {
        GroupsDB.child(groupId)
            .observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.children.allObjects.count > 0 {
                    let datadic = snapshot.value as! NSDictionary
                    let lasttime = datadic.value(forKey: "\(objGroupsDBM.groupCreatedAt)") as! Int
                    obj.convertTimespamIntoFullDateTime(timestring: "\(lasttime)", completion:{ isOnline, timestring in
                        
                        //MARK:- Check user status online or offline
                        
                        self.lastonlinetime = timestring
                        self.lastonlinetime = self.lastonlinetime.replacingOccurrences(of: "last seen", with: "Created at ")
                        self.updateOnline()
                        
                        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "otherUserOnlineTime"), object: ["isOnline":isOnline, "time": timestring])
                    })
                }
                else if snapshot.childrenCount == 0 {
                    
                }
            })
    }
    
    func funSendMsgInGroup(msgType: Int, receiverid: String, receiverToken: String, isAndroidUserTemp: Bool) {
        var bodymessage = messagetext
        self.messagetext = txtmsgv.text!
        var tempMessageType = Int()
        let timespam = Date().currentTimeMillis()!
        var dicmsg = [String: Any]()
        
        switch (msgType) {
        case (TEXT):
            tempMessageType = TEXT
            dicmsg = [
                "\(objMessageDBM.from)" :"\(self.fromuid)",
                "\(objMessageDBM.message)" :messagetext,
                "\(objMessageDBM.messageStatus)" :NOT_DELIVERED,
                "\(objMessageDBM.messageType)" :TEXT,
                "\(objMessageDBM.userName)" : USERUniqueID,
                "\(objMessageDBM.timeStamp)" : timespam]
            break
        case (CONTACT):
            bodymessage = "Contact Received"
            dicmsg = [
                "\(objMessageDBM.from)" :"\(self.fromuid)",
                "\(objMessageDBM.message)" :messagetext,
                "\(objMessageDBM.messageStatus)" :NOT_DELIVERED,
                "\(objMessageDBM.messageType)" :CONTACT,
                "\(objMessageDBM.userName)" : USERUniqueID,
                "\(objMessageDBM.timeStamp)" : timespam]
            break
            
        case (LOCATION):
            bodymessage = "Location Received"
            tempMessageType = LOCATION
            dicmsg = [
                "\(objMessageDBM.from)" :"\(self.fromuid)",
                "\(objMessageDBM.imageThumb)" :"\(self.currentlat),\(self.currentlong)",
                "\(objMessageDBM.message)" :messagetext,
                "\(objMessageDBM.messageStatus)" :NOT_DELIVERED,
                "\(objMessageDBM.messageType)" :LOCATION,
                "\(objMessageDBM.userName)" :USERUniqueID,
                "\(objMessageDBM.timeStamp)" : timespam]
            break
        default:
            print("dfggf")
        }
        if msgType == TEXT || msgType == LOCATION || msgType == CONTACT {
            MessagesDB.child(self.groupId)
                .child(receiverid)
                .child(self.autocreatedid)
                .setValue(dicmsg, withCompletionBlock: {
                    error, snapshot in
                    print(snapshot)
                    
                    if error != nil {
                        obj.showToast(message: (error?.localizedDescription)!, viewcontroller: self)
                    }
                    else {
                        
                        let parameters :Parameters = ["title":"1 new message",
                                                      "body":self.messagetext,
                                                      "sound":"default",
                                                      //"groupId":self.groupId,
                                                      "groupType":self.groupType,
                                                      "messageId":snapshot.key!,
                                                      "action":"newMessage",
                                                      "messageType":tempMessageType,
                                                      "firebaseId":self.fromuid,
                                                      //"to":receiverid,
                                                      "groupFireBaseId":self.groupId,
                                                      "froma":USERUniqueID,
                                                      "profilePic":defaults.value(forKey: "userimage") as? String ?? "",
                                                      "message":self.messagetext,
                                                      "mutable_content": true,
                                                      "isAndroidUser":isAndroidUserTemp]
                        if receiverid != USERUID {
                            obj.SendPushNotification(toToken: receiverToken, title: "1 new \(tempMessageType) message", body: self.messagetext, data: parameters )
                        }
                        self.txtmsgv.text = ""
                        self.imgvmike.image = UIImage(named: "unholdmike")
                        self.imgvmike.accessibilityIdentifier = "unholdmike"
                        self.funUpdateChatGroupStatusLocal(msgType: msgType, receiverid: receiverid)
                    }
                })
        }
        else {
            switch (msgType) {
            case (IMAGE):
                    tempMessageType = IMAGE
                    bodymessage = "Image Received"
                    dicmsg = [
                        "\(objMessageDBM.from)" :"\(self.fromuid)",
                        "\(objMessageDBM.imageThumb)" :self.objecturl,
                        "\(objMessageDBM.message)" :self.audioDuration,
                        "\(objMessageDBM.messageImagePath)" :self.objecturl,
                        "\(objMessageDBM.messageStatus)" :NOT_DELIVERED,
                        "\(objMessageDBM.messageType)" :IMAGE,
                        "\(objMessageDBM.userName)" : USERUniqueID,
                        "\(objMessageDBM.timeStamp)" : timespam]
                    break
                case AUDIO:
                    tempMessageType = AUDIO
                    bodymessage = "Audio Received"
                    dicmsg = [
                        "\(objMessageDBM.from)" :"\(self.fromuid)",
                        "\(objMessageDBM.message)" :self.audioDuration,
                        "\(objMessageDBM.messageImagePath)" :self.objecturl,
                        "\(objMessageDBM.messageStatus)" :NOT_DELIVERED,
                        "\(objMessageDBM.messageType)" :AUDIO,
                        "\(objMessageDBM.userName)" : USERUniqueID,
                        "\(objMessageDBM.timeStamp)" : timespam]
                    break
                case VIDEO:
                    tempMessageType = VIDEO
                    bodymessage = "Video Received"
                    dicmsg = [
                        "\(objMessageDBM.from)" :"\(self.fromuid)",
                        "\(objMessageDBM.message)" :self.audioDuration,
                        "\(objMessageDBM.imageThumb)" :self.videoimageurl,
                        "\(objMessageDBM.messageImagePath)" :self.videoimageurl,
                        "\(objMessageDBM.messageVideoPath)" :self.objecturl,
                        "\(objMessageDBM.messageStatus)" :NOT_DELIVERED,
                        "\(objMessageDBM.messageType)" :VIDEO,
                        "\(objMessageDBM.userName)" : USERUniqueID,
                        "\(objMessageDBM.timeStamp)" : timespam]
                    break
                case DOCUMENT:
                    bodymessage = "Document Received"
                    tempMessageType = DOCUMENT
                    dicmsg = [
                        "\(objMessageDBM.from)" :"\(self.fromuid)",
                        "\(objMessageDBM.message)" :self.selecteFileName,
                        "\(objMessageDBM.messageImagePath)" :self.objecturl,
                        "\(objMessageDBM.messageStatus)" :NOT_DELIVERED,
                        "\(objMessageDBM.messageType)" :DOCUMENT,
                        "\(objMessageDBM.userName)" : USERUniqueID,
                        "\(objMessageDBM.timeStamp)" : timespam]
                    break
                default:
                    print("dfggf")
                }
                
                MessagesDB.child(self.groupId)
                    .child(receiverid)
                    .child(self.autocreatedid)
                    .setValue(dicmsg, withCompletionBlock: {
                        error, snapshot in
                        print(snapshot)
                        
                        if error != nil {
                            obj.showToast(message: (error?.localizedDescription)!, viewcontroller: self)
                        }
                        else {
                            let parameters :Parameters = ["title":"1 new message",
                                                          "body":bodymessage,
                                                          "sound":"default",
                                                          //"groupId":self.groupId,
                                                          "groupType":self.groupType,
                                                          "messageId":snapshot.key!,
                                                          "action":"newMessage",
                                                          "messageType":tempMessageType,
                                                          "firebaseId":self.fromuid,
                                                          //"to":receiverid,
                                                          "groupFireBaseId":self.groupId,
                                                          "froma":USERUniqueID,
                                                          "profilePic":defaults.value(forKey: "userimage") as? String ?? "",
                                                          "message":self.messagetext,
                                                          "mutable_content": true,
                                                          "isAndroidUser":isAndroidUserTemp]
                            
                            if receiverid != USERUID {
                                obj.SendPushNotification(toToken: receiverToken, title: "1 new \(tempMessageType) message", body: self.messagetext, data: parameters )
                            }
                            self.txtmsgv.text = ""
                            self.imgvmike.image = UIImage(named: "unholdmike")
                            self.imgvmike.accessibilityIdentifier = "unholdmike"
                            self.funUpdateChatGroupStatusLocal(msgType: msgType, receiverid: receiverid)
                        }
                    })
        }
    }
    //MARK:- Group Chat Update
    func funUpdateChatGroupStatusLocal(msgType: Int, receiverid: String) {
        funGetMessageCount(receiverid: receiverid, completion: {
            unSeenCount in
            let timespam = Date().currentTimeMillis()!
            
            let dicChatGroup = [
                "\(objChatDBM.createdAt)" : timespam,
                "\(objChatDBM.groupType)" : PUBLICGROUP,
                "\(objChatDBM.lastMessage)" : self.messagetext,
                "\(objChatDBM.lastMessageStatus)" : NOT_DELIVERED,
                "\(objChatDBM.lastMessageTime)" : timespam,
                "\(objChatDBM.lastMessageType)" : msgType,
                "\(objChatDBM.lastMessageUserId)" : self.fromuid,
                "\(objChatDBM.messageStatus)" : "",
                "\(objChatDBM.lastMessageId)" : self.autocreatedid,
                //"otherUserId" : receiverid,
                "\(objChatDBM.seen)" : false,
                "\(objChatDBM.typing)" : STOP_TYPING_RECORDING,
                "\(objChatDBM.userName)" : USERUniqueID,
                "\(objChatDBM.unSeenCount)" :0,
                "\(objChatDBM.source)" :SOURCECODE] as [String : Any]
            
            ChatDB.child(receiverid).child(self.groupId).updateChildValues(dicChatGroup, withCompletionBlock: {
                error, snapshot in
                if error != nil {
                    print("Error occurd chat not update userid: \(receiverid)")
                }
                else {
                    print("Chat updated userid: \(receiverid)")
                }
            })
        })
    }
    
    var start:(location:CGPoint, time:TimeInterval)?
    let minDistance:CGFloat = 55
    let minSpeed:CGFloat = 1
    let maxSpeed:CGFloat = 6000
    
    var isTextMessage = false
    var isLockRecording = false
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // let aTouch = touches as AnyObject
        
        let touch = touches.first
        if(touch?.view == btnsend){
            print("touch working 1")
            if imgvmike.accessibilityIdentifier == "send" && self.isLockRecording == true{
                return
            }
        }
        else {
            print("touch not match and working")
            return
        }
        eview.dismiss()
        if let touch = touches.first {
            
            if imgvmike.accessibilityIdentifier ==  "holdmike" || imgvmike.accessibilityIdentifier == "unholdmike" {
                if obj.checkMicPermission() {
                    
                }
                else{
                    obj.setPermission(title: "Audio!", message: "Please grant audio permission for using audio service", viewController: self, mediaType: .audio)
                    return
                }
                
                start = (touch.location(in:self.btnsend), touch.timestamp)
                funHoldDown(sender:btnsend)
            }
//            else if imgvmike.accessibilityIdentifier == "send" && isLockRecording == true{
//                if txtmsgv.text!.isEmpty != true
//                {
//                    //andicator.startAnimating()
//                    isTextMessage = true
//                    sendMessage(msgtype: TEXT)
//                }
//
//            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if(touch?.view == btnsend){
            print("touch working 1")
            if imgvmike.accessibilityIdentifier == "send" && isLockRecording == false{
                btnsend(btnsend)
                return
            }
        }
        else {
            print("touch not match and working")
            return
        }
        
        eview.dismiss()
        var swiped = false
        self.isLockRecording = false
        if let touch = touches.first, let startTime = self.start?.time,
            let startLocation = self.start?.location {
            let location = touch.location(in:self.lblslidertocancel)
            let dx = location.x - startLocation.x
            let dy = location.y - startLocation.y
            let distance = sqrt(dx*dx+dy*dy)
            
            // Check if the user's finger moved a minimum distance
            if distance > minDistance {
                let deltaTime = CGFloat(touch.timestamp - startTime)
                let speed = distance / deltaTime
                
                // Check if the speed was consistent with a swipe
                if speed >= minSpeed && speed <= maxSpeed {
                    
                    // Determine the direction of the swipe
                    let x = abs(dx/distance) > 0.4 ? Int(sign(Float(dx))) : 0
                    let y = abs(dy/distance) > 0.4 ? Int(sign(Float(dy))) : 0
                    
                    swiped = true
                    switch (x,y) {
                    case (0,1):
                        print("swiped down")
                    case (0,-1):
                        print("swiped up")
                        self.lockRecording()
                    case (-1,0):
                        print("swiped left")
                        self.finishRecordingCancel()
                        return
                    case (1,0):
                        print("swiped right")
                    case (1,1):
                        print("swiped diag down-right")
                    case (-1,-1):
                        print("swiped diag up-left")
                        self.finishRecordingCancel()
                        return
                    case (-1,1):
                        print("swiped diag down-left")
                    case (1,-1):
                        print("swiped diag up-right")
                        self.lockRecording()
                    default:
                        swiped = false
                        break
                    }
                }
            }
        }
        start = nil
        if imgvmike.accessibilityIdentifier == "holdmike" || imgvmike.accessibilityIdentifier == "unholdmike" {
            if isTextMessage == true{
                isTextMessage = false
            }
            else {
                funholdRelease(sender: btnsend)
            }
        }
        else if imgvmike.accessibilityIdentifier == "send" && self.isLockRecording == false{
            funholdRelease(sender: btnsend)
        }
        
        if !swiped {
            // Process non-swipes (taps, etc.)
            print("not a swipe")
        }
    }
    //MARK:- Exit Group
    var role = ""
    var indexofAdmin = Int()
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
    //MARK:- Send Message in group
    func funSendMsgInGroup(msgText: String, msgType: Int,
                           receiverid: String, autoCreatedId: String,
                           completion: @escaping (_ response: String?) -> Void) {
        let timespam = Date().currentTimeMillis()!
        let fromuid = USERUID
        
        
        MessagesDB.child(groupId).child(receiverid).child(autoCreatedId).setValue([
            "\(objMessageDBM.from)": "\(fromuid)",
            "\(objMessageDBM.message)" :msgText,
            "\(objMessageDBM.messageStatus)": NOT_DELIVERED,
            "\(objMessageDBM.messageType)":msgType,
            "\(objMessageDBM.userName)":USERUniqueID,
            "\(objMessageDBM.timeStamp)": timespam] as [String : Any], withCompletionBlock: {
                error, ref in
                if error != nil
                {
                    // self.isdeliver(messageStatus: SENT)
                    //MARK:- Uncomment the upper line for testing the unSeenCount
                    
                    completion(error?.localizedDescription)
                }
                else
                {
                    funUpdateChatGroupStatus(msgType: msgType, groupid: self.groupId, messagetext: msgText, receiverid: receiverid, msgautoid: autoCreatedId, completion: {
                        response in
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
    func funLeaveGroup(){
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
                        
                        return
                    }
                }
                var tempUid = ""
                if self.arrGroupParticipant[0] as! String == USERUID {
                    if self.arrGroupParticipant.count > 0{
                        //MARK:- Make other user as admin before leave group
                        tempUid = self.arrGroupParticipant[1] as! String
                    }
                    else{
                        //MARK:- If last user want to leave
                        ParticipantsDB.child(self.groupId)
                            .child(USERUID).removeValue()
                       
                        return
                    }
                }
                else{
                    tempUid = self.arrGroupParticipant[0] as! String
                }
                ParticipantsDB.child(self.groupId)
                    .child(tempUid)
                    .updateChildValues(
                        ["\(objParticipantsDBM.Role)" : "admin"],
                        withCompletionBlock: {
                            error, snapshot in
                            if error == nil
                            {
                                //MARK:- Remove Participant
                                ParticipantsDB.child(self.groupId)
                                                .child(USERUID).removeValue()
                            }
                    })
                
            })
    }
    
    
}//MARK:-Class End



//Load image from url
//            let url = URL(string: userimgurlforcallscreen)
//            let request: URLRequest = URLRequest(url: url!)
//            let session = URLSession.shared
//            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
//                let error = error
//                let data = data
//                if error == nil {
//                    // Convert the downloaded data in to a UIImage object
//                    let image = UIImage(data: data!)
//                    // Update the cell
//                    DispatchQueue.main.async{
//                        cell.imgv.image = image
//                    }
//                }
//            })
//            task.resume()


var objMessage: Messagingg?
class TouchMoveButton: UIButton{
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        objMessage?.touchesMoved(touches, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        objMessage?.touchesBegan(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        objMessage?.touchesEnded(touches, with: event)
    }
}





