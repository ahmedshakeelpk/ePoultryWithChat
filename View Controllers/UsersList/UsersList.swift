//
//  UsersList.swift
//  ePoltry
//
//  Created by Apple on 11/02/2020.
//  Copyright © 2020 sameer. All rights reserved.
//

import UIKit

class UsersList: UIViewController {

    var arrSource = [Any]()
    var arrAddress = [Any]()
    var arrCreatedDate = [Any]()
    var arrCompany = [Any]()
    var arrNo = [Any]()
    var arrName = [Any]()
    var arrPic = [Any]()
    var arrId = [Any]()
    
    
    @IBOutlet weak var txtsearch: UITextField!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        txtsearch.layer.borderColor = UIColor.black.cgColor
        txtsearch.layer.borderWidth = 1
        obj.setTextFieldShade(textfield: txtsearch)
        obj.putRightImgTextField(txtfield: txtsearch, imgname: "search", x: 20, width: 15, height: 15)
        txtsearch.delegate = self
        //MARK:- Navigation Title Multilines
        obj.navigationTwoLineTitle(topline: "ePoultry", bottomline: "Smart Poultry System", viewcontroller: self)
        funFetchUserList()
        self.tablev.tableFooterView = UIView()
        self.tablev.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        self.tablev.delegate = self
        self.tablev.dataSource = self       
               // Marks: - Left button multiple
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
        
        self.tablev.register(UINib(nibName: "UsersListCell", bundle: nil), forCellReuseIdentifier: "UsersListCell")
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @objc func btnback(){
        self.navigationController?.popViewController(animated: true)
    }
    
    var offset = 0
    @objc func funFetchUserList() {
        let url = BASEURL+"user/All/search?limit=20&offset=\(offset)&days=0"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:{
            responseObject, error in
            self.andicator.stopAnimating()
            //print(responseObject)
            DispatchQueue.main.async {
                if error == nil && responseObject != nil{
                    if responseObject!.count > 0 {
                        let datadic = (responseObject! as NSDictionary)
                        if datadic.count > 0 {
                            let dataarr = (datadic.value(forKey: "Data") as! NSArray)
                            if dataarr.count > 0 {
                                let temparrId = dataarr.value(forKey: "id") as! [Any]
                                let temparrSource = dataarr.value(forKey: "Source") as! [Any]
                                let temparrAddress = dataarr.value(forKey: "address") as! [Any]
                                let temparrCompany = dataarr.value(forKey: "company") as! [Any]
                                let temparrNo = dataarr.value(forKey: "mobile") as! [Any]
                                let temparrName = dataarr.value(forKey: "Name") as! [Any]
                                let temparrCreatedDate = dataarr.value(forKey: "created_date") as! [Any]
                                let temparrPic = dataarr.value(forKey: "profile_img") as! [Any]
                                
                                self.arrId = self.arrPic + temparrId
                                self.arrSource = self.arrSource + temparrSource
                                self.arrAddress = self.arrAddress + temparrAddress
                                self.arrCompany = self.arrCompany + temparrCompany
                                self.arrNo = self.arrNo + temparrNo
                                self.arrName = self.arrName + temparrName
                                self.arrCreatedDate = self.arrCreatedDate + temparrCreatedDate
                                self.arrPic = self.arrPic + temparrPic
                                
                                self.offset = temparrId.last as! Int
                                self.tablev.reloadData()
                                print(dataarr)
                            }
                            
                        }
                        else {
                            obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                        }
                    }
                    else {
                        obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                    }
                }
                else {
                    //  obj.showAlert(title: "Error", message: error!, viewController: self)
                }
            }
        })
    }
    
    ////////////
    //MARK:- Search Section
    var isFiltered = Bool()
    var arrSearchIndex = NSMutableArray()
    @IBAction func txtsearchfun(_ sender: Any) {
    
        let length = txtsearch.text
        if length?.count == 0 {
            isFiltered = false
            arrSearchIndex = NSMutableArray()
            tablev.reloadData()
        }
        else {
            isFiltered = true
            arrSearchIndex = NSMutableArray()
            for (index, temp) in arrGfullname_AppUser.enumerated() {
                let name = temp
                // MARK:- case InSensitive Search
                if let _ = (name).range(of: "\(txtsearch.text!)", options: .caseInsensitive) {
                    self.arrSearchIndex.add(index)
                }
            }
            for (index, temp) in arrName.enumerated() {
                let name = temp as! String
                //print(name)
                // alternative: case sensitive
                if let _ = (name).range(of: "\(txtsearch.text!)", options: .caseInsensitive) {
                    self.arrSearchIndex.add(index)
                }
            }
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    self.tablev?.reloadData()
                }
            }
        }
    }
}


extension UsersList : UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered {
            return arrSearchIndex.count
        }
        return arrNo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "UsersListCell") as! UsersListCell
        var index = indexPath.row
        if isFiltered {
            index = arrSearchIndex[index] as! Int
        }
        cell.lblname.text = "Name: " + "\(arrName[index] as? String ?? "Name: ")"
        cell.lblno.text = "Number: " + "\(arrNo[index] as? String ?? "Number: ")"
        cell.lblcompany.text = "Company: " + "\(arrCompany[index] as? String ?? "Company: ")"
        cell.lblsource.text = "Source: " + "\(arrSource[index] as? String ?? "Source: ")"
        
        cell.lbladdress.text = "Address: " + "\(arrAddress[index] as? String ?? "Address: ")"
        
        let urlprofile = URL(string: userimagepath+"\(arrPic[index])")
        //this is working the bottom line
        //let urlprofile = URL(string: imagepath+arrgimgprofile[row])
        cell.imgv.kf.setImage(with: urlprofile) { result in
            switch result {
            case .success(let value):
                //print("Image: \(value.image). Got from: \(value.cacheType)")
                cell.imgv.image = value.image
            case .failure(let error):
                print("Error: \(error)")
                cell.imgv.image = UIImage(named: "user")
            }
        }
        if let CreatedOn = arrCreatedDate[index] as? String {
            var strtime = CreatedOn.replacingOccurrences(of: "T", with: " ")
            let dfmatter = DateFormatter()
            dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dfmatter.locale = Locale(identifier: "en_US_POSIX")
            dfmatter.timeZone = TimeZone.autoupdatingCurrent //Current time zone
            
            strtime = strtime.components(separatedBy: ".")[0]
            print(strtime)
            
            let agotime = obj.timeAgoSinceDate(dfmatter.date(from: strtime)!)
            
            cell.lblsignup.text = "Sign Up: \(agotime ?? "Sign Up: ")"
        }
        else {
            cell.lblsignup.text = "Sign Up: "
        }
        return cell
    }
    
    //Show Last Cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isFiltered {
            return()
        }
        if indexPath.row+1 == arrNo.count {
            self.funFetchUserList()
            print("came to last row")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    
}
