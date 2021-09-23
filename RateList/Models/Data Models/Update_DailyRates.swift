//
//  Update_DailyRates.swift
//  Poultry Rates
//
//  Created by Faisal Raza on 25/11/2019.
//  Copyright © 2019 Zaryans Group. All rights reserved.
//

import UIKit

class Update_DailyRates: NSObject
{
    public var id : Int?
    public var CreatedOn:String?
    public var CreatedBy:String?
    public var AreaId:String?
    var RateId : String = ""
    var Province : String = ""
    var Area : String = ""
    var SubArea : String = ""
    var SubAreaId : String = ""
    var RateCategory : String = ""
    var Rate : String = ""
    var Dated : String = ""
    var UpdatedBy : String = ""
    public var Updatedon:String?
    
    var isUpdate : Bool = false
    var index_Update : Int = 0
    var index_UpdateVal : String = ""
}
