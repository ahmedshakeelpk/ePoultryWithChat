//
//  YouTube.swift
//  ePoltry
//
//  Created by MacBook Pro on 14/10/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import youtube_ios_player_helper_swift

let CHANNEL_ID = "UC6BKACfBY2eRLoGKyVGZJpA"
let YOUTUBE_KEY = "AIzaSyCdeNPJdY9W2eEajaKFXz9DR0Am2iqxOMU"

class YouTube: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, YTPlayerViewDelegate {
    
    @IBOutlet weak var colv: UICollectionView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    let YOUTUBE_API = "https://www.googleapis.com/youtube/v3/search?key=\(YOUTUBE_KEY)&channelId=\(CHANNEL_ID)&part=snippet,id&order=date&maxResults=50"
    
    var arrYTIDs = [String]()
    var arrYTDesc = [String]()
    var arrYTDate = [String]()
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = 0.0
        let width = (self.colv.frame.size.width / 1) - CGFloat(2 * margin)
        return CGSize(width: width, height: width + 50 )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrYTIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = colv.dequeueReusableCell(withReuseIdentifier: "YouTubeCell", for: indexPath) as! YouTubeCell
        _ = cell.ytplayer.load(videoId: arrYTIDs[indexPath.row])
        //cell.ytplayer.contentMode = .scaleToFill
        cell.lbldesc.text = arrYTDesc[indexPath.row]
        cell.ytplayer.delegate = self
        let CreatedOn = arrYTDate[indexPath.row]
        var strtime = CreatedOn.replacingOccurrences(of: "T", with: " ")
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dfmatter.locale = Locale(identifier: "en_US_POSIX")
        dfmatter.timeZone = TimeZone.autoupdatingCurrent //Current time zone
        
        strtime = strtime.components(separatedBy: ".")[0]
        print(strtime)
        let agotime = obj.timeAgoSinceDate(dfmatter.date(from: strtime)!)
        cell.lbldesc.numberOfLines = 0
        cell.lbldesc.lineBreakMode = .byWordWrapping
        cell.lbldesc.text = arrYTDesc[indexPath.row] + "\n" + agotime!
        
        cell.lbldesc.sizeToFit()
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //MARK:- Cell Register
        self.colv.register(UINib(nibName: "YouTubeCell", bundle: nil), forCellWithReuseIdentifier: "YouTubeCell")
        GetYouTubeVideos()
        }
    

    
    
    func GetYouTubeVideos()
    {
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: YOUTUBE_API, completionHandler:
            {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil
                    {
                        if responseObject!.count > 0
                        {
                            let datadic = (responseObject?.value(forKey: "items") as! NSArray)
                            if datadic.count > 0
                            {
                                self.arrYTIDs = (datadic.value(forKey: "id") as! NSArray).value(forKey: "videoId") as! [String]
                            //    self.arrImgSrc = dataarr.value(forKey: "ImgSrc") as! [Any]
                                self.arrYTDesc = (datadic.value(forKey: "snippet") as! NSArray).value(forKey: "description") as! [String]
                                self.arrYTDate = (datadic.value(forKey: "snippet") as! NSArray).value(forKey: "publishedAt") as! [String]
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
    
}
