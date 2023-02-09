//
//  APIManager.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import Alamofire
import SwiftyJSON

enum APIs {
    
    case misc
    
    var url: String {
        var apiName = ""
        switch self {
        case .misc:                                             apiName = ""
        }
        return "\(ServerConstant.WebService.apiURL)\(apiName)"
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:                    return JSONEncoding.default
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:                    return HTTPMethod.get
        }
    }
    
    var isMultipart: Bool {
        switch self {
        default:                   return false
        }
    }
    
    var httpHeaders: HTTPHeaders? {
        switch self {
        default:    return nil
        }
    }
    
    var parameters:[String: Any]? {
        
        switch self {
            
        // MARK: default case
        default:
            return nil
            
        }
        
    }
    
    var description: String {
        switch self {
        case .misc:    return "Misc"
        }
    }
    
}

class APIManager: NSObject {
    
    typealias APICompletion = (Bool, String, Int, Any?, Error?, Bool) -> Void
    
    let manager: Session
    
    static let shared: APIManager = {
        let instance = APIManager.init()
        return instance
    }()
    
    fileprivate override init() {
        self.manager = Alamofire.Session.default
    }
    
}

extension APIManager {
    
    func dataDictionary(fromResponse response: JSON) -> [String: Any]? {
        let dataDictionary = response.dictionaryObject?[ServerConstant.WebService.Response.data] as? [String: Any]
        return dataDictionary
    }
    
    func dataArray(fromResponse response: JSON) -> [Any]? {
        let dataArray = response.dictionaryObject?[ServerConstant.WebService.Response.data] as? [Any]
        return dataArray
    }
    
    func dataObject(fromResponse response: JSON) -> Any? {
        if let dataDictionary = self.dataDictionary(fromResponse: response) {
            return dataDictionary
        } else {
            return self.dataArray(fromResponse: response)
        }
    }
    
    func getStatus(fromResponse response: JSON) -> Bool {
        if let mainStatus = response.dictionaryObject?[ServerConstant.WebService.Response.status] as? Bool, mainStatus == true {
            if let dictionary = self.dataDictionary(fromResponse: response) {
                let status = dictionary[ServerConstant.WebService.Response.status] as? Bool ?? true
                return status
            } else if let _ = self.dataArray(fromResponse: response) {
                return true
            }
        }
        return false
    }
    
    func errorMessage(fromResponse response: JSON) -> String {
        if let mainStatus = response.dictionaryObject?[ServerConstant.WebService.Response.status] as? Bool, mainStatus != true {
            let message = response.dictionaryObject?[ServerConstant.WebService.Response.message] as? String
            return message ?? ServerConstant.WebService.defaultErrorMessage
        }
        if let dataDictionary = self.dataDictionary(fromResponse: response) {
            if let message = dataDictionary[ServerConstant.WebService.Response.message] as? String, message.count > 0 {
                return message
            }
        }
        if let dataArray = self.dataArray(fromResponse: response) as? [[String: Any]], dataArray.count > 0 {
            var arrayMsgs: [String] = []
            dataArray.forEach { (dictionary) in
                if let message = dictionary[ServerConstant.WebService.Response.message] as? String, message.count > 0 {
                    arrayMsgs.append(message)
                }
            }
            if arrayMsgs.count > 0 {
                return arrayMsgs.joined(separator: "\n")
            }
        }
        if self.getStatus(fromResponse: response) != true {
            let message = response.dictionaryObject?[ServerConstant.WebService.Response.message] as? String
            return message ?? ServerConstant.WebService.defaultErrorMessage
        }
        return ""
    }
    
