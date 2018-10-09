//
//  HTTPClient+User.swift
//  Random People
//
//  Created by Maxim Lanskoy on 09.10.2018.
//  Copyright © 2018 Lanskoy. All rights reserved.
//

import Foundation
import ObjectMapper

extension HTTPClient {

    static func getUsers(completion: @escaping (_ response: [User]?, _ error: Error?) -> ()) {
        HTTPClient.sendGetRequest() { (response, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let responseDictionary = (response as? [String: Any])?["results"] {
                    let userList = Mapper<User>().mapArray(JSONObject: responseDictionary)
                    completion(userList, nil)
                } else {
                    if let serverError = Mapper<ServerError>().map(JSONObject: response) {
                        let errorMessage = NSError(domain: kAppInternalErrorDomain, code: kHTTPClientErrorCode, userInfo: [NSLocalizedDescriptionKey : serverError.message ?? ""])
                        completion(nil, errorMessage)
                    }
                }
            }
        }
    }
}

