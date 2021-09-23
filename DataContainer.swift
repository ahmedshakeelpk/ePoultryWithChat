//
//  DataContainer.swift
//  Cleaning Master
//
//  Created by User on 25/01/2017.
//  Copyright © 2017 Mustajab. All rights reserved.
//

import UIKit
import Alamofire
import CoreAudioKit
import EasyTipView
import Contacts
import AVFoundation
import CZPicker
import CoreData

var czpicker = CZPickerView()
let obj = DataContainer()
let objG = GlobelSetting()
let objCDB = CoreDataClass()
var eview = EasyTipView(text: "", preferences: EasyTipView.globalPreferences)
//MARK:- if Wifi
let WIFI = obj.isWifi()
// MARK: Variables declearations of App Delegate for Core Data
let appDelegate = UIApplication.shared.delegate as! AppDelegate
var context:NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
let STATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.height


class DataContainer: UIViewController, URLSessionDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate, URLSessionTaskDelegate {
    static  var strbalance = String()
    static var straddress = String()
    static var imgurl = String()
    
    var and = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    static func baseUrlHttps() -> String {
       // let string = "http://orupartners.com/cp/redirect_to.php"
      //  let string = "http://musicbeatfox.com/app/appapi/"
        
        //let string = "http://websrv.zederp.net/Apml/"
        let string = "https://epoultryapi.zederp.net/api/"
        
        return string
    }
    //MARK: - Get WebServices
    func webServicesGetwithJsonResponse(url:String, completionHandler: @escaping (NSDictionary?, String?) -> ())
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 14
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        Alamofire.request(url).validate().responseData(completionHandler: {
            response in
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            var jsonstring = String()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonstring = utf8Text
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    
                    //print(json!)
                }
                catch let parseError {
                    print(parseError)
                    print(jsonstring)
                    print("Something went wrong")
                    print(response.description)
                    print(Error.self)
                    
                }
            }
            let data = response.result
            switch(data)
            {
            case .success(let jsonstr):
                print(jsonstr)
                if let data = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        
                        completionHandler(json! as NSDictionary, nil)
                        print(json!)
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.")
                    }
                }
                
                sessionManager.session.invalidateAndCancel()
                break
                
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.")
                    break
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, please try again.")
                    break
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
            }
            
            ///////////////////////
            switch response.result {
            case .success:
                print("Validation Successful")
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                else
                {
                    completionHandler(nil, "Not JSON Data.")
                }
                //MARK: Data in string
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
                
            case .failure(let error):
                print(error)
                completionHandler(nil, error as? String)
            }
            //////////////////////
        })
    }
    //MARK: - Post WebServices
    func webService2(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping ([NSDictionary]?, String?, [String:Any]?) -> ())
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        //        let headers: HTTPHeaders = [
        //            "Content-Type": "application/json",
        //       //     "Content-Type": "application/x-www-form-urlencoded",
        //            "Accept": "application/json"
        //        ]
        sessionManager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).responseData(completionHandler: {
            
            response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            var jsonstring = String()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonstring = utf8Text
                if jsonstring.count > 2
                {
                    do{
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        
                        print(json as Any)
                    }
                    catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        //print(url)
                    }
                }
            }
            
            let data = response.result
            switch(data)
            {
            case .success(let json):
                print(json)
                
                if let data = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary]
                        if json != nil
                        {
                            completionHandler(json! as [NSDictionary], nil, nil)
                            print(json!)
                        }
                        else
                        {
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                // print("Data: \(utf8Text)") // original server data as UTF8 string
                                jsonstring = utf8Text
                                if jsonstring.count > 2
                                {
                                    do{
                                        
                                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                                        if json != nil
                                        {
                                            completionHandler([NSDictionary](), nil, json! as [String: Any])
                                        }
                                        print(json as Any)
                                    }
                                    catch let parseError {
                                        print(parseError)
                                        print(jsonstring)
                                        print("Something went wrong")
                                        print(response.description)
                                        print(Error.self)
                                        //print(url)
                                    }
                                }
                            }
                        }
                        
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.", nil)
                    }
                }
                
                
                sessionManager.session.invalidateAndCancel()
                break
                
                //            case .success(let JSON):
                //                                    completionHandler(JSON as? NSDictionary, nil)
                //
                //                                    sessionManager.session.invalidateAndCancel()
            //                                break
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.", nil)
                    
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, request time out please try again.", nil)
                    
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription, nil)
                    
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription, nil)
                    
                }
                else
                {
                    completionHandler(nil, error.localizedDescription, nil)
                    
                }
                sessionManager.session.invalidateAndCancel()
                break
            }
        })
    }
    //MARK: - Post WebServices
    func webServiceGet3WithParameters(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping (NSDictionary?, String?) -> ())
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        //        let headers: HTTPHeaders = [
        //            "Content-Type": "application/json",
        //       //     "Content-Type": "application/x-www-form-urlencoded",
        //            "Accept": "application/json"
        //        ]
         
        
        Alamofire.request( url, method:.get, parameters: parameters).responseData(completionHandler: { (response) -> Void in
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            var jsonstring = String()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonstring = utf8Text
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    
                    //print(json!)
                }
                catch let parseError {
                    print(parseError)
                    print(jsonstring)
                    print("Something went wrong")
                    print(response.description)
                    print(Error.self)
                    
                }
            }
            let data = response.result
            switch(data)
            {
            case .success(let jsonstr):
                print(jsonstr)
                if let data = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        
                        completionHandler(json! as NSDictionary, nil)
                        print(json!)
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.")
                    }
                }
                
                sessionManager.session.invalidateAndCancel()
                break
                
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.")
                    break
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, please try again.")
                    break
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
            }
            
            ///////////////////////
            switch response.result {
            case .success:
                print("Validation Successful")
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                else
                {
                    completionHandler(nil, "Not JSON Data.")
                }
                //MARK: Data in string
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
                
            case .failure(let error):
                print(error)
                completionHandler(nil, error as? String)
            }
            //////////////////////
        })
    }
    //MARK: - Get WebServices
    func webServicesGet(url:String, completionHandler: @escaping ([Dictionary<String,Any>]?, String?) -> ()) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 14
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        Alamofire.request(url).validate().responseData(completionHandler: {
            response in
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            var jsonstring = String()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                jsonstring = utf8Text
            }
            if jsonstring != "" {
                if let data = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        if json != nil {
                           //completionHandler(json as NSDictionary?, nil)
                        }
                        else {
                           // completionHandler(nil, "Error Occrued")
                        }
                        
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.")
                    }
                }
            }
            else
            {
                
            }
            let data = response.result
            switch(data) {
            case .success(let jsonstr):
                print(jsonstr)
                if let _ = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let data = jsonstring.data(using: .utf8)!
                        do {
                            
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>] {
                                print(jsonArray) // use the json here
                                completionHandler(jsonArray, nil)
                            }
                            else if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                            }
                            else {
                                print("bad json")
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.")
                    }
                }
                
                sessionManager.session.invalidateAndCancel()
                break
                
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.")
                    break
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, please try again.")
                    break
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
            }
            
            ///////////////////////
            switch response.result {
            case .success:
                print("Validation Successful")
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                else
                {
                    completionHandler(nil, "Not JSON Data.")
                }
                //MARK: Data in string
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
                
            case .failure(let error):
                print(error)
                completionHandler(nil, error as? String)
            }
            //////////////////////
            
        })
    }
    //MARK: - Post WebServices
    func webServicePut(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping (NSDictionary?, String?) -> ())
    {
        print(url)
        print(parameters)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        let headers: HTTPHeaders = [
            //"Content-Type": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json"
        ]
        
        sessionManager.request(url, method: .put, parameters: parameters, encoding:URLEncoding.default , headers: headers).responseData(completionHandler: {
            
            response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            var jsonstring = String()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonstring = utf8Text
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    
                    print(json!)
                }
                catch let parseError {
                    print(parseError)
                    print(jsonstring)
                    print("Something went wrong")
                    print(response.description)
                    print(Error.self)
                    
                }
            }
            
            let data = response.result
            switch(data)
            {
            case .success(let json):
                print(json)
                if let data = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        
                        completionHandler(json! as NSDictionary, nil)
                        print(json!)
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.")
                    }
                }
                
                
                sessionManager.session.invalidateAndCancel()
                break
                
                //            case .success(let JSON):
                //                                    completionHandler(JSON as? NSDictionary, nil)
                //
                //                                    sessionManager.session.invalidateAndCancel()
            //                                break
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.")
                    break
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, request time out please try again.")
                    break
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
            }
        })
        
    }
    //MARK:- Show navigation bar
    func navBarColor(color: UIColor) {
        //MARK:- Hide navigation bar
        navigationController?.navigationBar.barTintColor = color
        
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //MARK: - Post WebServices
    func webServiceDelete(url:String, completionHandler: @escaping (NSDictionary?, String?) -> ())
    {
        print(url)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 14
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        sessionManager.request(url, method: .delete).responseData(completionHandler: {
            
            response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            var jsonstring = String()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonstring = utf8Text
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    
                    print(json!)
                }
                catch let parseError {
                    print(parseError)
                    print(jsonstring)
                    print("Something went wrong")
                    print(response.description)
                    print(Error.self)
                    
                }
            }
            
            let data = response.result
            switch(data)
            {
            case .success(let json):
                print(json)
                if let data = jsonstring.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        
                        completionHandler(json! as NSDictionary, nil)
                        print(json!)
                    } catch let parseError {
                        print(parseError)
                        print(jsonstring)
                        print("Something went wrong")
                        print(response.description)
                        print(Error.self)
                        
                        completionHandler(nil, "Not JSON Data.")
                    }
                }
                
                
                sessionManager.session.invalidateAndCancel()
                break
                
                //            case .success(let JSON):
                //                                    completionHandler(JSON as? NSDictionary, nil)
                //
                //                                    sessionManager.session.invalidateAndCancel()
            //                                break
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.")
                    break
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, please try again.")
                    break
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
                else
                {
                    completionHandler(nil, error.localizedDescription)
                    break
                }
            }
        })
        
    }
    
    func webService(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping (NSDictionary?, String?) -> ())
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
      //  sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON
          sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON
            {
                response in
                let data = response.result
                switch(data)
                {
                case .success(let JSON):
                    completionHandler(JSON as? NSDictionary, nil)
                    
                    sessionManager.session.invalidateAndCancel()
                    break
                    
                case .failure(let error):
                    if error._code == NSURLErrorCannotParseResponse
                    {
                        completionHandler(nil, "Not JSON Data.")
                        break
                    }
                    else if error._code == NSURLErrorTimedOut
                    {
                        completionHandler(nil, "Server is not responding, please try again.")
                        break
                    }
                    else if error._code == NSURLErrorCannotFindHost
                    {
                        completionHandler(nil, error.localizedDescription)
                        break
                    }
                    else if error._code == NSURLErrorNotConnectedToInternet
                    {
                        completionHandler(nil, error.localizedDescription)
                        break
                    }
                    else
                    {
                        completionHandler(nil, error.localizedDescription)
                        break
                    }
                }
        }

