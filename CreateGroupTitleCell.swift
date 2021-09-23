//
//  CreateGroupTitleCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 19/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class CreateGroupTitleCell: UITableViewCell {

    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var imgvbg: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        let newImage = imgv.image!.withRenderingMode(.alwaysTemplate)
        imgv.tintColor = appclr
        imgv.image = newImage
    }
    
}
