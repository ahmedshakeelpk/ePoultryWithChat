//
//  UsersListCell.swift
//  ePoltry
//
//  Created by Apple on 11/02/2020.
//  Copyright © 2020 sameer. All rights reserved.
//

import UIKit

class UsersListCell: UITableViewCell {

    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblno: UILabel!
    @IBOutlet weak var lblcompany: UILabel!
    @IBOutlet weak var lblsource: UILabel!
    @IBOutlet weak var lblsignup: UILabel!
    @IBOutlet weak var lbladdress: UILabel!
    @IBOutlet weak var imgv: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
