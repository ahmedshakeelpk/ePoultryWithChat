//
//  AddCompany.swift
//  ePoltry
//
//  Created by MacBook Pro on 16/09/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class AddCompany: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var isAddCompany = false
    
    // MARKS:- Companies
    var arrCAddress = NSArray()
    var arrCCity = NSArray()
    var arrCSubCategory = NSArray()
    var arrCCompany = NSArray()
    var arrCCompanyId = NSArray()
    
    //MARK:- SubCategories
    var arrSubCName = NSArray()
    var arrSubCId = NSArray()
    var arrSubIcon = NSArray()
    var arrSubIsActive = NSArray()
    var arrSubOldId = NSArray()
    var arrSubType = NSArray()
    @IBOutlet weak var txtsearch: UITextField!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if isAddCompany{
            funGetCompany()
        }
        // Do any additional setup after loading the view.
        self.tablev.delegate = self
        self.tablev.dataSource = self
        
        // Do any additional setup after loading the view.
        self.tablev.register(UINib(nibName: "SubCategoryCell", bundle: nil), forCellReuseIdentifier: "SubCategoryCell")
        self.tablev.register(UINib(nibName: "AddCompanyCell", bundle: nil), forCellReuseIdentifier: "AddCompanyCell")
        self.tablev.tableFooterView = UIView()
        let backBtn = UIBarButtonItem(image: UIImage.init(named: "Back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funback))
        self.navigationItem.leftBarButtonItem = backBtn
        
        if isAddCompany{
            self.title = "Select Company"
        }
        else{
            self.title = "Select Category"
        }
        
        obj.txtbottomline(textfield: txtsearch)
        funSearchSetting()
        
        NotificationCenter.default.addObserver(self, selector: #selector(funCompanyRefresh), name: NSNotification.Name(rawValue: "funCompanyRefresh"), object: nil)
        
        DispatchQueue.main.async {
            if self.arrCCompanyId.count == 0{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "funGetCompany"), object: nil)
            }
            if self.arrSubCId.count == 0{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "funGetSubCategories"), object: nil)
            }
        }
    }
    @objc func funCompanyRefresh(){
        tablev.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered{
            return arrSearchIndex.count
        }
        if isAddCompany{
            return arrCCompanyId.count
        }
        return arrSubCId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var index = indexPath.row
        if isFiltered{
            index = arrSearchIndex[index] as! Int
        }
        if isAddCompany{
            let cell = tablev.dequeueReusableCell(withIdentifier: "AddCompanyCell") as! AddCompanyCell
            cell.lbltitle.text = arrCCompany[index] as? String ?? ""
            cell.lblsubcat.text = arrCSubCategory[index] as? String ?? ""
            return cell
        }
        
        let cell = tablev.dequeueReusableCell(withIdentifier: "SubCategoryCell") as! SubCategoryCell
        cell.lbltitle.text = arrSubCName[index] as? String ?? ""
       // let urlicon = URL(string:  imagepath+(arrSubIcon[index] as? String ?? ""))
      //  cell.imgv.kf.setImage(with: urlicon)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = indexPath.row
        if isFiltered{
            index = arrSearchIndex[index] as! Int
        }
        var datadic = [String:Any]()
        
        if isAddCompany{
            datadic = ["isAddCompany" : isAddCompany,
                       "isAddNewCompany": false,
                       "address": arrCAddress[index],
                       "city": arrCCity[index],
                       "name": arrCCompany[index],
                       "company": arrCSubCategory[index],
                       "companyid": arrCCompanyId[index]]
        }
        else{
            datadic = ["isAddCompany" : isAddCompany,
                       "isAddNewCompany": false,
                       "name" : arrSubCName[index],
                       "id": arrSubCId[index],
                       "icon": arrSubIcon[index],
                       "isactive": arrSubIsActive[index],
                       "oldid": arrSubOldId[index],
                       "type": arrSubType[index]]
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectCompany"), object: datadic)
        funback()
    }

    @objc func funback(){
        self.navigationController?.popViewController(animated: true)
    }
    func funSearchSetting()
    {
        // search textfield func
        let btncancelSearch = UIButton(type: .custom)
        txtsearch.delegate = self
        txtsearch.addTarget(self, action: #selector(change), for: .editingChanged)
    }
    
    //MARK:- Search Section
    var isFiltered = Bool()
    var arrSearchIndex = NSMutableArray()
    @objc func change()
    {
        let length = txtsearch.text
        if length?.count == 0
        {
            isFiltered = false
            arrSearchIndex = NSMutableArray()
            tablev.reloadData()
        }
        else
        {
            isFiltered = true
            arrSearchIndex = NSMutableArray()
            var arrSearchString = [String]()
            if isAddCompany{
                arrSearchString = arrCCompany as! [String]
                for (index, temp) in arrSearchString.enumerated() {
                    var name = "\(temp)"
                    if name.isNumeric{
                        print("String contain only Numeric")
                        name = name.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
                        name = name.trimmingCharacters(in: .whitespaces)
                        name = name.replacingOccurrences(of: " ", with: "")
                        name = name.replacingOccurrences(of: "+", with: "")
                        name = name.replacingOccurrences(of: "-", with: "")
                        name = name.replacingOccurrences(of: "(", with: "")
                        name = name.replacingOccurrences(of: ")", with: "")
                    }
                    // MARK:- case InSensitive Search
                    if let _ = (name).range(of: "\(txtsearch.text!)", options: .caseInsensitive) {
                        self.arrSearchIndex.add(index)
                    }
                }
                
                for (index, temp) in arrCSubCategory.enumerated() {
                    var name = "\(temp)"
                    if name.isNumeric{
                        print("String contain only Numeric")
                        name = name.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
                        name = name.trimmingCharacters(in: .whitespaces)
                        name = name.replacingOccurrences(of: " ", with: "")
                        name = name.replacingOccurrences(of: "+", with: "")
                        name = name.replacingOccurrences(of: "-", with: "")
                        name = name.replacingOccurrences(of: "(", with: "")
                        name = name.replacingOccurrences(of: ")", with: "")
                    }
                    // MARK:- case InSensitive Search
                    if let _ = (name).range(of: "\(txtsearch.text!)", options: .caseInsensitive) {
                        self.arrSearchIndex.add(index)
                    }
                }
            }
            else{
                arrSearchString = arrSubCName as! [String]
                for (index, temp) in arrSearchString.enumerated() {
                    var name = "\(temp)"
                    if name.isNumeric{
                        print("String contain only Numeric")
                        name = name.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
                        name = name.trimmingCharacters(in: .whitespaces)
                        name = name.replacingOccurrences(of: " ", with: "")
                        name = name.replacingOccurrences(of: "+", with: "")
                        name = name.replacingOccurrences(of: "-", with: "")
                        name = name.replacingOccurrences(of: "(", with: "")
                        name = name.replacingOccurrences(of: ")", with: "")
                    }
                    // MARK:- case InSensitive Search
                    if let _ = (name).range(of: "\(txtsearch.text!)", options: .caseInsensitive) {
                        self.arrSearchIndex.add(index)
                    }
                }
            }
            
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    self.tablev?.reloadData()
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    func funGetCompany()
    {
        let url = BASEURL+"company/get"
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:
            {
                responseObject, error in
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil
                    {
                        if responseObject!.count > 0
                        {
                            let datadic = (responseObject! as NSDictionary).value(forKey: "data") as! NSArray
                            if datadic.count > 0
                            {
                                self.arrCAddress = datadic.value(forKey: "Address") as! NSArray
                                self.arrCCity = datadic.value(forKey: "City") as! NSArray
                                self.arrCSubCategory = datadic.value(forKey: "SubCategory") as! NSArray
                                self.arrCCompany = datadic.value(forKey: "company") as! NSArray
                                self.arrCCompanyId = datadic.value(forKey: "company_id") as! NSArray
                                self.tablev.reloadData()
                            }
                            else
                            {
                                obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                            }
                        }
                        else
                        {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else
                    {
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }

}