    func getErrorMessage(fromErrorDictionary errorDictionary: [String: Any]?) -> String? {
        if errorDictionary?.count ?? 0 > 0 {
            var arrayErrorMessages:[String] = []
            let keys = errorDictionary!.keys
            for key in keys {
                if let message = errorDictionary![key] as? String {
                    arrayErrorMessages.append(message)
                } else if let dictionary = errorDictionary![key] as? [String: Any] {
                    let keys = dictionary.keys
                    for key in keys {
                        if let message = dictionary[key] as? String {
                            arrayErrorMessages.append(message)
                        }
                    }
                }
            }
            let errorMessage = arrayErrorMessages.joined(separator: "\n")
            return errorMessage
        }
        return nil
        
    }
    
}

extension APIManager {
    
    @discardableResult
    func apiCall(forWebService webService: APIs, completion:@escaping APICompletion) -> DataRequest? {
        
        if AppConstant.appDelegate.reachability?.connection != .unavailable {
            print("************* Request Parameters: *************\n\(JSON(webService.parameters ?? [:]).rawString() ?? "")\n***********************************************\n")
            if webService.isMultipart == true {
                self.multipartFormRequest(webService: webService, completion: completion)
            } else {
                let dataRequest = self.apiCall(withURL: webService.url, method: webService.httpMethod, parameters: webService.parameters, encoding: webService.encoding, headers: webService.httpHeaders, completion: completion, webService: webService)
                return dataRequest
            }
        } else {
            print("Internet connection not available.")
            completion(false, ServerConstant.WebService.Response.CommonErrorMessage.networkUnavailable, 0, nil, nil, false)
        }
        return nil
        
    }
    
    fileprivate func apiCall(withURL stringURL: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, headers: HTTPHeaders? = nil, completion:@escaping APICompletion, webService: APIs = .misc) -> DataRequest {
        
        let dataRequest = self.manager.request(stringURL, method: method, parameters: parameters, encoding: encoding, headers: headers).responseData { (dataResponse) in
            
            let tastInterval = (dataResponse.metrics?.taskInterval ?? DateInterval.init())
            
            print("\n*************** Task Interval: ****************\nRequest URL:\t\(dataResponse.request?.url?.absoluteString ?? "")\nRequest Desc:\t\(webService.description)\nTask Interval:\t\(tastInterval)\nDuration:\t\t\(tastInterval.duration)\n***********************************************\n")
            
            let statusCode = dataResponse.response?.statusCode ?? 0
            
            switch dataResponse.result {
                
            case .success(let value):
                if statusCode == StatusCode.NotFound.code {
                    self.handleNotFoundError(value: value, completion: { (status, message, response, error) in
                        completion(status, message, statusCode, response, error, false)
                    })
                    return
                }
                self.handleSuccess(webService: webService, value: value, completion: { (status, message, response, error) in
                    completion(status, message, statusCode, response, error?.underlyingError, (error?.isExplicitlyCancelledError ?? false))
                })
                break
            case .failure(let error):
                self.handleError(dataResponse: dataResponse, error: error, completion: completion)
                break
            }
            
        }
        
        dataRequest.cURLDescription { (curl) in
            print("**************** curl request: ****************\n\(curl)\n***********************************************")
        }
        
        return dataRequest
        
    }
    
    func multipartFormRequest(webService: APIs, completion:@escaping APICompletion) {
        
        let uploadRequest = self.manager.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in webService.parameters ?? [:] {
                if let dataValue = value as? Data {
                    let filename = GeneralUtility.getUniqueFilename()
                    multipartFormData.append(dataValue, withName: key, fileName: "\(filename).png", mimeType: "image/png")
                } else if let stringValue = value as? String {
                    multipartFormData.append(stringValue.utf8Encoded(), withName: key)
                } else if let intValue = value as? Int {
                    multipartFormData.append("\(intValue)".utf8Encoded(), withName: key)
                } else {
                    print("Not added key: \(key)")
                }
            }
            
        }, to: webService.url, method: webService.httpMethod, headers: webService.httpHeaders).responseData { (dataResponse) in
            
            let statusCode = dataResponse.response?.statusCode ?? 0
            
            switch dataResponse.result {
            case .success(let value):
                self.handleSuccess(webService: webService, value: value, completion: { (status, message, response, error) in
                    completion(status, message, statusCode, response, error, false)
                })
                break
            case .failure(let error):
                self.handleError(dataResponse: dataResponse, error: error, completion: completion)
                break
            }
            
        }
        
        uploadRequest.cURLDescription { (curl) in
            print("**************** curl request: ****************\n\(curl)\n***********************************************")
        }
        
    }
    
}

