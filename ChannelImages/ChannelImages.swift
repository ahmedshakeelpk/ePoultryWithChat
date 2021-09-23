//
//  ChannelImages.swift
//  ePoltry
//
//  Created by Apple on 05/11/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import Alamofire
import XLPagerTabStrip

class ChannelImages: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var colv: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = 5.0
        if indexPath.section == 0{
            if NEWsChannelSEARCHTags == "All" || NEWsChannelSEARCHTags == ""{
                return CGSize(width: 0, height: 0)
            }
            else{
                let width = (self.view.frame.size.width) - 10
                if IPAD{
                    return CGSize(width: width, height: 65)
                }
                return CGSize(width: width, height: 35)
            }
        }
        else{
            let width = (self.colv.frame.size.width / 3) - CGFloat(2 * margin)
            return CGSize(width: width, height: width)
        }
    }
    //MARK: - Activity andicator with footer view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tempdic = ["colv": colv]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scrollviewScroll"), object: tempdic)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return arrImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = colv.dequeueReusableCell(withReuseIdentifier: "ChannelIImagesTagFilterCell", for: indexPath) as! ChannelIImagesTagFilterCell
            
            cell.lbldesc.numberOfLines = 0
            cell.lbldesc.lineBreakMode = .byWordWrapping
            cell.lbldesc.text = NEWsChannelSEARCHTags
            cell.lblFilterTag.text = "Filter Tag"
            cell.lbldesc.sizeToFit()
            return cell
        }
        
        let cell = colv.dequeueReusableCell(withReuseIdentifier: "ChannelImagesCell", for: indexPath) as! ChannelImagesCell
        let url = URL(string: imagepath + "\(arrImages[indexPath.row] as! String)")
        cell.imgv.kf.setImage(with: url)
        //cell.imgv.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            return
        }
        let tag = indexPath.row
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        vc.videoimagetag = IMAGE
        vc.videoimagename = arrImages[tag] as? String ?? ""
        
        obj.funForceDownloadPlayShow(urlString: imagepath + "\(arrImages[tag])", isProgressBarShow: true, viewController: self, completion: {
            url in
            
            if url == ""{
                vc.profilepic = UIImage(named: "tempimg")!
            }
            else{
                vc.strurl = url!
            }
            //MARK:- Reload image row after download
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }

    var arrImages = NSArray()
    override func viewWillAppear(_ animated: Bool) {
        GetAllChannelImages()
        let tempdic = ["colv": colv]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scrollviewScroll"), object: tempdic)                                                                                           
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        colv.delegate = self
        // Do any additional setup after loading the view.
        GetAllChannelImages()
        
        self.colv.register(UINib(nibName: "ChannelImagesCell", bundle: nil), forCellWithReuseIdentifier: "ChannelImagesCell")
        self.colv.register(UINib(nibName: "ChannelIImagesTagFilterCell", bundle: nil), forCellWithReuseIdentifier: "ChannelIImagesTagFilterCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationshowNewsPost), name: NSNotification.Name(rawValue: "newspost"), object: nil)
        }
        //Marks: - Handle Notification
        @objc func handleNotificationshowNewsPost(notification: Notification)
        {
            GetAllChannelImages()
        }

    // Get Location Name from Latitude and Longitude
    func GetAllChannelImages()
    {
        arrImages = NSArray()
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String
        {
            userid = tempid
        }
        else
        {
            userid = ""
        }
        
        let url = BASEURL + "news/\(NEWsChannelID)/channel?channelid=\(NEWsChannelID)&userId=\(userid)&type=All&subType=\("image")&hashtag=\(NEWsChannelSEARCHTags)&limit=\(40)&offset=\(0)&eventDate=\(NEWsChannelEventDate)&FromDate=\(NEWsChannelFromDate)&ToDate=\(NEWsChannelToDate)&search=\(NEWsChannelSEARCHTitle)"
        
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:
            {
                responseObject, error in
                self.andicator.stopAnimating()
               
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil
                    {
                        if responseObject!.count > 0
                        {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0
                            {
                                let dataarray = datadic.value(forKey: "Data") as! NSArray
                                if dataarray.count > 0{
                                    self.arrImages = dataarray.value(forKey: "ImagePath") as! NSArray
                                    self.colv.reloadData()
                                }
                                else{
                                    self.colv.reloadData()
                                }
                            }
                            else
                            {
                                self.colv.reloadData()
                                //obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
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
}


// MARK: - IndicatorInfoProvider for page controller like android
extension ChannelImages: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "PHOTOS")
        return itemInfo
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "PHOTOS")
        return itemInfo
    }
}
