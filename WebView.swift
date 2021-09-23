//
//  WebView.swift
//  ZedChat
//
//  Created by MacBook Pro on 17/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import WebKit

class WebView: UIViewController, WKUIDelegate, WKNavigationDelegate, UIWebViewDelegate {


    @IBOutlet weak var andicator: UIActivityIndicatorView!
    var link = String()
    var strtitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = strtitle
        self.andicator.startAnimating()
        if strtitle == "Help"{
            self.title = "Contact Help"
             let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            let string = "If some of your friends don't appear in the contacts list, we recommend the following steps:\n\n<ul style=\"list-style-type:square;\"><li>Make sure that your friend's phone number is in your address book.</li></ul>\n<ul style=\"list-style-type:square;\"><li>Make sure that your friend is using \(APPBUILDNAME) App.</li>"
            webView.loadHTMLString("<html><body><p>\(string)</p></body></html>", baseURL: nil)
            webView.delegate = self
            self.view.addSubview(webView)
        }
        
        // Do any additional setup after loading the view.
        else if #available(iOS 10.0, *) {
            let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            self.view.addSubview(webView)
            
            webView.delegate = self
            let url = URL(string: link)
            webView.loadRequest(URLRequest(url: url!))

            //    http://zedchat.net/Privacy_Policy.html
            //    http://zedchat.net/Terms_Of_Use.html
            andicator.sendSubviewToBack(webView)
          
        }
        else {
            let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            self.view.addSubview(webView)
            
            webView.uiDelegate = self
            webView.navigationDelegate = self
            let url = URL(string: link)
            webView.load(URLRequest(url: url!))
            
            andicator.sendSubviewToBack(webView)
        }
        
        //MARK:- Back Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(funback))
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { timer in
                self.andicator.stopAnimating()
                
            }
        
    }
    
    @objc func funback()
    {
        self.navigationController?.popViewController(animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        andicator.stopAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        andicator.stopAnimating()
    }
}