extension APIManager {
    
    func handleSuccess(webService: APIs, value: Any, completion:@escaping (Bool, String, Any?, AFError?) -> Void) {
        
        let responseJSON = JSON(value)
        print("****************** Response: ******************\n\(responseJSON)\n***********************************************\n")
        
        let status = self.getStatus(fromResponse: responseJSON)
        let message = self.errorMessage(fromResponse: responseJSON)
        
        if status != true {
            if message == ServerConstant.WebService.Response.CommonErrorMessage.invalidToken || message == ServerConstant.WebService.Response.CommonErrorMessage.unauthorized {
                GeneralUtility.endProcessing {
                    self.performLogout()
                    GeneralUtility.showAlert(message: message)
                }
            } else {
                completion(false, message, nil, nil)
            }
            return
        }
        
        let data = self.dataObject(fromResponse: responseJSON)
        
        switch webService {
        default:
            break
        }
        
        if data == nil {
            if responseJSON.dictionaryObject != nil {
                completion(true, message, responseJSON.dictionaryObject, nil)
            } else if responseJSON.arrayObject != nil {
                completion(true, message, responseJSON.arrayObject, nil)
            } else {
                if let errorMessageString = responseJSON.rawString() {
                    completion(false, errorMessageString, responseJSON, nil)
                } else {
                    completion(false, ServerConstant.WebService.defaultErrorMessage, nil, nil)
                }
            }
            return
        }
        
        completion(true, message, data, nil)
        return
        
    }
    
    func handleError(error: AFError?) {
        print("Error: \n\(error?.localizedDescription ?? "")\n")
    }
    
    func handleError(dataResponse: AFDataResponse<Data>, error: AFError, completion:@escaping APICompletion) {
        self.handleError(error: error)
        let statusCode = dataResponse.response?.statusCode ?? 0
        let isCancelled = error.isExplicitlyCancelledError
        if statusCode == StatusCode.Unauthorized.code {
            self.performLogout()
            return
        }
        if isCancelled == true {
            completion(false, error.localizedDescription, statusCode, nil, error, isCancelled)
            return
        }
        if let responseData = dataResponse.data {
            do {
                let responseJSON = try JSON.init(data: responseData)
                print("****************** Response: ******************\n\(responseJSON)\n***********************************************\n")
                let data = self.dataObject(fromResponse: responseJSON)
                let errorMessage = self.errorMessage(fromResponse: responseJSON)
                completion(false, errorMessage, statusCode, data, error, isCancelled)
                return
            } catch {
                completion(false, error.localizedDescription, statusCode, nil, error, isCancelled)
                return
            }
        }
        completion(false, error.localizedDescription, statusCode, nil, error, isCancelled)
        return
    }
    
    func handleNotFoundError(value: Any, completion:@escaping (Bool, String, Any?, AFError?) -> Void) {
        let responseJSON = JSON(value)
        print("****************** Response: ******************\n\(responseJSON)\n***********************************************\n")
        if let message = responseJSON.dictionaryObject?[ServerConstant.WebService.Response.message] as? String, message.count > 0 {
            completion(false, message, responseJSON, nil)
            return
        }
        completion(false, StatusCode.NotFound.message, responseJSON, nil)
    }
    
}

extension APIManager {
    
    func performLogout() {
        UserDefaults.removeObject(forKey: AppConstant.UserDefaultsKey.token)
    }
    
}

