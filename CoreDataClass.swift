//
//  CoreDataClass.swift
//  ZedChat
//
//  Created by MacBook Pro on 18/07/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import CoreData

class CoreDataClass: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Methods to Open, Store and Fetch data
    func updateCallRecord(datadic: [String: Any], call_type: Int, completion: @escaping (_ success: Bool?) -> Void) {
        
        //Key = column
        print("Updating Data..")
        
        let entityCallRecords = NSEntityDescription.entity(forEntityName: "CallRecords", in: context)
        
        let newCallRecordObject = NSManagedObject(entity: entityCallRecords!, insertInto: context)
        
        updateRecord(datadic: datadic, call_type: call_type, newCallRecordObject: newCallRecordObject, completion: { (success) in
            completion(success)
            self.funRefreshCallScreen()
        })
    }
    
    // MARK: Methods to Open, Store and Fetch data
    func updateRecord(datadic: [String: Any], call_type: Int, newCallRecordObject: NSManagedObject, completion: @escaping (_ success: Bool?) -> Void) {
        //Key = column
        print("Updating Data..")
        
        let datadic = SinCallDataDic
        
        
        let temp_user_image = (datadic["current_profile"] as? String)!
        let temp_caller_no = (datadic["current_username"] as? String)!

        
        let temp_group_id = (datadic["firebase_group_id"] as? String)!

        let temp_caller_FBID = (datadic["current_fireBase_user_id"] as? String)!
        var temp_caller_Call_Id = ""
        if let tempid = datadic["id"] as? String{
            temp_caller_Call_Id = temp_caller_no + "_" + tempid
        }
 //           else{
//            let datadic = datadic as NSDictionary
//            let sindatastr = datadic.value(forKey: "sin") as! String
//
//            let dict = convertToDictionary(text: sindatastr)
//
//            if let temp = dict?["public_headers"] as? NSDictionary
//            {
//                //From IOS
//                temp_caller_Call_Id = temp.value(forKey: "user_id") as! String
//            }
//        }
        
//        callUser_Picture = (datadic["current_profile"] as? String)!
        let timespam = Date().currentTimeMillis()!
        newCallRecordObject.setValue(timespam, forKey: "call_date")
        newCallRecordObject.setValue(temp_user_image, forKey: "user_image")
        newCallRecordObject.setValue(temp_caller_no, forKey: "caller_no")
        newCallRecordObject.setValue(temp_group_id, forKey: "group_id")
        newCallRecordObject.setValue(temp_caller_FBID, forKey: "caller_FBID")
        newCallRecordObject.setValue(temp_caller_Call_Id, forKey: "call_id")
        newCallRecordObject.setValue("value", forKey: "call_duration")
        newCallRecordObject.setValue(call_type, forKey: "call_type")
        
        do {
            try context!.save()
            completion(true)
        } catch _ {
            print("Something went wrong.")
            completion(false)
        }
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func deleteAllData(entityName:String){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var count = 0
            //            let dataArray = result as NSArray
            //            let dataArray2nd = dataArray
            for data in result as! [NSManagedObject] {
                //                if let temp = data.value(forKey: "wifi_data") as? String{
                //                    print(temp)
                //                }else{
                //
                //                }
                print("data: \(data)")
                context.delete(data)
                try context.save()
                print("\(count)")
                // let groupid = data.value(forKey: "groupid") as! String
                //let age = data.value(forKey: "age") as! String
                // print("User Name is : "+groupid+" and Age is : "+age)
                
                count += 1
            }
            funRefreshCallScreen()
            
        } catch {
            print("Fetching data Failed")
        }
    }
    
    func funRefreshCallScreen(){
        DispatchQueue.main.async {
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "funRefresh"), object: nil)
        }
    }
}
