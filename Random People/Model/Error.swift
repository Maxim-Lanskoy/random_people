//
//  Error.swift
//  Random People
//
//  Created by Maxim Lanskoy on 09.10.2018.
//  Copyright © 2018 Lanskoy. All rights reserved.
//

import ObjectMapper

class ServerError: Mappable {
    var message: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message <- map["error"]
    }
}
