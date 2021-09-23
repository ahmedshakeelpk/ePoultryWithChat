////
////  Video&image.swift
////  AMPL
////
////  Created by sameer on 04/06/2017 Anno Domini.
////  Copyright © 2017 sameer. All rights reserved.
////
//
import UIKit
import Kingfisher
import Photos
//
//
class DisplayVideoImage: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {
//
    var videoimagename = String()
    var videoimagetag: Int?
    var strurl = String()
    var profilepic = UIImage()
    var name = ""
    
    @IBOutlet weak var scrollv: UIScrollView!
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var webv: UIWebView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    @IBOutlet weak var bgv: UIView!
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBAction func imgvpinch(_ sender: UIPinchGestureRecognizer) {
//        self.imgv.transform = self.imgv.transform.scaledBy(x: sender.scale, y: sender.scale)
//        sender.scale = 1
//
//        var contentRect = CGRect()
//        for view in self.scrollv.subviews {
//            contentRect = contentRect.union(view.frame)
//        }
//        self.scrollv.contentSize = contentRect.size
        
    }
    @IBOutlet weak var btndownload: UIButton!
    @IBOutlet weak var imgvDownload: UIImageView!
    @IBAction func btndownload(_ sender: Any) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            self.download()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    self.download()
                } else {
                    //access denied
                    obj.showToast(message: "Permission required for downloading", viewcontroller: self)
                }
            })
        }
    }
    @IBOutlet weak var btnback: UIButton!
    
    @IBAction func btnback(_ sender: Any) {
        funback()
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgv
    }
    var navBarStatus = 0
    override func viewWillAppear(_ animated: Bool) {
        //MARK : - Scroll view
        if self.navigationController?.navigationBar.isHidden == true{
            navBarStatus = 1
        }
        obj.hideNavBar(viewcontroller: self)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if navBarStatus == 1{
            obj.hideNavBar(viewcontroller: self)
        }else{
            obj.showNavBar(viewcontroller: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      //  scrollv.alwaysBounceVertical = false
     //   scrollv.alwaysBounceHorizontal = false
        
        lbltitle.text = name
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height
        
        let scrollImg: UIScrollView = UIScrollView()
        scrollImg.delegate = self
        scrollImg.frame = CGRect(x:0, y:0, width: vWidth, height: vHeight)
        scrollImg.backgroundColor = UIColor.clear
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 10.0
        
        scrollv!.addSubview(scrollImg)
        
        imgv!.layer.cornerRadius = 11.0
        imgv!.clipsToBounds = false
        scrollImg.addSubview(imgv!)
        
        bgv.layer.cornerRadius = 12
        //Marks: - Andicator
        andicator.startAnimating()
        
        webv.delegate = self
        
       // let url = URL(string:strurl)
        
        if videoimagetag == VIDEO {
            btndownload.isHidden = true
            imgvDownload.isHidden = true
            andicator.stopAnimating()
            self.title = "Video"
            imgv.isHidden = true
            scrollv.isHidden = true
            
            self.webv.allowsInlineMediaPlayback = true
            self.webv.mediaPlaybackRequiresUserAction = false
           // let url = NSURL(string: (url)!)
         //   let url_request = NSURLRequest(url: url! ,
            //                               cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad,
             //                              timeoutInterval: 20.0)
            
          //  self.webv.loadRequest(url as URLRequest)
            
            let url = NSURL(string: strurl)!
            let request = URLRequest(url: url as URL)
            self.webv.loadRequest(request)
            
            return
    
//            obj.funDownloadPlayShow(urlString: strurl, type: VIDEO, isAuto: false, isProgressBarShow: true, viewController: self) { url in
//                if url == ""{
//                    self.webv.isHidden = true
//                    self.imgv.isHidden = false
//                    self.scrollv.isHidden = false
//                    self.imgv.image = UIImage(named: "tempimg")
//                }
//                else{
//                    
//                    let url = NSURL(string: url!)!
//                    
//                    let request = URLRequest(url: url as URL)
//                    self.webv.loadRequest(request)
//                }
//            }
//            funDownloadVideoAndPlay(url: strurl, completion: { url in
//                self.webv.loadRequest(NSURLRequest(url: url!) as URLRequest)
//            })
        }
        else if videoimagetag == IMAGE {
            self.title = "Image"
            webv.isHidden = true
            
            obj.funDownloadPlayShow(urlString: strurl, type: IMAGE, isAuto: false, isProgressBarShow: true, viewController: self, completion: { url in
                if url == ""{
                    DispatchQueue.main.async {
                        self.imgv.image = UIImage(named: "tempimg")
                    }
                }
                else if let imageData = NSData(contentsOf: URL(string: url!)!) {
                    let image = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
                    DispatchQueue.main.async {
                        self.imgv.image = image
                    }
                }else{
                    DispatchQueue.main.async {
                        self.imgv.image = UIImage(named: "tempimg")
                    }
                }
            })
            andicator.stopAnimating()
        }
        else if videoimagetag == PROFILEPIC {
            webv.isHidden = true
            imgv.image = profilepic
            andicator.stopAnimating()
        }
        
//        // Marks: - Right Search button
//        let btndownload:UIBarButtonItem = UIBarButtonItem(image:UIImage(named: "download"), style: UIBarButtonItem.Style.done, target: self, action: #selector(download))
//        self.navigationItem.setRightBarButtonItems([btndownload], animated: true)
//
//        let backBtn = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funback))
//        self.navigationItem.leftBarButtonItem = backBtn
    }
    
    @objc func funback() {
        navigationController?.popViewController(animated: true)
    }
    // Marks: - Save images and videos to download directory
    @objc func download() {
        andicator.startAnimating()
        if videoimagetag == VIDEO {
            self.bgv.isHidden = false
            downloadVideo()
        }
        else if videoimagetag == IMAGE {
            let documentsDirectoryURL = try! FileManager().url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // create a name for your image
            let fileURL = documentsDirectoryURL.appendingPathComponent(videoimagename)
            
            
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try imgv.image!.pngData()!.write(to: fileURL)
                    UIImageWriteToSavedPhotosAlbum(imgv.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//                    print("Image save successfully to Library directory")
//                    obj.showAlert(title: "Successfully!", message: "Image save successfully to Library directory.", viewController: self)
                } catch {
                    print(error)
                }
            }
            else {
                UIImageWriteToSavedPhotosAlbum(imgv.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
               //// print("Image Not Added")
              //  obj.showAlert(title: "Failed!", message: "Check you Library directory maybe image with this name already exist.", viewController: self)
            }
            
            andicator.stopAnimating()
            // Marks: - Get saved picture address
                    let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
                    let filePath = documentsURL.appendingPathComponent("\(videoimagename)").path
                    if FileManager.default.fileExists(atPath: filePath) {
                       print(filePath)
                    }
        }
    }
    
    
    func downloadVideo() {
        self.andicator.startAnimating()
        let sampleURL = strurl
        
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: sampleURL), let urlData = NSData(contentsOf: url) {
                let galleryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(galleryPath)/nameX1.mp4"
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL:
                            URL(fileURLWithPath: filePath))
                    }) {
                        success, error in
                        self.andicator.stopAnimating()
                        self.bgv.isHidden = true
                        if success {
                            DispatchQueue.main.async {
                                self.bgv.isHidden = true
                                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in
                                    let alert = UIAlertController(title: "Successfully!", message: "Video save successfully to Library directory.", preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                                        DispatchQueue.main.async {
                                            DispatchQueue.main.async {
                                                self.bgv.isHidden = true
                                            }
                                        }
                                    }
                                    alert.addAction(ok)
                                    self.present(alert, animated: true)
                                })
                            }
                        }
                        if (error != nil) {
                            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in
                                self.bgv.isHidden = true
                                let alert = UIAlertController(title: "Failed!", message: (error?.localizedDescription)!, preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                                    DispatchQueue.main.async {
                                        DispatchQueue.main.async {
                                            self.bgv.isHidden = true
                                        }
                                    }
                                }
                                alert.addAction(ok)
                                self.present(alert, animated: true)
                            })
                        }
                    }
                }
            }
            else{
                self.andicator.stopAnimating()
            }
        }
    }
    
    //MARK:- Download Video and Audio
    func funDownloadVideoAndPlay(url: String,completion: @escaping (_ url: URL?) -> Void) {
        let url = URL(string: url)
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(url!.lastPathComponent)
            //print(destinationUrl)
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                self.stopandicator()
                    print("The file already exists at path")
                    completion(destinationUrl)
            } else {
                // if the file doesn't exist
                var downloadTask:URLSessionDownloadTask
                downloadTask = URLSession.shared.downloadTask(with: url!, completionHandler: { [weak self](URL, response, error) -> Void in
                    
                    do {
                        guard let URL = URL, error == nil else {
                            return }
                        try FileManager.default.moveItem(at: URL, to: destinationUrl)
                        print("File moved to documents folder")
                        completion(destinationUrl)
                        _ = Timer.scheduledTimer(timeInterval: 10.0, target: self!, selector: #selector(self?.stopandicator), userInfo: nil, repeats: false);
                    }
                    catch let error as NSError {
                        //self.player = nil
                        print(error.localizedDescription)
                        obj.showToast(message: error.localizedDescription, viewcontroller: self!)
                    } catch {
                        print("AVAudioPlayer init failed")
                        obj.showToast(message: "Video Failed ...!", viewcontroller: self!)
                    }
                })
                downloadTask.resume()
        }
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func stopandicator() {
        andicator.stopAnimating()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        andicator.stopAnimating()
    }
    
    // Added
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("\(error.localizedDescription)")
    }
}

