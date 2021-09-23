
//
//  OutGoingMsgCell.swift
//  ZedChat
//
//  Created by Apple on 27/11/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
protocol ShareChatCellDelegate: class {
    func didTapOnRow(row: NSInteger)
}
class ShareChatCell: UITableViewCell {

    weak var celldelegate: OutGoingMsgCellDelegate?
    
    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lbltextmsg: UILabel!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var imgvtype: UIImageView!
    @IBOutlet weak var imgvcheck: UIImageView!
    
    @IBOutlet weak var btnprofilepic: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func cellConfigration(row: NSInteger, delegate: OutGoingMsgCellDelegate)
    {
        btnprofilepic.tag = row
        celldelegate = delegate
    }
    
}
