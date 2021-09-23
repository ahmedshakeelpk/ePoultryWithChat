//
//  RateList_ViewModel.swift
//  Poultry Rates
//
//  Created by Faisal Raza on 21/11/2019.
//  Copyright © 2019 Zaryans Group. All rights reserved.
//

import UIKit


public var DataFound = Bool()

class RateList_ViewModel: NSObject
{
    var RateListData_Arr = [RateList_Model]()
    var isTodayData_exist : Bool = false
    var RateListData_Yesterdya_Arr = [RateList_Model]()
    var isYesterdayData_exist : Bool = false
    
    var province_Arr = [Province_Model]()
    
    func ProvinceData_Add(response:AnyObject?)
           {
               guard let responciveDictionary = response as? [String:AnyObject] else {return print("Data Is Irrelivant")}
               guard let data = responciveDictionary["data"] as? NSArray else {return print("Nil Data")}
               if data.count == 0
               {
                   DataFound = false
               }
               else
               {
                   DataFound = true
                   province_Arr.removeAll()
                   
                   for contact_Data in data
                   {
                       let dictionary_Data:NSDictionary = contact_Data as! NSDictionary
                       if let data = Province_Model(dictionary: dictionary_Data)
                       {
                           self.province_Arr.append(data)
                       }
                   }
               }
           }
    
     func insertData_Testing(response:AnyObject?)
        {
            guard let responciveDictionary = response as? [String:AnyObject] else {return print("Data Is Irrelivant")}
            
            guard let data = responciveDictionary["data"] as? NSArray else
            {
                RateListData_Arr.removeAll()
                RateListData_Yesterdya_Arr.removeAll()
                return print("Nil Data")
            }
            
            let data_Last : NSArray = responciveDictionary["LastDay"] as? NSArray ?? []
            if data.count == 0
            {
            }
            else
            {
                RateListData_Arr.removeAll()
                RateListData_Yesterdya_Arr.removeAll()
                
                for contact_Data in data
                {
                    let dictionary_Data:NSDictionary = contact_Data as! NSDictionary
                    if let data_Today = RateList_Model(dictionary: dictionary_Data)
                    {
                        let nameCheck = data_Today.SubArea
                        var dataMatch : Bool = false
                    
                        for contact_Data in data_Last
                           {
                               let dictionary_Data:NSDictionary = contact_Data as! NSDictionary
                               if let data = RateList_Model(dictionary: dictionary_Data)
                               {
                                    if nameCheck == data.SubArea
                                    {
                                        self.RateListData_Arr.append(data_Today)
                                        self.RateListData_Yesterdya_Arr.append(data)
                                        dataMatch = true
                                        break
                                    }
                               }
                           }
                            if dataMatch == false
                            {
                                let dictionary_yesterday:NSDictionary = [:]
                                let emptyModel = RateList_Model(dictionary: dictionary_yesterday)
                                self.RateListData_Yesterdya_Arr.append(emptyModel!)
                                self.RateListData_Arr.append(data_Today)
                            }
                    }
                }
            }
        }
    
    //Bool is used for check wether today data exist or not if not exist then post the Data after this
    func insertData(response:AnyObject?)
       {
            guard let responciveDictionary = response as? [String:AnyObject] else {return print("Data Is Irrelivant")}
               
            guard let yesterdaydata = responciveDictionary["LastDay"] as? NSArray else
            {
                RateListData_Arr.removeAll()
                RateListData_Yesterdya_Arr.removeAll()
                return print("Nil Data")
            }
        
        
           /*guard let Todaydata = responciveDictionary["data"] as? NSArray else
           {
               RateListData_Arr.removeAll()
               RateListData_Yesterdya_Arr.removeAll()
               return print("Nil Data")
           }*/
        
            let data_Last : NSArray = responciveDictionary["data"] as? NSArray ?? []
        
           if data_Last.count == 0
           {
                isTodayData_exist = false
           }
           
           if yesterdaydata.count == 0
           {
                isYesterdayData_exist = false
           }
           else
           {
               RateListData_Arr.removeAll()
               RateListData_Yesterdya_Arr.removeAll()
               
               for contact_Data in yesterdaydata
 {
                   let dictionary_Data:NSDictionary = contact_Data as! NSDictionary
                   if let data_Yesterday = RateList_Model(dictionary: dictionary_Data)
                   {
                       let nameCheck = data_Yesterday.SubArea
                       var dataMatch : Bool = false
                   
                       for contact_Data in data_Last
                          {
                              let dictionary_Data:NSDictionary = contact_Data as! NSDictionary
                              if let data = RateList_Model(dictionary: dictionary_Data)
                              {
                                   if nameCheck == data.SubArea
                                   {
                                        /*var is_AreaExist : Bool = false
                                        for RateArea in RateListData_Arr
                                        {
                                            if RateArea.SubArea == nameCheck
                                            {
                                                is_AreaExist = true
                                                dataMatch = true
                                                break
                                            }
                                        }
                                        if is_AreaExist == false
                                        {*/
                                           self.RateListData_Arr.append(data)
                                           self.RateListData_Yesterdya_Arr.append(data_Yesterday)
                                           dataMatch = true
                                        //}
                                       break
                                   }
                              }
                          }
                       if dataMatch == false
                       {
                           let dictionary_yesterday:NSDictionary = [:]
                           let emptyModel = RateList_Model(dictionary: dictionary_yesterday)
                           
                            //self.RateListData_Yesterdya_Arr.append(emptyModel!)
                            //self.RateListData_Arr.append(data_Today)
                        
                            self.RateListData_Yesterdya_Arr.append(data_Yesterday)
                            self.RateListData_Arr.append(data_Yesterday)
                        }
                   }
               }
            
           }
       }
}
