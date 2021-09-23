//
//  ContactsCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 22/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {

    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblnumber: UILabel!
    @IBOutlet weak var btninvite: UIButton!
    @IBOutlet weak var imgvbg: UIView!
    @IBOutlet weak var btnprofilepic: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btninvite.backgroundColor = appclr
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
