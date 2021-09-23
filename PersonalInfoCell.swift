//
//  PersonalInfoCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 24/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class PersonalInfoCell: UITableViewCell {

    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblselection: UILabel!
    @IBOutlet weak var imgvarrow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
