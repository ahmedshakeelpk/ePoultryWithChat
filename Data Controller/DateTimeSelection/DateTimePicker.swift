//
//  DateTimeSelection.swift
//  ePoltry
//
//  Created by Apple on 14/02/2020.
//  Copyright © 2020 sameer. All rights reserved.
//

import UIKit

protocol DateTimeDelegate {
    func selectedDateTime(selectedDateTime: String, isTime: Bool)
}
class DateTimePicker: UIViewController {
    var isTime : Bool = false
    var isPresent = false
    
    var delegate: DateTimeDelegate?
    @IBOutlet weak var bgvDetails: UIView!
    @IBOutlet weak var bgvTitle: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblDateMonth: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    
    @IBAction func btnCancel(_ sender: Any) {
        if isPresent {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func btnSelect(_ sender: Any) {
        let date = "\(self.datePicker.date)".split(separator: " ")
        let joinedDate = date[0].split(separator: "-")
        let date_update = "\(joinedDate[1])-\(joinedDate[2])-\(joinedDate[0])"
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone.current
        let time = dateFormatter.string(from: self.datePicker.date)
        self.lblDateMonth.text = "\(date_update) \(time)"
        if isTime {
            delegate?.selectedDateTime(selectedDateTime: time, isTime: isTime)
        }
        else {
            delegate?.selectedDateTime(selectedDateTime: date_update, isTime: isTime)
        }
        
        if isPresent {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(funback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
        
        if isTime {
            datePicker.datePickerMode = .time
            self.title = "Select Time"
        }
        else if isTime == false{
            datePicker.datePickerMode = .date
            self.title = "Select Date"
        }
        else {
            self.title = "Select Date & Time"
        }
        
        bgvTitle.backgroundColor = appclr
        btnCancel.backgroundColor = .red
        btnSelect.backgroundColor = appclr
        
        funDatePicker()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func funback(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func datePicker(_ sender: Any) {
        funDatePicker()
    }
    
    func funDatePicker() {
        let calendar = Calendar.current
        let crrent_date = Date()
        let year = calendar.component(.year, from: crrent_date)
        self.lblYear.text = "\(year)"
        
        let date = "\(self.datePicker.date)".split(separator: " ")
        let timePart = "\(date[1])".split(separator: ":")
        self.lblDateMonth.text = "\(date[0]) \(date[1])"
        self.lblDateMonth.text = "\(date[0])       \(timePart[0]):\(timePart[1])"
    }
}


