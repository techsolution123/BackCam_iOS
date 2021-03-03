//
//  WebService.swift
//  BagCam
//
//  Created by Pankaj Patel on 13/02/21.
//

import UIKit
import Alamofire

class Webservice {
    
    /// StatusCode
    enum StatusCode: Int {
        case success          = 200 // OK for success
        case error            = 400 // Bad request for wrong parameters
        case unauthorized     = 401 // Thrown due to token mismatch or expiration
        case tokenRefreshed   = -1  // When token expires nd token refresh is call, then in response this code will be sent.
        case noContent        = 204 // No content when everything goes right but there is no data to be shown.
        case resourceNotFound = 404 // When Resource is not found
        case codeError        = 500 // Where we(backend) have messed up the code
        case unsupportedMedia = 415 // Unsupported Media Type
        case timeOut          = -2  // Time out
        case requestCancelled = -3  // Request Cancelled
        case noStatusCode     = 0   // If any other above code is obtained
        case noInternet       = -4  // No internet available
    }
    
    /// UrlType
    enum UrlType: String {
        case development = "http://34.222.182.112/api/"
        case current = " "
        case live = "  "

        #warning("Please check URLType while deploying")
        static fileprivate var baseURL: String = UrlType.development.rawValue
    }
    
    /// MethodName
    enum MethodName: String {
        case login = "login"
        case signup = "register"
        case forgotPassword = "forgot-password"
        case verificationCode = "verification-code"
        case resetPassword = "reset-password"
        case addDevice = "add_device"
        case deviceList = "device-pairing"
    }
    
    enum HeaderType: String {
        case app_json = "application/json"
        case app_xForm_urlEncode = "application/x-www-form-urlencoded"
        
        func getHeader() -> HTTPHeaders {
            var tempHeader: HTTPHeaders = [HTTPHeader(name: "Accept", value: self.rawValue)]
//            if let token =  Webservice.shared.getUserToken() {
//                tempHeader.add(HTTPHeader(name: "Authorization", value: "Bearer \(token)"))
//            }
            return tempHeader
        }
    }
    
    // Custom Type
    typealias WSResponseBlock = ((_ status: Webservice.StatusCode,_ json: Any?, _ error: String?) -> ())
    typealias WSDownlaodBlock = ((_ url: URL?, _ error: String?,_ resumData: Data?) -> ())
    typealias WSProgressBlock = ((_ progress: Double) -> ())
    
    // Variable(s) Declaratrion
    static  var shared : Webservice = Webservice()
    private var alamofireManager: Session!
    
    private init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        alamofireManager = Session(configuration: configuration)
    }
}

// MARK: Request Method
extension Webservice {
    
//    func getUserId() -> String {
//        if let id = _user?.id {
//            return id
//        } else if let id = UserDefaults.standard.string(forKey: "_userId") {
//            return id
//        }
//        return ""
//    }
//
//    func getUserToken() -> String? {
//        if let token = _user?.token {
//            return token
//        } else if let token = UserDefaults.standard.string(forKey: "_userToken") {
//            return token
//        }
//        return nil
//    }
    
    @discardableResult
    func request(_ methodType: HTTPMethod = .post, for methodName: MethodName, param: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, headerParam: HeaderType = .app_json, completion: WSResponseBlock?) -> DataRequest? {
        
        print("+++ +++ +++ \(methodName) +++ +++ +++")
        
        /// Check internet connection
        guard isConnectedToInternet() else {
            completion?(.noInternet, nil, "No internet available!")
            return nil
        }
        
        /// Create full URL
        let urlStr: String = (UrlType.baseURL + methodName.rawValue)
        guard let url = URL(string: urlStr) else {
            completion?(.error, nil, "invalid URL")
            return nil
        }
        
        let header = headerParam.getHeader()
        
        print("URL: \(urlStr)")
        print("Header: \(header)")
        print("Params: \(param ?? [:])")
        
        /// Request
        return alamofireManager.request(url, method: methodType, parameters: param, encoding: encoding, headers: header, interceptor: nil).validate().responseJSON { (data) in
            
            /// Check with our status code list
            let code: Int = data.response?.statusCode ?? 0
            var codeType: StatusCode = StatusCode(rawValue: code) ?? .noStatusCode
            print("Status Code: \(data.response?.statusCode ?? 0) - \(codeType)")
            
            switch data.result {
            /// Success with json response
            case .success(let value):
                if code == 201 {
                    codeType = .success
                }
                print("Success Response:  \(value)")
                completion?(codeType, value, nil)
                break
                
            /// Failur with error
            case .failure(let fError):
                    
                if fError.responseCode == NSURLErrorTimedOut || data.response?.statusCode  == NSURLErrorTimedOut {
                    completion?(.timeOut, nil, "Request Time out")
                } else if fError.isSessionTaskError {
                    completion?(.error, nil, "Could not connect to the server")
                }  else if fError.isExplicitlyCancelledError {
                    completion?(.requestCancelled, nil, nil)
                } else {
                    print("Error ResponseCode: \(fError.responseCode ?? 0)")
                    /// if fails then check data from server
                    if let jsonRawData = data.data {
                        do {
                            /// If error data it is not json serialized
                            let json = try JSONSerialization.jsonObject(with: jsonRawData, options: [])
                            print("Failure Response: \(json)")
                            let errStr: String? = ((json as? [String: Any])?["message"] as? String) ?? fError.localizedDescription
                            completion?(codeType, json, errStr)
                        }
                        catch let err {
                            // then throm with error description
                            print("Error: \(err.localizedDescription)")
                            completion?(codeType, nil, err.localizedDescription)
                        }
                    } else {
                        print("Error : \(fError)")
                        print("Error Desc: \(fError.localizedDescription)")
                        completion?(codeType, nil, fError.localizedDescription)
                    }
                }
                break
            }
        }
    }
    
