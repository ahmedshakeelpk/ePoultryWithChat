//
//  EventsCell.swift
//  ePoltry
//
//  Created by MacBook Pro on 30/04/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class EventsCell: UITableViewCell {

    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var btnprofile: MIBadgeButton!
    @IBOutlet weak var lblmsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
