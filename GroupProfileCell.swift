//
//  GroupProfileCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 17/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

protocol GroupProfileCellDelegate: class {
    
}
class GroupProfileCell: UITableViewCell {

    weak var celldelegate: CreateGroupCellDelegate?
    
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblnumber: UILabel!
    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var lbladmin: UILabel!
    @IBOutlet weak var Imgvbg: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func cellConfigration(row: NSInteger, delegate: CreateGroupCellDelegate)
    {
        celldelegate = delegate
    }
    
}
