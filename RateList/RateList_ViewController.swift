//
//  RateList_ViewController.swift
//  Poultry Rates
//
//  Created by Faisal Raza on 18/11/2019.
//  Copyright © 2019 Zaryans Group. All rights reserved.
//

import UIKit
import Alamofire
import EVReflection


var widthView = 0
let screenSize = UIScreen.main.bounds

var update_Items_dic = [NSDictionary]()

class RateList_ViewController: UIViewController
{
    @IBOutlet weak var collection_Type: UICollectionView!
    @IBOutlet weak var collection_Province: UICollectionView!
    @IBOutlet weak var Height_CollectionProvince: NSLayoutConstraint!
    
    
    @IBOutlet weak var ImageUpdate: UIImageView!
    @IBOutlet weak var BtnUpdate: UIButton!
    
    @IBOutlet weak var Tbl_Ratelist: UITableView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var View_EditRate: UIView!
    
    @IBOutlet weak var indicator_Rates: UIActivityIndicatorView!
    //MARK: Filter attributes
    var is_OpenFilter : Bool = false
    @IBOutlet weak var Image_OpenFilter: UIImageView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var View_FilterBackground: UIView!
    @IBOutlet weak var View_FilterDetail: UIView!
    @IBOutlet weak var Width_Filter: NSLayoutConstraint!
    
    //MARK: Layout attributes
    
    
    var provinces = ["Punjab" , "Sindh" , "KPK" , "Balouchistan"]
    var type_Poultry = ["Egg Rate" , "DOC" , "Ready Stock"]
    
    var selected_poultryType : String = ""
    var selected_province : String = ""
    var todayDate : String = ""
    
    var viewEditCheck : Bool = false
    @objc func btnback(){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        let cellSize = CGSize(width:80 , height:80)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        //layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        collection_Province.setCollectionViewLayout(layout, animated: true)
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .vertical //.horizontal
        layout2.itemSize = cellSize
        //layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout2.minimumLineSpacing = 1.0
        layout2.minimumInteritemSpacing = 1.0
        collection_Type.setCollectionViewLayout(layout2, animated: true)
        
        viewEditCheck = false
        self.RegisterNotifications()
    }
    
