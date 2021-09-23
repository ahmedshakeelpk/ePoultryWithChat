//
//  AudioCall.swift
//  TeleMedican
//
//  Created by IOS Dev on 09/04/2018.
//  Copyright © 2018 Paragon Marketing. All rights reserved.
//

import UIKit
import Sinch

class AudioCall: UIViewController, SINCallDelegate, SINAudioControllerDelegate, SINClientDelegate, CAAnimationDelegate  {
    
    
    var callitmer = Timer()
    var username = String()
    
    @IBOutlet weak var imgvcenter: UIImageView!
    @IBOutlet weak var lblinitializer: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var imgvbg: UIImageView!
    @IBOutlet weak var bgvbuttons: UIView!
    @IBOutlet weak var btnmike: UIButton!
    @IBAction func btnmike(_ sender: Any) {
        if btnmike.tag == 0
        {
            btnmike.tag = 1
            sinAudioController?.unmute()
            btnmike.setImage(#imageLiteral(resourceName: "mikeincallimg"), for: .normal)
        }
        else
        {
            btnmike.tag = 0
            sinAudioController?.mute()
            btnmike.setImage(#imageLiteral(resourceName: "mikeincalloffimg"), for: .normal)
        }
    }
    @IBOutlet weak var btnendcall: UIButton!
    @IBAction func btnendcall(_ sender: Any) {
        playerCall?.stop()
        sincall?.hangup()
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endcall"), object: nil)
    }
    @IBOutlet weak var btnspeaker: UIButton!
    @IBAction func btnspeaker(_ sender: Any) {
        if btnspeaker.tag == 0
        {
            sinAudioController?.enableSpeaker()
            btnspeaker.tag = 1
            if isOutGoing == 0
            {
                
            }
            else
            {
                DispatchQueue.main.async {
                    self.setAudioOutputSpeaker(enabled: true)
                }
            }
            btnspeaker.setImage(UIImage.init(named: "speakerincallimg"), for: .normal)
        }
        else
        {
            btnspeaker.tag = 0
            sinAudioController?.disableSpeaker()
            if isOutGoing == 1
            {
                
            }
            else
            {
                DispatchQueue.main.async {
                    self.setAudioOutputSpeaker(enabled: false)
                }
            }
            
            btnspeaker.setImage(UIImage.init(named: "speakerincalloffimg"), for: .normal)
        }
    }
    @IBOutlet weak var lbltimer: UILabel!
    
    override func viewWillDisappear(_ animated: Bool) {
        callitmer.invalidate()
        DispatchQueue.main.async {
            NotificationCenter.default.removeObserver(self, name: UIDevice.proximityStateDidChangeNotification, object: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if isOutGoing == 0{
            let tempobject = AnswerCall()
            tempobject.funSetIncommingData(completion: {image in
                self.imgvcenter.image = call_ReceiverImage
                self.lblname.text = callUser_Name
            })
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            let device = UIDevice.current
            device.isProximityMonitoringEnabled = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if obj.checkMicPermission(){
            
        }
        else{
            obj.setPermission(title: "Microphone!", message: "Please grant Microphone Permission for using audio service", viewController: self, mediaType: .audio)
            return
        }
        self.view.backgroundColor = appclr
        btnmike.tag = 1
        activateProximitySensor()
        // Do any additional setup after loading the view.
        //Ripple Effect Show in image
        //        ripple = MTRipple.init(frame:CGRect(x: 0.0, y: 0.0, width: self.imgvcenter.frame.size.width, height: self.imgvcenter.frame.size.height)).startViewAniamtion(animationTime: 6.0, animateView: self.imgvcenter) as! MTRipple
        imgvcenter.layer.cornerRadius = imgvcenter.frame.size.height / 2
        callitmer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(self.funCallTimer), userInfo: nil, repeats: true)
        
        
        let animation = CATransition()
        animation.delegate = self
        animation.duration = 5.0
        animation.timingFunction = CAMediaTimingFunction(name : CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType(rawValue: "rippleEffect")
        imgvcenter.layer.add(animation, forKey: nil)
        
        btnspeaker.setImage(UIImage.init(named: "speakerincalloffimg"), for: .normal)
        btnendcall.frame.size.height = btnendcall.frame.size.width
        btnmike.frame.size.height = btnmike.frame.size.width
        btnspeaker.frame.size.height = btnspeaker.frame.size.width
        imgvcenter.frame.size.height = imgvcenter.frame.size.width
        
        //MARK:- Sinch Call Delegates
        sincall?.delegate = self
        sinclientG?.delegate = self
        sinVideoController = (UIApplication.shared.delegate as? AppDelegate)?.client!.videoController()
        sinAudioController = (UIApplication.shared.delegate as? AppDelegate)?.client!.audioController()
        sinAudioController?.delegate = self
        
        playerCall?.stop()
        sincall?.answer()
        
        //Username
        //        if let tempusername = sincall?.remoteUserId
        //        {
        //            lblname.text = tempusername
        //        }
        //        else
        //        {
        //            lblname.text = "Unknown"
        //        }
        
        lblname.text = callUser_Name
        imgvcenter.image = call_ReceiverImage
        //        if isOutGoing == 1
        //        {
        //
        //
        //        }
        //        else
        //        {
        //
        //        }
        //        lblname.text = tempdocnameforcallscreen
        //        lblinitializer.text = tempdoclanguagesforcallscreen
        
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
        DispatchQueue.main.async {
            self.setAudioOutputSpeaker(enabled: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:- Manual Speaker Enagle and Disable
    func setAudioOutputSpeaker(enabled: Bool)
    {
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
    
    //    AVAudioSession *session =   [AVAudioSession sharedInstance];
    //     *error;
    //    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    //    [session setMode:AVAudioSessionModeVoiceChat error:&error];
    //    if (enabled) // Enable speaker
    //    {
    //    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    //    }
    //    else // Disable speaker
    //    {
    //    [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&error];
    //    }
    //    [session setActive:YES error:&error];
    //
    
    // MARK: - Sinch Delegates
    func callDidEnd(_ call: SINCall!) {
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endcall"), object: nil)
        SinCallDataDic = [String: AnyObject]()
    }
    
    
    func callDidEstablish(_ call: SINCall!) {
        
        sincall = call
        sinAudioController?.disableSpeaker()
        var callType = 0
        if isOutGoing == 1{
            
            let temparr = callUser_Receiver_id.split(separator: "_")
            callType = AUDIO_CALL
            SinCallDataDic["current_username"] = SinCallDataDic["phoneNumber"]
            SinCallDataDic["current_profile"] = SinCallDataDic["user_profile"]
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
    
    func callDidProgress(_ call: SINCall!) {
        
    }
    
    // MARK: - Sinch Out Going Call
    func clientDidStart(_ client: SINClient!) {
        
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        
    }
    
    //MARK: - Fun call timer
    var countercalltime = 0
    @objc func funCallTimer()
    {
        countercalltime = countercalltime + 1
        //Human Language timer calling
        funhmsFrom(seconds: countercalltime) { hours, minutes, seconds in
            //let hours = self.getStringFrom(seconds: hours)
            let minutes = self.getStringFrom(seconds: minutes)
            let seconds = self.getStringFrom(seconds: seconds)
            
            self.lbltimer.text = "\(minutes):\(seconds)"
            //print("\(hours):\(minutes):\(seconds)")
        }
    }
    
    /////////////////////////////////////Call Timer//////////
    //MARK:- Timer show in human language 00:01:23 etc like this
    func funhmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    //MARK:- Timer show in human language 00:01:23 etc like this
    func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }//End Human language timer
    
    
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
