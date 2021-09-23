//
//  Twitter.swift
//  AMPL
//
//  Created by sameer on 11/07/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class Twitter: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        andicator.startAnimating()
        //let strUrl =  String(format:"https://twitter.com/@apmlofficial_")
        let strUrl =  String(format:TwitterLink)
        
        DispatchQueue.main.async {
            self.webview.loadRequest(NSURLRequest(url: NSURL(string: strUrl)! as URL) as URLRequest)
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
