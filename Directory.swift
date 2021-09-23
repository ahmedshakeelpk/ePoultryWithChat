//
//  Directory.swift
//  ePoltry
//
//  Created by MacBook Pro on 25/04/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class Directory: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK:- Collection view Delegates
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = 5.0
        let width = (self.colv.frame.size.width / 2) - CGFloat(2 * margin)
        return CGSize(width: width, height: width / 2)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrHardCodeImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colv.dequeueReusableCell(withReuseIdentifier: "DirectoryColCell", for: indexPath) as! DirectoryColCell
        //let urlprofile = URL(string: arrImgSrc[indexPath.row] as! String)
        //cell.imgv.kf.setImage(with: urlprofile)
        //cell.imgv.layer.cornerRadius = 10
        cell.imgv.image = UIImage.init(named: arrHardCodeImages[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "DirectoryCities") as! DirectoryCities
        if arrSubCategoryId.count > 0 {
            vc.catid = "\(arrSubCategoryId[indexPath.row])"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            obj.showAlert(title: "Alert!", message: "wait please while data fetch", viewController: self)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubCategoryId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tablev.dequeueReusableCell(withIdentifier: "DirectoryCell", for: indexPath) as! DirectoryCell
        cell.lblname.text = (arrSubCategory[indexPath.row] as! String)
        //Kingfisher Image upload
        let urlprofile = URL(string: arrImgSrc[indexPath.row] as! String)
        cell.imgv.kf.setImage(with: urlprofile)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "CompanyMap") as! CompanyMap
        
        vc.catid = "\(arrSubCategoryId[indexPath.row])"
        vc.name = "\(arrSubCategory[indexPath.row])"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    var pulltorefresh = String()
    var width = Int()
    var height = Int()
    
    var arrHardCodeImages = ["breeder_chicks", "dairy_farms", "hatchries", "drug_manufecturing", "pharma_distr", "broiler_farm", "gradn_parent_farm", "undefined", "feed_mill", "clinics", "poultry_labs","medicalstore","equipment","other_services","control_house", "poultry_services", "layer_form"]
    @IBOutlet weak var btnbussiness: UIButton!
    @IBOutlet weak var btnmap: UIButton!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var colv: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        if arrSubCategoryId.count == 0
        {
             GetAllsubcategory()
        }
    }
    override func viewDidLoad() {
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
        if IPAD{
            
        }
        else{
//            self.btnmap.frame.origin.y = (self.navigationController?.navigationBar.frame.height)!+64
//            self.btnbussiness.frame.origin.y = (self.navigationController?.navigationBar.frame.height)!+64
        }
        self.view.frame.origin.y = (self.navigationController?.navigationBar.frame.maxY)!
        self.view.frame.size.height = (tabBarController?.tabBar.frame.minY)!
        // This is the default value of edgesForExtendedLayout
        //self.navigationController!.edgesForExtendedLayout = .all;

        // The default for this is false
        //self.navigationController!.extendedLayoutIncludesOpaqueBars = true;

        btnmap.frame.origin.y = self.view.frame.origin.y
        btnbussiness.frame.origin.y = self.view.frame.origin.y
        tablev.frame.origin.y = btnmap.frame.maxY
        colv.frame.origin.y = btnmap.frame.maxY
        tablev.frame.size.height = (tabBarController?.tabBar.frame.minY)! - btnmap.frame.maxY
        colv.frame.size.height = (tabBarController?.tabBar.frame.minY)! - btnmap.frame.maxY
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        width = Int(self.btnbussiness.frame.width)
        height = Int(self.btnbussiness.frame.height)
        
        btnbussiness.tag = 1
        GetAllsubcategory()
        tablev.tableFooterView = UIView()
    }
    @objc func btnback(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Friend
    @IBAction func btnbussiness(_ sender: Any) {
        colv.isHidden = false
        tablev.isHidden = true
        btnmap.tag = 0
        btnbussiness.tag = 1
        tablev.reloadData()
        colv.reloadData()
        btnmap.frame = CGRect(x: Int(self.btnmap.frame.origin.x), y: Int(self.btnmap.frame.origin.y), width: Int(btnmap.frame.size.width), height: height+2)
        btnbussiness.frame = CGRect(x: Int(self.btnbussiness.frame.origin.x), y: Int(self.btnbussiness.frame.origin.y), width: Int(btnbussiness.frame.size.width), height: Int(height))
        
    }
    //MARK: - Friend Request
    @IBAction func btnmap(_ sender: Any) {
        colv.isHidden = true
        tablev.isHidden = false
        btnmap.tag = 1
        btnbussiness.tag = 0
        tablev.reloadData()
        colv.reloadData()
        btnmap.frame = CGRect(x: Int(self.btnmap.frame.origin.x), y: Int(self.btnmap.frame.origin.y), width: Int(btnmap.frame.size.width), height: height)
        btnbussiness.frame = CGRect(x: Int(self.btnbussiness.frame.origin.x), y: Int(self.btnbussiness.frame.origin.y), width: Int(btnbussiness.frame.size.width), height: Int(height+2))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func GetAllsubcategory()
    {
//        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"category/subcategory"
        print(url)
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:
            {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil
                    {
                        if responseObject!.count > 0
                        {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0
                            {
                                let dataarr = (datadic.value(forKey: "data") as! NSArray)
                                self.arrImgSrc = dataarr.value(forKey: "ImgSrc") as! [Any]
                                self.arrSubCategoryId = dataarr.value(forKey: "SubCategoryId") as! [Any]
                                self.arrSubCategory = dataarr.value(forKey: "SubCategory") as! [Any]
                                
                                self.tablev.reloadData()
                                self.colv.reloadData()
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
                          obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
    
    var arrSubCategoryId = [Any]()
    var arrSubCategory = [Any]()
    var arrImgSrc = [Any]()
}
