//
//  AnswerCall.swift
//  ZedChat
//
//  Created by Paragon Marketing on 06/01/2018.
//  Copyright © 2018 Paragon Marketing. All rights reserved.
//

import UIKit
import Sinch
import Alamofire

var isOutGoing = 0
var isAudio = 0

var callUser_Receiver_id = String()
var callGroup_Id = String()
var callCaller_Id = String()
//MARK:- For Call Screens


var callUser_Name = String()
var callUser_FBID = String()
var callUser_FBID_Receiver = String()
var callUser_image_Sender = String()
var callUser_PhoneNumber = String()
var callUser_Picture = String()
var callUser_PhoneNumber_Receiver = String()
var call_ReceiverImage = UIImage()
var call_ReceiverFBToken = String()
var call_ReceiverUser_id = String()
public var callUser_PhoneNumberIncomming = String()


class AnswerCall: UIViewController, SINCallDelegate, SINAudioControllerDelegate, SINClientDelegate, CAAnimationDelegate{
    
    
    
    
    
    
    @IBOutlet weak var rippleview: UIView!
    
    @IBOutlet var animateView: UIView!
    
    @IBOutlet weak var imgvcallingGif: UIImageView!
    @IBOutlet weak var lblcalltype: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var bgvbtns: UIView!
    @IBOutlet weak var btnaccept: UIButton!
    @IBOutlet weak var btnreject: UIButton!
    @IBOutlet weak var imgvcenter: UIImageView!
    @IBOutlet weak var bgvoutgoingcall: UIView!
    
    var isCallScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Ripple Effect Show in image
        //Remeaning
        self.view.backgroundColor = appclr
        
