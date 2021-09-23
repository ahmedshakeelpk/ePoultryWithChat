//
//  Province_Model.swift
//  Poultry Rates
//
//  Created by Faisal Raza on 21/11/2019.
//  Copyright © 2019 Zaryans Group. All rights reserved.
//

import UIKit

class Province_Model: NSObject
{
        public var name : String?
        public var nameurdu:String?
        
    required public init?(dictionary:NSDictionary)
        {
            name = dictionary["name"] as? String ?? ""
            nameurdu = dictionary["nameurdu"] as? String ?? ""
        }
}
