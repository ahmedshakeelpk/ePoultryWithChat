//
//  CallCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 19/07/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

protocol CallCellDelegate: class {
    func didTapOnRow(row: NSInteger)
}
class CallCell: UITableViewCell {
    
    weak var calldelegate: CallCellDelegate?
    
    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var imgvtype: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lbltextmsg: UILabel!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var vselection: UIView!
    @IBOutlet weak var imgvstatus: UIImageView!
    
    @IBOutlet weak var btncall: UIButton!
   
    @IBOutlet weak var btnprofilepic: UIButton!
    @IBOutlet weak var imgvcallbutton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let tableView : UITableView = self.superview?.superview as! UITableView?{
            
            let indexForCell : NSIndexPath = tableView.indexPath(for: self)! as NSIndexPath
            let row = indexForCell.row
            print("Row : \(row)")
        }
        if imgvcallbutton != nil{
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func cellConfigration(row: NSInteger, delegate: CallCellDelegate)
    {
        btnprofilepic.tag = row
       // btncall.tag = row
        calldelegate = delegate
    }
    
}