    @discardableResult
    func uploadProfileImageMedias(_ methodName: MethodName, fileData: Data?, fileName: String, fileType: String, param: [String: Any]?, headerParam: HeaderType = .app_json, completion: WSResponseBlock?) -> DataRequest? {
        print("+++ +++ +++ \(methodName) +++ +++ +++")
        
        /// Check internet connection
        guard isConnectedToInternet() else {
            completion?(.noInternet, nil, "No internet available!")
            return nil
        }
        
        /// Create full URL
        let urlStr: String = (UrlType.baseURL + methodName.rawValue)
        guard let url = URL(string: urlStr) else {
            completion?(.error, nil, "invalid URL")
            return nil
        }
        
        let header = headerParam.getHeader()
        
        print("URL: \(urlStr)")
        print("Header: \(header)")
        print("Params: \(param ?? [:])")
        
        return alamofireManager.upload(multipartFormData: { (formData) in
            if let data = fileData {
                formData.append(data, withName: "profile_photo", fileName: fileName, mimeType: fileType)
            }
            
            if let parameter = param {
                for (key, value) in parameter {
                    formData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!, withName: key)
                }
            }
        }, to: url, method: .post, headers: header).uploadProgress(closure: { (progress) in
            print(progress)
        }) .responseJSON { (data) in
            /// Check with our status code list
            let code: Int = data.response?.statusCode ?? 0
            var codeType: StatusCode = StatusCode(rawValue: code) ?? .noStatusCode
            print("Status Code: \(data.response?.statusCode ?? 0) - \(codeType)")
            
            switch data.result {
            /// Success with json response
            case .success(let value):
                if code == 201 {
                    codeType = .success
                }
                print("Success Response:  \(value)")
                completion?(codeType, value, nil)
                break
                
            /// Failur with error
            case .failure(let fError):
                    
                if fError.responseCode == NSURLErrorTimedOut || data.response?.statusCode  == NSURLErrorTimedOut {
                    completion?(.timeOut, nil, "Request Time out")
                } else if fError.isSessionTaskError {
                    completion?(.error, nil, "Could not connect to the server")
                }  else if fError.isExplicitlyCancelledError {
                    completion?(.requestCancelled, nil, nil)
                } else {
                    print("Error ResponseCode: \(fError.responseCode ?? 0)")
                    /// if fails then check data from server
                    if let jsonRawData = data.data {
                        do {
                            /// If error data it is not json serialized
                            let json = try JSONSerialization.jsonObject(with: jsonRawData, options: [])
                            print("Failure Response: \(json)")
                            let errStr: String? = ((json as? [String: Any])?["message"] as? String) ?? fError.localizedDescription
                            completion?(codeType, json, errStr)
                        }
                        catch let err {
                            // then throm with error description
                            print("Error: \(err.localizedDescription)")
                            completion?(codeType, nil, err.localizedDescription)
                        }
                    } else {
                        print("Error : \(fError)")
                        print("Error Desc: \(fError.localizedDescription)")
                        completion?(codeType, nil, fError.localizedDescription)
                    }
                }
                break
            }
        }
    }
    
    @discardableResult
    func uploadPostMedias(_ methodName: MethodName, fileData: Data?, thumbnailData: Data? = nil, fileName: String, fileType: String, param: [String: Any]?, headerParam: HeaderType = .app_json, completion: WSResponseBlock?) -> DataRequest? {
        print("+++ +++ +++ \(methodName) +++ +++ +++")
        
        /// Check internet connection
        guard isConnectedToInternet() else {
            completion?(.noInternet, nil, "No internet available!")
            return nil
        }
        
        /// Create full URL
        let urlStr: String = (UrlType.baseURL + methodName.rawValue)
        guard let url = URL(string: urlStr) else {
            completion?(.error, nil, "invalid URL")
            return nil
        }
        
        let header = headerParam.getHeader()
        
        print("URL: \(urlStr)")
        print("Header: \(header)")
        print("Params: \(param ?? [:])")
        
        return alamofireManager.upload(multipartFormData: { (formData) in
            if let data = fileData {
                formData.append(data, withName: "file", fileName: fileName, mimeType: fileType)
            }
            
            if let data = thumbnailData {
                formData.append(data, withName: "thumbnail", fileName: "videoImage.jpg", mimeType: " image/jpeg")
            }
            
            if let parameter = param {
                for (key, value) in parameter {
                    formData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!, withName: key)
                }
            }
        }, to: url, method: .post, headers: header).uploadProgress(closure: { (progress) in
            print(progress)
        }) .responseJSON { (data) in
            /// Check with our status code list
            let code: Int = data.response?.statusCode ?? 0
            var codeType: StatusCode = StatusCode(rawValue: code) ?? .noStatusCode
            print("Status Code: \(data.response?.statusCode ?? 0) - \(codeType)")
            
            switch data.result {
            /// Success with json response
            case .success(let value):
                if code == 201 {
                    codeType = .success
                }
                print("Success Response:  \(value)")
                completion?(codeType, value, nil)
                break
                
            /// Failur with error
            case .failure(let fError):
                    
                if fError.responseCode == NSURLErrorTimedOut || data.response?.statusCode  == NSURLErrorTimedOut {
                    completion?(.timeOut, nil, "Request Time out")
                } else if fError.isSessionTaskError {
                    completion?(.error, nil, "Could not connect to the server")
                }  else if fError.isExplicitlyCancelledError {
                    completion?(.requestCancelled, nil, nil)
                } else {
                    print("Error ResponseCode: \(fError.responseCode ?? 0)")
                    /// if fails then check data from server
                    if let jsonRawData = data.data {
                        do {
                            /// If error data it is not json serialized
                            let json = try JSONSerialization.jsonObject(with: jsonRawData, options: [])
                            print("Failure Response: \(json)")
                            let errStr: String? = ((json as? [String: Any])?["message"] as? String) ?? fError.localizedDescription
                            completion?(codeType, json, errStr)
                        }
                        catch let err {
                            // then throm with error description
                            print("Error: \(err.localizedDescription)")
                            completion?(codeType, nil, err.localizedDescription)
                        }
                    } else {
                        print("Error : \(fError)")
                        print("Error Desc: \(fError.localizedDescription)")
                        completion?(codeType, nil, fError.localizedDescription)
                    }
                }
                break
            }
        }
    }
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

