//
//  MessagingCell.swift
//  TeleMedican
//
//  Created by IOS Dev on 02/05/2018.
//  Copyright © 2018 Paragon Marketing. All rights reserved.
//

import UIKit
import GoogleMaps
class MessagingSenderCell: UITableViewCell {

    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lblmsg: UILabel!
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var imgvbg: UIImageView!
    @IBOutlet weak var imgvbgpic: UIImageView!
    @IBOutlet weak var imgvmsgstatus: UIImageView!
    @IBOutlet weak var btnplay: UIButton!
    @IBOutlet weak var vformap: GMSMapView!
    @IBOutlet weak var btnmap: UIButton!
    @IBOutlet weak var imgvplayvideo: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var lblcurrentvoicetime: UILabel!
    @IBOutlet weak var lbltotalvoicetime: UILabel!
    @IBOutlet weak var vselection: UIView!
    
    let sliderr = UISlider()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //MARK:- Need to fix it
        
        if vselection != nil{
            vselection.backgroundColor = appclrOwnMessageBg
        }
        if imgvbg != nil{
            imgvbg.layer.cornerRadius = MESSAGECELL_RADIUS
            imgvbg.backgroundColor = appclrOtherMessageBg
        }
        
        if imgvbgpic != nil{
            imgvbgpic.backgroundColor = appclrOtherMessageBg
            imgvbgpic.layer.cornerRadius = MESSAGECELL_RADIUS
        }
    }

    @IBOutlet weak var imgvsender: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
      //  updateSeekBar(slider: slider)
        //slider.value = sliderr.value
        //print(slider.value)
        if IPAD
        {
            if slider != nil{
                let ypoint = btnplay.center.y
                self.slider.frame.origin.y = ypoint - (self.slider.frame.size.height / 2)
            }
        }
        else
        {
            if slider != nil{
                self.slider.setThumbImage(UIImage.init(named: "slider"), for: .normal)
                self.btnplay.imageView?.setImageColor(color: appclr)
            }
        }
        
    }
    
   
    
//    func updateSeekBar(slider: UISlider)
//    {
//        let duration : CMTime = cmTime
//        var seconds : Float64 = CMTimeGetSeconds(duration)
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            seconds -= 1
//            if seconds == 0 {
//                print("Go!")
//                timer.invalidate()
//            } else {
//                print(self.responds)
//                self.updateTyping(slider: self.sliderr)
//            }
//        }
//
//
//
//        var currentTime = Int(audioPlayer.currentTime)
//        var duration = Int(audioPlayer.duration)
//        var total = currentTime - duration
//        var totalString = String(total)
//
//        var minutes = currentTime/60
//        var seconds = currentTime - minutes / 60
//
//        let playertime = NSString(format: "%02d:%02d", minutes,seconds) as String
//        let index = slider.tag
//        let indexPath = IndexPath(row: index, section: 0)
//        slider .setValue(Float(seconds), animated: false)
//        if arrMsgFomid[index] as! String == USERUID
//        {
//            //            let cell = self.tablev.cellForRow(at: indexPath) as! MessagingReceiverCell
//            //            if cell.btnplay.imageView?.image == UIImage.init(named: "play")
//            //            {
//            //                cell.btnplay.setImage(UIImage.init(named: "pause"), for: .normal)
//            //
//            //            }
//            //            else
//            //            {
//            //                cell.btnplay.setImage(UIImage.init(named: "play"), for: .normal)
//            //
//            //            }
//        }
//        else
//        {
//            //            let cell = self.tablev.cellForRow(at: indexPath) as! MessagingSenderCell
//            //            if cell.btnplay.imageView?.image == UIImage.init(named: "play")
//            //            {
//            //                cell.btnplay.setImage(UIImage.init(named: "pause"), for: .normal)
//            //                arrImagePlayPause[index] = "pause"
//            //
//            //                cell.slider.value = Float(audioPlayer.currentTime)
//            //                let cmTime = CMTime(seconds: audioPlayer.duration, preferredTimescale: 1000000)
//            //
//            //                let duration : CMTime = cmTime
//            //                let seconds : Float64 = CMTimeGetSeconds(duration)
//            //
//            //                cell.slider.maximumValue = Float(seconds)
//            //                cell.slider.isContinuous = true
//            //                cell.slider.tintColor = UIColor.green
//            //            }
//            //            else
//            //            {
//            //                cell.btnplay.setImage(UIImage.init(named: "play"), for: .normal)
//            //                arrImagePlayPause[index] = "play"
//            //            }
//        }
//        //MARK:- Insert new row in table view
//        self.tablev.reloadRows(at: [indexPath], with: .none)
//    }

}
