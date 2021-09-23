//
//  RateList_Model.swift
//  Poultry Rates
//
//  Created by Faisal Raza on 21/11/2019.
//  Copyright © 2019 Zaryans Group. All rights reserved.
//

import UIKit

class RateList_Model: NSObject
{
    public var id : Int?
    public var CreatedOn:String?
    public var CreatedBy:String?
    public var Province:String?
    public var Area:String?
    public var SubArea:String?
    public var AreaId:String?
    public var SubAreaId:Int?
    public var RateCategory:String = ""
    public var Rate:Int = 0
    public var Dated:String?
    public var Updatedby:String?
    public var Updatedon:String?
    
    var isUpdate : Bool = false
    var index_Update : Int = 0
    var index_UpdateVal : String = ""
    
    required public init?(dictionary:NSDictionary)
    {
        id = dictionary["Id"] as? Int ?? 0
        CreatedOn = dictionary["CreatedOn"] as? String ?? ""
        CreatedBy = dictionary["CreatedBy"] as? String ?? ""
        Province = dictionary["Province"] as? String ?? ""
        Area = dictionary["Area"] as? String ?? ""
        SubArea = dictionary["SubArea"] as? String ?? ""
        //AreaId = dictionary["AreaId"] as? String ?? ""
        SubAreaId = dictionary["SubAreaId"] as? Int ?? 0
        RateCategory = dictionary ["RateCategory"] as? String ?? ""
        Rate = dictionary["Rate"] as? Int ?? 0
        Dated = dictionary["Dated"] as? String ?? ""
        Updatedby = dictionary ["Updatedby"] as? String ?? ""
        Updatedon = dictionary ["Updatedon"] as? String ?? ""
     }
}
