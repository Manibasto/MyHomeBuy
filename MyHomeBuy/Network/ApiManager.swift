//
//  ApiManager.swift
//  MysteryShoppers
//
//  Created by wazid on 16/05/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation
import  Alamofire
import SwiftyJSON
class ApiManager
{
    static let sharedInstance   =   ApiManager()
    
    fileprivate init(){
        
    }
    func getHeader() -> HTTPHeaders{
        let user = Credential.USER_NAME
        let password = Credential.PASSWORD
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials)",
            "api_key":Credential.API_KEY
        ]
        return headers
    }
    
    func requestApiServer(_ parmDict: Dictionary<String, Any>, _ imageArray :  [UIImage] , _ onSuccess: @escaping (Any)-> (), _ onFailure: @escaping (Error)-> () , _ onProgress: @escaping (Double)-> ()){
        let headers = getHeader()
        let url = ApiUrl.BASE_URL
        print("requestWithUrl  \(url) and requestWithData : \(parmDict)")
        Alamofire.upload(multipartFormData: { multipartFormData in
            var count = 1
            print("No of images to upload ==  \(imageArray.count)")
            for image in imageArray{
                
                if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                    print("***** compressed Size \(imageData.description) **** ")
                    
                    let fileName = "image_no_\(count).png"
                    multipartFormData.append(imageData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
                    count += 1
                }
                
                
            }
            
            for (key, value) in parmDict {
                multipartFormData.append(((value as Any) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                
            }
            
        }
            , usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        
                        onProgress(Progress.fractionCompleted)
                    })
                    upload.responseJSON {
                        response in
                        if let value = response.result.value {
                            print("json  \(JSON(value))")
                            onSuccess(value)
                            
                        }
                        
                    }
                case .failure(let encodingError):
                    onFailure(encodingError)
                    
                    print(encodingError)
                }
                
        })
    }
    func connectToServer( _ parmDict: Dictionary<String, Any>, _ onSuccess: @escaping (Any)-> (), _ onFailure: @escaping (Error)-> ()){
        let url = ApiUrl.BASE_URL
        print("requestWithUrl  \(url) and requestWithData : \(parmDict)")
        let headers = getHeader()
        Alamofire.request(url, method: .post, parameters: parmDict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print("json  \(JSON(value))")
                
                onSuccess(value)
            case .failure(let resError):
                let error = JSON(resError)
                print("error backend \(error)")
                
                
                
                onFailure(resError)
            }
        }
        
    }
    
    
    
    func uploadMultipleImagesWithData( _ parmDict: Dictionary<String, Any>, _ imageArray :  [UIImage] , _ onSuccess: @escaping (Any)-> (), _ onFailure: @escaping (Error)-> () , _ onProgress: @escaping (Double)-> ()){
        let headers = getHeader()
        let url = ApiUrl.BASE_URL
        
        print("requestWithUrl  \(url) and requestWithData : \(parmDict)")
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            var count = 1
            print("No of images to upload ==  \(imageArray.count)")
            for image in imageArray{
                //                let newImage = image.resizeImageWith(newSize: CGSize(width: 500, height: 500))
                if let imageData = UIImageJPEGRepresentation(image, 1) {
                    print("***** compressed Size \(imageData.description) **** ")
                    
                    let fileName = "image_no_\(count).png"
                    multipartFormData.append(imageData, withName: "image[]", fileName: fileName, mimeType: "image/jpeg")
                    count += 1
                }
                
                
            }
            
            for (key, value) in parmDict {
                multipartFormData.append(((value as Any) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                
            }
            
        }
            , usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        
                        onProgress(Progress.fractionCompleted)
                    })
                    upload.responseJSON {
                        response in
                        if let value = response.result.value {
                            let json = JSON(value)
                            
                            print("JSON: \(json)")
                            onSuccess(value)
                            
                            
                        }
                        
                    }
                case .failure(let encodingError):
                    onFailure(encodingError)
                    
                    print(encodingError)
                }
                
        })
    }
    
    
    
    func requestDocumentImageApiServer(_ parmDict: Dictionary<String, Any>, _ imageArray :  [UIImage] , _ onSuccess: @escaping (Any)-> (), _ onFailure: @escaping (Error)-> () , _ onProgress: @escaping (Double)-> ()){
        let headers = getHeader()
        let url = ApiUrl.BASE_URL
        print("requestWithUrl  \(url) and requestWithData : \(parmDict)")
        Alamofire.upload(multipartFormData: { multipartFormData in
            var count = 1
            print("No of images to upload ==  \(imageArray.count)")
            for image in imageArray{
                
                if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                    print("***** compressed Size \(imageData.description) **** ")
                    
                    let fileName = "image_no_\(count).png"
                    multipartFormData.append(imageData, withName: "file_name[]", fileName: fileName, mimeType: "image/jpeg")
                    count += 1
                }
                
            }
            
            for (key, value) in parmDict {
                multipartFormData.append(((value as Any) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                
            }
            
        }
            , usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        
                        onProgress(Progress.fractionCompleted)
                    })
                    upload.responseJSON {
                        response in
                        if let value = response.result.value {
                            print("json  \(JSON(value))")
                            onSuccess(value)
                            
                        }
                        
                    }
                case .failure(let encodingError):
                    onFailure(encodingError)
                    
                    print(encodingError)
                }
                
        })
    }
    
 //For Pdf Upload API Server
    func requestDocumentPdfApiServer(_ parmDict: Dictionary<String, Any>, _ pdfData :  Data , _ onSuccess: @escaping (Any)-> (), _ onFailure: @escaping (Error)-> () , _ onProgress: @escaping (Double)-> ()){
        let headers = getHeader()
        let url = ApiUrl.BASE_URL
        print("requestWithUrl  \(url) and requestWithData : \(parmDict)")
        Alamofire.upload(multipartFormData: { multipartFormData in
            var count = 1
            //print("No of images to upload ==  \(imageArray.count)")
                // dataimg =  [[NSData alloc] initWithContentsOfURL:[arrImage objectAtIndex:index]];
                
                    let fileName = "files_%@.pdf"
                    multipartFormData.append(pdfData, withName: "file_name[]", fileName: fileName, mimeType: "application/pdf")
                    count += 1
                
                
            
            for (key, value) in parmDict {
                multipartFormData.append(((value as Any) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                
            }
            
        }
            , usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        
                        onProgress(Progress.fractionCompleted)
                    })
                    upload.responseJSON {
                        response in
                        if let value = response.result.value {
                            print("json  \(JSON(value))")
                            onSuccess(value)
                            
                        }
                        
                    }
                case .failure(let encodingError):
                    onFailure(encodingError)
                    
                    print(encodingError)
                }
                
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func apiCall( _ parmDict: Dictionary<String, Any>, _ imageArray :  [UIImage] , _ onSuccess: @escaping (Any)-> (), _ onFailure: @escaping (Error)-> () , _ onProgress: @escaping (Double)-> ()){
        let url = URL(string:ApiUrl.BASE_URL)
        let username = Credential.USER_NAME
        let password = Credential.PASSWORD
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64EncodedCredential = loginData.base64EncodedString()
        let authString = "Basic \(base64EncodedCredential)"
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization" : authString , "api_key" : Credential.API_KEY]
        // create the request
      
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
       
        
        let defaultSession = URLSession(configuration: config)
        let boundary: NSString = "----CustomFormBoundarycC4YiaUFwM44F6rT"
        let body: NSMutableData = NSMutableData()
        
        
        print("requestWithUrl  \(url) and requestWithData : \(parmDict)")

        // parameters to send i.e. text
        let paramsArray = parmDict.keys
        for item in paramsArray {
            body.append(("--\(boundary)\r\n" as String).data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append("Content-Disposition: form-data; name=\"\(item)\"\r\n\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append("\(parmDict[item]!)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        }
        
        // you can also send multiple images
       
           
            for i in (0..<imageArray.count) {
                let imageData = UIImageJPEGRepresentation(imageArray[i], 1)
                body.append(("--\(boundary)\r\n" as String).data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                body.append("Content-Disposition: form-data; name=\"image[]\"; filename=\"photo\(i+1).jpeg\"\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                body.append(imageData!)
                body.append("\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            }
            
      
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        request.httpBody = body as Data
        request.timeoutInterval = 60
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
     let task = defaultSession.dataTask(with: request, completionHandler:
            {(data , response , error) in
                if let response = response{
                    print("response \(response)")

                }
                guard let data = data else {
                    if(error != nil){
                        print("network error  \(error)")
                        DispatchQueue.main.async {

                        onFailure(error!)
                        }
                    }
                    return
                }
                guard let jsonString = String(bytes: data, encoding: .utf8) else{return}
                print(jsonString)
                print("---------")
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    
                    // print(json)
                    if let jsonArray = json as? [Any]{
                        let str = self.prettyPrintArray(with: jsonArray)
                        print(str)
                        //onSuccess(str)


                    }
                    if let jsonDict = json as? [String : Any]{
                        let str = self.prettyPrintDict(with: jsonDict)
                        print(str)
                       // onSuccess(str)

                    }
                    DispatchQueue.main.async {
                        onSuccess(json)

                    }

                }catch let error{
                    print( error)
                    DispatchQueue.main.async {
                        
                        onFailure(error)
                    }
                }
                if(error != nil){
                    print("network error  \(error)")
                    DispatchQueue.main.async {

                    onFailure(error!)
                    }
                }
        })
        task.resume()
        
        
    }
    
    func prettyPrintArray(with json: [Any]) -> String{
        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        //let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        //print(string!)
        let string = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        if let string  = string{
            
            return string
        }
        print("something went wrong")
        return ""
    }
    func prettyPrintDict(with json: [String : Any]) -> String{
        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        //let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        let string = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        if let string  = string{
            
            return string
        }
        print("something went wrong")
        return ""
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func test(json : Any){
         let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let string = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        print(string ?? "No value found")
    }
    
    
}

