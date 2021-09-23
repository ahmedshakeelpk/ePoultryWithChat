//
//  DirectoryCities.swift
//  ePoltry
//
//  Created by MacBook Pro on 07/05/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class DirectoryCities: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered == true
        {
            return arrSearchIndex.count
        }
        else
        {
            return arrcities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "DirectoryCitiesCell") as! DirectoryCitiesCell
        var index = indexPath.row
        if isFiltered == true
        {
            index = arrSearchIndex[indexPath.row] as! Int
        }
        cell.lbltitle.text = (arrcities[index] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD
        {
            return 110
        }
        else
        {
            return 55
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "DirectoryCompanyNames") as! DirectoryCompanyNames
        if arrcities.count > 0
        {
            var index = indexPath.row
            if isFiltered == true
            {
                index = arrSearchIndex[indexPath.row] as! Int
            }
            vc.catid = catid
            vc.cityname = arrcities[index] as! String
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            obj.showAlert(title: "Alert!", message: "wait please while data fetch", viewController: self)
        }
    }
    var catid = String()
    var arrcities = NSArray()
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var tablev: UITableView!
    @IBAction func txtsearch(_ sender: Any) {
    }
    @IBOutlet weak var txtsearch: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GetAllCities()
        tablev.tableFooterView = UIView()
        obj.putRightImgTextField(txtfield: txtsearch, imgname: "search", x: 5, width: 25, height: 25)
        obj.txtbottomline(textfield: txtsearch)
        //MARK:- Navigation Title Multilines
        obj.navigationTwoLineTitle(topline: "ePoultry", bottomline: "Smart Poultry System", viewcontroller: self)
        funSearchSetting()
    }
    
    
    
    func GetAllCities()
    {
        let url = BASEURL+"cities/\(catid)"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:
            {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil
                    {
                        if responseObject!.count > 0
                        {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0
                            {
                                self.arrcities = ((datadic.value(forKey: "data") as! NSArray).value(forKey: "city") as! NSArray)
                            //    self.arrImgSrc = dataarr.value(forKey: "ImgSrc") as! [Any]
                                
                                
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
    //MARK:- Search Section
    var isFiltered = Bool()
    var arrSearchIndex = NSMutableArray()
    var btncancelSearch = UIButton(type: .custom)
    @IBAction func btncancelSearch(sender: UIButton){
        txtsearch.text = ""
        self.view.endEditing(true)
        isFiltered = false
        arrSearchIndex = NSMutableArray()
        tablev.reloadData()
    }
    
    func funSearchSetting()
    {
        // search textfield func    
        // search textfield func
        obj.putRightButtoninTextField(btn: btncancelSearch, txtfield: txtsearch, imgname: "cross", x: 20, width: 15, height: 15)
        btncancelSearch.addTarget(self, action: #selector(btncancelSearch(sender:)), for: .touchUpInside)
        obj.putLeftImgInTextField(txtfield: txtsearch, imgname: "search", x: 5, width: 25, height: 25)
        
        txtsearch.delegate = self
        txtsearch.addTarget(self, action: #selector(change), for: .editingChanged)
    }
    @objc func change()
    {
        let length = txtsearch.text
        if length?.count == 0
        {
            isFiltered = false
            //searchBar.responds(to: Selector(resignFirstResponder()))
            //txtsearch.resignFirstResponder()
            arrSearchIndex = NSMutableArray()
            tablev.reloadData()
        }
        else
        {
            isFiltered = true
            arrSearchIndex = NSMutableArray()
            for (index, temp) in arrcities.enumerated() {
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
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    self.tablev?.reloadData()
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }//End Search Setting
}
