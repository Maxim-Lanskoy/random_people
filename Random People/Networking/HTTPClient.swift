//
//  HTTPClient.swift
//  Random People
//
//  Created by Maxim Lanskoy on 09.10.2018.
//  Copyright © 2018 Lanskoy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

let kHTTPClientErrorCode = 1001
let kAppInternalErrorDomain = "com.nure.lanskoi.maksym.RandomPeople"

let resultsNumber = 20
let noInfo = true

typealias CompletionBlock = (_ response: Any?, _ error: Error?) -> ()

class HTTPClient: NSObject {
    
    static let serverURL = "https://randomuser.me/api/"
    static var lastRequest: DataRequest?
    
    static private func sendRequest(method: HTTPMethod, parameters: Parameters? = nil, completion: @escaping CompletionBlock) -> Void {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.isNetworkActivityIndicatorEnabled = true
        
        if self.lastRequest != nil {
            self.lastRequest?.cancel()
            self.lastRequest = nil
        }
        
        let request = "results=\(resultsNumber)"  + "&"
                    + "\(noInfo ? "noinfo" : "")" + "&"
                    + "nat=\(Nationality.allCasesString.joined(separator: ","))"
        var url: String
        url = "\(serverURL)/?\(request)"
        
        self.lastRequest = Alamofire.request(url, method: method, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .success(let responseValue):
                    completion(responseValue, nil)
                case .failure(let error):
                    if (error as NSError).code != NSURLErrorCancelled {
                        completion(nil, error)
                    }
                }
                self.lastRequest = nil
        }
    }
    
    static func sendGetRequest(parameters: Parameters? = nil, completion: @escaping CompletionBlock) -> Void {
        self.sendRequest(method: .get, parameters: parameters) { (response, error) in
            completion(response,error)
        }
    }
    
    static func sendPostRequest(parameters: Parameters? = nil, completion: @escaping CompletionBlock) -> Void {
        self.sendRequest(method: .post, parameters: parameters) { (response, error) in
            completion(response,error)
        }
    }
}

