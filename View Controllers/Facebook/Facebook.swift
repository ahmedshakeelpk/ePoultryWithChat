//
//  Facebook.swift
//  AMPL
//
//  Created by sameer on 11/07/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class Facebook: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webv: UIWebView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        andicator.startAnimating()
    //    let strUrl =  String(format:"https://www.facebook.com/pervezmusharraf")
        let strUrl = String(format:FaceBookLink)
        DispatchQueue.main.async {
           
            self.webv.loadRequest(NSURLRequest(url: NSURL(string: strUrl)! as URL) as URLRequest)
        }
    }

   
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            self.andicator.stopAnimating()
        }
       
    }
    @objc func btnback(){
        self.navigationController?.popViewController(animated: true)
    }
}
