//
//  ShareViewControllerCell.swift
//  SE
//
//  Created by MacBook Pro on 17/10/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit


class ShareViewControllerCell: UITableViewCell {
    @IBOutlet weak var lbltitle: UILabel!
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
