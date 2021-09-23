//
//  RateList_TableViewCell.swift
//  Poultry Rates
//
//  Created by Faisal Raza on 18/11/2019.
//  Copyright © 2019 Zaryans Group. All rights reserved.
//

import UIKit

class RateList_TableViewCell: UITableViewCell
{

    @IBOutlet weak var View_EditRate: UIView!
    @IBOutlet weak var lbCityName: UILabel!
    @IBOutlet weak var tfTodayRate: UITextField!
    @IBOutlet weak var viewTodayRate: UIView!
    @IBOutlet weak var tfYesterdayRate: UITextField!
    @IBOutlet weak var tfEditTodayRate: UITextField!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }
    
}
