//
//  DirectoryCompanyNamesCell.swift
//  ePoltry
//
//  Created by MacBook Pro on 07/05/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class DirectoryCompanyNamesCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var lbltitle: UILabel!
    
    @IBOutlet weak var lbladdress: UILabel!
    @IBOutlet weak var imgv: MIBadgeButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
