//
//  Server Calls.swift
//  Poultry Rates
//
//  Created by Faisal Raza on 18/11/2019.
//  Copyright © 2019 Zaryans Group. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

public var ApiCheck = Bool()
public var Api_Message = String()

class ServerCalls:NSObject
{
    static let shareInstance = ServerCalls()
    var Error_Messge:String?
    typealias CompletionBlock = ((_ saveData:Int,_ data:AnyObject? ,_ message:String?) -> Void)
    
    //MARK:- Province API
    func Province_API(completionBlock:@escaping CompletionBlock)
    {
        let URL_string : String = "\(DomainUrl)\(province)"
        
        let url_Rates : URL = URL(string: URL_string) ?? URL(string: "\(DomainUrl)/province")!
        headers = [:]
        
        NetworkHelper.ShareInstance.callEndPoint(url: url_Rates, message: "Rates retrieved successfully", method: .get, httpHeaders: headers, completion:
            { (responce,error) in
                
                guard let responseValue = responce else
                {
                    self.Error_Messge = error ?? ""
                    return
                }
            
            self.Rate_handleApiResponce(responce: responseValue,error: error, completionBlock: completionBlock)
        })
    }
    
    //MARK:- Daily Rates
    func Post_DailyRate(Rates:Data , todayDate : String,completionHandler:@escaping CompletionBlock)
       {
            for data_Index in 0..<ratelistVM.RateListData_Arr.count
            {
                let index_Today = ratelistVM.RateListData_Arr[data_Index]
                
                if index_Today.isUpdate == true
                {
                    let Data : NSDictionary =
                        [
                            "Province":"\(index_Today.Province ?? "")",
                            //"Area":"\(index_Today.Area ?? "")",
                            "SubArea":"\(index_Today.SubArea ?? "")",
                            "SubAreaId":"\(index_Today.SubAreaId ?? 0)",
                            "RateCategory":"\(index_Today.RateCategory)",
                            "Rate":index_Today.Rate,
                            "Dated":todayDate,
                            "CreatedBy" : index_Today.CreatedBy ?? ""
                        ]
                    update_Items_dic.append(Data)
                }
            }
        
        var url = "\(DomainUrl)\(post_dailyrates)"
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        headers = [:]
           
         var request = URLRequest(url: URL.init(string: url)!)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
           
            let jsonData = try JSONSerialization.data(withJSONObject: update_Items_dic, options: .prettyPrinted)
        
            request.httpBody =  jsonData
            Alamofire.request(request).responseJSON
                {(response) in

                print("Success: \(response)")
                
                    
                /*if response.result.value != nil
                   {
                       guard let responseValue = response.result.value as? [String:AnyObject] else
                       {
                           print("Sorry Ur Data Is Damagged")
                           return
                       }
                       completion(responseValue,nil)
                   }
                   else
                   {
                       if let data = response.data
                       {
                           let json = String(data: data, encoding: String.Encoding.utf8)
                           completion([:],json)
                       }
                   }*/
                    
                switch response.result
                {
                case .success:
                  
                    let statusCode: Int = (response.response?.statusCode)!
                    switch statusCode
                    {
                    case 200:
                        completionHandler(1, nil, "Today rate add Successfull")
                        break
                    default:
                        
                        completionHandler(0, nil, "We are facing error. Please try again later.")
                        break
                    }
                    break
                case .failure:
                        completionHandler(0, nil, "We are facing error. Please try again later.")
                    break
                }
            }
        } catch
        {
            print(error.localizedDescription)
        }
    }
   
        
    
    func DailyRates(todayDate : String , province : String, rateCategory : String , completionBlock:@escaping CompletionBlock)
    {
        var URL_string = "\(DomainUrl)\(dailyrates)\(todayDate)&province=\(province)&rateCategory=\(rateCategory)"
        URL_string = URL_string.replacingOccurrences(of: " ", with: "%20")
        //let url_Rates : NSURL = NSURL(string: URL_string)
        
        let url_Rates : URL = URL.init(string: URL_string)!
        
        headers = [:]
        
        NetworkHelper.ShareInstance.callEndPoint(url: url_Rates as URL, message: "Rates retrieved successfully", method: .get, httpHeaders: headers, completion:
        { (responce,error) in
                
                guard let responseValue = responce else
                {
                    self.Error_Messge = error ?? ""
                    return
                }
            
            self.Rate_handleApiResponce(responce: responseValue,error: error, completionBlock: completionBlock)
        })
    }
    
    
    func Rate_handleApiResponce(responce:[String:AnyObject],error :String?,completionBlock:@escaping CompletionBlock)
       {
           if error == nil
           {
               guard let responceSuccess = responce["success"] else
               {
                    ApiCheck  = false; return print("Success Message is 0")
                }
               completionBlock(responceSuccess as? Int ?? 1,responce as AnyObject,nil)
           }
           else
           {
               let errors = jsonSerialize(erorrString: error ?? "")
               let errorCount : Int = errors.count ?? 0
               if errorCount > 0
               {
                   let complete_Erorr_String = removeSpecialCharsFromString(text: errors[0])
                   completionBlock(0,nil,complete_Erorr_String)
               }
               else
               {
                   completionBlock(0,nil,"Please try again later.")
               }
           }
       }
}

extension ServerCalls
{
    func jsonSerialize(erorrString: String) ->[String]
    {
        let data = Data(erorrString.utf8)
        var erorr_String = [String]()
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // try to read out a string array
                if let names = json["errors"] as? NSDictionary {
                    for (_,value) in names
                    {
                        let object_String = value as AnyObject
                        erorr_String.append(String(describing: object_String))
                    }
                }
            }
            return erorr_String
        }
        catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            return []
        }
    }
    func removeSpecialCharsFromString(text: String) -> String
    {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ./")
        return text.filter {okayChars.contains($0) }
    }

}
