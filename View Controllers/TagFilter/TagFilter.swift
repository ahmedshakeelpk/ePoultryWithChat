//
//  TagFilter.swift
//  ePoltry
//
//  Created by Apple on 11/11/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import DropDown

protocol TagFilterDelegate: class {
    func tableViewTag(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func search(searchTag: String, dateStr: String, dateStrFrom: String, dateStrTo: String, searchTitle: String)
}

class TagFilter: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAdaptivePresentationControllerDelegate {
   
    var tempFromDate = ""
    var tempToDate = ""
    let dropDown = DropDown()
    
    @IBOutlet weak var headerv: UIView!
    
    
    var dataSourceSelectedCheck = [String]()
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var btnclose: UIButton!
    weak var delegate: TagFilterDelegate?
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var txtdate: UITextField!
    @IBOutlet weak var txtsearchtitle: UITextField!
    
    @IBAction func txtdatefun(_ sender: Any) {
        txtdate.resignFirstResponder()
      
        let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.year = 30
        let maxDate = calendar.date(byAdding: comps, to: Date())
        comps.year = -20
        let minDate = calendar.date(byAdding: comps, to: Date())
        
       // Simple Date and Time Picker
        RPicker.selectDate(title: "Select Date", datePickerMode: .date, minDate: minDate, maxDate: maxDate, didSelectDate: { (selectedDate) in
                    // TODO: Your implementation for date
            print(selectedDate)
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "MM/dd/yyyy"
            print(dateFormatterGet.string(from: selectedDate))
            self.txtdate.text = dateFormatterGet.string(from: selectedDate)
            
            self.txtdropdown.text = ""
            
            self.tempFromDate = ""
            self.tempToDate = ""
        })
    }
    @IBOutlet weak var btnremovetag: UIButton!
    
    @IBAction func btnremovetag(_ sender: Any) {
        removeVerificationPopup(viewController: self)
        delegate?.search(searchTag: "All", dateStr: "", dateStrFrom: "", dateStrTo: "", searchTitle: "")
    }
    @IBOutlet weak var btnsearch: UIButton!
    @IBAction func btnsearch(_ sender: Any) {
        var tempSelectedTag = "All"
        if dataSourceSelectedCheck.count > 0 {
//            obj.showAlert(title: "Alert!", message: "Please select tag before search", viewController: self)
//            return
            let tempSelectedData = dataSourceSelectedCheck as NSArray
            tempSelectedTag = tempSelectedData.componentsJoined(by: ",")
        }
        removeVerificationPopup(viewController: self)
        delegate?.search(searchTag: (tempSelectedTag), dateStr: txtdate.text!, dateStrFrom: tempFromDate, dateStrTo: tempToDate, searchTitle: txtsearchtitle.text!)
        
    }
    @IBAction func btnclose(_ sender: Any) {
        removeVerificationPopup(viewController: self)
    }
    
    @IBOutlet weak var txtdropdown: UITextField!
    var arrDataSource: NSArray?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "TagFilterCell") as! TagFilterCell
        cell.lbltitle.text = arrDataSource?[indexPath.row] as? String ?? ""
        
        if dataSourceSelectedCheck.contains(arrDataSource![indexPath.row] as! String){
            cell.imgvcheck.image = UIImage(named: "circlecheck")
        }
        else{
            cell.imgvcheck.image = UIImage(named: "circleuncheck")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate!.tableViewTag(tableView, didSelectRowAt: indexPath)
        
        self.tablev.beginUpdates()
        let cell = self.tablev.cellForRow(at: indexPath) as! TagFilterCell
        if (cell.imgvcheck.image?.isEqualToImage(image: UIImage(named: "circleuncheck")!))!
        {
            cell.imgvcheck.image = UIImage(named: "circlecheck")
            dataSourceSelectedCheck.append(arrDataSource![indexPath.row] as! String)
        }
        else
        {
            cell.imgvcheck.image = UIImage(named: "circleuncheck")
            let index = dataSourceSelectedCheck.firstIndex(of: arrDataSource![indexPath.row] as! String)
            dataSourceSelectedCheck.remove(at: index!)
        }
        self.tablev.endUpdates()
    }
    