    func RegisterNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(datePickerViewShow(notification:)), name: .dateView, object: nil)
    }
    
    
    @objc func datePickerViewShow(notification: Notification)
    {
        let date_select = UserDefaults.standard.string(forKey: "ShowDate")
        let dateArr = date_select?.components(separatedBy: "-")
        self.lbDate.text = "\(dateArr?[1] ?? "")-\(dateArr?[2] ?? "")-\(dateArr?[0] ?? "")"
        
        todayDate = self.lbDate.text ?? ""
        self.DailyRates_ServerCallSend(todayDate: todayDate, poultryType: selected_poultryType, province: selected_province)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.Data_Allocate()
        self.Register_NIBs()
        self.ReteriveData()
        self.DefaultData()
    }
    
    func DefaultData()
    {
        //defaults.setValue(roletitle, forKey: "role")

        var role = String()
        if let tempid = defaults.value(forKey: "isadmin") as? String
        {
            role = tempid
        }
        if role == "1"
        {
            viewEditCheck = true
        }
        else
        {
            viewEditCheck = false
        }
        
        if viewEditCheck == true
       {
            View_EditRate.isHidden = false
            ImageUpdate.isHidden = false
            BtnUpdate.isHidden = false
       }
       else
       {
            View_EditRate.isHidden = true
            ImageUpdate.isHidden = true
            BtnUpdate.isHidden = true
       }
    }
    
    func Data_Allocate()
    {
        let plist = Plist(name: "PoultrySave")
        let plist_Data = plist!.getMutablePlistFile()!
        
        selected_poultryType = plist_Data["poultryType"] as? String ?? ""
        selected_province = plist_Data["province"] as? String ?? ""
        
        if selected_poultryType == "" || selected_province == ""
        {
              let plist = Plist(name: "PoultrySave")
              let plist_Data = plist!.getMutablePlistFile()!
              plist_Data["poultryType"] = type_Poultry[0]
              selected_poultryType = type_Poultry[0]
              plist_Data["province"] = "PUNJAB"
              selected_province = "PUNJAB"
              do
             {
                 try plist!.addValuesToPlistFile(dictionary: plist_Data)
             }
             catch
             {
                 print(error)
             }
        }
    }
    
    func Register_NIBs()
    {
        Tbl_Ratelist.register(UINib(nibName: "RateList_TableViewCell", bundle: nil), forCellReuseIdentifier: "RateList_TableViewCell")
    
    }
    
    func ReteriveData()
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        todayDate = formatter.string(from: date)
        lbDate.text = todayDate
        self.DailyRates_ServerCallSend(todayDate: todayDate, poultryType: selected_poultryType, province: selected_province)
        self.Province_ServerCallSend()
    }
    
    
    @IBAction func Action_Back(_ sender: Any)
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_User(_ sender: Any)
    {  if viewEditCheck == false
        {
            viewEditCheck = true
            View_EditRate.isHidden = true
            self.Tbl_Ratelist.reloadData()
        }
        else
        {
            View_EditRate.isHidden = false
            viewEditCheck = false
            self.Tbl_Ratelist.reloadData()
        }
    }
    
    
    @IBAction func Action_Previous(_ sender: Any)
    {
//        let DateArr = todayDate.components(separatedBy: "-")
//        var changeDate = Int(DateArr[1])
//        changeDate = (changeDate ?? 0) - 1
//        todayDate = "\(DateArr[0])-\(changeDate ?? 0)-\(DateArr[2])"
//        lbDate.text = todayDate
//        self.DailyRates_ServerCallSend(todayDate: todayDate, poultryType: selected_poultryType, province: selected_province)

        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePicker_ViewController") as? DatePicker_ViewController
        {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func Action_Next(_ sender: Any)
    {
                let DateArr = todayDate.components(separatedBy: "-")
              var changeDate = Int(DateArr[1])
              changeDate = (changeDate ?? 0) + 1
              todayDate = "\(DateArr[0])-\(changeDate ?? 0)-\(DateArr[2])"
              lbDate.text = todayDate
              self.DailyRates_ServerCallSend(todayDate: todayDate, poultryType: selected_poultryType, province: selected_province)
    }
    
    @IBAction func Action_Put(_ sender: Any)
    {
        view.endEditing(true)
        self.uploadDataToServer(completionHandler:
             { responce in

                 print(responce)
                  self.DailyRates_ServerCallSend(todayDate: self.todayDate, poultryType: self.selected_poultryType, province: self.selected_province)
         })
    }
    
    @IBAction func Action_Open(_ sender: Any)
    {
        if is_OpenFilter == false
        {
            is_OpenFilter = true
            self.viewFilter.isHidden = false
            view.layoutIfNeeded() // always make sure any pending layout changes have happened
            Width_Filter.constant = 250
            Image_OpenFilter.image = UIImage(named: "close")
            UIView.animate(withDuration: 0.3, animations:
            {
                self.view.layoutIfNeeded()
            })
        }
        else
        {
            is_OpenFilter = false
           view.layoutIfNeeded() // always make sure any pending layout changes have happened
           Width_Filter.constant = 0
           Image_OpenFilter.image = UIImage(named: "open")
           UIView.animate(withDuration: 0.3, animations:
           {
               self.view.layoutIfNeeded()
               self.viewFilter.isHidden = true
            })
        }
    }
}

extension RateList_ViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView.tag == 0
        {
            return type_Poultry.count
        }
        else
        {
            return ratelistVM.province_Arr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView.tag == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Type_CollectionViewCell2", for: indexPath) as! Type_CollectionViewCell
        
            cell.lbType.text = type_Poultry[indexPath.row]
            
            if selected_poultryType == type_Poultry[indexPath.row]
            {
                cell.imgRadio.image = UIImage(named: "radio_Select")
            }
            else
            {
               cell.imgRadio.image = UIImage(named: "radio_unselect")
            }
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Type_CollectionViewCell", for: indexPath) as! Type_CollectionViewCell
            
            cell.lbType.text = ratelistVM.province_Arr[indexPath.row].name
            
            if selected_province == ratelistVM.province_Arr[indexPath.row].name
            {
               cell.imgRadio.image = UIImage(named: "radio_Select")
            }
            else
            {
                cell.imgRadio.image = UIImage(named: "radio_unselect")
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let plist = Plist(name: "PoultrySave")
        let plist_Data = plist!.getMutablePlistFile()!
        
        if collectionView.tag == 0
        {
            
            plist_Data["poultryType"] = type_Poultry[indexPath.row]
            selected_poultryType = type_Poultry[indexPath.row]
        }
        else
        {
            plist_Data["province"] = ratelistVM.province_Arr[indexPath.row].name
            selected_province = ratelistVM.province_Arr[indexPath.row].name ?? ""
        }
        do
       {
           try plist!.addValuesToPlistFile(dictionary: plist_Data)
       }
       catch
       {
           print(error)
       }
        
        if collectionView.tag == 0
        {
            collection_Type.reloadData()
        }
        else
        {
            DispatchQueue.main.async
            {
                self.collection_Province.reloadData()
            }
        }
        self.DailyRates_ServerCallSend(todayDate: todayDate, poultryType: selected_poultryType, province: selected_province)
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView.tag == 0
        {
            let width = Int(self.collection_Type.frame.size.width/3.5)
            return CGSize(width: width , height: 35)
        }
        else
        {
            let width = screenSize.width / 2.1
            return CGSize(width: width, height: 35.0)
        }
    }
}

extension RateList_ViewController : UITextFieldDelegate
{
    //MARK:- TextField Delegate for tableview functions
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        let pointInTable = textField.convert(textField.bounds.origin, to: self.Tbl_Ratelist)
        let textFieldIndexPath = self.self.Tbl_Ratelist.indexPathForRow(at: pointInTable)
     
        let cell_Textfield = self.self.Tbl_Ratelist.cellForRow(at: textFieldIndexPath!) as? RateList_TableViewCell
        
        if cell_Textfield?.tfTodayRate == textField
        {
            print("Size textfield")
            cell_Textfield?.viewTodayRate.backgroundColor = global_utility.hexStringToUIColor(hex: view_backcolor)
        }
        print("Textfield \(textField)")
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        print("Textfield \(textField)")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("Textfield \(textField)")
        print("This function will called")
        let pointInTable = textField.convert(textField.bounds.origin, to: self.Tbl_Ratelist)
        let textFieldIndexPath = self.Tbl_Ratelist.indexPathForRow(at: pointInTable)
        let cell_Textfield = self.Tbl_Ratelist.cellForRow(at: textFieldIndexPath!) as? RateList_TableViewCell
        
        if cell_Textfield?.tfTodayRate == textField
        {
            print("Size textfield")
            ratelistVM.RateListData_Arr[textFieldIndexPath?.row ?? 0].index_Update = textFieldIndexPath?.row ?? 0
            ratelistVM.RateListData_Arr[textFieldIndexPath?.row ?? 0].index_UpdateVal = textField.text ?? ""
            ratelistVM.RateListData_Arr[textFieldIndexPath?.row ?? 0].isUpdate = true
            cell_Textfield?.viewTodayRate.backgroundColor = global_utility.hexStringToUIColor(hex: view_backcolor)
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        print("This function will called")
        let pointInTable = textField.convert(textField.bounds.origin, to: self.Tbl_Ratelist)
        let textFieldIndexPath = self.Tbl_Ratelist.indexPathForRow(at: pointInTable)
        let cell_Textfield = self.Tbl_Ratelist.cellForRow(at: textFieldIndexPath!) as? RateList_TableViewCell
        
        if cell_Textfield?.tfTodayRate == textField
        {
            print("Size textfield")
            ratelistVM.RateListData_Arr[textFieldIndexPath?.row ?? 0].index_Update = textFieldIndexPath?.row ?? 0
            ratelistVM.RateListData_Arr[textFieldIndexPath?.row ?? 0].index_UpdateVal = textField.text ?? ""
            ratelistVM.RateListData_Arr[textFieldIndexPath?.row ?? 0].isUpdate = true
            cell_Textfield?.viewTodayRate.backgroundColor = global_utility.hexStringToUIColor(hex: view_backcolor)
        }
    
    }
    
}

extension RateList_ViewController : UITableViewDataSource , UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if ratelistVM.RateListData_Arr.count > 0
        {
            return ratelistVM.RateListData_Arr.count
        }
        return ratelistVM.RateListData_Yesterdya_Arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell_Rate = tableView.dequeueReusableCell(withIdentifier: "RateList_TableViewCell", for: indexPath) as! RateList_TableViewCell
        
        cell_Rate.lbCityName.text = ratelistVM.RateListData_Arr[indexPath.row].SubArea
        
        cell_Rate.selectionStyle = .none
        
        if ratelistVM.RateListData_Arr.count > indexPath.row
        {
            cell_Rate.tfTodayRate.text = "\(ratelistVM.RateListData_Arr[indexPath.row].Rate)"
        }
        else
        {
            cell_Rate.tfTodayRate.text = "0"
        }
        
        if ratelistVM.RateListData_Yesterdya_Arr.count > indexPath.row
        {
            cell_Rate.tfYesterdayRate.text = "\(ratelistVM.RateListData_Yesterdya_Arr[indexPath.row].Rate)"
        }
        else
        {
            cell_Rate.tfYesterdayRate.text = "0"
        }
        
        cell_Rate.tfYesterdayRate.isUserInteractionEnabled = false
        
        if viewEditCheck == true
        {
            cell_Rate.View_EditRate.isHidden = false
            cell_Rate.tfTodayRate.isUserInteractionEnabled = true
            cell_Rate.tfTodayRate.delegate = self
            
        }
        else
        {
            cell_Rate.View_EditRate.isHidden = true
            cell_Rate.tfTodayRate.isUserInteractionEnabled = false
        }
        
        return cell_Rate
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
}


