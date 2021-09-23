//
//  Channels.swift
//  ePoltry
//
//  Created by MacBook Pro on 26/04/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class Channels: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    var isChannelRequest = false
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var colv: UICollectionView!
    @IBOutlet weak var btnaddchannel: UIButton!
    @IBAction func btnaddchannel(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "AddNewChannel") as! AddNewChannel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        if arrUserId.count == 0 {
            GetAllchannels()
        }
    }
    
    override func viewDidLoad() {
        if isChannelRequest {
            let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
            self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
            //MARK:- Navigation Title Multilines
            obj.navigationTwoLineTitle(topline: "ePoultry", bottomline: "Smart Poultry System", viewcontroller: self)
            self.colv.frame = self.view.frame
        }
        // Do any additional setup after loading the view.
        GetAllchannels()
        btnaddchannel.layer.cornerRadius = btnaddchannel.frame.width / 2
        
        // MARK : - Remove Notification
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(GetAllchannels), name: NSNotification.Name(rawValue: "GetAllchannels"), object: nil)
        colv.register(UINib(nibName: "ChannelsColCell", bundle: .main), forCellWithReuseIdentifier: "ChannelsColCell")
        super.viewDidLoad()
    }
    
    @objc func btnback(){
        self.navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = 5.0
        let width = (self.colv.frame.size.width / 2) - CGFloat(2 * margin)
        return CGSize(width: width, height: width  + 40)
//        if arrStatus[indexPath.row] as! String == "Blocked" || arrStatus[indexPath.row] as! String == "Rejected"
//        {
//            return CGSize(width: 0, height: 0)
//        }
//        else if arrRequestStatus[indexPath.row] as? Int ?? 0 == 1{
//            return CGSize(width: width, height: width  + 60)
//        }
//        else
//        {
//            return CGSize(width: 0, height: 0)
//        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isChannelRequest {
            return arrChannelId.count
        }
        else {
            return arrRemoveIndexes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colv.dequeueReusableCell(withReuseIdentifier: "ChannelsColCell", for: indexPath) as! ChannelsColCell
        var index = indexPath.row
        if isChannelRequest {
            let tempChannelStatus = arrRequestStatus[indexPath.row] as! Int
            //MARK:- If Admin come from Channel Request
            if tempChannelStatus == 1{
                cell.lbltitle.textColor = .green
                cell.lbldesc.textColor = .green
            }
            else if tempChannelStatus == 2 {
                cell.lbltitle.textColor = .red
                cell.lbldesc.textColor = .red
            }
            else {
                cell.lbltitle.textColor = .black
                cell.lbldesc.textColor = .gray
            }
        }
        else {
            //MARK:- If Normal user come
            index = arrRemoveIndexes[index]
        }
        
        cell.contentView.layer.borderColor = edgeColor.cgColor
        cell.contentView.layer.borderWidth = 1
        let url = NSURL(string: imagepath + "\(arrthumbnail[index] as! String)")
        if url != nil{
            cell.imgv.kf.setImage(with: url! as URL)
        }
        cell.contentView.layer.cornerRadius = 5

        cell.lbltitle.text = arrTitle[index] as? String
        cell.lbldesc.text = arrDescription[index] as? String
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isChannelRequest {
            channelSetting(indexPath: indexPath)
        }
        else {
            let vc = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "PageViewChannels") as! PageViewChannels
            guard let cell = self.colv.cellForItem(at: indexPath) as? ChannelsColCell else {
                return // or fatalError() or whatever
            }
            let index = arrRemoveIndexes[indexPath.row]
            NEWsChannelID = "\(arrChannelId[index])"
            NEWsChannelName = "\(arrTitle[index])"
            NEWsChannelDescription = "\(arrDescription[index])"
            NEWsChannelTags = "\(arrTags[index])"
            if cell.imgv.image == nil {
                NEWsHeaderimage = UIImage(named: "groupimg")!
            }
            else {
                NEWsHeaderimage = cell.imgv.image!
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func channelSetting(indexPath: IndexPath) {
        let index = indexPath.row
        let alert = UIAlertController(title: arrTitle[index] as? String, message: arrDescription[index] as? String, preferredStyle: .alert)
        
        let edit = UIAlertAction(title: "Edit", style: .default) { (action) in
            self.funEdit(indexPath: indexPath)
        }
        let approved = UIAlertAction(title: "Approv", style: .default)
        { (action) in
            self.funChangeStatusChannelRequest(requestStatus: "1", status: "Approved", index: index)
        }
        let reject = UIAlertAction(title: "Reject", style: .default)
        { (action) in
            self.funChangeStatusChannelRequest(requestStatus: "2", status: "Rejected", index: index)
        }
        let block = UIAlertAction(title: "Block", style: .default)
        { (action) in
            self.funChangeStatusChannelRequest(requestStatus: "0", status: "Blocked", index: index)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        { (action) in

        }
        alert.addAction(edit)
        let tempRequestStatus = arrRequestStatus[index] as! Int
        if tempRequestStatus == 1 {
            alert.addAction(block)
        }
        else if tempRequestStatus == 2 {
            alert.addAction(approved)
        }
        else {
           alert.addAction(approved)
           alert.addAction(reject)
        }
        alert.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var arrChannelId = [Any]()
    var arrCreatedBy = [Any]()
    var arrCreatedon = [Any]()
    var arrDescription = [Any]()
    var arrIsActive = [Any]()
    var arrRequestStatus = [Any]()
    var arrStatus = [Any]()
    var arrTags = [Any]()
    var arrTitle = [Any]()
    var arrType = [Any]()
    var arrUpdatedby = [Any]()
    var arrUpdatedon = [Any]()
    var arrUserId = [Any]()
    var arrthumbnail = [Any]()
    
    @objc func GetAllchannels() {
        // let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"channels"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
            responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            self.arrRemoveIndexes = [Int]()
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                let dataarr = (datadic.value(forKey: "data") as! NSArray)
                                self.arrChannelId = dataarr.value(forKey: "ChannelId") as! [Any]
                                self.arrCreatedBy = dataarr.value(forKey: "CreatedBy") as! [Any]
                                self.arrCreatedon = dataarr.value(forKey: "Createdon") as! [Any]
                                self.arrDescription = dataarr.value(forKey: "Description") as! [Any]
                                self.arrIsActive = dataarr.value(forKey: "IsActive") as! [Any]
                                self.arrRequestStatus = dataarr.value(forKey: "RequestStatus") as! [Any]
                                self.arrStatus = dataarr.value(forKey: "Status") as! [Any]
                                self.arrTags = dataarr.value(forKey: "Tags") as! [Any]
                                self.arrTitle = dataarr.value(forKey: "Title") as! [Any]
                                self.arrType = dataarr.value(forKey: "Type") as! [Any]
                                self.arrUpdatedby = dataarr.value(forKey: "Updatedby") as! [Any]
                                self.arrUpdatedon = dataarr.value(forKey: "Updatedon") as! [Any]
                                self.arrUserId = dataarr.value(forKey: "UserId") as! [Any]
                                self.arrthumbnail = dataarr.value(forKey: "thumbnail") as! [Any]
                                
//                                var tempcount = 0
//                                for temp in self.arrStatus
//                                {
//                                    if let tempp = temp as? String
//                                    {
//                                        if tempp == "Blocked" || tempp == "Rejected"
//                                        {
//                                            self.arrremoveindexes.append(tempcount)
//                                        }
//                                    }
//                                    tempcount = tempcount + 1
//                                }
                                if !self.isChannelRequest {
                                    for (index, element) in self.arrRequestStatus.enumerated(){
                                        if element as! Int == 1{
                                            self.arrRemoveIndexes.append(index)
                                        }
                                    }
                                }
                               // self.removeindex()
                                self.colv.reloadData()
                            }
                            else
                            {
                                obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                            }
                        }
                        else
                        {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else
                    {
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
    
    var arrremoveindexes = [Int]()
    var arrRemoveIndexes = [Int]()
    func removeindex() {
        arrChannelId.remove(at: arrremoveindexes)
        arrCreatedBy.remove(at: arrremoveindexes)
        arrCreatedon.remove(at: arrremoveindexes)
        arrDescription.remove(at: arrremoveindexes)
        arrIsActive.remove(at: arrremoveindexes)
        arrRequestStatus.remove(at: arrremoveindexes)
        arrStatus.remove(at: arrremoveindexes)
        arrTags.remove(at: arrremoveindexes)
        arrTitle.remove(at: arrremoveindexes)
        arrType.remove(at: arrremoveindexes)
        arrUpdatedby.remove(at: arrremoveindexes)
        arrUpdatedon.remove(at: arrremoveindexes)
        arrUserId.remove(at: arrremoveindexes)
        arrthumbnail.remove(at: arrremoveindexes)
       
        self.colv.reloadData()
    }
    
    
    func funChangeStatusChannelRequest(requestStatus: String, status: String, index: Int) {
        let url = BASEURL + "channel/\(arrChannelId[index])"
        let parameters : Parameters =
            ["UserId":USERID,
             "RequestStatus": requestStatus,
             "Status":status,
             "Title":arrTitle[index] as? String ?? "",
             "Description":arrDescription[index] as? String ?? "",
             "Type":"ChannelRequest",
             "Tags":arrTags[index] as? String ?? "",
             "IsActive":true,
             "Thumbnail":arrthumbnail[index] as? String ?? "",
             "CreatedBy":arrCreatedBy[index] as? String ?? ""]
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
            
            if error == nil && responseObject != nil {
                if (responseObject!.value(forKey: "data") as? Int) != nil {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetAllchannels"), object: nil)
                }
                else {
                    obj.showAlert(title: "Error!", message: "Error occured try again", viewController: self)
                }
            }
            else {
                if error == nil {
                    obj.showAlert(title: "Error!", message: ("error?.description"), viewController: self)
                    return
                }
                obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
            }
        })
    }
    @objc func funEdit(indexPath: IndexPath) {
        let index = indexPath.row
        let cell = colv.cellForItem(at: indexPath) as! ChannelsColCell
        NEWsChannelID = "\(arrChannelId[index])"
        NEWsChannelName = "\(arrTitle[index])"
        NEWsChannelDescription = "\(arrDescription[index])"
        NEWsChannelTags = "\(arrTags[index])"
        if cell.imgv.image == nil {
            NEWsHeaderimage = UIImage(named: "groupimg")!
        }
        else {
            NEWsHeaderimage = cell.imgv.image!
        }
        let vc = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "AddNewChannel") as! AddNewChannel
        vc.isEdit = true
        vc.channelimage = NEWsHeaderimage
        vc.channeltitle = NEWsChannelName
        vc.channeldesc = NEWsChannelDescription
        vc.channelid = NEWsChannelID
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - IndicatorInfoProvider for page controller like android
extension Channels: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "All")
        return itemInfo
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "All")
        return itemInfo
    }
}
