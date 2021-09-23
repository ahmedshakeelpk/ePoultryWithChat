//
//  Settings.swift
//  ZedChat
//
//  Created by MacBook Pro on 12/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class Settings: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var arrtitle = ["Account", "Chats", "Notifications", "Data and storage usage", "App Lock","Invite a friend", "Help"]
    var arrpic = ["Account", "Chats", "Notifications","DataNdStorage", "applock", "Invite", "Help", "privacy", "terms"]
    //Will Change when app complete
//    var arrtitle = [ "Privacy Policy", "Terms & Conditions"]
//    var arrpic = [ "privacy", "terms"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrtitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell

        cell.lbltitle.text = arrtitle[indexPath.row]
        cell.imgv.image = UIImage(named: arrpic[indexPath.row])
        
        let number = Int.random(in: 0 ..< 6)
        let arrclr = arrcolor[number]
        cell.imgvbg.applyGradient(colours: arrclr)
        
        obj.setImageHeighWidth4Pad(image: cell.imgv, viewcontroller: self)
        obj.setimageCircle(image: cell.imgvbg, viewcontroller: self)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = arrtitle[indexPath.row]
        if title == "Account" {
            let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "Accounts") as! Accounts
            vc.screen = "Privacy"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if title == "Chats" {
            let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "Accounts") as! Accounts
            vc.screen = "Chats"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if title == "Notifications" {
            
        }
        else if title == "Data and storage usage" {
            let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "Accounts") as! Accounts
            vc.screen = "Data & Storage"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if title == "App Lock" {
            if let isLock = defaults.value(forKey: "isLock") as? String{
                if isLock == "0" {
                 //   funEnterNewPasswordScreen(viewController: self)
                    funLockScreen(viewController: self, isCancelButton: true, type: "new")
                }
                else if isLock == "1" {
                    let vc = UIStoryboard.init(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "PasswordScreen") as! PasswordScreen
                    vc.passwordtype = "lock"
                    vc.isCancelButton = true
                    vc.isChangeScreen = true
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
        else if title == "Invite a friend" {
            let cell = tablev.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
            funinvite(sender: cell.lbltitle)
        }
        else if title == "Help" {
            let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "Accounts") as! Accounts
            vc.screen = "Help"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD {
            return 150
        }
        else {
            return 74
        }
    }

    @IBOutlet weak var btnprofile: UIButton!
    @IBAction func btnprofile(_ sender: Any) {
        let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "Profile") as! Profile
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var headerv: UIView!
    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblstatus: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        showData()
    }
    override func viewDidLoad() {
                       self.title = "Settings"
        //MARK:- Back Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(funback))
        
        tablev.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(funsetPassword), name: NSNotification.Name(rawValue: "setPassword"), object: nil)
        self.tablev.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        
        self.tablev.tableHeaderView = headerv
        super.viewDidLoad()
    }
    
    @objc func funsetPassword() {
        funChangeRemoveScreen(viewController: self)
    }
    @objc func funback() {
        self.navigationController?.popViewController(animated: true)
    }

    func showData() {
        lblstatus.numberOfLines = 0
        lblstatus.lineBreakMode = .byWordWrapping
        lblname.text = (defaults.value(forKey: "username") as! String)
        lblstatus.text = (defaults.value(forKey: "userstatus") as! String)
        obj.setimageCircle(image: imgvprofile, viewcontroller: self)
        
        if let tempimgurl = defaults.value(forKey: "userimage") as? String {
            if tempimgurl != "" {
                //Kingfisher Image upload
                let url = URL(string: USER_IMAGE_PATH + tempimgurl)
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
            }
            else {
                
            }
        }
        
        //lblstatus.sizeToFit()
        DispatchQueue.main.async {
         //   self.lblstatus.baselineAdjustment = .alignCenters
          //  self.lblstatus.textAlignment = .center

        }
        tablev.reloadData()
    }
    @objc func funinvite(sender: UILabel) {
        print(sender.tag)
        //Set the default sharing message.
        //Set the link to share.
        let objectsToShare = [SHAREMESSAGE ,SHARELINKANDROID, SHARELINKIOS]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            activityVC.popoverPresentationController?.sourceView = sender
            activityVC.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            activityVC.popoverPresentationController?.permittedArrowDirections = .any
        default:
            break
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
