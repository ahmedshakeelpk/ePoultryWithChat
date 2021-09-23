//
//  SubCategoryCell.swift
//  ePoltry
//
//  Created by MacBook Pro on 16/09/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class SubCategoryCell: UITableViewCell {

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