        if isCallScreen{
            
        }
        self.navigationController?.navigationBar.isHidden = true
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(funEndcall), name: NSNotification.Name(rawValue: "endcall"), object: nil)
        DispatchQueue.main.async{
            self.imgvcenter.layer.cornerRadius = self.imgvcenter.frame.size.height / 2
        }
        btnendcall.frame.size.height = btnendcall.frame.size.width
        btnaccept.frame.size.height = btnaccept.frame.size.width
        btnreject.frame.size.height = btnreject.frame.size.width
        imgvcenter.frame.size.height = imgvcenter.frame.size.width
        
        sinVideoController = (UIApplication.shared.delegate as? AppDelegate)?.client!.videoController()
        sinAudioController = (UIApplication.shared.delegate as? AppDelegate)?.client!.audioController()
        
        sincall?.delegate = self
        (UIApplication.shared.delegate as? AppDelegate)?.client!.delegate = self
        sinAudioController?.delegate = self
        //MARK:- Use Gif in imgview
        imgvcallingGif.loadGif(name: "callinggif")
        
        //        if let tempusername = sincall?.remoteUserId
        //        {
        //            lblname.text = tempusername
        //        }
        //        else
        //        {
        //            lblname.text = ""
        //        }
        if isOutGoing == 1
        {
            bgvbtns.isHidden = true
            bgvoutgoingcall.isHidden = false
            funoutgoingcall()
        }
        else
        {
            funincomming()
            bgvbtns.isHidden = false
            bgvoutgoingcall.isHidden = true
        }
        
        //MARK:- Sensor Configration Observer
        activateProximitySensor()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        playerCall?.stop()
        outgoingcalltimer.invalidate()
        imgvcallingGif.stopAnimating()
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = false
    }
    
    func funincomming(){
        //Sound incomming call play
        playSound()
        //        if let datadic = sincall?.headers! as? [String: Any]
        //        {
        if SinCallDataDic.count != 0
        {
            funSetIncommingData(completion: {image in
                self.imgvcenter.image = call_ReceiverImage
            })
            lblname.text = callUser_Name
        }
        // }
        if sincall?.details.isVideoOffered == true
        {
            self.lblcalltype.text = "Incoming Video Call"
            if obj.checkMicPermission(){
                
            }
            else{
                obj.setPermission(title: "Camera!", message: "Please grant Camera permission for using video service", viewController: self, mediaType: .video)
                return
            }
        }
        else
        {
            self.lblcalltype.text = "Incoming Audio Call"
            if obj.checkMicPermission(){
                
            }
            else{
                obj.setPermission(title: "Microphone!", message: "Please grant Microphone Permission for using audio service", viewController: self, mediaType: .audio)
                return
            }
        }
    }
    
    func funSetIncommingData(completion: @escaping (_ image: UIImage?) -> Void) {
        let datadic = SinCallDataDic
        callUser_PhoneNumber = (datadic["current_username"] as? String)!
        callGroup_Id = (datadic["firebase_group_id"] as? String)!
        callUser_image_Sender = (datadic["user_profile"] as? String)!
        callUser_FBID_Receiver = (datadic["current_fireBase_user_id"] as? String)!
        callUser_PhoneNumber_Receiver = (datadic["phoneNumber"] as? String)!
        callUser_FBID = (datadic["fireBaseUserId"] as? String)!
        callUser_Picture = (datadic["current_profile"] as? String)!
        
        callUser_Name = obj.getContactNameFromNumber(contactNumber:callUser_PhoneNumber)
        
        //Load image from url
        if callUser_Picture != ""
        {
            let tempimageview = UIImageView()
            //Kingfisher Image upload
            let url = URL(string: USER_IMAGE_PATH + callUser_Picture)
            tempimageview.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    call_ReceiverImage = value.image
                    DispatchQueue.main.async {
                        completion(UIImage())
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                    call_ReceiverImage = UIImage(named: "user")!
                    DispatchQueue.main.async {
                        completion(UIImage())
                    }
                }
            }
        }
        else
        {
            call_ReceiverImage = UIImage(named: "user")!
            DispatchQueue.main.async {
                completion(UIImage())
            }
        }
    }
    
    var outgoingcalltimer = Timer()
    func funoutgoingcall()
    {
        imgvcenter.image = call_ReceiverImage
        callUser_Name = obj.getContactNameFromNumber(contactNumber:callUser_PhoneNumber_Receiver)
        lblname.text = callUser_Name
        
        //Load image from url
        //        let url = URL(string: tempdocimageforcallscreen)
        //        let request: URLRequest = URLRequest(url: url!)
        //        let session = URLSession.shared
        //        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
        //            let error = error
        //            let data = data
        //            if error == nil {
        //                // Convert the downloaded data in to a UIImage object
        //                let image = UIImage(data: data!)
        //                // Update the cell
        //                DispatchQueue.main.async{
        //                    self.imgvcenter.image = image
        //                }
        //            }
        //        })
        //        task.resume()
        
        outgoingcalltimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(playSoundOutGoing), userInfo: nil, repeats: true)
        
        
        let callid = callUser_PhoneNumber+"_"+(defaults.value(forKey: "userid") as! String)
        let parametersdic = [
            "id":defaults.value(forKey: "userid") as! String,
            "user_id":callid,
            "identifier":callUser_PhoneNumber,
            "current_profile": defaults.value(forKey: "userimage") as! String,
            "user_profile": callUser_image_Sender,
            "phoneNumber": callUser_PhoneNumber_Receiver,
            "current_username": defaults.value(forKey: "phoneno") as! String,
            "current_fireBase_user_id": callUser_FBID,
            "fireBaseUserId": callUser_FBID_Receiver,
            "firebase_group_id": callGroup_Id,
            "action":"audioservice",
            "froma":callUser_PhoneNumber,
            "profilePic":callUser_image_Sender,
            "message":"startservices",
            ] as [String : AnyObject]
        
        SinCallDataDic = parametersdic
        
        let ownUser_id = defaults.value(forKey: "userid") as! String
        
        let parCalldic = ["id":defaults.value(forKey: "userid") as! String,
                          "user_id":callid,
                          "identifier":callUser_PhoneNumber,
                          "current_profile": defaults.value(forKey: "userimage") as! String,
                          "user_profile": callUser_image_Sender,
                          "phoneNumber": callUser_PhoneNumber_Receiver,
                          "current_username": defaults.value(forKey: "phoneno") as! String,
                          "current_fireBase_user_id": callUser_FBID,
                          "fireBaseUserId": callUser_FBID_Receiver,
                          "firebase_group_id": callGroup_Id,
                          "action":"audioservice",
                          "froma":callUser_PhoneNumber,
                          "profilePic":callUser_image_Sender,
                          "message":"startservices",
            ] as [String : AnyObject]
        
        //sincall?.delegate = self
        if isAudio == 1
        {
            obj.SendPushNotification(toToken: call_ReceiverFBToken, title: "audioservice", body: "sChat Audio Call", data: parametersdic)
            self.lblcalltype.text = "Audio Calling ..."
            //let call = sinclientG?.call().callUser(withId: callmsguser)
            (UIApplication.shared.delegate as? AppDelegate)?.client!.delegate = self
            // let call = (UIApplication.shared.delegate as? AppDelegate)?.client!.call().callUser(withId: "77", headers: parametersdic)
            
            //let calll = sinchClient()?.call()?.callUser(withId: "77")
            
            DispatchQueue.main.async {
                let call = self.sinchClient()?.call()?.callUser(withId: callUser_Receiver_id, headers: parametersdic)
                sincall = call
                
                sincall?.delegate = self
                //  self.setAudioOutputSpeaker(enabled: false)
                sinAudioController?.disableSpeaker()
            }
        }
        else if isAudio == 0
        {
            obj.SendPushNotification(toToken: call_ReceiverFBToken, title: "vidioservice", body: "sChat Audio Call", data: parametersdic)
            self.lblcalltype.text = "Video Calling ..."
            //MARK:- If call to user and donot want to send any extra parameters
            //let call = sinclientG?.call().callUserVideo(withId: callmsguser)
            //MARK:- If call to user and want to send parameters
            DispatchQueue.main.async {
                let call = (UIApplication.shared.delegate as? AppDelegate)?.client!.call().callUserVideo(withId: callUser_Receiver_id, headers: parametersdic)
                sincall = call
                sincall?.delegate = self
            }
        }
        //        let parameters : Parameters =
        //            ["pushPayload": call,
        //             "pushData":parametersdic]
        //        print (parameters)
        //        obj.webService2(url: "clientapi.sinch.com", parameters: parameters, completionHandler:{ responseObject, error, responseObject2nd  in
        //
        //            if error == nil
        //            {
        //
        //            }
        //        })
        
        
        //        sinVideoController = sinclientG?.videoController()
        //        sinAudioController = sinclientG?.audioController()
    }
    func sinchClient() -> SINClient? {
        return (UIApplication.shared.delegate as? AppDelegate)?.client
    }
    func callClient(userid: String, header: [String : AnyObject]) -> SINCallClient? {
        return self.sinchClient()?.call()
        //  return sinchClient()?.call()?.callUser(withId: "70") as? SINCallClient
        // return sinchClient()!.call().callUser(withId: "70", headers: nil) as? SINCallClient
    }
    @IBOutlet weak var btnendcall: UIButton!
    @IBAction func btnendcall(_ sender: Any) {
        //MARK:- For Out Going call
        DispatchQueue.main.async {
            self.funEndcall()
            self.funEndCallWithButtonSaveCDBase()
        }
        
    }
    @objc func funEndcall()
    {
        outgoingcalltimer.invalidate()
        playerCall?.stop()
        sincall?.hangup()
        funBack()
        if isCallScreen{
            
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("callendnotficication"), object: nil, userInfo: nil)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                self.navigationController?.navigationBar.isHidden = false
            })
        }
    }
    func funBack()
    {
        if isOutGoing == 1
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
           // self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func btnaccept(_ sender: Any) {
        outgoingcalltimer.invalidate()
        playerCall?.stop()
        if sincall?.details.isVideoOffered == true
        {
            //MARK:- Video Call
            let vc = UIStoryboard.init(name: "Calling", bundle: nil).instantiateViewController(withIdentifier: "VideoCall") as! VideoCall
            isAudio = 0
            isOutGoing = 0
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
                //self.present(vc, animated: true, completion: nil)
            }
        }
        else
        {
            //MARK:- Audio Call
            let vc = UIStoryboard.init(name: "Calling", bundle: nil).instantiateViewController(withIdentifier: "AudioCall") as! AudioCall
            isAudio = 1
            isOutGoing = 0
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
                //self.present(vc, animated: true, completion: nil)
            }
        }
        print(SinCallDataDic)
    }
    @IBAction func btnreject(_ sender: Any) {
        DispatchQueue.main.async {
            self.funEndcall()
            self.funEndCallWithButtonSaveCDBase()
        }
    }
    
    func funEndCallWithButtonSaveCDBase(){
        if SinCallDataDic.count == 0 {
            return
        }
        var callType = 0
        if isOutGoing == 1{
            
            let temparr = callUser_Receiver_id.split(separator: "_")
            callType = AUDIO_CALL
            SinCallDataDic["current_username"] = callUser_PhoneNumber_Receiver as AnyObject
            if isCallScreen{
                SinCallDataDic["current_profile"] = callUser_Picture as AnyObject
            }
            else{
                SinCallDataDic["current_profile"] = callUser_image_Sender as AnyObject
            }
            SinCallDataDic["id"] = temparr[1] as AnyObject
        }else{
            callType = INCOMING_AUDIO
        }
        objCDB.updateCallRecord(datadic: SinCallDataDic as [String : Any], call_type: callType, completion: {
            success in
            
            if success!{
                print("Outgoing call save")
            }
            else{
                print("Outgoing call not save")
            }
        })
    }
    func playSound() {
        guard let url = Bundle.main.url(forResource: "incomming", withExtension: ".mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            playerCall = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let playerCall = playerCall else { return }
            playerCall.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func playSoundOutGoing() {
        guard let url = Bundle.main.url(forResource: "outgoing", withExtension: ".wav") else { return }
        
        do {
            
            if playerCall?.isPlaying == true{
                playerCall?.stop()
            }
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            playerCall = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let playerCall = playerCall else { return }
            playerCall.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Sinch Delegates
    func callDidEnd(_ call: SINCall!) {
        playerCall?.stop()
        outgoingcalltimer.invalidate()
        //self.dismiss(animated: true, completion: nil)
        funBack()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endcall"), object: nil)
    }
    
    // MARK: - Sinch Out Going Call
    func clientDidStart(_ client: SINClient!) {
        
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        // print(error)
        //self.dismiss(animated: true, completion: nil)
        funBack()
    }
    
    //MARK : - For out going call its necessary
    func call(_ call: SINCall!, shouldSendPushNotifications pushPairs: [Any]!) {
        sincall = call
        sincall?.delegate = self
        
        let sinpushpair = pushPairs.last
        let parameters : Parameters =
            ["pushPayload": sinpushpair as Any,
             "pushData":sinpushpair!]
        print (parameters)
        obj.webService2(url: RECTIFYUSER, parameters: parameters, completionHandler:{ responseObject, error, responseObject2nd  in
            
            
            if error == nil
            {
                
            }
        })
    }
    //
    
    
    @objc func funSendPush()
    {
        
    }
    func observe<Value>(_ keyPath: KeyPath<AnswerCall, Value>, options: NSKeyValueObservingOptions, changeHandler: @escaping (AnswerCall, NSKeyValueObservedChange<Value>) -> Void) -> NSKeyValueObservation {
        
        return NSKeyValueObservation.value(forKey: "AnswerCall") as! NSKeyValueObservation
    }
    
    func client(_ client: SINClient!, requiresRegistrationCredentials registrationCallback: SINClientRegistration!) {
        
    }
    
    func callDidProgress(_ call: SINCall!) {
        sincall = call
        sincall?.delegate = self
        self.lblcalltype.text = "Ringing ..."
        if isAudio == 1
        {
            DispatchQueue.main.async {
                self.setAudioOutputSpeaker(enabled: false)
            }
        }
    }
    
    func callDidEstablish(_ call: SINCall!) {
        sincall = call
        playerCall?.stop()
        outgoingcalltimer.invalidate()
        DispatchQueue.main.async {
            if sincall?.details.isVideoOffered == false
            {
                //MARK:- Audio Call
                let vc = UIStoryboard.init(name: "Calling", bundle: nil).instantiateViewController(withIdentifier: "AudioCall") as! AudioCall
                isAudio = 0
                DispatchQueue.main.async {
                    //self.present(vc!, animated: true, completion: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if sincall?.details.isVideoOffered == true
            {
                //MARK:- Video Call
                let vc = UIStoryboard.init(name: "Calling", bundle: nil).instantiateViewController(withIdentifier: "VideoCall") as! VideoCall
                DispatchQueue.main.async {
                    //self.present(vc!, animated: true, completion: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        //        sinVideoController = sinclientG?.videoController()
        //        sinAudioController = sinclientG?.audioController()
    }
    
    func callDidResumeVideoTrack(_ call: SINCall!) {
        
    }
    func callDidAddVideoTrack(_ call: SINCall!) {
        
    }
    func callDidPauseVideoTrack(_ call: SINCall!) {
        
    }
    
    func willChangeValue<Value>(for keyPath: KeyPath<AnswerCall, Value>) {
        
    }
    
    //MARK:- Manual Speaker Enagle and Disable
    func setAudioOutputSpeaker(enabled: Bool)
    { //MARK:- Enable Speaker
        
        let session = AVAudioSession.sharedInstance()
        var _: Error?
        try? session.setCategory(AVAudioSession.Category.playAndRecord)
        try? session.setMode(AVAudioSession.Mode.voiceChat)
        if enabled {
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } else {
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
        }
        try? session.setActive(true)
    }
    //MARK:- Sensor deduct when hide and show the screen when call
    func activateProximitySensor() {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged(notification:)), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
        }
    }
    
    @objc func proximityChanged(notification: NSNotification) {
        if let device = notification.object as? UIDevice {
            print("\(device) detected!")
        }
    }
    
    
}
