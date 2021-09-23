 //
 //  VideoCall.swift
 //  TeleMedican
 //
 //  Created by IOS Dev on 09/04/2018.
 //  Copyright © 2018 Paragon Marketing. All rights reserved.
 //
 
 import UIKit
 import AVFoundation
 import Sinch
 
 class VideoCall: UIViewController, SINCallDelegate, SINAudioControllerDelegate, SINClientDelegate {
    func clientDidStart(_ client: SINClient!) {
        
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        
    }
    
    var callitmer = Timer()
    let templabelRemoteUserView = UILabel()
    let templabelLocalUserView = UILabel()
    
    @IBOutlet weak var bgvbuttons: UIView!
    @IBOutlet weak var vlocaluser: UIView!
    @IBOutlet weak var vremoteuser: UIView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblinitializer: UILabel!
    @IBOutlet weak var lbltimer: UILabel!
    
    @IBOutlet weak var btnendcall: UIButton!
    @IBOutlet weak var imgvLocalUserVideoBlur: UIImageView!
    @IBOutlet weak var imgvVideoBlur: UIImageView!
    @IBOutlet weak var lblVideoBlur: UILabel!
    @IBAction func btnendcall(_ sender: Any) {
        playerCall?.stop()
        sincall?.hangup()
            // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endcall"), object: nil)
    }
    @IBOutlet weak var btnmike: UIButton!
    @IBAction func btnmike(_ sender: Any) {
        if btnmike.tag == 0
        {
            btnmike.tag = 1
            sinAudioController?.mute()
            btnmike.setImage(#imageLiteral(resourceName: "mikeincalloffimg"), for: .normal)
        }
        else
        {
            btnmike.tag = 0
            sinAudioController?.unmute()
            btnmike.setImage(#imageLiteral(resourceName: "mikeincallimg"), for: .normal)
        }
    }
    @IBOutlet weak var btnvideo: UIButton!
    @IBAction func btnvideo(_ sender: Any) {
        if btnvideo.tag == 0
        {
            
            btnvideo.tag = 1
            sincall?.pauseVideo()
            btnvideo.setImage(#imageLiteral(resourceName: "videoincalloffimg"), for: .normal)
            obj.setBlurView(view: vlocaluser)
            imgvLocalUserVideoBlur.isHidden = false
        }
        else
        {
            imgvLocalUserVideoBlur.isHidden = true
            btnvideo.tag = 0
            sincall?.resumeVideo()
            btnvideo.setImage(#imageLiteral(resourceName: "videoincallimg"), for: .normal)
            obj.removeBlurView(view: vlocaluser)
        }
    }
    @IBOutlet weak var btnspeaker: UIButton!
    @IBAction func btnspeaker(_ sender: Any) {
        
        if btnspeaker.tag == 0
        {
            btnspeaker.tag = 1
            if isOutGoing == 0
            {
                sinAudioController?.enableSpeaker()
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
            if isOutGoing == 1
            {
                sinAudioController?.disableSpeaker()
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
    
    var session: AVCaptureSession?
    var input: AVCaptureDeviceInput?
    var output: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    @IBOutlet weak var btncamera: UIButton!
    @IBAction func btncamera(_ sender: Any) {
        
        if btncamera.tag == 0
        {
            btncamera.tag = 1
            sinVideoController?.captureDevicePosition = .back
        }
        else
        {
            btncamera.tag = 0
            sinVideoController?.captureDevicePosition = .front
        }
        //MARK:- Manual Front and backvideo handle
        //        if btncamera.tag == 0
        //        {
        //            btncamera.tag = 1
        //            let cameraback = getDevice(position: .back)
        //            do {
        //                input = try AVCaptureDeviceInput(device: cameraback!)
        //
        //            } catch let error as NSError {
        //                print(error)
        //                input = nil
        //            }
        //        }
        //        else
        //        {
        //
        //            let camerafront = getDevice(position: .front)
        //            do {
        //                input = try AVCaptureDeviceInput(device: camerafront!)
        //
        //            } catch let error as NSError {
        //                print(error)
        //                input = nil
        //            }
        //        }
        //Initialize session an output variables this is necessary
        //        session = AVCaptureSession()
        //        output = AVCaptureStillImageOutput()
        //        if(session?.canAddInput(input!) == true){
        //            session?.addInput(input!)
        //            output?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        //            if(session?.canAddOutput(output!) == true){
        //                session?.addOutput(output!)
        //                previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        //                previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //                previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        //                previewLayer?.frame = vlocaluser.bounds
        //                vlocaluser.layer.addSublayer(previewLayer!)
        //                session?.startRunning()
        //            }
        //        }
    }
    
    //Get the device (Front or Back)
    func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices: NSArray = AVCaptureDevice.devices() as NSArray;
        for de in devices {
            let deviceConverted = de as! AVCaptureDevice
            if(deviceConverted.position == position){
                return deviceConverted
            }
        }
        return nil
    }
    override func viewWillDisappear(_ animated: Bool) {
        callitmer.invalidate()
        UIApplication.shared.isStatusBarHidden = false
        
        DispatchQueue.main.async {
            NotificationCenter.default.removeObserver(self, name: UIDevice.proximityStateDidChangeNotification, object: nil)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        btnspeaker.tag = 1
        sinAudioController?.enableSpeaker()
        DispatchQueue.main.async {
            let device = UIDevice.current
            device.isProximityMonitoringEnabled = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = true
        if isOutGoing == 0{
            let tempobject = AnswerCall()
            tempobject.funSetIncommingData(completion: {image in
                self.lblname.text = callUser_Name
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if obj.checkMicPermission(){
            
        }
        else{
            obj.setPermission(title: "Camera!", message: "Please grant Camera permission for using video service", viewController: self, mediaType: .video)
            return
        }
        self.view.backgroundColor = appclr
        activateProximitySensor()
        // Do any additional setup after loading the view.
        callitmer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(self.funCallTimer), userInfo: nil, repeats: true)
        
        btnendcall.frame.size.height = btnendcall.frame.size.width
        btnmike.frame.size.height = btnmike.frame.size.width
        btnspeaker.frame.size.height = btnspeaker.frame.size.width
        btnvideo.frame.size.height = btnvideo.frame.size.width
        
        //MARK:- Sinch Call Delegates
        sincall?.delegate = self
        sinclientG?.delegate = self
        sinVideoController = (UIApplication.shared.delegate as? AppDelegate)?.client!.videoController()
        sinAudioController = (UIApplication.shared.delegate as? AppDelegate)?.client!.audioController()
        sinAudioController?.delegate = self
        
        vremoteuser.frame = self.view.bounds
        vremoteuser.contentMode = .scaleAspectFill
        vlocaluser.contentMode = .scaleAspectFill
        
        playerCall?.stop()
        if isOutGoing == 0
        {
            sincall?.answer()
        }
        //Username
        //        if let tempusername = sincall?.remoteUserId
        //        {
        //            lblname.text = tempusername
        //        }
        //        else
        //        {
        //            lblname.text = "Unknown"
        ////        }
        //        if isOutGoing == 1
        //        {
        //
        //        }
        lblname.text = callUser_Name
        //        lblname.text = tempdocnameforcallscreen
        //        lblinitializer.text = tempdoclanguagesforcallscreen
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    ///////////
    //MARK:- Show video in viewcontroller
    func callDidAddVideoTrack(_ call: SINCall!) {
        //MARK:- Change remote user full screen
        sinVideoController?.remoteView().contentMode = .scaleAspectFill
        //MARK:- Add local video and remove video in views
        DispatchQueue.main.async {
            self.vremoteuser.addSubview((sinVideoController?.remoteView())!)
            self.vlocaluser.addSubview((sinVideoController?.localView())!)
            
        }
    }
    
    //When Call end from other party
    func callDidEnd(_ call: SINCall!) {
        // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endcall"), object: nil)
        
        SinCallDataDic = [String: AnyObject]()
    }
    
    func callDidEstablish(_ call: SINCall!) {
        sincall = call
        var callType = 0
        if isOutGoing == 1{
            let temparr = callUser_Receiver_id.split(separator: "_")
            callType = VIDEO_CALL
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
   
    
    func callDidPauseVideoTrack(_ call: SINCall!) {
        obj.setBlurView(view: vremoteuser)
       
        lblVideoBlur.text = callUser_Name + "'s camera off"
        lblVideoBlur.isHidden = false
        imgvVideoBlur.isHidden = false
    }
    func callDidResumeVideoTrack(_ call: SINCall!) {
        lblVideoBlur.isHidden = true
        imgvVideoBlur.isHidden = true
        obj.removeBlurView(view: vremoteuser)
    }
    
    func audioControllerMuted(_ audioController: SINAudioController!) {
        
    }
    func audioControllerUnmuted(_ audioController: SINAudioController!) {
        
    }
    
    func audioControllerSpeakerEnabled(_ audioController: SINAudioController!) {
        
    }
    func audioControllerSpeakerDisabled(_ audioController: SINAudioController!) {
        
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