extension Webservice {
    func downloadFile(_ url: URL, id: String, progressBlock: WSProgressBlock? = nil, isToBeSaved: Bool = true, completion: @escaping WSDownlaodBlock) {
        
        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        path = path.appendingPathComponent(id + url.lastPathComponent)
        
        if UIApplication.shared.canOpenURL(path), FileManager.default.fileExists(atPath: path.absoluteString)  {
            completion(path, nil, nil)
        } else {
            var destination: DownloadRequest.Destination? = nil
            if isToBeSaved {
                destination = { _, _ in
                    return (path, [])
                }
            }
            
            alamofireManager.download(url, method: .get, encoding: JSONEncoding.default, to: destination).downloadProgress(closure: { (progress) in
                
                progressBlock?(progress.fractionCompleted)
            }).response(completionHandler: { (response) in
                
                completion(response.fileURL, response.error?.localizedDescription, response.resumeData)
            })
        }
    }
    
    func downloadFile(_ resumeData: Data, progressBlock: WSProgressBlock? = nil, completion: @escaping WSDownlaodBlock) {
        
        alamofireManager.download(resumingWith: resumeData).downloadProgress(closure: { (progress) in
            
            progressBlock?(progress.fractionCompleted)
        }).response(completionHandler: { (response) in
            
            completion(response.fileURL, response.error?.localizedDescription, response.resumeData)
        })
    }
}