//        sessionManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON
//            {
//                response in
//                let data = response.result
//                switch(data)
//                {
//                case .success(let JSON):
//                    completionHandler(JSON as? NSDictionary, nil)
//                    
//                    sessionManager.session.invalidateAndCancel()
//                    break
//                
//                case .failure(let error):
//                    if error._code == NSURLErrorCannotParseResponse
//                    {
//                        completionHandler(nil, "Not JSON Data.")
//                        break
//                    }
//                    else if error._code == NSURLErrorTimedOut
//                    {
//                        completionHandler(nil, "Server is not responding, please try again.")
//                        break
//                    }
//                    else if error._code == NSURLErrorCannotFindHost
//                    {
//                        completionHandler(nil, error.localizedDescription)
//                        break
//                    }
//                    else if error._code == NSURLErrorNotConnectedToInternet
//                    {
//                        completionHandler(nil, error.localizedDescription)
//                        break
//                    }
//                    else
//                    {
//                        completionHandler(nil, error.localizedDescription)
//                        break
//                    }
//                }
//        }
    }
    
   
    func webServicePutUpdateUser(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping (NSDictionary?, String?) -> ())
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        //  sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON
        sessionManager.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON
            {
                response in
                let data = response.result
                switch(data)
                {
                case .success(let JSON):
                    completionHandler(JSON as? NSDictionary, nil)
                    
                    sessionManager.session.invalidateAndCancel()
                    break
                    
                case .failure(let error):
                    if error._code == NSURLErrorCannotParseResponse
                    {
                        completionHandler(nil, "Not JSON Data.")
                        break
                    }
                    else if error._code == NSURLErrorTimedOut
                    {
                        completionHandler(nil, "Server is not responding, please try again.")
                        break
                    }
                    else if error._code == NSURLErrorCannotFindHost
                    {
                        completionHandler(nil, error.localizedDescription)
                        break
                    }
                    else if error._code == NSURLErrorNotConnectedToInternet
                    {
                        completionHandler(nil, error.localizedDescription)
                        break
                    }
                    else
                    {
                        completionHandler(nil, error.localizedDescription)
                        break
                    }
                }
        }
    }
    //MARK: - Post WebServices
    func webServiceWithPictureAudioChat(url:String , parameters:Dictionary<String,Any>,imagename: String, imageData:Data, audioData:Data, viewController: UIViewController, completionHandler: @escaping ([NSDictionary]?, String?) -> ()) {
        let timespamaudio = "\(Date().currentTimeMillis()!).mp4"
        //        var headers = HTTPHeaders()
        //        headers = [
        //            //"Content-Type" :"text/html; charset=UTF-8",
        //            //"Content-Type": "application/json",
        //            "Content-Type": "application/x-www-form-urlencoded",
        //            //"Accept": "application/json",
        //            "Accept": "multipart/form-data"
        //        ]
        //        headers = [ "Content-type": "multipart/form-data",
        //                    "Accept" : "text/html; charset=UTF-8"]
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        //configuration.httpAdditionalHeaders = headers
        //configuration.urlCredentialStorage = nil
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        var tempFirst = 0
        MEDIAPROGRESS = Float()
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if imageData.isEmpty != true {
                multipartFormData.append((imageData), withName: "filename", fileName: imagename, mimeType: "image/png/jpeg/jpg")
            }
            if audioData.isEmpty != true {
                multipartFormData.append((audioData), withName: "voice", fileName: timespamaudio, mimeType: "audio/m4a/wav/mp4")
            }
        }, to: url,
           encodingCompletion: {    response in
            switch(response)
            {
                
            case .success(let upload, _, _):
                //MARK:- Handle progress
                upload.uploadProgress { progress in
                    print("Progress: ", progress.fractionCompleted)
                    
                    // self.bar_progress.progress = Float(progress.fractionCompleted)
                    // self.lbl_uploadProgress.text = "Upload Progress: \( Int(progress.fractionCompleted * 100))%"
                    
                    if progress.fractionCompleted >= 1.0{
                        print("Progress Completed")
                        //MEDIAPROGRESS = Float(progress.fractionCompleted)
                        MEDIAPROGRESS = 1.0
                    }
                    if progress.isPausable{
                        print("Pausable")      // THIS IS WHAT I WANT
                        //objG.removeVerificationPopup(viewController: viewController)
                    }
                    else{
                        print("Not pausable")    // THIS IS MY PROBLEM
                        print("Not pausable \(progress.fractionCompleted)")
                        if tempFirst == 0{
                            tempFirst = 1
                            objG.showProgressBar(viewController: viewController)
                        }
                    }
                    MEDIAPROGRESS = Float(progress.fractionCompleted)
                }
                //MARK:- Handle Response
                upload.responseJSON {
                    response in
                    print(  "response" , response)
                    
                    if let json = response.result.value {
                        print("JSON: \(json)") // serialized json response
                    }
                    var jsonstring = String()
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        jsonstring = utf8Text
                    }
                    if jsonstring != ""
                    {
                        if let data = jsonstring.data(using: String.Encoding.utf8) {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary]
                                if json != nil
                                {
                                    completionHandler(json! as [NSDictionary], nil)
                                    print(json!)
                                }
                                else
                                {
                                    completionHandler([NSDictionary](), nil)
                                }
                                
                            } catch let parseError {
                                print(parseError)
                                print(jsonstring)
                                print("Something went wrong")
                                print(response.description)
                                print(Error.self)
                                
                                completionHandler(nil, "Not JSON Data.")
                            }
                        }
                    }
                    else
                    {
                        if let json = response.result.value {
                            print("JSON: \(json)") // serialized json response
                            completionHandler(([json as! NSDictionary]), nil)
                        }
                    }
                    sessionManager.session.invalidateAndCancel()
                }
                break
            case .failure(let error):
                MEDIAPROGRESS = 1.0
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.")
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, request time out please try again.")
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription)
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription)
                }
                else
                {
                    completionHandler(nil, error.localizedDescription)
                }
                sessionManager.session.invalidateAndCancel()
                break
            }
        })
    }
        
    //MARK: - Post WebServices
    func webServiceWithPictureAudio(url:String , parameters:Dictionary<String,Any>,imagefilename: String, audiofilename: String, videofilename: String, imageData:Data, audioData:Data, videoData:Data, viewController: UIViewController, completionHandler: @escaping ([NSDictionary]?, String?) -> ()) {
//                var headers = HTTPHeaders()
//                headers = [
//                    //"Content-Type" :"text/html; charset=UTF-8",
//                    //"Content-Type": "application/json",
//                    "Content-Type": "application/x-www-form-urlencoded",
//                    //"Accept": "application/json",
//                    "Accept": "multipart/form-data"
//                ]
        //        headers = [ "Content-type": "multipart/form-data",
        //                    "Accept" : "text/html; charset=UTF-8"]
        var updateUrl = url
        if imageData.isEmpty != true {
            updateUrl = imagepathPost
        }
        if videoData.isEmpty != true {
            updateUrl = videopathPost
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        //configuration.httpAdditionalHeaders = headers
        //configuration.urlCredentialStorage = nil
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if imageData.isEmpty != true {
                multipartFormData.append((imageData), withName: "filename", fileName: imagefilename, mimeType: "image/png/jpeg/jpg")
            }
            if audioData.isEmpty != true {
                multipartFormData.append((audioData), withName: "voice", fileName: audiofilename, mimeType: "audio/m4a/wav/mp4")
            }
            if videoData.isEmpty != true {
                multipartFormData.append((videoData), withName: "videoFilename", fileName: videofilename, mimeType: "mp3/m4a/wav/mp4")
            }
        }, to: updateUrl,
           encodingCompletion: {    response in
            switch(response) {
            case .success(let upload, _, _):
                 MEDIAPROGRESS = Float()
                //MARK:- Handle progress
                upload.uploadProgress { progress in
                    print("Progress: ", progress.fractionCompleted)
                    
                    // self.bar_progress.progress = Float(progress.fractionCompleted)
                    // self.lbl_uploadProgress.text = "Upload Progress: \( Int(progress.fractionCompleted * 100))%"
                    if MEDIAPROGRESS == 0.0{
                        objG.showProgressBar(viewController: viewController)
                    }
                    MEDIAPROGRESS = Float(progress.fractionCompleted)
                    if progress.isPausable{
                        print("Pausable")      // THIS IS WHAT I WANT
                        print("Uploading Complete")      // THIS IS WHAT I WANT
                        MEDIAPROGRESS = 1.0
                    }
                    else{
                        print("Not pausable")    // THIS IS MY PROBLEM
                        //UIApplication.shared.keyWindow!.addSubview(self.vnavigation)
                    }
                }
                //MARK:- Handle Response
                upload.responseJSON {
                    response in
                    MEDIAPROGRESS = 1.0
                    print(  "response" , response)
                    
                    if let json = response.result.value {
                        print("JSON: \(json)") // serialized json response
                    }
                    var jsonstring = String()
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        jsonstring = utf8Text
                    }
                    if jsonstring != "" {
                        if jsonstring == "success" {
                            completionHandler([NSDictionary](), jsonstring)
                        }
                        else if let data = jsonstring.data(using: String.Encoding.utf8) {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary]
                                if json != nil {
                                    completionHandler(json! as [NSDictionary], nil)
                                    print(json!)
                                }
                                else {
                                    completionHandler([NSDictionary](), nil)
                                }
                                
                            } catch let parseError {
                                print(parseError)
                                print(jsonstring)
                                print("Something went wrong")
                                print(response.description)
                                print(Error.self)
                                
                                completionHandler(nil, "Not JSON Data.")
                            }
                        }
                    }
                    else
                    {
                        if let json = response.result.value {
                            print("JSON: \(json)") // serialized json response
                            completionHandler(([json as! NSDictionary]), nil)
                        }
                    }
                    sessionManager.session.invalidateAndCancel()
                }
                break
            case .failure(let error):
                if error._code == NSURLErrorCannotParseResponse
                {
                    completionHandler(nil, "Not JSON Data.")
                }
                else if error._code == NSURLErrorTimedOut
                {
                    completionHandler(nil, "Server is not responding, request time out please try again.")
                }
                else if error._code == NSURLErrorCannotFindHost
                {
                    completionHandler(nil, error.localizedDescription)
                }
                else if error._code == NSURLErrorNotConnectedToInternet
                {
                    completionHandler(nil, error.localizedDescription)
                }
                else
                {
                    completionHandler(nil, error.localizedDescription)
                }
                sessionManager.session.invalidateAndCancel()
                break
            }
        })
    }
    //MARK: - Post WebServices
        func webServiceWithProfilePicture(url:String , parameters:Dictionary<String,Any>,imagefilename: String, audiofilename: String, videofilename: String, imageData:Data, audioData:Data, videoData:Data, viewController: UIViewController, completionHandler: @escaping ([NSDictionary]?, String?) -> ()) {
    //                var headers = HTTPHeaders()
    //                headers = [
    //                    //"Content-Type" :"text/html; charset=UTF-8",
    //                    //"Content-Type": "application/json",
    //                    "Content-Type": "application/x-www-form-urlencoded",
    //                    //"Accept": "application/json",
    //                    "Accept": "multipart/form-data"
    //                ]
            //        headers = [ "Content-type": "multipart/form-data",
            //                    "Accept" : "text/html; charset=UTF-8"]
            var updateUrl = url
            
            let configuration = URLSessionConfiguration.default
            
            configuration.timeoutIntervalForRequest = 30
            //configuration.httpAdditionalHeaders = headers
            //configuration.urlCredentialStorage = nil
            let sessionManager = Alamofire.SessionManager(configuration: configuration)
            sessionManager.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                if imageData.isEmpty != true {
                    multipartFormData.append((imageData), withName: "filename", fileName: imagefilename, mimeType: "image/png/jpeg/jpg")
                }
                if audioData.isEmpty != true {
                    multipartFormData.append((audioData), withName: "voice", fileName: audiofilename, mimeType: "audio/m4a/wav/mp4")
                }
                if videoData.isEmpty != true {
                    multipartFormData.append((videoData), withName: "videoFilename", fileName: videofilename, mimeType: "mp3/m4a/wav/mp4")
                }
            }, to: updateUrl,
               encodingCompletion: {    response in
                switch(response) {
                case .success(let upload, _, _):
                     MEDIAPROGRESS = Float()
                    //MARK:- Handle progress
                    upload.uploadProgress { progress in
                        print("Progress: ", progress.fractionCompleted)
                        
                        // self.bar_progress.progress = Float(progress.fractionCompleted)
                        // self.lbl_uploadProgress.text = "Upload Progress: \( Int(progress.fractionCompleted * 100))%"
                        if MEDIAPROGRESS == 0.0{
                            objG.showProgressBar(viewController: viewController)
                        }
                        MEDIAPROGRESS = Float(progress.fractionCompleted)
                        if progress.isPausable{
                            print("Pausable")      // THIS IS WHAT I WANT
                            print("Uploading Complete")      // THIS IS WHAT I WANT
                            MEDIAPROGRESS = 1.0
                        }
                        else{
                            print("Not pausable")    // THIS IS MY PROBLEM
                            //UIApplication.shared.keyWindow!.addSubview(self.vnavigation)
                        }
                    }
                    //MARK:- Handle Response
                    upload.responseJSON {
                        response in
                        MEDIAPROGRESS = 1.0
                        print(  "response" , response)
                        
                        if let json = response.result.value {
                            print("JSON: \(json)") // serialized json response
                        }
                        var jsonstring = String()
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            jsonstring = utf8Text
                        }
                        if jsonstring != "" {
                            if jsonstring == "success" {
                                completionHandler([NSDictionary](), jsonstring)
                            }
                            else if let data = jsonstring.data(using: String.Encoding.utf8) {
                                do {
                                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary]
                                    if json != nil {
                                        completionHandler(json! as [NSDictionary], nil)
                                        print(json!)
                                    }
                                    else {
                                        completionHandler([NSDictionary](), nil)
                                    }
                                    
                                } catch let parseError {
                                    print(parseError)
                                    print(jsonstring)
                                    print("Something went wrong")
                                    print(response.description)
                                    print(Error.self)
                                    
                                    completionHandler(nil, "Not JSON Data.")
                                }
                            }
                        }
                        else
                        {
                            if let json = response.result.value {
                                print("JSON: \(json)") // serialized json response
                                completionHandler(([json as! NSDictionary]), nil)
                            }
                        }
                        sessionManager.session.invalidateAndCancel()
                    }
                    break
                case .failure(let error):
                    if error._code == NSURLErrorCannotParseResponse
                    {
                        completionHandler(nil, "Not JSON Data.")
                    }
                    else if error._code == NSURLErrorTimedOut
                    {
                        completionHandler(nil, "Server is not responding, request time out please try again.")
                    }
                    else if error._code == NSURLErrorCannotFindHost
                    {
                        completionHandler(nil, error.localizedDescription)
                    }
                    else if error._code == NSURLErrorNotConnectedToInternet
                    {
                        completionHandler(nil, error.localizedDescription)
                    }
                    else
                    {
                        completionHandler(nil, error.localizedDescription)
                    }
                    sessionManager.session.invalidateAndCancel()
                    break
                }
            })
        }
    //MARK:- PassPhone number and get contact name
    func getContactNumberFromGlobalNumber(contactNumber: String) -> String {
        var contactName = String()
        let contactStore = CNContactStore()
        let t = CNPhoneNumber.init(stringValue: contactNumber)
        
        var predicate = CNContact.predicateForContacts(withIdentifiers: [contactNumber])
        if #available(iOS 11.0, *) {
            predicate = CNContact.predicateForContacts(matching: t)
        } else {
            // Fallback on earlier versions
        }
        var contacts = [CNContact]()
        var message: String!
        
        do {
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: CONTACTKEY)
            
            if contacts.count == 0 {
                message = "No contacts were found matching the given name."
            }
        }
        catch {
            message = "Unable to fetch contacts."
        }
        //print(message)
        if contacts.count > 0{
            print(contacts[0])
            let tempcontact = contacts[0]
            
            contactName =  (tempcontact.phoneNumbers.first?.value.stringValue)!
        }
        if contactName == ""{
            contactName = ""
        }
        return contactName
    }
    
    public func showAlert(title: String, message: String, viewController: UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        { (action) in
        
        }
        alert.addAction(ok)
        
        viewController.present(alert, animated: true)
    }
    
    public func showActivityIndicatory(uiView: UIView) {
        
    }
    func device()-> Int{
           if IPAD {
               return 59
           }
           if UIDevice().userInterfaceIdiom == .phone {
               switch UIScreen.main.nativeBounds.height {
               case 1136:
                   print("iPhone 5 or 5S or 5C")
                   //bgv.image = UIImage.init(named: "SE")
                   return 33
               case 1334:
                   print("iPhone 6/6S/7/8")
                   // bgv.image = UIImage.init(named: "6")
                   return 39
               case 1920, 2208:
                   // bgv.image = UIImage.init(named: "6Plus")
                   print("iPhone 6+/6S+/7+/8+")
                   return 43
               case 2436:
                   print("iPhone X, XS")
                   
               case 2688:
                   print("iPhone XS Max")
                   
               case 1792:
                   print("iPhone XR")
                   
               default:
                   print("Unknown")
               }
           }
           return 43
       }
    
    var andcat: UIActivityIndicatorView = UIActivityIndicatorView()
    public func startandicator(viewController: UIViewController)
    {
        andcat = UIActivityIndicatorView()
        andcat.frame = CGRect(x:0.0, y:0.0, width:40.0, height:40.0);
        andcat.center = viewController.view.center
        andcat.frame.origin.y = (viewController.view.frame.size.width / 2) + 20
        
        andcat.hidesWhenStopped = true
        andcat.style =
            UIActivityIndicatorView.Style.whiteLarge
        andcat.color = appcolor
        viewController.view.addSubview(andcat)
        andcat.startAnimating()
    }
    
    public func stopandicator(viewController: UIViewController)
    {
        andcat.stopAnimating()
        DispatchQueue.global(qos: .background).async {
            self.andcat.removeFromSuperview()
        }
    }
    //MARK: - Easy Tip View Validation
    public func funValidationfromBottom(sender: AnyObject, text: String, view: UIView) {
        eview.dismiss()
        var preferences = EasyTipView.Preferences()
        preferences.drawing.backgroundColor = .white
        preferences.drawing.foregroundColor = UIColor.darkGray
        preferences.drawing.textAlignment = NSTextAlignment.center
        preferences.drawing.borderColor = .red
        preferences.drawing.borderWidth = 1.5
        
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 50, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1.5
        preferences.animating.dismissDuration = 1.5
        preferences.drawing.arrowPosition = .bottom
        
        eview = EasyTipView(text: text, preferences: preferences)
        eview.show(forView: sender as! UIView, withinSuperview: view)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {timer in
            eview.dismiss()
        })
    }
    
    func cornorRadiusOneSide(object: AnyObject, side: UIRectCorner){
        //Cornor Raius of only one corner
        let path = UIBezierPath(roundedRect:object.bounds,
                                 byRoundingCorners:[side],
                                 cornerRadii: CGSize(width: 20, height:  20))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        if #available(iOS 13.0, *) {
            object.layer.mask = maskLayer
        } else {
            // Fallback on earlier versions
            (object as! UIButton).layer.mask = maskLayer
        }
    }
    
    //MARK:- Wifi is Connected or not Check
    func isWifi()->Bool{
        var wifi = Bool()
        do {
            wifi = NetworkReachabilityManager.init()!.isReachableOnEthernetOrWiFi
        }
        catch{
            wifi = false
        }
        return wifi
    }
    
    func getYofTextField(textfield: UITextField) -> Float
    {
        var y = Float()
        
        y = Float(textfield.frame.maxY)
        
        return y
    }
    //MARK:- set View Circle
    public func setViewCircle(view: UIView, viewcontroller: UIViewController)
    {
        setviewHeighWidth4Pad(view: view, viewcontroller: viewcontroller)
        DispatchQueue.main.async {
            view.layer.cornerRadius = view.frame.size.height / 2
            view.clipsToBounds = true
        }
    }
    //MARK:- set heigh view 4 ipad
    public func setviewHeighWidth4Pad(view: UIView, viewcontroller :UIViewController)
    {
        let viewCenterPoint = view.center
        view.frame.size.width = view.frame.size.height
        view.frame.origin.x = (viewcontroller.view.frame.midX - (view.frame.width / 2))
        view.center = viewCenterPoint
    }
    //MARK:- set heigh image 4 ipad
    public func setImageHeighWidth4Pad(image: UIImageView, viewcontroller :UIViewController)
    {
        let imageCenterPoint = image.center
        image.frame.size.width = image.frame.size.height
        //image.frame.origin.x = (viewcontroller.view.frame.midX - (image.frame.width / 2))
        //image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.center = imageCenterPoint
    }
    //MARK:- set heigh image 4 ipad
    public func setViewHeighWidth4Pad(view: UIView, viewcontroller :UIViewController)
    {
        let imageCenterPoint = view.center
        view.frame.size.width = view.frame.size.height
        //image.frame.origin.x = (viewcontroller.view.frame.midX - (image.frame.width / 2))
        //image.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.center = imageCenterPoint
    }
    //MARK:- set image Circle
    public func setimageCircle(image: UIImageView, viewcontroller: UIViewController)
    {
        setImageHeighWidth4Pad(image: image, viewcontroller: viewcontroller)
        DispatchQueue.main.async {
            image.layer.cornerRadius = image.frame.size.height / 2
            image.clipsToBounds = true
            
            let imagecenterpoint = image.center
            image.frame.size.width = image.frame.size.height
            //image.frame.origin.x = (viewcontroller.view.frame.midX - (image.frame.width / 2))
            //image.contentMode = .scaleAspectFill
            image.center = imagecenterpoint
        }
    }
    //MARK:- set heigh view 4 ipad
    public func setLabelHeighWidth4Pad(label: UILabel, viewcontroller :UIViewController)
    {
        let labelCenterPoint = label.center
        label.frame.size.width = label.frame.size.height
        label.frame.origin.x = (label.frame.midX - (label.frame.width / 2))
        label.center = labelCenterPoint
    }
    //MARK:- Timer show in Label for human language 00:01:23 etc like this
    func funHMSFromSeconds(seconds: Double) -> String {
        let secondinInt = Int(seconds)
        // let hours = (secondinInt / 3600)
        let minutes = (secondinInt % 3600) / 60
        let seconds = ((secondinInt % 3600) % 60)
        
        return "\(getStringFrom(seconds: minutes)):\(getStringFrom(seconds: seconds))"
    }
    //MARK:- Timer show in human language 00:01:23 etc like this
    func funhmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    //MARK:- Timer show in human language 00:01:23 etc like this
       func getStringFrom(seconds: Int) -> String {
           return seconds < 10 ? "0\(seconds)" : "\(seconds)"
       }//End Human language timer
    //MARK:- set Label Circle
    public func setLabelCircle(label: UILabel, viewcontroller: UIViewController)
    {
        setLabelHeighWidth4Pad(label: label, viewcontroller: viewcontroller)
        DispatchQueue.main.async {
            label.layer.cornerRadius = label.frame.size.height / 2
            label.clipsToBounds = true
            
            let labelCenterPoint = label.center
            label.frame.size.width = label.frame.size.height
            //image.frame.origin.x = (viewcontroller.view.frame.midX - (image.frame.width / 2))
            //image.contentMode = .scaleAspectFill
            label.center = labelCenterPoint
        }
    }
    //MARK:- set image Circle
    public func setviewCircle(view: UIView, viewcontroller: UIViewController)
    {
        setViewHeighWidth4Pad(view: view, viewcontroller: viewcontroller)
        DispatchQueue.main.async {
            view.layer.cornerRadius = view.frame.size.height / 2
            view.clipsToBounds = true
            
            let imagecenterpoint = view.center
            view.frame.size.width = view.frame.size.height
            //image.frame.origin.x = (viewcontroller.view.frame.midX - (image.frame.width / 2))
            //image.contentMode = .scaleAspectFill
            view.center = imagecenterpoint
        }
    }
    //MARK:- Chek valid email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    //MARK:- Put right button
    public func putRightImgTextField(txtfield: UITextField, imgname: String, x: Int, width:Int, height:Int)
    {
        let y = CGFloat(txtfield.frame.size.height / 2) - CGFloat(height / 2)
        //MARK: - Add image in text field Right SIDE
        let rightimgv = UIView()
        rightimgv.frame = CGRect(x:0, y:0, width:50, height:txtfield.frame.size.height)
        txtfield.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: x, y: Int(y), width: width, height: height))
        let image = UIImage(named: imgname)
        imageView.image = image
        rightimgv.addSubview(imageView)
        txtfield.rightView = rightimgv
    }
    public func putRightButtoninTextField(btn: UIButton ,txtfield: UITextField, imgname: String, x: Int, width:Int, height:Int)
    {
        let y = CGFloat(txtfield.frame.size.height / 2) - CGFloat(height / 2)
        //MARK: - Add image in text field Right SIDE
        let rightimgv = UIView()
        rightimgv.frame = CGRect(x:0, y:0, width:50, height:txtfield.frame.size.height)
        txtfield.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: x, y: Int(y), width: width, height: height))
        let image = UIImage(named: imgname)
        imageView.image = image
        rightimgv.addSubview(imageView)
        txtfield.rightView = rightimgv
        
        //MARK: - Add button in text field Right SIDE
        btn.frame = rightimgv.frame
        rightimgv.addSubview(btn)
    }
    //MARK: - Function for Add image in text field LEFT SIDE
    public func putLeftImgInTextField(txtfield: UITextField, imgname: String, x:Int, width:Int, height:Int)
    {
        let y = CGFloat(txtfield.frame.size.height / 2) - CGFloat(height / 2)
        //MARK: - Add image in text field LEFT SIDE
        let leftimgv = UIView()
        leftimgv.frame = CGRect(x:10, y:Int(y), width:40, height:Int(txtfield.frame.size.height))
        txtfield.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: x, y: Int(y), width: width, height: height))
        let image = UIImage(named: imgname)
        imageView.image = image
        leftimgv.addSubview(imageView)
        txtfield.leftView = leftimgv
    }
    
    
    //MARK:- Find link in string
    func findLinkInText(label: UILabel) {
        let input = label.text!
        var link = findLink(string: input)
        if link == ""{
            
            return
        }
        let temparray = link.components(separatedBy: ",")
        print(temparray)
        if temparray.count == 0{
            
            return
        }
        let attributedString = NSMutableAttributedString(string: input)
        for temp in temparray{
            link = temp
            let linkRange = (attributedString.string as NSString).range(of: link)
            attributedString.addAttribute(NSAttributedString.Key.link, value: "\(link)", range: linkRange)
        }
        
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.green,
            NSAttributedString.Key.underlineColor: UIColor.lightGray,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        // textView is a UITextView
        //  label.linkTextAttributes = linkAttributes as [String : Any]
        
        label.attributedText = attributedString
    }
    public func putImgInButtonWithOutLabel2XSmall(button: UIButton, imgname: String)
    {
        button.setImage(UIImage.init(named: imgname), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        //  button.contentMode = .scaleAspectFit
        let imageSize:CGSize = CGSize(width: ((button.frame.size.width + 12) / 2) / 2, height: ((button.frame.size.height + 12) / 2) / 2)
        button.imageEdgeInsets = UIEdgeInsets(
            top: (((button.frame.size.height - imageSize.height) / 2)) ,
            left: (((button.frame.size.height - imageSize.height) / 2)) ,
            bottom: (((button.frame.size.height - imageSize.height) / 2)),
            right: (((button.frame.size.height - imageSize.height) / 2)))
    }
    func findLink(string: String) -> String {
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let matches = detector.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
        
        var link = ""
        var array = [String]()
        if matches.count == 0{
            return ""
        }
        for match in matches {
            //guard let range = Range(match.range, in: input) else { continue }
            guard let range = Range(match.range, in: string) else { return ""}
            let url = string[range]
            print(url)
            link = "\(url)"
            if link.contains("https://"){
                
            }
            else if link.contains("http://"){
            
            }
            else{
               // link = "https://\(link)"
            }
            
            link = link.replacingOccurrences(of: "https://https://", with: "https://")
            link = link.replacingOccurrences(of: "http://http://", with: "http://")
            link = "\(url)"
            
            
            // do something
            if NSURL(string: link) != nil {
                link = "\(url)"
                array.append(link)
//                if NSData(contentsOf: url as URL) == nil {
//
//                }
//                else {
//                    //link = "\(url)"
//                    //array.append(link)
//                }
            }
        }
        if array.count > 0{
            link = array.joined(separator: ",")
        }
        else{
            link = ""
        }
        
        return link
        
    }//END find link in label and string
    
    // Marks: - Keyboard Handling in UIViews
    func keybShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeightt = keyboardRectangle.height
            keyboardHeight = Float(keyboardHeightt)
        }
        return
        self.view.frame.origin.y = 64
        
        let height = Float(self.view.frame.size.height)
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = Float(keyboardRectangle.height )
        
        var lblremheight = Float()
        if (height - (txtfiledMaxY + 64)) < 20
        {
            lblremheight = (height - (txtfiledMaxY - 60));
        }
        else
        {
            lblremheight = (height - (txtfiledMaxY + 40));
        }
        
        
       // print(lblremheight)
        let kbremheight = Float(height - keyboardHeight)
       // print(kbremheight)
        let checkheight = Float(lblremheight - (kbremheight))
        //print(checkheight)
        
        if checkheight < 0
        {
            let h = abs(checkheight)
            print(h)
            activeview.frame.origin.y = (CGFloat)((checkheight))
        }
        else
        {
            
        }
    }
    //MARK:- Check How many days pass
    func isPassedMoreThan(days: Int, fromDate date : Date, toDate date2 : Date) -> Bool {
        let unitFlags: Set<Calendar.Component> = [.day]
        let deltaD = Calendar.current.dateComponents( unitFlags, from: date, to: date2).day
        return (deltaD ?? 0 > days)
    }
    //MARK:- New version available on apple store
    func autoUpDateIOSVersion(viewcontroller :UIViewController)
    {
        VersionCheck.shared.isUpdateAvailable() { (hasUpdates) in
          print("is update available: \(hasUpdates)")
            // Create the alert controller
            let alertController = UIAlertController(title: "Latest Version", message: "Old version is: \(APPVERSIONNUMBER!)\n New version is available: \(APPVERSION_ON_APPLE)\nPlease update your latest version from App Store", preferredStyle: .alert)
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                //MARK:- Forcly Quit the Application
                
                if let url = URL(string: SHARELINKIOS) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: {
                            response in
                            DispatchQueue.main.async {
                                exit(0)
                            }
                        })
                    } else {
                        // Earlier versions
                        if UIApplication.shared.canOpenURL(url as URL) {
                            UIApplication.shared.openURL(url as URL)
                            DispatchQueue.main.async {
                                exit(0)
                            }
                        }
                    }
                }
            }
            // Add the actions
            alertController.addAction(okAction)
            // Present the controller
            viewcontroller.present(alertController, animated: true, completion: nil)
        }
    }
    public func setImageViewShade(imageview: UIImageView)
    {
        //view.layer.cornerRadius = 8
        imageview.layer.borderWidth = 1
        imageview.layer.borderColor = AppTextFieldBorderColor.cgColor
        
        //MARK:- Shade a view
        imageview.layer.shadowOpacity = 0.5
        imageview.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageview.layer.shadowRadius = 3.0
        imageview.layer.shadowColor = UIColor.black.cgColor
        imageview.layer.masksToBounds = false
    }
    //MARK:- set heigh button 4 ipad
    public func setbuttonHeighWidth4Pad(button: UIButton, viewcontroller :UIViewController)
    {
        let buttonCenterPoint = button.center
        button.frame.size.width = button.frame.size.height
        button.frame.origin.x = (viewcontroller.view.frame.midX - (button.frame.width / 2))
        button.imageView?.contentMode = .scaleAspectFit
        
        button.center = buttonCenterPoint
    }
    public func setTextFieldShade(textfield: UITextField)
    {
        //view.layer.cornerRadius = 8
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = AppTextFieldBorderColor.cgColor
        
        //MARK:- Shade a view
        textfield.layer.shadowOpacity = 0.5
        textfield.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        textfield.layer.shadowRadius = 3.0
        textfield.layer.shadowColor = UIColor.black.cgColor
        textfield.layer.masksToBounds = false
    }
    //MARK:- Unlimited text to label
    public func labelunlimitedtext(label :UILabel)
    {
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 9
    }
    //MARK:- Show Toast Like Android
    func showToast(message : String, viewcontroller: UIViewController) {
        let toastLabel = UILabel()
        labelunlimitedtext(label: toastLabel)
        toastLabel.text = message
        toastLabel.sizeToFit()
        toastLabel.frame = CGRect(x: toastLabel.frame.origin.x, y: toastLabel.frame.origin.y, width: toastLabel.frame.size.width + 40, height: toastLabel.frame.size.height + 40)
        toastLabel.center = viewcontroller.view.center
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = toastLabel.frame.size.height / 2;
        toastLabel.clipsToBounds  =  true
        //viewcontroller.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        UIApplication.shared.keyWindow!.addSubview(toastLabel)
    }
    func keybHide(notification: NSNotification) {
        print("kb hide")
        activeview.frame.origin.y = 64
    }

    //MARK:- Add bottom line for textfield
    public func txtbottomline(textfield: UITextField)
    {
        let frame = CGRect(x: 0.0, y:textfield.frame.height - 1, width: textfield.frame.width, height: 1.0)
        let bottompass = CALayer()
        bottompass.frame = frame
        bottompass.backgroundColor = appclr.cgColor
        textfield.borderStyle = UITextField.BorderStyle.none
        textfield.layer.addSublayer(bottompass)
    }
    //MARK:- Hide navigation bar
    func hideNavBar(viewcontroller: UIViewController) {
        //MARK:- Hide navigation bar
        viewcontroller.navigationController?.navigationBar.isHidden = true
    }
    public func putImgInButtonWithOutLabelForCell(button: UIButton, imgname: String)
    {
        button.setImage(UIImage.init(named: imgname), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        // button.contentMode = .scaleAspectFit
        let imageSize:CGSize = CGSize(width: (button.frame.size.width - 25) / 2, height: (button.frame.size.height - 8) / 2)
        button.imageEdgeInsets = UIEdgeInsets(
            top: (((button.frame.size.height - imageSize.height) / 2) / 2),
            left: (((button.frame.size.height - imageSize.height) / 2) / 2) ,
            bottom: (((button.frame.size.height - imageSize.height) / 2) / 2),
            right: (((button.frame.size.height - imageSize.height) / 2) / 2))
    }
    //MARK:- Show navigation bar
    func showNavBar(viewcontroller: UIViewController) {
        //MARK:- Hide navigation bar
        viewcontroller.navigationController?.navigationBar.isHidden = false
    }
    //MARK:- Hide navigation bar
    func hideNavBarBackButton(viewcontroller: UIViewController) {
        //MARK:- Hide navigation bar
        viewcontroller.navigationItem.hidesBackButton = true
    }
    public func hideBottomLineNavBar(viewcontroller: UIViewController) {
        //MARK:- Hide bottom line of navigation bar
        viewcontroller.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    //MARK:- Fetch All Contacts of Phone with image data
    func fetchContacts(completion: @escaping (_ result: [CNContact], String) -> Void){
        DispatchQueue.main.async {
            var results = [CNContact]()
            let keys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactGivenNameKey,CNContactFamilyNameKey,CNContactMiddleNameKey,CNContactEmailAddressesKey,CNContactPhoneNumbersKey,CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey] as! [CNKeyDescriptor]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
            fetchRequest.sortOrder = .userDefault
            let store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler: {(grant,error) in
                if grant{
                    do {
                        try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                            // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contactrefresh"), object: nil)
                            results.append(contact)
                        })
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                    completion(results, "")
                }else{
                    print("Error \(error?.localizedDescription ?? "")")
                    completion(results, "Contact Permissaion required")
                }
            })
        }
    }
    public func setViewShade(view: UIView)
    {
        //view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = appclr.cgColor
        
        //MARK:- Shade a view
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
    }
    public func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String? {
            
            // From Time
            let fromDate = date
            
            // To Time
            let toDate = Date()
            
            // Estimation
            // Year
            if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
                
                return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
            }
            
            // Month
            if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
                
                return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
            }
            
            // Day
            if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
                
                return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
            }
            
            // Hours
            if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
                
                return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
            }
            
            // Minute
            if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
                
                return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
            }
            
            return "a moment ago"
        }
    
    func funOpenAppSetting() {
        if let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLEID)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    //MARK:- Two line in Navigation Title with Multiple Sizes
    func navigationTwoLineTitle(topline: String, bottomline: String, viewcontroller :UIViewController){
        let topText = NSLocalizedString(topline, comment: "")
        let bottomText = NSLocalizedString(bottomline, comment: "")
        //MARK:- Bold Font
        let titleParameters = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)]
        //MARK:- Regular Font
        let subtitleParameters = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12.0)]
        
        let title:NSMutableAttributedString = NSMutableAttributedString(string: topText, attributes: titleParameters)
        let subtitle:NSAttributedString = NSAttributedString(string: bottomText, attributes: subtitleParameters)
        
        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)
        
        let size = title.size()
        
        let width = size.width
        guard let height = viewcontroller.navigationController?.navigationBar.frame.size.height else {return}
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        viewcontroller.navigationItem.titleView = titleLabel
    }
    
    func set3LinesTitle(topline: String, middleline: String, bottomline: String, label :UILabel){
        var multiplayer = 1.0
        if IPAD{
            multiplayer = 2.0
        }
        let topText = NSLocalizedString(topline, comment: "")
        let middleText = NSLocalizedString(middleline, comment: "")
        let bottomText = NSLocalizedString(bottomline, comment: "")
        //MARK:- Bold Font
        let titleParameters = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(16.0*multiplayer))]
        //MARK:- Regular Font for Middle
        let subtitleMiddleParameters = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: CGFloat(10.0*multiplayer))]
        //MARK:- Regular Font
        let subtitleParameters = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: CGFloat(8.0*multiplayer))]
        
        let title:NSMutableAttributedString = NSMutableAttributedString(string: topText, attributes: titleParameters)
        let middletitle:NSMutableAttributedString = NSMutableAttributedString(string: middleText, attributes: subtitleMiddleParameters)
        let bottomtitle:NSAttributedString = NSAttributedString(string: bottomText, attributes: subtitleParameters)
        
        title.append(NSAttributedString(string: "\n"))
        title.append(middletitle)
        title.append(NSAttributedString(string: "\n"))
        title.append(bottomtitle)
        
        label.attributedText = title
        label.numberOfLines = 0
    }
    func convertTimespamIntoTime(timestring: String) -> String
    {
        let currentDateTimeToMiliSec = NSDate(timeIntervalSince1970: Double(Date().currentTimeMillis()!) / 1000)
        
        let date = NSDate(timeIntervalSince1970: Double(timestring)! / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = (NSTimeZone(name: "\(TimeZone.current.identifier)")! as TimeZone)
        
        formatter.dateFormat = "YYYY-MM-dd"
        //formatter.dateFormat = "ddmmYY"
        let currentdate = formatter.date(from: formatter.string(from: currentDateTimeToMiliSec as Date))
        let msgdate = formatter.date(from: formatter.string(from: date as Date))
        
        if currentdate == msgdate
        {
            formatter.dateFormat = "hh:mm a"
            return "" + formatter.string(from: date as Date)
        }
        else
        {
            formatter.dateFormat = "d/MM/yy hh:mm a"
            return formatter.string(from: date as Date)
        }
    }
    //MARK:- PassPhone number and get contact name
    func getContactNameFromNumber(contactNumber: String) -> String {
        var contactName = String()
        let contactStore = CNContactStore()
        let t = CNPhoneNumber.init(stringValue: contactNumber)
        
        var predicate = CNContact.predicateForContacts(withIdentifiers: [contactNumber])
        if #available(iOS 11.0, *) {
            predicate = CNContact.predicateForContacts(matching: t)
        } else {
            // Fallback on earlier versions
        }
        var contacts = [CNContact]()
        var message: String!
        
        do {
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: CONTACTKEY)
            
            if contacts.count == 0 {
                message = "No contacts were found matching the given name."
            }
        }
        catch {
            message = "Unable to fetch contacts."
        }
        //print(message)
        if contacts.count > 0{
            print(contacts[0])
            let tempcontact = contacts[0]
            
            if let fullname = tempcontact.value(forKey: "fullName") as Any as? String
            {
                contactName = fullname
            }
            else{
                contactName =  (tempcontact.phoneNumbers.first?.value.stringValue)!
            }
        }
        if contactName == ""{
            contactName = contactNumber
        }
        return contactName
    }
    func checkMicPermission() -> Bool {

        var permissionCheck: Bool = false

        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSessionRecordPermission.granted:
            permissionCheck = true
        case AVAudioSessionRecordPermission.denied:
            permissionCheck = false
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted {
                    permissionCheck = true
                } else {
                    permissionCheck = false
                }
            })
        default:
            break
        }
        return permissionCheck
    }
    
    func setPermission(title: String, message: String, viewController: UIViewController, mediaType: AVMediaType){
        AVCaptureDevice.requestAccess(for: mediaType) { success in
          if success { // if request is granted (success is true)
            DispatchQueue.main.async {
              //viewController.performSegue(withIdentifier: "identifier", sender: nil)
            }
          } else { // if request is denied (success is false)
            // Create Alert
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            // Add "OK" Button to alert, pressing it will bring you to the settings app
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            // Show the alert with animation
            viewController.present(alert, animated: true)
          }
        }
    }
    
    func convertTimeSpamIntoJustDateTime(timestring: String) -> String
    {
        //  let currentDateTimeToMiliSec = NSDate(timeIntervalSince1970: Double(Date().currentTimeMillis()!) / 1000)
        
        let date = NSDate(timeIntervalSince1970: Double(timestring)! / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = (NSTimeZone(name: "\(TimeZone.current.identifier)")! as TimeZone)
        
        formatter.dateFormat = "YYYY-MM-dd"
        //formatter.dateFormat = "ddmmYY"
        //    let currentdate = formatter.date(from: formatter.string(from: currentDateTimeToMiliSec as Date))
        //  let msgdate = formatter.date(from: formatter.string(from: date as Date))
        
        
        formatter.dateFormat = "d/MM/yy hh:mm a"
        return formatter.string(from: date as Date)
    }
    //MARK: - Function for Add image in button  LEFT SIDE WITHOUT LABEL
    public func putImgInButtonWithOutLabel(button: UIButton, imgname: String)
    {
        button.setImage(UIImage.init(named: imgname), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        let imageSize:CGSize = CGSize(width: (button.frame.size.width - 8) / 2, height: (button.frame.size.height - 8) / 2)
        
        button.imageEdgeInsets = UIEdgeInsets(
            top: (((button.frame.size.height - imageSize.height) / 2) / 2),
            left: (((button.frame.size.height - imageSize.height) / 2) / 2) ,
            bottom: (((button.frame.size.height - imageSize.height) / 2) / 2),
            right: (((button.frame.size.height - imageSize.height) / 2) / 2))
    }
    func convertTimespamIntoFullDateTime(timestring: String, completion: @escaping (_ isOnline: String, _ time: String)->()) {
        
        let currentDateTimeToMiliSec = NSDate(timeIntervalSince1970: Double(Date().currentTimeMillis()!) / 1000)
        //Mark:- Incoming date in function
        let dateIncoming = NSDate(timeIntervalSince1970: Double(timestring)! / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = (NSTimeZone(name: "\(TimeZone.current.identifier)")! as TimeZone)
        
        formatter.dateFormat = "YYYY-MM-dd"
        //Mark:- Current today date and time
        var currentdate = formatter.date(from: formatter.string(from: currentDateTimeToMiliSec as Date))
        
        var incomingOnlineDate = formatter.date(from: formatter.string(from: dateIncoming as Date))
        
        if currentdate == incomingOnlineDate
        {
            formatter.dateFormat = "YYYY-MM-dd hh:mm a"
            //Mark:- Current today date and time
            currentdate = formatter.date(from: formatter.string(from: currentDateTimeToMiliSec as Date))
            
            incomingOnlineDate = formatter.date(from: formatter.string(from: dateIncoming as Date))
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: incomingOnlineDate!, to: currentdate!)
            
            // To get the hours
            //print(components.hour)
            // To get the minutes
            //print(components.minute)
            
            //MARK:- Check if current time and otheruser online time difference is more then two minutes
            formatter.dateFormat = "hh:mm a"
            if components.hour! < 2
            {
                if components.minute! > 1
                {
                    //Offline
                }
                else
                {
                    //Online
                    completion("1", "" + formatter.string(from: dateIncoming as Date))
                    return
                }
            }
            //Offline
            completion("0", "Today " + formatter.string(from: dateIncoming as Date))
        }
        else
        {
            formatter.dateFormat = "d/MM/yy hh:mm a"
            //Offline
            completion("0", "" + "last seen " + formatter.string(from: dateIncoming as Date))
        }
    }
    func ifPreviousDateMessageSelect(timestring: String) -> String
    {
        let currentDateTimeToMiliSec = NSDate(timeIntervalSince1970: Double(Date().currentTimeMillis()!) / 1000)
        
        let date = NSDate(timeIntervalSince1970: Double(timestring)! / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = (NSTimeZone(name: "\(TimeZone.current.identifier)")! as TimeZone)
        
        formatter.dateFormat = "YYYY-MM-dd"
        //formatter.dateFormat = "ddmmYY"
        
        let currentdate = formatter.date(from: formatter.string(from: currentDateTimeToMiliSec as Date))
        let msgdate = formatter.date(from: formatter.string(from: date as Date))
        
        if currentdate == msgdate
        {
            return "1"
        }
        else
        {
            return "0"
        }
    }
    //MARK:- Download Video and Audio //Type is Video/Audio/Documents/Voice
    func funDownloadPlayShow(urlString: String, type: Int, isAuto: Bool, isProgressBarShow: Bool, viewController: UIViewController,completion: @escaping (_ urlString: String?) -> Void) {
        let url = NSURL(string: urlString)
        if url == nil {
            return
        }
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(url!.lastPathComponent!)
        //print(destinationUrl)
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
            completion("\(destinationUrl)")
            return
        }
        else {
            if isAuto{
                var temptype = String()
                let tempArrWifi = WIFI_DATA.components(separatedBy: ",")
                let tempArrMobileData = MOBILE_DATA.components(separatedBy: ",")
                switch type {
                case IMAGE :
                    temptype = "Photo"
                    break
                case AUDIO :
                    temptype = "Audio"
                    break
                case VIDEO :
                    temptype = "Video"
                    break
                case DOCUMENT :
                    temptype = "Document"
                    break
                default:
                    break
                }
                if WIFI{
                    if tempArrWifi.contains(temptype){
                        
                    }else {
                        completion("\("")")
                        return}
                }else{
                    if tempArrMobileData.contains(temptype){
                        
                    }else {
                        completion("\("")")
                        return}
                }
            }
            
            // if the file doesn't exist
            var downloadTask:URLSessionDownloadTask
            //MARK:- WORKIKNG BUT DELEGATES NOT CALL IF WE USE THIS
            downloadTask = URLSession.shared.downloadTask(with: url! as URL, completionHandler: {
                (URL, response, error) -> Void in
                
                do {
                    guard let URL = URL, error == nil else {
                        return }
                    try FileManager.default.moveItem(at: URL, to: destinationUrl)
                    print("File moved to documents folder")
                    completion("\(destinationUrl)")
                }
                catch let error as NSError {
                    //self.player = nil
                    print(error.localizedDescription)
                    // obj.showToast(message: error.localizedDescription, viewcontroller: self!)
                    completion("\(destinationUrl)")
                } catch {
                    print("AVAudioPlayer init failed")
                    //obj.showToast(message: "Video Failed ...!", viewcontroller: self!)
                    print("Failed ...!")
                }
            })
            downloadTask.resume()
        }
    }
    
    //MARK:- Download Video and Audio //Type is Video/Audio/Documents/Voice
    func funForceDownloadPlayShow(urlString: String, isProgressBarShow: Bool, viewController: UIViewController,completion: @escaping (_ urlString: String?) -> Void) {
        var tempUrl = urlString
        var isVideo = false
        if urlString.contains("___") {
            let tempUrlArray = urlString.components(separatedBy: "___")
            tempUrl = tempUrlArray[0]
            isVideo = true
        }
        
        var url = NSURL(string: tempUrl)
        
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(url!.lastPathComponent!)
        //print(destinationUrl)
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
            completion("\(destinationUrl)")
            return
        }
        else {
            MEDIAPROGRESS = Float()
            obj.showProgressBar(viewController: viewController)
            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
            if isVideo {
                url = NSURL(string: tempUrl+"/index.m3u8")
            }
            Alamofire.download(
                url! as URL,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default,
                headers: nil,
                to: destination).downloadProgress(closure: { (progress) in
                    //progress closure
                    MEDIAPROGRESS = Float(progress.fractionCompleted)
                    print(MEDIAPROGRESS)
                }).response(completionHandler: { (response) in
                    //here you able to access the DefaultDownloadResponse
                    //result closure
                    if MEDIAPROGRESS == 1.0 {
                        print("Go!")
                        do {
                            //  guard let URL = response.temporaryURL else {
                            //    return }
                            
                            completion("\(destinationUrl)")
                        }
                        catch {
                            //localFileDestinationUrl = URL(string: "")
                            print("Error in Compete Download URLSessionDownloadTas catch Failed ...!")
                        }
                    } else {
                        print(MEDIAPROGRESS)
                    }//End of if MEDIAPROGRESS == 1.0
                })//End of Alamofire.download(
        }
    }
    //MARK:- Check Box Custom Popup
       func showProgressBar(viewController: UIViewController){
           let popvc = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "ProgressBar") as! ProgressBar
           viewController.addChild(popvc)
           let frame = CGRect(x: 0, y: 0, width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
           popvc.view.frame = frame
           viewController.view.addSubview(popvc.view)
           popvc.didMove(toParent: viewController)
           
           viewController.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
           viewController.view.alpha = 0.0
           //MARK:- agar is main 0.25 karn dain gay to popup blink kar k atta ha animation .//UIView.animate(withDuration: 0.25, animations: {
           UIView.animate(withDuration: 0.0, animations: {
               viewController.view.alpha = 1.0
               viewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
           })
       }
    var isCompeted = Bool()
    var localFileDestinationUrl: URL!
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File complete download")
        MEDIAPROGRESS = 1.0
        do {
            //            guard let URL = location else {
            //                return }
            try FileManager.default.moveItem(at: location, to: localFileDestinationUrl!)
            print("File moved to documents folder")
            // completion("\(destinationUrl)")
        }
        catch let error as NSError {
            //localFileDestinationUrl = URL(string: "")
            print("Error in Compete Download URLSessionDownloadTask catch let error" + error.localizedDescription)
        } catch {
            //localFileDestinationUrl = URL(string: "")
            print("Error in Compete Download URLSessionDownloadTas catch Failed ...!")
        }
    }
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // println("download task did write data")
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print(progress)
        MEDIAPROGRESS = Float(totalBytesWritten)
        if Float(MEDIAPROGRESS) >= 0.99{
            print("Downloading Complete")      // THIS IS WHAT I WANT
        }
        else{
            print("Not pausable")    // THIS IS MY PROBLEM
        }
    }
    
   
    //MARK:- This try cach is use for move local image/audio/video/documents file to Local Directry
    func funMoveLocalFileToLocalDirectory(fileName: String, downloadURL: URL, fileData: Data){
        //MARK:- This try cach is use for move local image/audio/video/documents file to Local Directry
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(fileName)
            try fileData.write(to: fileURL, options: .atomic)
            //////////////////////
            try FileManager.default.moveItem(at: downloadURL, to: fileURL)
            print("File moved to documents folder")
            
            /////////////////////////
            
        } catch { }
    }
    // Mrks: -  Get thumbnail of video with the Upload image and video
       public func thumbnailForVideoAtURL(url: URL) -> UIImage? {
           
           let asset = AVAsset(url: url)
           let assetImageGenerator = AVAssetImageGenerator(asset: asset)
           
           var time = asset.duration
           time.value = min(time.value, 2)
           
           do {
               let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
               return UIImage(cgImage: imageRef)
           } catch {
               print("error")
               return nil
           }
       }
    var eViewTimer = Timer()
    //MARK: - Easy Tip View Validation
    func funValidationfromTopWithColor(sender: AnyObject, text: String, view:UIView, color: UIColor)
    {
        eview.dismiss()
        var preferences = EasyTipView.Preferences()
        //MARK:- Background Colo.r
        preferences.drawing.backgroundColor = color
        //MARK:- Text Color
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.textAlignment = NSTextAlignment.center
        //MARK:- Border Color
        preferences.drawing.borderColor = color
        preferences.drawing.borderWidth = 1
        
        preferences.animating.dismissTransform = CGAffineTransform(translationX:50, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1.5
        preferences.animating.dismissDuration = 1.5
        preferences.drawing.arrowPosition = .bottom
        eview = EasyTipView(text: text, preferences: preferences)
        eview.show(forView: sender as! UIView, withinSuperview: view)
        eViewTimer.invalidate()
        eViewTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {timer in
            eview.dismiss()
        }
    }
    func showProgress()
    {
        //        let progressview = CGRect(x: toastLabel.frame.origin.x, y: toastLabel.frame.origin.y, width: toastLabel.frame.size.width + 40, height: toastLabel.frame.size.height + 40)
    }
    
    func SendPushNotification(toToken: String, title: String, body: String, data: [String: Any])
       {
           let sender = PushNotificationSender()
           sender.sendPushNotification(to: toToken, title: title, body: body, data: data)
       }
    //MARK:- Set Blur UIView
       public func setBlurView(view: UIView){
           let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
           var blurEffectView = UIVisualEffectView()
           blurEffectView = UIVisualEffectView(effect: blurEffect)
           blurEffectView.frame = view.bounds
           blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           blurEffectView.tag = 99999
           view.addSubview(blurEffectView)
       }
       //MARK:- Remove Blur UIView
       public func removeBlurView(view: UIView){
           if let viewWithTag = view.viewWithTag(99999) {
               viewWithTag.removeFromSuperview()
           }else{
               print("No view found!")
           }
       }
}




