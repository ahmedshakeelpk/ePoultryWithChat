//
//  UserProfile.swift
//  ZedChat
//
//  Created by MacBook Pro on 18/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UserProfile: UIViewController {

    var userphone = ""
    var userstatus = ""
    var userimage = UIImage()
    var username = ""
    var useruid = ""
    var userdata = NSMutableArray()
    
    var otherUserPhoneNumber = ""
    var otherUserStatus = ""
    var otherUserShowStatus = ""
    @IBOutlet weak var btnprofilepic: UIButton!
    @IBAction func btnprofilepic(_ sender: Any) {
        if imgvprofile.image != nil{
            self.funShowProfilePic()
        }
    }
    @IBOutlet weak var scrollv: UIScrollView!
    @IBOutlet weak var contentv: UIView!
    @IBOutlet weak var bgvtop: UIView!
    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var bgvnotification: UIView!
    @IBOutlet weak var lblnumberstatus: UILabel!
    @IBOutlet weak var lblnotification: UILabel!
    @IBOutlet weak var switchnotification: UISwitch!
    
    @IBAction func switchnotification(_ sender: Any) {
    }
    
    @IBOutlet weak var bgvstatus: UIView!
    @IBOutlet weak var lblnumber: UILabel!
    @IBOutlet weak var lblstatus: UILabel!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        obj.showNavBar(viewcontroller: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        funSetUserData()
        let backBtn = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funback))
        self.navigationItem.leftBarButtonItem = backBtn
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("otherUserProfileUpdate"), object: nil, queue: nil, using: { note in
                //
            })
        }
        self.getUserProfile()
    }
    
    func funSetUserData(){
        self.title = username
        lblstatus.lineBreakMode = .byWordWrapping
        lblstatus.numberOfLines = 0
        lblname.text = username
        lblnumber.text = userphone
        if userstatus != ""
        {
            lblstatus.text = userstatus
        }
        //
        self.bgvstatus.autoresizesSubviews = false
        
        bgvtop.backgroundColor = appclrProfileBG
        imgvprofile.image = userimage
        if userimage.accessibilityIdentifier == "user"{
            imgvprofile.contentMode = .scaleAspectFit
            imgvprofile.image = UIImage(named: "userpng")
        }
        setScrollView()
    }
    @objc func funback()
    {
        NotificationCenter.default.removeObserver(self)
        obj.hideNavBar(viewcontroller: self)
        navigationController?.popViewController(animated: true)
    }

    func setScrollView(){
        DispatchQueue.main.async {
            self.lblstatus.sizeToFit()
            DispatchQueue.main.async {
                self.bgvstatus.frame.size.height = self.lblstatus.frame.maxY + 20
                //  self.bgvstatus.backgroundColor = .red
                if IPAD
                {
                    self.contentv.frame.size.height = self.bgvstatus.frame.maxY + 60
                }
                else
                {
                    self.contentv.frame.size.height = self.bgvstatus.frame.maxY + 30
                }
                // self.contentv.backgroundColor = .white
                
                self.contentv.autoresizesSubviews = false
                var contentRect = CGRect()
                self.contentv.frame.size.height = self.bgvstatus.frame.maxY + 50
                for view in self.scrollv.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                self.scrollv.contentSize = contentRect.size
                DispatchQueue.main.async {
                    self.bgvstatus.frame.size.height = self.lblstatus.frame.maxY + 20
                }
            }
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

    //MARK:- Run Time Message Delivery Status
    @objc func getUserProfile()
    {
        andicator.startAnimating()
        UserDB.child(useruid)
            .observeSingleEvent(of: .value, with: { (snapshot) in
            self.andicator.stopAnimating()
            if snapshot.childrenCount > 0
            {
                let dicdata = (snapshot.value as! NSDictionary)
                if let temp = dicdata.value(forKey: "LastSeen") as? String
                {
                    if temp == "Nobody"
                    {
                        self.userdata.add(temp)
                    }
                    else
                    {
                        self.userdata.add("Every One")
                    }
                }
                else
                {
                    self.userdata.add("Every One")
                }
                if let temp = dicdata.value(forKey: "ProfilePhoto") as? String
                {
                    if temp == "Nobody"
                    {
                        self.userdata.add(temp)
                    }
                    else
                    {
                        self.userdata.add("Every One")
                    }
                }
                else
                {
                    self.userdata.add("Every One")
                }
                if let temp = dicdata.value(forKey: "SeeAbout") as? String
                {
                    if temp == "Nobody"
                    {
                        self.userdata.add(temp)
                    }
                    else
                    {
                        self.userdata.add("Every One")
                    }
                }
                else
                {
                    //self.arrSelectionSectionOne.add("Every One")
                }
                // self.arrSelectionSectionOne.add("")
                
                if let imgurl = dicdata.value(forKey: "UserLink") as? String    
                {
                    if imgurl != ""
                    {
                        //Kingfisher Image upload
                        let url = URL(string: imgurl)
                        self.imgvprofile.kf.setImage(with: url) { result in
                            switch result {
                            case .success(let value):
                                print("Image: \(value.image). Got from: \(value.cacheType)")
                                self.imgvprofile.image = value.image
                                
                                
                            case .failure(let error):
                                print("Error: \(error)")
                                self.imgvprofile.image = UIImage(named: "user")
                            }
                        }
                        
                    }else{
                        self.imgvprofile.contentMode = .scaleAspectFit
                        self.imgvprofile.image = UIImage(named: "userpng")
                    }
                }
//                if let tempname = dicdata.value(forKey: "UserName") as? String
//                {
//                    //self.username = tempname
//                }
                if let tempphone = dicdata.value(forKey: "UserPhoneNumber") as? String
                {
                    self.userphone = tempphone
                }
                if let tempstatus = dicdata.value(forKey: "UserStatus") as? String
                {
                    self.userstatus = tempstatus
                }
                self.funSetUserData()
            }
        })
    }
    
    func funShowProfilePic(){
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        vc.profilepic = imgvprofile.image!
        vc.videoimagename = "Picture"
        vc.videoimagetag = PROFILEPIC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
