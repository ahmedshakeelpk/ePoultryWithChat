//
//  DirectoryCitiesCell.swift
//  ePoltry
//
//  Created by MacBook Pro on 07/05/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class DirectoryCitiesCell: UITableViewCell {

    @IBOutlet weak var imgv: MIBadgeButton!
    @IBAction func imgv(_ sender: Any) {
    }
    @IBOutlet weak var lbltitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