extension RateList_ViewController
{
    open func Province_ServerCallSend()
       {
           DispatchQueue.main.async
               {
                ServerCalls.shareInstance.Province_API(completionBlock:
                    {(appstatus,responce,ErrorMessage)  in
                       
                        if appstatus == 1
                        {
                            ratelistVM.ProvinceData_Add(response: responce)
                            
                            let heightCount : Float = Float(ratelistVM.province_Arr.count/2)
                            let height = heightCount.rounded(.up)
                            //self.Height_CollectionProvince.constant = CGFloat(height * 40)
                            //self.viewWillLayoutSubviews()
                            self.collection_Province.reloadData()
                        }
                        else if appstatus == 0
                        {
                        }
                    })
                }
        }

    open func DailyRates_ServerCallSend(todayDate : String , poultryType : String , province : String)
    {
        DispatchQueue.main.async
            {
                self.indicator_Rates.startAnimating()
                self.indicator_Rates.isHidden = false
                
                ServerCalls.shareInstance.DailyRates(todayDate: todayDate, province: province, rateCategory: poultryType, completionBlock:
                    {(appstatus,responce,ErrorMessage)  in
                       
                        if appstatus == 1
                        {
                            ratelistVM.insertData(response: responce)
                            self.Tbl_Ratelist.reloadData()
                        }
                        else if appstatus == 0
                        {
                            
                        }
                        self.indicator_Rates.stopAnimating()
                        self.indicator_Rates.isHidden = true
                    })
        }
    }
    
