//
//  Setting.swift
//  AMPL
//
//  Created by Paragon Marketing on 22/06/2017.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit
import StoreKit

class Setting: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tablev: UITableView!
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    let arrHeadersForSection = ["NOTIFICATIONS", "ACCOUNT", "OTHER"]
    let arrNotificationTitles = ["Sound", "Push Notifications", "New Public Post", "New User Join"]
    var arrAccountTitles = ["Profile"]
    let arrOtherTitles = ["Review on App Store", "About"]
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrHeadersForSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return arrNotificationTitles.count
        }
        else if section == 1{
            return arrAccountTitles.count
        }
        else if section == 2{
            return arrOtherTitles.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "SettingOnOffBtnCell") as! SettingOnOffBtnCell
            cell.lbltitle.text = arrNotificationTitles[indexPath.row]
            cell.imgv.image = UIImage.init(named: "notificationappclr")
            return cell
        }
        else if indexPath.section == 1 {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "SettingArrowBtnCell") as! SettingArrowBtnCell
            cell.lbltitle.text = arrAccountTitles[indexPath.row]
            cell.imgv.image = UIImage.init(named: "user")
            return cell
        }
        else {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "SettingArrowBtnCell") as! SettingArrowBtnCell
            cell.lbltitle.text = arrOtherTitles[indexPath.row]
            cell.imgv.image = UIImage.init(named: "about")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "   " + arrHeadersForSection[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = CGFloat(65)
        if IPAD{
            return height*2
        }
        return height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        //self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.navigationController?.isNavigationBarHidden = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let tempSelectedTitle = arrAccountTitles[indexPath.row]
            if tempSelectedTitle == "Profile" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isProfilePage"), object: nil)
            }
            else if tempSelectedTitle == "User List"  {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isUserList"), object: nil)
            }
            else if tempSelectedTitle == "Channel Request" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isChannelRequestStatus"), object: nil)
            }
        }
        else if indexPath.section == 2 {
            if arrOtherTitles[indexPath.row] == "Review on App Store" {
                rateApp()
            }
            else if arrOtherTitles[indexPath.row] == "About"{
                let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "AppInfo") as! AppInfo
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    @IBOutlet weak var btnlogout: UIButton!
    @objc func btnback(){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        //obj.navigationTwoLineTitle(topline: "ePoultry", bottomline: "Smart Poultry System", viewcontroller: self)
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
       
        if USERROLE == "1" {
            arrAccountTitles = ["Profile", "User List", "Channel Request"]
        }
        // Do any additional setup after loading the view.
        self.tablev.register(UINib(nibName: "SettingOnOffBtnCell", bundle: nil), forCellReuseIdentifier: "SettingOnOffBtnCell")
        self.tablev.register(UINib(nibName: "SettingArrowBtnCell", bundle: nil), forCellReuseIdentifier: "SettingArrowBtnCell")
        self.tablev.tableFooterView = UIView()
        
        super.viewDidLoad()
    }
    
    @IBAction func btnlogout(_ sender: Any) {
        DispatchQueue.main.async {
            //            navigationController.popToRootViewController(animated: true)
            defaults .setValue("", forKey: "view")
            
            //        let customViewControllersArray : NSArray = [newViewControllerr]
            //        self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
            
            if !IPAD{
                self.navigationController?.popViewController(animated: true)
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
            }
            
        }
    }

   func rateApp() {
    andicator.startAnimating()
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()

            DispatchQueue.main.async {
                self.andicator.stopAnimating()
            }
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "1463154294") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            } else {
                UIApplication.shared.openURL(url)
            }
            DispatchQueue.main.async {
                self.andicator.stopAnimating()
            }
        }
    }

}
