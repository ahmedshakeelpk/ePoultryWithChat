//
//  GroupInfoNotCell.swift
//  AMPL
//
//  Created by Paragon Marketing on 19/07/2017.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class GroupInfoNotCell: UITableViewCell {

    @IBOutlet weak var lblparticpant: UILabel!
    @IBOutlet weak var btnswitch: UISwitch!
    @IBAction func btnswitch(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