    @IBAction func txtdropdownfun(_ sender: Any) {
        dropDown.width = txtdropdown.frame.width
        dropDown.direction = .bottom
        // The list of items to display. Can be changed dynamically
        let arrDropDown = ["All", "Last 7 days", "Last month", "Last 6 month", "Last year"]
        let arrDropDownDays = [0, 7, 1, 6, 12]
        
        
        
        self.dropDown.dataSource = arrDropDown
        dropDown.show()
        self.txtdropdown.resignFirstResponder()
        DispatchQueue.main.async {
            
        }
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dropDown.hide()
            self.txtdropdown.text = arrDropDown[index]
            
            self.txtdate.text = ""
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "MM/dd/yyyy"
            
            
            let calendar = Calendar(identifier: .gregorian)
            var comps = DateComponents()
            if arrDropDownDays[index] == 7 {
                comps.day = -7
            }
            else{
                comps.month = -(arrDropDownDays[index])
            }
            
            let minDate = calendar.date(byAdding: comps, to: Date())
            
            
            
            print(dateFormatterGet.string(from: minDate!))
            self.tempFromDate = dateFormatterGet.string(from: minDate!)
            self.tempToDate = dateFormatterGet.string(from: Date())
//            print(self.tempFromDate)
//            print(self.tempToDate)
        }
    }
    
    let btnDropDown = UIButton()
    @objc func btnDropDownFunction(sender: UIButton){
        txtdropdownfun(sender)
    }
    
    override func viewDidLoad() {
        headerv.layer.borderColor = UIColor.lightGray.cgColor
        headerv.layer.borderWidth = 1
        //tablev.layer.borderColor = UIColor.lightGray.cgColor
        //tablev.layer.borderWidth = 1
        tablev.layer.cornerRadius = 5
        headerv.autoresizesSubviews = false
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        self.tablev.register(UINib(nibName: "TagFilterCell", bundle: nil), forCellReuseIdentifier: "TagFilterCell")
        btnDropDown.addTarget(self, action: #selector(btnDropDownFunction), for: .touchUpInside)
        
        obj.txtbottomline(textfield: txtsearchtitle)
        obj.txtbottomline(textfield: txtdate)
        obj.txtbottomline(textfield: txtdropdown)
        obj.putRightButtoninTextField(btn: btnDropDown, txtfield: txtdropdown, imgname: "dropdown", x: 25, width: 20, height: 20)
        
        tablev.tableHeaderView = headerv
        tablev.tableFooterView = UIView()
        
        
        btnsearch.clipsToBounds = true
        btnsearch.layer.borderColor = appclr.cgColor
        btnsearch.layer.borderWidth = 1
        btnremovetag.clipsToBounds = true
        btnremovetag.layer.borderColor = appclr.cgColor
        btnremovetag.layer.borderWidth = 1
        self.btnsearch.layer.cornerRadius = self.btnsearch.frame.size.height / 2
        self.btnremovetag.layer.cornerRadius = self.btnremovetag.frame.size.height / 2
        self.tablev.reloadData()
        
        txtsearchtitle.delegate = self
        txtdate.delegate = self
        txtdropdown.delegate = self
        
        super.viewDidLoad()
    }
    // Marks: - Add custom popup
    static func showTagPopup(arrSource: NSArray, viewController: UIViewController)
    {
        let popvc = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "TagFilter") as! TagFilter
        popvc.arrDataSource = arrSource
        popvc.delegate = (viewController as! TagFilterDelegate)
        viewController.addChild(popvc)
        popvc.view.frame = viewController.view.frame
        popvc.view.frame.origin.y = 0
        viewController.view.addSubview(popvc.view)
        popvc.didMove(toParent: viewController)
        viewController.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        viewController.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            viewController.view.alpha = 1.0
            viewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    // Marks: - Remove custom popup
    public func removeVerificationPopup(viewController: UIViewController)
    {
        UIView.animate(withDuration: 0.25, animations: {
            viewController.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            viewController.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                viewController.willMove(toParent: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
