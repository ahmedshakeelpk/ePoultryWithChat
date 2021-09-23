//
//  DatePicker_ViewController.swift
//  ePoltry
//
//  Created by Faisal Raza on 03/12/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class DatePicker_ViewController: UIViewController
{

    @IBOutlet weak var user_datepicker: UIDatePicker!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    func getDate(date: Date)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone.current
        let time = dateFormatter.string(from: date)
        print(time)
    }
    
    @IBAction func Action_Ok(_ sender: Any)
    {
        let date = "\(self.user_datepicker.date)".split(separator: " ")
            
        UserDefaults.standard.set("\(date[0])", forKey: "ShowDate")
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone.current
        let time = dateFormatter.string(from: self.user_datepicker.date)
              
        NotificationCenter.default.post(name: .dateView, object: nil)
              
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Action_Cancel(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerChange(_ sender: UIDatePicker)
       {
           let date = "\(self.user_datepicker.date)".split(separator: " ")
           
           //let timePart = "\(date[1])".split(separator: ":")
           //self.lbDateMonth.text = "\(date[0]) \(timePart[0]):\(timePart[1])"
           
           let dateFormatter = DateFormatter()
           dateFormatter.timeStyle = DateFormatter.Style.short
           dateFormatter.timeZone = TimeZone.current
           let time = dateFormatter.string(from: sender.date)
           
           print(time)
       
    }
    
}
extension Notification.Name
{
    static let dateView = Notification.Name("DatePicker")
    static let noReturn = Notification.Name("noReturn")
    
}