//MARK:- Hyper link label
class LinkedLabel: UILabel {
    
    fileprivate let layoutManager = NSLayoutManager()
    fileprivate let textContainer = NSTextContainer(size: CGSize.zero)
    fileprivate var textStorage: NSTextStorage?
    
    
    override init(frame aRect:CGRect){
        super.init(frame: aRect)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LinkedLabel.handleTapOnLabel))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    override var attributedText: NSAttributedString?{
        didSet{
            if let _attributedText = attributedText{
                self.textStorage = NSTextStorage(attributedString: _attributedText)
                
                self.layoutManager.addTextContainer(self.textContainer)
                self.textStorage?.addLayoutManager(self.layoutManager)
                
                self.textContainer.lineFragmentPadding = 0.0;
                self.textContainer.lineBreakMode = self.lineBreakMode;
                self.textContainer.maximumNumberOfLines = self.numberOfLines;
            }
        }
    }
    
    @objc func handleTapOnLabel(tapGesture:UITapGestureRecognizer){
        
        let link = obj.findLink(string: self.text!)
        if link == ""{
            return
        }
        let locationOfTouchInLabel = tapGesture.location(in: tapGesture.view)
        let labelSize = tapGesture.view?.bounds.size
        let textBoundingBox = self.layoutManager.usedRect(for: self.textContainer)
        let textContainerOffset = CGPoint(x: ((labelSize?.width)! - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: ((labelSize?.height)! - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = self.layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        self.attributedText?.enumerateAttribute(NSAttributedString.Key.link, in: NSMakeRange(0, (self.attributedText?.length)!), options: NSAttributedString.EnumerationOptions(rawValue: UInt(0)), using:{
            (attrs: Any?, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) in
            
            if NSLocationInRange(indexOfCharacter, range){
                if let _attrs = attrs{
                    
                    guard let url = URL(string: "\(_attrs as! String)"), !url.absoluteString.isEmpty else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
    }}





//MARK:- Device to device Push Notification
class PushNotificationSender {
    func
        sendPushNotification(to token: String, title: String, body: String, data: [String: Any]) {
        let url = NSURL(string: FBASE_SEND_NOTIFICATION_URL)!
        
        
        var tempdataAndroid = data
        var paramString = [String : Any]()
        var tempisAndroid = Bool()
        let tempdic = data as NSDictionary
        if (tempdic.allKeys as NSArray).contains("isAndroidUser") {
            tempisAndroid = (tempdic.value(forKey: "isAndroidUser") as? Bool)!
            if tempisAndroid == true{
                //For Android
                tempdataAndroid.removeValue(forKey: "title")
                tempdataAndroid.removeValue(forKey: "body")
                tempdataAndroid.removeValue(forKey: "isAndroidUser")
                paramString = [
                    "to" : token,
                    "priority": "high",
                    "data" : tempdataAndroid,
                    "sound": "default"
                   // "notification": tempdataAndroid
                ]
            }else{
                tempdataAndroid.removeValue(forKey: "isAndroidUser")
                //For IOS
                paramString = [
                    "to" : token,
                    // "title":title,
                    // "body":body,
                    "priority": "high",
                    "data" : data,
                    "notification": data,
                    //"aps": dd,
                    //"payload": dd,
                    "sound": "default"
                    // "mutable_content": true,
                    //  "content_available": true
                ]
            }
        }
        else{
            if isAndroidUser == true{
                //For Android
                tempdataAndroid.removeValue(forKey: "title")
                tempdataAndroid.removeValue(forKey: "body")
                paramString = [
                    "to" : token,
                    "priority": "high",
                    "data" : tempdataAndroid,
                    "sound": "default"
                   // "notification": tempdataAndroid
                ]
            }else{
                //For IOS
                paramString = [
                    "to" : token,
                    // "title":title,
                    // "body":body,
                    "priority": "high",
                    "data" : data,
                    "notification": data,
                    //"aps": dd,
                    //"payload": dd,
                    "sound": "default"
                    // "mutable_content": true,
                    //  "content_available": true
                ]
            }
        }
        
        
        //        let dd = [
        //            "title":title,
        //            "body":body,
        //            "alert": "Hello!",
        //            "sound": "default",
        //            "mutable_content": true,
        //            //"content_available": true,
        //            "badge": 0,
        //            "data": [
        //                    "attachment-url": "https://ibb.co/BccHsMR"
        //            ]] as [String : Any]
        
        //        let paramString: [String : Any] = ["to" : token,
        //                                           "title":title,
        //                                           "body":body,
        //                                           "priority": "high",
        //                                           "data" : data,
        //                                           // "notification": data,
        //            "aps": dd,
        //            "payload": dd,
        //            "sound": "incomming.mp3",
        //            // "content_available": true//,
        //            "mutable_content": true
        //        ]
        
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(FIREBASE_SERVERKEY)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}




///Substitute class for _UITextLayoutView bug
//class FixedTextView: UITextView {
//    required init?(coder: NSCoder) {
//        if #available(iOS 13.2, *) {
//        } else {
//            let className = "_UITextLayoutView"
//            let theClass = objc_getClass(className)
//            if theClass == nil {
//                let classPair: AnyClass? = objc_allocateClassPair(UIView.self, className, 0)
//                objc_registerClassPair(classPair!)
//            }
//        }
//    }
//}

//******************************************************************
// MARK: - Workaround for the Xcode 11.2 bug
//******************************************************************
class UITextViewWorkaround: NSObject {

    // --------------------------------------------------------------------
    // MARK: Singleton
    // --------------------------------------------------------------------
    // make it a singleton
    static let unique = UITextViewWorkaround()

    // --------------------------------------------------------------------
    // MARK: executeWorkaround()
    // --------------------------------------------------------------------
    func executeWorkaround() {

        if #available(iOS 13.2, *) {

            NSLog("UITextViewWorkaround.unique.executeWorkaround(): we are on iOS 13.2+ no need for a workaround")

        } else {

            // name of the missing class stub
            let className = "_UITextLayoutView"

            // try to get the class
            var cls = objc_getClass(className)

            // check if class is available
            if cls == nil {

                // it's not available, so create a replacement and register it
                cls = objc_allocateClassPair(UIView.self, className, 0)
                objc_registerClassPair(cls as! AnyClass)

                #if DEBUG
                NSLog("UITextViewWorkaround.unique.executeWorkaround(): added \(className) dynamically")
               #endif
           }
        }
    }
}

class VersionCheck {
  public static let shared = VersionCheck()
  func isUpdateAvailable(callback: @escaping (Bool)->Void) {
    Alamofire.request("https://itunes.apple.com/lookup?bundleId=\(BUNDLEID)").responseJSON { response in
      if let json = response.result.value as? NSDictionary, let results = json["results"] as? NSArray, let entry = results.firstObject as? NSDictionary, let appStoreVersion = entry["version"] as? String{
        APPVERSION_ON_APPLE = appStoreVersion
        if let installed = Int(APPVERSIONNUMBER!.replacingOccurrences(of: ".", with: "")), let appStore = Int(appStoreVersion.replacingOccurrences(of: ".", with: "")), appStore > installed {
          callback(true)
        }
      }
    }
  }
}

extension Date {
    func currentTimeMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
