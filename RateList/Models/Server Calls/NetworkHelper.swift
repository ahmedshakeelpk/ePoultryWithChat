//
//  NetworkHelper.swift
//  Poultry Rates
//
//  Created by Faisal Raza on 18/11/2019.
//  Copyright © 2019 Zaryans Group. All rights reserved.
//

import Foundation
import Alamofire
import Photos
typealias JsonDictionay = [String : Any]

enum ServiceResponse
{
    case success(response: JsonDictionay)
    case failure
    case notConnectedToInternet
}

var headers: HTTPHeaders = [
    //"Authorization": "GTQYYB1UfdSc8Efh0YNNQ8X1FetzDPiiJXrnj6algh7VcbSdsAgk0xy8IJ9LldTa",
    "Accept" : "application/json"
]

var secoundHeader: HTTPHeaders = [:
    //"Authorization" : "GTQYYB1UfdSc8Efh0YNNQ8X1FetzDPiiJXrnj6algh7VcbSdsAgk0xy8IJ9LldTa",
    //"Content-Type": "multipart/form-data"
]
enum ResponseStatusCode: Int
{
    case success = 200
}

typealias CompletionBlock = (([String:AnyObject]? , String?) -> Void)
typealias download_Complete = ((_ image_Url:String)->Void)

class Connectivity
{
    class func isConnectedToInternet() -> Bool
    {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class NetworkHelper:NSObject
{
    var dataRequestArray: [DataRequest] = []
    
    let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
    
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    var sessionManager: [URL : Alamofire.SessionManager] = [:]
    
    static let ShareInstance = NetworkHelper()
    var dataRequest: DataRequest?
    
    func callEndPoint(params:[String:AnyObject] = [:],url : URL,message:String,method: Alamofire.HTTPMethod = .post,httpHeaders:HTTPHeaders,completion: @escaping CompletionBlock)
    {
        
        if Connectivity.isConnectedToInternet()
        {
            switch method
            {
            case .post:
            dataRequest = request(url, method: .post, parameters: params,headers: httpHeaders).validate().responseJSON
                { (response) in
        
                    if response.result.value != nil
                    {
                        guard let responseValue = response.result.value as? [String:AnyObject] else
                        {
                            print("Sorry Ur Data Is Damagged")
                            return
                        }
                        completion(responseValue,nil)
                        self.sessionManager.removeValue(forKey: url)
                    }
                    else
                    {
                        if let data = response.data
                        {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            completion([:],json)
                        }
                        
                        self.sessionManager.removeValue(forKey: url)
                    }
                }
            case .delete:
                dataRequest = request(url, method: .delete, parameters: params,headers: httpHeaders).validate().responseJSON { (response) in
                    
                    print("URL",url,"Parameters",params)
                    
                    if response.result.value != nil
                    {
                        guard let responseValue = response.result.value as? [String:AnyObject] else {
                            print("Sorry Ur Data IS Damagged")
                            return
                        }
                        completion(responseValue,nil)
                    }
                    else
                    {
                        if let data = response.data {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            completion([:],json)
                        }
                    }
                }
            case .put:
                dataRequest = request(url, method: .put, parameters: params,headers: httpHeaders).validate().responseJSON { (response) in
                    
                    print("URL",url,"Parameters",params)
                    
                    if response.result.value != nil
                    {
                        guard let responseValue = response.result.value as? [String:AnyObject] else {
                            print("Sorry Ur Data IS Damagged")
                            return
                        }
                        completion(responseValue,nil)
                    }
                    else
                    {
                        if let data = response.data {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            completion([:],json)
                        }
                    }
                }
            default:
                dataRequest = request(url, method: .get, parameters: params,headers: headers).validate().responseJSON
                { (response) in
                    print(response)
                    if response.result.value != nil
                    {
                        guard let responseValue = response.result.value as? [String:AnyObject] else
                        {
                            print("Sorry Ur Data IS Damagged")
                            return
                        }
                        completion(responseValue,nil)
                    }
                    else
                    {
                        if let data = response.data
                        {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            completion([:],json)
                        }
                    }
                }
                break
            }
        }
        else
        {
            
        }
    }
    func uploadImages(params:[String:AnyObject] = [:],url:URL,imageName:NSData,method: Alamofire.HTTPMethod = .post,header:HTTPHeaders,keyName : String = "image",completion:@escaping CompletionBlock)
    {
        Alamofire.SessionManager.default.upload(multipartFormData:
            { multipartFormData in
                multipartFormData.append(imageName as Data, withName: "image", fileName: keyName, mimeType: "image/jpeg")
                for (key, value) in params
                {
                    print("key",key,"Value",value)
                    multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
        },to: url,headers: header,encodingCompletion: { encodingResult in
            switch encodingResult
            {
            case .success(let upload, _, _):
                upload.responseJSON
                    { response in
                        
                        if response.result.value != nil
                        {
                            guard let responseValue = response.result.value as? [String:AnyObject] else
                            {
                                print("Sorry Ur Data Is Damagged")
                                return
                            }
                            completion(responseValue,nil)
                            self.sessionManager.removeValue(forKey: url)
                        }
                        else
                        {
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                completion([:],json)
                            }
                            self.sessionManager.removeValue(forKey: url)
                        }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    func UploadFiles (params:[String:AnyObject],files:[Data],method: Alamofire.HTTPMethod = .post,url:URL,completion:@escaping CompletionBlock)
    {
        Alamofire.SessionManager.default.upload(multipartFormData:
            { multipartFormData in
                for i in files
                {
                    multipartFormData.append(i as Data, withName: "files\([0])", fileName: "image.jpeg", mimeType: "image/jpeg")
                }
                for (key, value) in params {
                    multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
        },to: url,headers: secoundHeader,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let jsonResponse = response.result.value as? [String: AnyObject] {
                        completion(jsonResponse,nil)
                    }
                    else
                    {
                        if let data = response.data {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            completion([:],json)
                        }
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    func postCase(params:[String:Any] = [:],images:[Data],videos:[Data],method: Alamofire.HTTPMethod = .post,httpHeaders:HTTPHeaders,url:URL,keyName:String,completion:@escaping CompletionBlock)
    {
        
        Alamofire.SessionManager.default.upload(multipartFormData:
            { multipartFormData in
                
                let images_data = images //as [NSData]
                
                if images_data.count > 0
                {
                    var numberOfImage = images_data.count + 1
                    for images in images_data
                    {
                        numberOfImage = numberOfImage - 1
                        if numberOfImage == 0
                        {
                            print(numberOfImage)
                        }
                        else
                        {
                            //multipartFormData.append(images as Data, withName: "images[\(numberOfImage - 1)]", fileName: "images.jpeg", mimeType: "images/jpeg")
                            let imageData1 = images
                            
                            multipartFormData.append(imageData1, withName: "images[]", fileName: "image[\(numberOfImage - 1)]" + "."  + keyName, mimeType: "image/jpeg")
                            //multipartFormData.append(imageData1, withName: "images[]", fileName: "image.jpeg", mimeType: "image/jpeg")
                            
                            print(multipartFormData)
                            print("ok")
                        }
                    }
                }
                let Videos_Data = videos //as [NSData]
                if Videos_Data.count > 0
                {
                    var numberOfVideos = Videos_Data.count + 1
                    for videos in Videos_Data
                    {
                        numberOfVideos = numberOfVideos - 1
                        if numberOfVideos == 0
                        {
                            print(numberOfVideos)
                        }
                        else
                        {
                            multipartFormData.append(videos , withName: "videos[]", fileName: "video[\(numberOfVideos - 1)].mp4", mimeType: "video/mp4")
                            
                            print(multipartFormData)
                        }
                    }
                }
                print(params)
                for (key, value) in params
                {
                    print("Key",key,"Values",value)
                    multipartFormData.append(((value) as AnyObject).data(using: String.Encoding.utf8.rawValue)!,withName: key)
                }
                print("Added all Values")
                
        },to: url, method: .post,headers: httpHeaders,encodingCompletion:
            { encodingResult in
            switch encodingResult
            {
            case .success(let upload, _, _):
                upload.responseJSON
                    { response in
                        self.printJSON(data: response.data)
                    self.printJSON(data: response.result.value as? Data)
                    if let jsonResponse = response.result.value as? [String: AnyObject] {
                        completion(jsonResponse,nil)
                    }
                    else
                    {
                        if let data = response.data {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            completion([:],json)
                        }
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    func downloadImage (image_Url:String,image_name:String,downloadDone:@escaping download_Complete)
    {
        var localpath :String = String()
        let download_url = URL.init(string: image_Url)
        Alamofire.download(download_url!,method: .get,encoding: JSONEncoding.default,headers: nil,to: destination).downloadProgress(closure: { (progress) in
            print(progress)
        }).response(completionHandler: { (DefaultDownloadResponse) in
            
            print("responce",DefaultDownloadResponse)
            
            localpath = self.documentsPath + "/" + image_name
            
            let getpath = self.documentsPath
            
            print("complete path",localpath,"true or false=",getpath)
            
            downloadDone(localpath)
        })
    }
     func serializeResponse(response: Alamofire.DataResponse<String>)
    {
        print(response)
    }
    
    func printJSON(data : Data?){
        if data != nil {
            print(String.init(data: data!, encoding: .utf8) ?? "")
        }
    }
}

