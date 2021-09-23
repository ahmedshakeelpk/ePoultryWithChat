//
//  MsgCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 14/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
protocol InboxMsgCellDelegate: class {
    func didTapOnRow(row: NSInteger)
}
class InboxMsgCell: UITableViewCell {

    weak var celldelegate: InboxMsgCellDelegate?
    
    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var imgvtype: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lbltextmsg: UILabel!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lblcount: UILabel!
    @IBOutlet weak var vselection: UIView!
    @IBOutlet weak var btnprofilepic: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.imgvprofile.layer.cornerRadius = self.imgvprofile.frame.height / 2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    func cellConfigration(row: NSInteger, delegate: InboxMsgCellDelegate)
    {
        celldelegate = delegate
        btnprofilepic.tag = row
    }
}
