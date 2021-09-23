//
//  SingleTone.swift
//  ZedChat
//
//  Created by MacBook Pro on 25/07/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

public class SingleTone: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        USER_IMAGE_PATH = ""
    }
    
    
    static func User_Image_Path() -> String
    {
        return USER_IMAGE_PATH
    }
    
    static func Group_Image_Path() -> String
    {
        return GROUP_IMAGE_PATH
    }
    
    static func findCallerName(number: String) -> String
    {
        return obj.getContactNameFromNumber(contactNumber:"\(number)")
        
    }

}