    func json(from object:Any) -> String?
    {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else
        {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    func uploadDataToServer(completionHandler:@escaping (Bool) -> ())
    {
        var rateID : String = ""
        update_Items_dic.removeAll()
        for data_Index in 0..<ratelistVM.RateListData_Arr.count
        {
            let index_Today = ratelistVM.RateListData_Arr[data_Index]
            rateID = "\(ratelistVM.RateListData_Arr[0].id ?? 0)"
            
            if index_Today.isUpdate == true
            {
                let Data : NSDictionary =
                    [
                        "RateId" : "\(index_Today.id ?? 0)",
                        "Province":"PUNJAB",
                        "Area":"",
                        "SubArea":"\(index_Today.SubArea ?? "")",
                        "SubAreaId":"\(index_Today.SubAreaId ?? 0)",
                        "RateCategory":"\(index_Today.RateCategory)",
                        "Rate":index_Today.index_UpdateVal,
                        "Dated":index_Today.Dated ?? "",
                        "UpdatedBy" : index_Today.CreatedBy ?? ""
                    ]
                update_Items_dic.append(Data)
            }
        }
        
        var url = "\(DomainUrl)\(dailyrates_update)\(rateID)"
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        headers = [:]
           
         var request = URLRequest(url: URL.init(string: url)!)
        
        request.httpMethod = "PUT"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
           
            let jsonData = try JSONSerialization.data(withJSONObject: update_Items_dic, options: .prettyPrinted)
            
            request.httpBody =  jsonData
            Alamofire.request(request).responseJSON
                {(response) in

                print("Success: \(response)")
                switch response.result
                {
                case .success:
                  
                    let statusCode: Int = (response.response?.statusCode)!
                    switch statusCode
                    {
                    case 200:
                        completionHandler(true)
                        break
                    default:
                        completionHandler(false)
                        break
                    }
                    break
                case .failure:
                    completionHandler(false)
                    break
                }
            }
        } catch
        {
            print(error.localizedDescription)
        }
    }
    
}
extension Sequence
{
    public func toDictionary<K: Hashable, V>(_ selector: (Iterator.Element) throws -> (K, V)?) rethrows -> [K: V] {
        var dict = [K: V]()
        for element in self {
            if let (key, value) = try selector(element) {
                dict[key] = value
            }
        }

        return dict
    }
}
